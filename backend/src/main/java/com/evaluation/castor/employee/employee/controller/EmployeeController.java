package com.evaluation.castor.employee.employee.controller;

import com.evaluation.castor.employee.commons.Constants;
import com.evaluation.castor.employee.employee.model.dto.EmployeeDTO;
import com.evaluation.castor.employee.employee.model.entity.Employee;
import com.evaluation.castor.employee.employee.model.mapper.EmployeeMapper;
import com.evaluation.castor.employee.employee.services.EmployeeService;
import jakarta.validation.ConstraintViolationException;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/employee")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class EmployeeController {
    private final EmployeeService employeeService;
    private final EmployeeMapper employeeMapper;

    public EmployeeController(EmployeeService employeeService, EmployeeMapper employeeMapper) {
        this.employeeService = employeeService;
        this.employeeMapper = employeeMapper;
    }

    private static final Logger log = LoggerFactory.getLogger(EmployeeController.class);

    @GetMapping("")
    public ResponseEntity<List<EmployeeDTO>> getEmployees() {
        List<Employee> employees = employeeService.findAll();
        List<EmployeeDTO> employeeDTOs = employeeMapper.toDtoList(employees);
        return new ResponseEntity<>(employeeDTOs, HttpStatus.OK);
    }

    @PostMapping("")
    public ResponseEntity<Object> create(@RequestBody EmployeeDTO employeeDTO) {
        Map<String, Object> response = new HashMap<>();

        try {
            Employee employee = employeeMapper.toEntity(employeeDTO);
            employee = employeeService.save(employee);
            EmployeeDTO savedDto = employeeMapper.toDto(employee);
            return new ResponseEntity<>(savedDto, HttpStatus.CREATED);
        } catch (DataAccessException e) {
            log.error(Constants.LOG_ERROR_ACCESS_DATA, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.MESSAGE_CREATION_ERROR);
            response.put(Constants.ERROR, Constants.ERROR_DATABASE);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (ConstraintViolationException e) {
            log.error(Constants.LOG_ERROR_VALIDATION, e.getMessage(), e);

            List<String> errors = new ArrayList<>();
            e.getConstraintViolations().forEach(violation -> errors.add(violation.getMessage()));

            response.put(Constants.MESSAGE, Constants.ERROR_VALIDATION);
            response.put(Constants.ERROR, errors);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            log.error(Constants.LOG_ERROR_UNKNOWN, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.ERROR_UNEXPECTED);
            response.put(Constants.ERROR, Constants.MESSAGE_CONTACT_ADMIN);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> show(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        try {
            Employee employee = employeeService.findById(id);
            if (employee == null) {
                response.put(Constants.MESSAGE, String.format(Constants.MESSAGE_NOT_FOUND, id));
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }
            EmployeeDTO employeeDTO = employeeMapper.toDto(employee);
            return new ResponseEntity<>(employeeDTO, HttpStatus.OK);
        } catch (DataAccessException e) {
            log.error(Constants.LOG_ERROR_ACCESS_DATA, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.ERROR_DATABASE);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Object> update(@RequestBody EmployeeDTO employeeDTO, @PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        Employee currentEmployee = employeeService.findById(id);
        if (currentEmployee == null) {
            response.put(Constants.MESSAGE, String.format(Constants.MESSAGE_NOT_FOUND, id));
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
        }

        try {
            employeeDTO.setId(id);
            Employee employee = employeeMapper.toEntity(employeeDTO);
            if (employee.getCreatedAt() == null) {
                employee.setCreatedAt(currentEmployee.getCreatedAt());
            }
            employeeService.save(employee);
            EmployeeDTO savedDto = employeeMapper.toDto(employee);
            return new ResponseEntity<>(savedDto, HttpStatus.OK);
        } catch (DataAccessException e) {
            log.error(Constants.LOG_ERROR_ACCESS_DATA, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.MESSAGE_UPDATE_ERROR);
            response.put(Constants.ERROR, Constants.ERROR_DATABASE);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (ConstraintViolationException e) {
            log.error(Constants.LOG_ERROR_VALIDATION, e.getMessage(), e);

            List<String> errors = new ArrayList<>();
            e.getConstraintViolations().forEach(violation -> errors.add(violation.getMessage()));

            response.put(Constants.MESSAGE, Constants.ERROR_VALIDATION);
            response.put(Constants.ERROR, errors);
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            log.error(Constants.LOG_ERROR_UNKNOWN, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.ERROR_UNEXPECTED);
            response.put(Constants.ERROR, Constants.MESSAGE_CONTACT_ADMIN);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        Employee currentEmployee = employeeService.findById(id);
        if (currentEmployee == null) {
            response.put(Constants.MESSAGE, String.format(Constants.MESSAGE_NOT_FOUND, id));
            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
        }

        try {
            employeeService.delete(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (DataAccessException e) {
            log.error(Constants.LOG_ERROR_ACCESS_DATA, e.getMessage(), e);
            response.put(Constants.MESSAGE, Constants.MESSAGE_DELETE_ERROR);
            response.put(Constants.ERROR, Constants.ERROR_DATABASE);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
