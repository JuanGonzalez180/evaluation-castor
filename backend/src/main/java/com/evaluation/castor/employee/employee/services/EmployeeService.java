package com.evaluation.castor.employee.employee.services;

import com.evaluation.castor.employee.employee.model.entity.Employee;

import java.util.List;

public interface EmployeeService {
    public List<Employee> findAll();

    public Employee findById(Long id);

    public Employee save(Employee employee);

    public void delete(Long id);
}
