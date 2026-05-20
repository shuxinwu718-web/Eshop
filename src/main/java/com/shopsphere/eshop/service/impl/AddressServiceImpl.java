package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Address;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.AddressMapper;
import com.shopsphere.eshop.service.AddressService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressServiceImpl implements AddressService {

    private final AddressMapper addressMapper;

    @Override
    public void addAddress(Address address, Long userId) {
        address.setUserId(userId);
        if (address.getIsDefault() == null) {
            address.setIsDefault(0);
        }
        if (address.getIsDefault() == 1) {
            clearDefaultAddress(userId);
        }
        addressMapper.insert(address);
    }

    @Override
    public void updateAddress(Address address, Long userId) {
        Address existing = addressMapper.selectById(address.getId());
        if (existing == null || !existing.getUserId().equals(userId)) {
            throw new BusinessException("地址不存在或无权限修改");
        }
        address.setUserId(userId);
        if (address.getIsDefault() == 1) {
            clearDefaultAddress(userId);
        }
        addressMapper.updateById(address);
    }

    @Override
    public void deleteAddress(Long id, Long userId) {
        Address existing = addressMapper.selectById(id);
        if (existing == null || !existing.getUserId().equals(userId)) {
            throw new BusinessException("地址不存在或无权限删除");
        }
        addressMapper.deleteById(id);
    }

    @Override
    public List<Address> listAddresses(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId)
                .orderByDesc(Address::getIsDefault)
                .orderByDesc(Address::getCreateTime);
        return addressMapper.selectList(wrapper);
    }

    @Override
    public Address getAddressById(Long id, Long userId) {
        Address address = addressMapper.selectById(id);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new BusinessException("地址不存在");
        }
        return address;
    }

    @Override
    public void setDefaultAddress(Long id, Long userId) {
        Address address = addressMapper.selectById(id);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new BusinessException("地址不存在或无权限操作");
        }
        clearDefaultAddress(userId);
        address.setIsDefault(1);
        addressMapper.updateById(address);
    }

    private void clearDefaultAddress(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId).eq(Address::getIsDefault, 1);
        Address oldDefault = addressMapper.selectOne(wrapper);
        if (oldDefault != null) {
            oldDefault.setIsDefault(0);
            addressMapper.updateById(oldDefault);
        }
    }
}
