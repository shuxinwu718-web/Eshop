# AGENTS.md — E-Shop 电商系统速览

> 给新场景 / Agent 快速对齐「项目是什么、在哪、怎么跑、有哪些坑」。完整细节见各端 README。

## 1. 项目组成（三端）

| 端 | 技术栈 | 本地路径 | 仓库 |
|---|---|---|---|
| 前端 | Vue3 + TS + Vite8 + Element Plus + Pinia | `C:\Users\admin\Desktop\项目\电商系统\Eshop` | Eshop_front |
| 后端 | Java17 + SpringBoot3 + MyBatis-Plus + MySQL/Redis/RabbitMQ | `C:\Users\admin\Desktop\e-shop`（**规范路径，勿用旧副本 `项目\电商系统\e-shop`**） | Eshop |
| AI 客服 | Python + FastAPI | `C:\Users\admin\Desktop\ai-customer-service` | ai-customer-service |

功能：用户商城(shop) + 商家中心(merchant) + 管理后台(system) 三端；含拼团、秒杀、退款、优惠券、签到、AI 客服(SSE)、消息通知、**模拟物流**（发货→轨迹→自动确认收货闭环）。

## 2. 快速启动 / 部署

- **后端本地**：`mvn spring-boot:run`（8080），需本机 MySQL `localhost:3306` / `eshops`(`root/123456`)、Redis、RabbitMQ(延迟插件)。首次建库导入 `sql/eshops.sql`。
- **前端本地**：`pnpm install && pnpm dev`（3000），代理 `/dev-api`→8080、`/ai`→5000、`/uploads`→8080。
- **AI 本地**：FastAPI（5000）。
- **本地容器化**：`docker compose up -d`（`docker-compose.yml`，含 Elasticsearch，App 用 `application-docker.yml`）。
- **生产一键部署**：`docker compose -f docker-compose.prod.yml up -d --build`（`/opt/eshop/`，**无 ES**，挂载 jar/dist 非源码构建）。
- **后端打包**：`mvn package -DskipTests` → fat jar。

## 3. 关键技术与约定（改动前必读）

- **后端工作目录红线**：所有后端代码改 `Desktop\e-shop`，不要动 `项目\电商系统\e-shop`（旧废弃副本）。
- **时间格式**：后端全局 `yyyy-MM-dd HH:mm:ss`（JacksonConfig，勿在 DTO 加 @JsonFormat 覆盖）；前端时间处理只用 `@/utils/format.ts`，禁止 `replace("T")`/`toLocaleString`；`el-date-picker` 用 `value-format="YYYY-MM-DD HH:mm:ss"`。
- **搜索双引擎**：`elasticsearch.enabled` 开关，`false` 走 MySQL 降级（无关键词按 id 升序）。
- **秒杀**：抢下单资格不包 @Transactional（拒绝路径挤占连接池），落库用 TransactionTemplate；持久化方案见 SeckillServiceImpl。
- **RabbitMQ 延迟插件**：订单超时取消依赖 `rabbitmq_delayed_message_exchange`；生产用 `rabbitmq:3.12-management` + `3.12.0.ez`，镜像与插件版本必须匹配；跨容器账号用 `eshop/eshop123`（非 localhost 时 guest 会被拒）。
- **支付**：支付宝走真实沙箱（密钥从外部 `application-dev.yml`/`.env` 读，**严禁入库**）；`notify-url` 留空，入账靠结果页轮询对账自愈；支付方式值 1=微信 2=支付宝。
- **不定时提交敏感物**：`.env*`、`application-dev.yml`、uploads 图片、`uploads.rar`、临时备份文件一律 gitignore 不提交。
- **模拟物流（2026-10-02 落地）**：商家发货后，`shipment_track` 轨迹由 RabbitMQ 延迟消息逐级推进（已揽收1→运输中2→派送中3→已签收4），签收后自动确认收货（订单→已完成）；推进间隔用 `simulation.logistics.*` 配置（默认各 1 分钟，演示可调大）；**幂等双保险**= `UNIQUE(shipment_id, track_status)` 唯一键 + 消费侧前置校验（deliveryStatus==1 && order.status==2 && 无该状态轨迹）；启动时 `LogisticsRecoveryRunner` 兜底补投丢失轨迹消息；接口 `GET /api/order/track/shipment/{id}`、`/api/order/track/order/{orderId}`（含 userId 归属校验）；确认收货用 CAS（`eq(deliveryStatus,1).set(deliveryStatus,2)`）保证并发幂等。**增量 SQL 无 Flyway，必须手动执行** `src/main/resources/db/V20261002__create_shipment_track.sql`（本地执行或生产 `docker exec -i eshop-mysql mysql -uroot -p123456 eshops < ...`）。前端：物流跟踪页 `track.vue`（`/order/track/:shipmentId`，meta.hideMobileTabbar），详情页「查看物流」入口；商家发货弹窗快递公司为 5 家枚举下拉（顺丰/圆通/中通/韵达/EMS），运单号自动生成（`SimulatedExpressCompany.generateTrackingNo`，前缀+时间戳+随机）。
- **API 前缀**：前端生产 `/prod-api/`（nginx 去前缀转发后端）；SSE 需 nginx `proxy_buffering off` + `proxy_read_timeout 3600s`。
- **keep-alive 页面**：高频页缓存需 `meta.keepAlive` + 组件 `name` 与路由名一致 + `onActivated` 刷新 + `onDeactivated` 停 timer；滚动位置用 sessionStorage。

## 4. 工作流建议

- 新改动前，先读本文件 + 对应端 README（`e-shop/README.md`、`Eshop/README.md`）。
- 跨端配合：前端毫秒 → 先按后端 README 起后端，再 `pnpm dev`。
- 生产排查看服务器 `/opt/eshop/` + `docker logs`。