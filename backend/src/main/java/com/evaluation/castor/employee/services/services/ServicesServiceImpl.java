package com.evaluation.castor.employee.services.services;

import com.evaluation.castor.employee.services.model.dao.ServicesDao;
import com.evaluation.castor.employee.services.model.entity.Services;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ServicesServiceImpl implements ServicesService {

    private final ServicesDao requestersDao;

    public ServicesServiceImpl(ServicesDao requestersDao) {
        this.requestersDao = requestersDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Services> findAll() {
        return (List<Services>) requestersDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Services findById(Long id) {
        return requestersDao.findById(id).orElse(null);
    }
}
