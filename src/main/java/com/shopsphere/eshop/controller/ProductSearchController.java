package com.shopsphere.eshop.controller;

import co.elastic.clients.elasticsearch._types.FieldValue;
import co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.QueryBuilders;
import co.elastic.clients.json.JsonData;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.document.ProductDocument;
import com.shopsphere.eshop.dto.ProductPageQueryDTO;
import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.CategoryMapper;
import com.shopsphere.eshop.mapper.ProductCommentMapper;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.service.ProductSyncService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.client.elc.NativeQueryBuilder;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchTemplate;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.FetchSourceFilter;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/product/es")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "商品搜索管理", description = "拼音搜索、排序搜索")
public class ProductSearchController {

    private final ElasticsearchTemplate esTemplate;
    private final ProductSyncService productSyncService;
    private final CategoryMapper categoryMapper;
    private final ProductService productService;
    private final ProductCommentMapper productCommentMapper;

    /** Elasticsearch 开关：false 直接走 MySQL 降级搜索 */
    @Value("${elasticsearch.enabled:false}")
    private boolean esEnabled;

    @GetMapping("/search")
    public Result<ProductSearchVO> search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "relevant") String sortBy) {

        // 1. 开关关闭：直接走 MySQL 降级（避免等 ES 连接超时）
        if (!esEnabled) {
            return Result.success(searchFromDb(keyword, categoryId, minPrice, maxPrice, status, page, size, sortBy));
        }

        try {
            return Result.success(searchFromEs(keyword, categoryId, minPrice, maxPrice, status, page, size, sortBy));
        } catch (Exception e) {
            log.warn("ES 搜索失败，降级 MySQL: {}", e.getMessage());
            return Result.success(searchFromDb(keyword, categoryId, minPrice, maxPrice, status, page, size, sortBy));
        }
    }

    // ====== ES 查询（原有逻辑） ======

    private ProductSearchVO searchFromEs(String keyword, Long categoryId, Double minPrice, Double maxPrice,
                                         Integer status, int page, int size, String sortBy) {
        // 构建 bool 查询
        BoolQuery.Builder boolBuilder = QueryBuilders.bool();

        // 1. 关键词搜索（multi-match + 拼音前缀匹配）
        if (StringUtils.hasText(keyword)) {
            BoolQuery.Builder keywordBool = QueryBuilders.bool();
            keywordBool.should(QueryBuilders.multiMatch()
                    .fields("name^3", "description", "categoryName")
                    .query(keyword)
                    .fuzziness("AUTO")
                    .build()._toQuery());
            keywordBool.should(QueryBuilders.matchPhrasePrefix()
                    .field("namePinyin")
                    .query(keyword)
                    .build()._toQuery());
            keywordBool.minimumShouldMatch("1");
            boolBuilder.must(keywordBool.build()._toQuery());
        } else {
            // 无关键词时返回所有上架商品
            boolBuilder.must(QueryBuilders.matchAll().build()._toQuery());
        }

        // 2. 过滤条件（filter context，不参与评分）
        if (categoryId != null) {
            List<Long> categoryIds = getAllDescendantCategoryIds(categoryId);
            if (!categoryIds.isEmpty()) {
                List<FieldValue> fieldValues = categoryIds.stream()
                        .map(FieldValue::of)
                        .collect(Collectors.toList());

                boolBuilder.filter(QueryBuilders.terms()
                        .field("categoryId")
                        .terms(t -> t.value(fieldValues))
                        .build()._toQuery());
            }
        }

        // 价格范围过滤
        if (minPrice != null || maxPrice != null) {
            var rangeBuilder = QueryBuilders.range().field("price");
            if (minPrice != null) {
                rangeBuilder.gte(JsonData.of(minPrice));
            }
            if (maxPrice != null) {
                rangeBuilder.lte(JsonData.of(maxPrice));
            }
            boolBuilder.filter(rangeBuilder.build()._toQuery());
        }

        // 状态过滤
        if (status != null) {
            boolBuilder.filter(QueryBuilders.term()
                    .field("status")
                    .value(status)
                    .build()._toQuery());
        }

        // 3. 排序
        NativeQueryBuilder nativeQueryBuilder = new NativeQueryBuilder()
                .withQuery(boolBuilder.build()._toQuery())
                .withPageable(PageRequest.of(page, size, buildSort(sortBy, StringUtils.hasText(keyword))))
                .withSourceFilter(new FetchSourceFilter(new String[]{
                        "id", "name", "categoryId", "categoryName", "price",
                        "stock", "coverImage", "description", "status", "sales", "createTime"
                }, null));

        NativeQuery query = nativeQueryBuilder.build();
        SearchHits<ProductDocument> hits = esTemplate.search(query, ProductDocument.class);

        List<SearchResultItem> items = hits.getSearchHits().stream()
                .map(hit -> {
                    SearchResultItem item = new SearchResultItem();
                    item.setProduct(hit.getContent());
                    item.setHighlights(hit.getHighlightFields());
                    return item;
                })
                .collect(Collectors.toList());
        // 实时填充用户评分平均数（索引中不存储，避免评分更新延迟）
        fillAvgRatings(items);

        ProductSearchVO vo = new ProductSearchVO();
        vo.setTotal(hits.getTotalHits());
        vo.setList(items);

        return vo;
    }

    // ====== MySQL 降级查询（返回与 ES 同构的 ProductSearchVO，前端无感知） ======

    private ProductSearchVO searchFromDb(String keyword, Long categoryId, Double minPrice, Double maxPrice,
                                         Integer status, int page, int size, String sortBy) {
        ProductPageQueryDTO dto = new ProductPageQueryDTO();
        dto.setPageNum(page + 1);
        dto.setPageSize(size);
        dto.setName(keyword);
        dto.setCategoryId(categoryId);
        dto.setStatus(status != null ? status : 1);
        dto.setMinPrice(minPrice);
        dto.setMaxPrice(maxPrice);
        dto.setSortBy(sortBy);

        Page<Product> result = productService.pageQuery(dto);
        List<SearchResultItem> items = result.getRecords().stream().map(p -> {
            SearchResultItem item = new SearchResultItem();
            item.setProduct(convertToDocument(p));
            item.setHighlights(new HashMap<>()); // 降级无高亮
            return item;
        }).collect(Collectors.toList());
        // 实时填充用户评分平均数
        fillAvgRatings(items);

        ProductSearchVO vo = new ProductSearchVO();
        vo.setTotal(result.getTotal());
        vo.setList(items);
        return vo;
    }

    /** 批量查询商品平均评分并填充到搜索结果（无评分返回 null，前端可兜底展示） */
    private void fillAvgRatings(List<SearchResultItem> items) {
        if (items == null || items.isEmpty()) {
            return;
        }
        List<Long> ids = items.stream()
                .map(item -> item.getProduct() != null ? item.getProduct().getId() : null)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        if (ids.isEmpty()) {
            return;
        }
        List<Map<String, Object>> rows = productCommentMapper.selectAvgRatingByProductIds(ids);
        Map<Long, Double> ratingMap = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Object pid = row.get("productId");
            Object avg = row.get("avgRating");
            if (pid != null && avg != null) {
                ratingMap.put(((Number) pid).longValue(), ((Number) avg).doubleValue());
            }
        }
        for (SearchResultItem item : items) {
            if (item.getProduct() != null && item.getProduct().getId() != null) {
                item.getProduct().setAvgRating(ratingMap.get(item.getProduct().getId()));
            }
        }
    }

    /** Product → ProductDocument（与 ES 文档同构，createTime 转 epoch） */
    private ProductDocument convertToDocument(Product p) {
        ProductDocument doc = new ProductDocument();
        BeanUtils.copyProperties(p, doc);
        if (p.getCreateTime() != null) {
            doc.setCreateTime(p.getCreateTime().toInstant(ZoneOffset.ofHours(8)).toEpochMilli());
        }
        if (p.getNamePinyin() != null) {
            doc.setNamePinyin(p.getNamePinyin().replace(" ", ""));
        }
        return doc;
    }

    @PostMapping("/reindex")
    public Result<String> reindex() {
        if (!esEnabled) {
            return Result.success("ES 未启用，无需重建索引");
        }
        productSyncService.syncAllProducts();
        return Result.success("全量同步触发成功");
    }

    private Sort buildSort(String sortBy, boolean hasKeyword) {

        return switch (sortBy) {
            case "price_asc" -> Sort.by(Sort.Direction.ASC, "price");
            case "price_desc" -> Sort.by(Sort.Direction.DESC, "price");
            case "sales" -> Sort.by(Sort.Direction.DESC, "sales");
            case "newest" -> Sort.by(Sort.Direction.DESC, "createTime");
            // relevant：有关键词按相关性 _score 排序；无关键词按 id 升序（靠前商品优先）
            default -> hasKeyword
                    ? Sort.unsorted()
                    : Sort.by(Sort.Direction.ASC, "id");
        };
    }

    // ====== 内部 VO ======

    @lombok.Data
    public static class ProductSearchVO {
        private long total;
        private List<SearchResultItem> list;
    }

    @lombok.Data
    public static class SearchResultItem {
        private ProductDocument product;
        private Map<String, List<String>> highlights;
    }


    public List<Long> getAllDescendantCategoryIds(Long categoryId) {
        List<Long> ids = new ArrayList<>();
        ids.add(categoryId);
        List<Category> children = categoryMapper.selectByParentId(categoryId);
        for (Category child : children) {
            ids.addAll(getAllDescendantCategoryIds(child.getId()));
        }
        return ids;
    }
}
