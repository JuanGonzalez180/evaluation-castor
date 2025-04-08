package com.evaluation.castor.employee.services.services;

import com.evaluation.castor.employee.services.model.entity.Services;

import java.util.List;

public interface ServicesService {
    public List<Services> findAll();

    public Services findById(Long id);
}
