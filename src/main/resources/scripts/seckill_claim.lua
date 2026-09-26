-- ============================================================
-- 秒杀抢购原子脚本：判重 + 扣库存 + 记录用户，一次网络往返完成
-- 原实现需 3 次 Redis RTT（SISMEMBER / DECR / SADD）且非原子，
-- 并发窗口内可能出现"扣了库存但没记上用户"的中间态。
--
-- KEYS[1] = seckill:users:{sessionId}   已抢用户集合
-- KEYS[2] = seckill:stock:{sessionId}   剩余库存
-- ARGV[1] = userId
--
-- 返回值约定：
--   >=0  抢购成功，返回剩余库存
--   -1   用户已在集合中（重复抢购）
--   -2   库存不足（已回滚扣减）
--   -3   库存 key 不存在（宕机/丢失，由上层预热后重试）
-- ============================================================
if redis.call('EXISTS', KEYS[2]) == 0 then
    return -3
end
if redis.call('SISMEMBER', KEYS[1], ARGV[1]) == 1 then
    return -1
end
local remain = redis.call('DECR', KEYS[2])
if remain < 0 then
    -- 库存不足，回滚本次扣减，保证 Redis 库存不虚减
    redis.call('INCR', KEYS[2])
    return -2
end
redis.call('SADD', KEYS[1], ARGV[1])
return remain
