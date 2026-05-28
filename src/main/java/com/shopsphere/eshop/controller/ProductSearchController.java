package com.shopsphere.eshop.controller;

import co.elastic.clients.elasticsearch._types.query_dsl.BoolQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.QueryBuilders;
import co.elastic.clients.json.JsonData;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.document.ProductDocument;
import com.shopsphere.eshop.service.ProductSyncService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.client.elc.NativeQueryBuilder;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchTemplate;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.FetchSourceFilter;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/product/es")
@RequiredArgsConstructor
public class ProductSearchController {

    private final ElasticsearchTemplate esTemplate;
    private final ProductSyncService productSyncService;

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
        // 分类过滤
        if (categoryId != null) {
            boolBuilder.filter(QueryBuilders.term()
                    .field("categoryId")
                    .value(categoryId)
                    .build()._toQuery());
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
                .withPageable(PageRequest.of(page, size, buildSort(sortBy)))
                .withSourceFilter(new FetchSourceFilter(new String[]{
                        "id", "name", "categoryId", "categoryName", "price",
                        "stock", "coverImage", "description", "status", "sales", "createTime"
                }, null));

        NativeQuery query = nativeQueryBuilder.build();
        SearchHits<ProductDocument> hits = esTemplate.search(query, ProductDocument.class);

        ProductSearchVO vo = new ProductSearchVO();
        vo.setTotal(hits.getTotalHits());
        vo.setList(hits.getSearchHits().stream()
                .map(hit -> {
                    SearchResultItem item = new SearchResultItem();
                    item.setProduct(hit.getContent());
                    item.setHighlights(hit.getHighlightFields());
                    return item;
                })
                .collect(Collectors.toList()));

        return Result.success(vo);
    }

    @PostMapping("/reindex")
    public Result<String> reindex() {
        productSyncService.syncAllProducts();
        return Result.success("全量同步触发成功");
    }

    private Sort buildSort(String sortBy) {

        return switch (sortBy) {
            case "price_asc" -> Sort.by(Sort.Direction.ASC, "price");
            case "price_desc" -> Sort.by(Sort.Direction.DESC, "price");
            case "sales" -> Sort.by(Sort.Direction.DESC, "sales");
            case "newest" -> Sort.by(Sort.Direction.DESC, "createTime");
            default -> Sort.unsorted(); // relevant: 按 ES _score 排序
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
}
