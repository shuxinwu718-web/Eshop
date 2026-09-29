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

### 支付（支付宝沙箱）

- 下单携带支付方式（微信=1 / 支付宝=2）；收银台 PayDialog 选支付方式，支付完成锁定支付方式
- 支付宝走真实沙箱 channel（`application-dev.yml` 配置，密钥从外部 `.env.local` 读取，未入库），`return-url` 指向在线前端 `/pay/result` 回跳，并结合结果页轮询 `alipay.trade.query` 对账自愈（`reconcilePaidOrder`），支付幂等用状态机条件更新（CAS）保证
- `PayController` + `PaymentTransaction`（支付流水）+ `db/V20260908__create_payment_transaction.sql`

### 支付高并发兜底（秒杀）

- 秒杀主流程**不包 @Transactional**（拒绝路径会借空事务挤占连接池），落库段用 `TransactionTemplate` 收窄
- Redis Lua 原子扣减 + 判重防超卖（`scripts/seckill_claim.lua`），拒绝路径只打 debug 日志避免同步 Console 洪峰

### 系统监控与访问日志

- `MonitorController` + `monitor.mapper`：系统运行指标监控页（DB 行数统计）
- `TraceFilter` 异步采集访问日志（`visit_log`，含 method/status/duration_ms），对高频轮询接口（秒杀场次、未读、验证码、SSE、监控页）自动噪声排除，避免虚高 PV/UV
- `JacksonConfig`：全局统一 `LocalDateTime=yyyy-MM-dd HH:mm:ss`、`LocalDate=yyyy-MM-dd` 序列化，反序列化宽松兼容带 T/空格/毫秒格式；跨模块复用同一 JavaTimeModule

## 快速开始

### 环境要求

- JDK 17
- Maven 3.9+
- MySQL 8.0
- Redis（可选，部分功能依赖）
- RabbitMQ 3.12+（默认 `localhost:5672`，guest/guest；**必须启用 `rabbitmq_delayed_message_exchange` 延迟消息插件**，否则订单超时取消功能不可用）
- Elasticsearch 8.11（可选，无 ES 环境可关闭）

> 注：RabbitMQ 依赖延迟消息插件，Docker Compose 已内置（启动时自动启用插件）；本地安装则需手动加载（见下方「RabbitMQ 延迟消息插件」说明）。

### 方式一：本地开发运行（推荐，改动调试最快）

需本机装好 JDK 17、Maven、MySQL 8.0、Redis、RabbitMQ（可选，需延迟插件）。

1. **初始化数据库**：新建库 `eshops`，导入 `sql/eshops.sql`（全量建表 + 初始数据）；如用富文本商品详情，再按需执行 `src/main/resources/db/` 下的增量迁移脚本（如 `V20260811__product_intro_version.sql`）。
2. **改配置**：编辑 `src/main/resources/application-dev.yml`，确认数据库账号密码（默认 `localhost:3306`，`root / 123456`）。
3. **启动应用**（默认端口 `8080`）：

```bash
mvn spring-boot:run
```

或在 IDE 中直接运行 `EShopApplication`。

4. **（可选）RabbitMQ**：本地安装 RabbitMQ 3.12+ 并启用延迟消息插件（见下），未启用时仅「订单超时取消」不可用。
5. **配合前端**：前端本地代理已指向本机 `8080`，按前端仓库 README 起动 `pnpm dev` 即可联调。

启动成功后访问：

- 接口文档（Swagger）：<http://localhost:8080/swagger-ui.html>
- OpenAPI JSON：<http://localhost:8080/v3/api-docs>

### 方式二：本地 Docker Compose 一键（中间件 + 后端全容器化）

无需预先安装 MySQL/Redis/ES/RabbitMQ，全部由容器承担：

```bash
docker compose up -d
```

- 使用 `docker-compose.yml`（MySQL + Redis + Elasticsearch + RabbitMQ + 后端 App）
- MySQL 首次启动自动执行 `sql/` 下的初始化脚本
- 后端使用 `application-docker.yml`（`eshop-mysql` / `eshop-redis` / `eshop-es` / `eshop-rabbitmq` 容器内网互通），默认端口 `8080`
- RabbitMQ 管理后台：<http://localhost:15672>（guest/guest）

### 方式三：生产服务器 Docker 一键部署（docker-compose.prod.yml）

用于线上服务器，固定部署到 `/opt/eshop/`。区别于方式二：**不构建 App 镜像，直接挂载本地打好的 jar**；前端挂载 `dist` 与 `nginx.conf`；**移除 Elasticsearch**（搜索走 MySQL 降级），降低 2G 小机 CPU 占用。

**① 本地打包上传产物：**

```bash
# 后端 fat jar
mvn package -DskipTests
#   → 上传 /opt/eshop/app/app.jar

# 前端 dist（见前端仓库 README「方式二」）
pnpm build     # 产物 dist/
#   → dist 上传 /opt/eshop/frontend/dist/，nginx.conf 上传 /opt/eshop/frontend/

# 数据与图片
#   eshops.sql → /opt/eshop/sql/
#   本地 e-shop/uploads 整份 → /opt/eshop/uploads/
```

**② 准备密钥文件 `/opt/eshop/.env`（至少含）：**

```bash
JWT_SECRET=<后端 JWT 密钥，务必修改>
DASHSCOPE_API_KEY=<AI 客服通义千问密钥>
# 如需真实支付宝沙箱支付再加：
ALIPAY_ENABLED=true
ALIPAY_APP_ID=...
ALIPAY_APP_PRIVATE_KEY=...
ALIPAY_PUBLIC_KEY=...
ALIPAY_RETURN_URL=http://<在线域名/IP>/pay/result
```

**③ 上传 RabbitMQ 延迟插件**到 `/opt/eshop/rabbitmq/rabbitmq_delayed_message_exchange-3.12.0.ez`（对应 compose 中 rabbitmq 的挂载路径，须与 `rabbitmq:3.12-management` 匹配）。

**④ 一键启动：**

```bash
cd /opt/eshop
docker compose -f docker-compose.prod.yml up -d --build
```

**⑤ 访问与端口规范：**

| 服务 | 地址 | 说明 |
|---|---|---|
| 前端商城 | `http://<服务器IP>` | nginx :80 |
| 后端 Swagger | `http://<服务器IP>:8080` | 仅内网 |
| RabbitMQ 管理台 | `http://<服务器IP>:15672` | `eshop/eshop123`，仅内网 |
| 数据库 | 容器 `eshop-mysql`（宿主端口 3307） | 仅内网 |

> ⚠️ **安全红线**：生产服务器只对外开放 **80**；8080 / 15672 / 3307 / 5000 / 9200 等仅限本机或内网访问（连数据库用 SSH 隧道 / Navicat，勿开公网端口）。

**存量数据库更新**：Docker 只在 MySQL **首次空卷启动**时自动导入 `sql/`；替换 SQL 文件不会重新导入，需重建库再手动导入，且会清空线上数据（有真实数据请用备份/binlog 方式）。

### RabbitMQ 延迟消息插件说明

订单超时自动取消依赖 `rabbitmq_delayed_message_exchange` 插件：

- **Docker Compose（方式二/方式三）**：镜像已带插件文件，启动命令自动启用。注意**镜像与插件版本必须匹配**——`docker-compose.prod.yml` 用 `rabbitmq:3.12-management` + `3.12.0.ez`。
- **本地安装（方式一）**：下载对应版本的 `.ez` 放入 RabbitMQ `plugins` 目录后执行：

```bash
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

未启用时仅「订单超时取消」功能不可用，其余功能不受影响。

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

肇庆学院
