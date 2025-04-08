package com.evaluation.castor.employee.employee.model.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class EmployeeDTO {
    private Long id;
    private Long identificationNumber;
    private String name;
    private Date hireDate;
    private Date createdAt;
    private Long positionId;
    private String positionName;
}