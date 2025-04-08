package com.evaluation.castor.employee.employee.model.dao;

import com.evaluation.castor.employee.employee.model.entity.Employee;
import org.springframework.data.repository.CrudRepository;

public interface EmployeeDao extends CrudRepository<Employee, Long> {
}
