package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Address;
import java.util.List;

public interface AddressService {
    void addAddress(Address address, Long userId);
    void updateAddress(Address address, Long userId);
    void deleteAddress(Long id, Long userId);
    List<Address> listAddresses(Long userId);
    Address getAddressById(Long id, Long userId);
    void setDefaultAddress(Long id, Long userId);
}
