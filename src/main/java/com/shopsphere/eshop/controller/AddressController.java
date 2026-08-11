package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Address;
import com.shopsphere.eshop.service.AddressService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/address")
@RequiredArgsConstructor
@Tag(name = "用户地址信息管理", description = "地址信息的CRID和用户获取自己的地址信息")
public class AddressController {

    private final AddressService addressService;

    @PostMapping
    public Result<?> addAddress(@RequestBody Address address,
                                @CurrentUserId Long userId) {
        addressService.addAddress(address, userId);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> updateAddress(@RequestBody Address address,
                                   @CurrentUserId Long userId) {
        addressService.updateAddress(address, userId);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> deleteAddress(@PathVariable Long id,
                                   @CurrentUserId Long userId) {
        addressService.deleteAddress(id, userId);
        return Result.success("删除成功");
    }

    @GetMapping("/list")
    public Result<?> listAddresses(@CurrentUserId Long userId) {
        return Result.success(addressService.listAddresses(userId));
    }

    @PutMapping("/default/{id}")
    public Result<?> setDefaultAddress(@PathVariable Long id,
                                       @CurrentUserId Long userId) {
        addressService.setDefaultAddress(id, userId);
        return Result.success("设置成功");
    }

    @GetMapping("/{id}")
    public Result<?> getAddressById(@PathVariable Long id,
                                    @CurrentUserId Long userId) {
        return Result.success(addressService.getAddressById(id, userId));
    }
}
