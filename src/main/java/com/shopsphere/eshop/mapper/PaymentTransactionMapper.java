package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.PaymentTransaction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

/**
 * 支付流水 Mapper
 */
@Mapper
public interface PaymentTransactionMapper extends BaseMapper<PaymentTransaction> {

    /**
     * 条件更新流水状态（幂等核心）：仅当当前状态等于 expect 时才更新为 target。
     * 回调并发到达 / 回调与查单竞态时，只有一条能成功。
     */
    @Update("UPDATE payment_transaction SET status = #{target}, trade_no = #{tradeNo}, " +
            "buyer_logon_id = #{buyerLogonId}, notify_time = #{notifyTime} " +
            "WHERE out_trade_no = #{outTradeNo} AND status = #{expect}")
    int casUpdateStatus(@Param("outTradeNo") String outTradeNo,
                        @Param("expect") Integer expect,
                        @Param("target") Integer target,
                        @Param("tradeNo") String tradeNo,
                        @Param("buyerLogonId") String buyerLogonId,
                        @Param("notifyTime") java.time.LocalDateTime notifyTime);
}
