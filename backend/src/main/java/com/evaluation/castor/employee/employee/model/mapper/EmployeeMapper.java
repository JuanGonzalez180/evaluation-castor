package com.evaluation.castor.employee.employee.model.mapper;

import com.evaluation.castor.employee.employee.model.dto.EmployeeDTO;
import com.evaluation.castor.employee.employee.model.entity.Employee;
import com.evaluation.castor.employee.position.model.entity.Position;
import com.evaluation.castor.employee.position.services.PositionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class EmployeeMapper {

    @Autowired
    private PositionService positionService;

    public Employee toEntity(EmployeeDTO dto) {
        if (dto == null) {
            return null;
        }

        Employee employee = new Employee();
        employee.setId(dto.getId());
        employee.setIdentificationNumber(dto.getIdentificationNumber());
        employee.setName(dto.getName());
        employee.setHireDate(dto.getHireDate());

        if (dto.getPositionId() != null) {
            Position position = positionService.findById(dto.getPositionId());
            employee.setPosition(position);
        }

        return employee;
    }

    public EmployeeDTO toDto(Employee entity) {
        if (entity == null) {
            return null;
        }

        EmployeeDTO dto = new EmployeeDTO();
        dto.setId(entity.getId());
        dto.setIdentificationNumber(entity.getIdentificationNumber());
        dto.setName(entity.getName());
        dto.setHireDate(entity.getHireDate());

        if (entity.getPosition() != null) {
            dto.setPositionId(entity.getPosition().getPositionId());
            dto.setPositionName(entity.getPosition().getName());
        }

        return dto;
    }

    public List<EmployeeDTO> toDtoList(List<Employee> entities) {
        if (entities == null) {
            return Collections.emptyList();
        }

        return entities.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }
}