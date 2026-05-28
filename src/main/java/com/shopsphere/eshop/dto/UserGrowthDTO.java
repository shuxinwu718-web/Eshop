package com.shopsphere.eshop.dto;

import lombok.Data;
import java.util.List;

@Data
public class UserGrowthDTO {
    private List<String> dates;
    private List<Long> newUserCountList;
    private List<Long> totalUserCountList;
}
