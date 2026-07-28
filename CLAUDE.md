# E-Shop B2B2C 项目

## 技术栈
- **后端**: Spring Boot 3.2.2, MyBatis-Plus, MySQL, Redis, Elasticsearch
- **前端**: Vue 3 (位于 `C:\Users\admin\Eshop`)
- **数据库**: MySQL `eshops` @ localhost:3306, 用户 root

## 分支策略
- `master` — 稳定发布分支
- `feature/product-sales` — 当前开发分支（所有新功能在此开发）
- 所有未合并的 feature 都在 `feature/product-sales` 上

## 项目结构
```
src/main/java/com/shopsphere/eshop/
├── annotation/         # 自定义注解
├── aspect/             # AOP 切面
├── common/             # Result 统一返回
├── config/             # 配置类（Security, Web, MyBatis-Plus, Swagger, ES, Redis）
├── constant/           # 常量
├── controller/         # 控制器（30个）
├── document/           # Elasticsearch document 类
├── dto/                # 请求 DTO
├── entity/             # 数据库实体
├── exception/          # BusinessException + GlobalExceptionHandler
├── interceptor/        # 拦截器
├── mapper/             # MyBatis-Plus Mapper
├── repository/         # ES Repository
├── service/            # 业务接口 + impl/
├── utils/              # 工具类（JWT, Token, IP, 拼音等）
├── vo/                 # 视图对象（响应 VO）
```

## 关键编码约定
- JWT 鉴权: `JwtUtil.getUserIdFromToken(token)`, token 通过 `TokenUtils.extractToken(authHeader)` 提取
- 统一返回: `Result<T>` → `{code: 200, msg: "success", data: T}`
- 异常: 抛出 `BusinessException(code, msg)` → GlobalExceptionHandler 统一处理
- DI: `@RequiredArgsConstructor` + `private final`（已在个别类中手工注入，但尽量遵循）
- 事务: 写操作加 `@Transactional(rollbackFor = Exception.class)`
- 主键: MyBatis-Plus `id-type: auto`（数据库自增）
- 逻辑删除: `deleted` 字段, 1=已删, 0=未删

## 状态枚举
- 订单: 0=待付款, 1=已付款, 2=已发货, 3=已完成, 4=已取消, 5=退款中, 6=已退款
- 发货单 deliveryStatus: 0=待发货, 1=已发货, 2=已签收
- 退款审核: 0=待商户审核, 1=待管理员审核, 2=已通过, 3=已拒绝, 4=退款执行中, 5=已退款

## 当前分支状态 (feature/product-sales)
- 基础架构: 完整 Spring Boot 项目（JWT 鉴权, Swagger, 文件上传, 邮件）
- 已完成功能: 商品、订单、购物车、类目、用户、地址、收藏、评论、秒杀、退款、优惠券、签到、节日活动、消息通知（系统+商户）、浏览历史、商家申请/审核、数据统计、操作日志、验证码、店铺设计
- **未提交修改**: 删除 GitHub OAuth 登录，替换为邮箱验证码免密登录
- 上传目录 `uploads/` 有测试数据

## 前端
位于 `C:\Users\admin\Eshop`，Vue 3 项目。
后端 API 基路径: `/api`（已在 WebConfig 中配置前缀）

## 常用命令
- 启动: `mvn spring-boot:run` (在 `D:\idea_workspase\e-shop`)
- 打包: `mvn clean package -DskipTests`
- 数据库: MySQL localhost:3306, database `eshops`
- Redis: localhost:6379, 无密码
- ES: localhost:9200
