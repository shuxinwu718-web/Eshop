# E-Shop 电商系统（后端）

> 基于 Spring Boot 3 的单体电商后端，为前端仓库 [Eshop_front](https://github.com/shuxinwu718-web/Eshop_front) 提供 REST API。
> 覆盖用户商城、商家中心、管理后台三类业务，内置拼团、秒杀、退款、优惠券、AI 客服（SSE）等完整电商能力。

## 项目仓库导航

| 项目 | 仓库地址 |
|------|----------|
| 🖥️ **前端（本项目）** | [Eshop_front](https://github.com/shuxinwu718-web/Eshop_front) |
| ☕ **后端（Java）** | [Eshop](https://github.com/shuxinwu718-web/Eshop) |
| 🐍 **AI 客服服务（Python）** | [ai-customer-service](https://github.com/shuxinwu718-web/ai-customer-service) |

> 包含**用户商城（shop）**、**商家中心（merchant）**、**系统管理（system）** 三端，以及拼团、秒杀、优惠券、AI 客服等特色功能。


## 技术栈

| 类别 | 技术 |
| --- | --- |
| 语言 | Java 17 |
| 框架 | Spring Boot 3.2.2、Spring Security |
| 持久层 | MyBatis-Plus 3.5.6、MySQL 8.0 |
| 缓存 | Redis（Spring Data Redis，拼团/秒杀/热点数据） |
| 消息队列 | RabbitMQ（延迟消息插件，订单超时取消/支付异步处理/邮件/访问日志） |
| 搜索引擎 | Elasticsearch 8.11（可选，开关控制，无 ES 自动降级 MySQL 搜索） |
| 认证 | JWT（jjwt 0.11.5，Authorization Bearer） |
| 接口文档 | SpringDoc OpenAPI（Swagger UI） |
| 其他 | EasyExcel 导出、QQ 邮件服务、EasyCaptcha 验证码、jpinyin、SSE 实时推送 |

## 项目结构

```
e-shop
├── sql/                          # 数据库全量初始化脚本（建库建表 + 初始数据）
├── src/main/java/com/shopsphere/eshop
│   ├── annotation/               # 自定义注解（@CurrentUserId、@Log）
│   ├── aspect/                   # 操作日志切面
│   ├── common/                   # 统一返回结果 Result
│   ├── config/                   # Security / Web / Redis / MyBatis-Plus / ES / RabbitMQ / JWT 过滤器等配置
│   ├── constant/                 # 业务常量与枚举
│   ├── controller/               # REST 控制器（用户/商品/订单/拼团/秒杀/商家/管理端…）
│   ├── dto/                      # 请求参数对象
│   ├── entity/                   # 数据实体
│   ├── exception/                # 全局异常处理与错误码
│   ├── interceptor/              # 访问记录拦截器
│   ├── mapper/                   # MyBatis-Plus Mapper 接口
│   ├── mq/                       # RabbitMQ 消息模型与消费者（订单/邮件/访问日志）
│   ├── repository/               # ES 搜索仓储
│   ├── service/                  # 业务层（接口 + impl 实现）
│   ├── utils/                    # JWT、IP、拼音等工具
│   └── vo/                       # 视图对象
├── src/main/resources
│   ├── mapper/                   # MyBatis XML 映射
│   ├── db/                       # 增量迁移 SQL（拼团、秒杀、退款、尺码表等）
│   └── application-*.yml         # dev / docker / prod 环境配置
└── src/test/java                 # 集成测试
```

## 功能模块

- **用户端**：注册登录、JWT 认证、收货地址、商品浏览与搜索（ES/MySQL 双引擎）、购物车、下单支付、订单管理、收藏、优惠券领取、退款售后、签到活动、拼团、秒杀、AI 客服
- **商家端**：店铺入驻申请、商品管理（SKU/规格/尺码表）、订单处理、退款审核、拼团活动管理、经营统计、消息通知
- **管理端**：用户/商品/订单/优惠券管理、秒杀场次管理、商家审核、运营统计、系统日志、访问统计

### 消息队列异步化（RabbitMQ）

- **订单超时自动取消**：下单后发送延迟消息（依赖 `rabbitmq_delayed_message_exchange` 插件），超时未支付自动关单并回滚
- **支付成功异步处理**：支付/退款成功发布消息，异步扣减库存、追加销量（`StockConsumer` / `OrderPaidConsumer`）
- **邮件异步发送**：邮箱验证码、找回密码等邮件投递不阻塞主线程（`EmailConsumer`）
- **订单通知**：下单/支付后异步生成站内通知（`OrderNotifyConsumer`）
- **访问日志异步落库**：`TraceFilter` 对每个请求发送访问日志消息（`VisitLogConsumer`），落库零阻塞

> 注：各消费者均为手动 ACK 模式，处理失败可重新入队，保证不丢消息。

## 快速开始

### 环境要求

- JDK 17
- Maven 3.9+
- MySQL 8.0
- Redis（可选，部分功能依赖）
- RabbitMQ 3.12+（默认 `localhost:5672`，guest/guest；**必须启用 `rabbitmq_delayed_message_exchange` 延迟消息插件**，否则订单超时取消功能不可用）
- Elasticsearch 8.11（可选，无 ES 环境可关闭）

> 注：当前 `docker-compose.yml` 尚未内置 RabbitMQ，容器化部署时请自行添加 RabbitMQ 服务（并加载延迟消息插件）；本地开发可直接安装并启动 RabbitMQ。

### 方式一：Docker Compose（推荐）

一条命令启动 MySQL + Redis + Elasticsearch + 后端应用：

```bash
docker compose up -d
```

- MySQL 首次启动会自动执行 `sql/` 下的初始化脚本
- 后端使用 `application-docker.yml`，默认端口 `8080`
- 数据库/Redis/ES 通过容器内网互通，无需额外配置

### 方式二：本地运行

1. **初始化数据库**：在 MySQL 中新建库 `eshops`，导入 `sql/eshops.sql`（全量建表 + 初始数据），再按需执行 `src/main/resources/db/` 下的增量迁移脚本（如拼团 `V20260810__create_group_buy.sql`）。
2. **修改配置**：编辑 `src/main/resources/application-dev.yml`，确认数据库账号密码（默认 `root / 123456`）。
3. **启动应用**：

```bash
mvn spring-boot:run
```

或在 IDE 中直接运行 `EShopApplication`。

启动成功后访问：

- 接口文档（Swagger）：<http://localhost:8080/swagger-ui.html>
- OpenAPI JSON：<http://localhost:8080/v3/api-docs>

### 配置说明

以下配置均可通过环境变量覆盖：

| 环境变量 | 默认值 | 说明 |
| --- | --- | --- |
| `MYSQL_PASSWORD` | `123456` | MySQL 密码 |
| `JWT_SECRET` | 内置测试密钥 | JWT 签名密钥，生产环境务必注入 |
| `MAIL_PASSWORD` | 内置授权码 | QQ 邮箱 SMTP 授权码（验证码/找回密码） |
| `ES_ENABLED` | `false` | 是否启用 Elasticsearch（false 时降级 MySQL 搜索） |
| `ES_URIS` | `http://localhost:9200` | ES 连接地址 |

## 常用脚本

```bash
# 打包（跳过测试）
mvn package -DskipTests

# 构建 Docker 镜像
docker build -t eshop-app .

# 运行测试
mvn test
```

## License

MIT
