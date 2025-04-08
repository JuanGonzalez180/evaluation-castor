package com.evaluation.castor.employee.employee.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import com.evaluation.castor.employee.employee.model.dao.EmployeeDao;
import com.evaluation.castor.employee.employee.model.entity.Employee;

@Service
public class EmployeeServiceImpl implements EmployeeService {
    private final EmployeeDao employeeDao;

    public EmployeeServiceImpl(EmployeeDao employeeDao) {
        this.employeeDao = employeeDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Employee> findAll() {
        return (List<Employee>) employeeDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Employee findById(Long id) {
        return employeeDao.findById(id).orElse(null);
    }

    @Override
    public Employee save(Employee employee) {
        return employeeDao.save(employee);
    }

    @Override
    public void delete(Long id) {
        employeeDao.deleteById(id);
    }
}
