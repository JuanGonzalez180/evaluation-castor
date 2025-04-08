package com.evaluation.castor.employee.request.services;

import com.evaluation.castor.employee.request.model.entity.Request;

import java.util.List;

public interface RequestService {
    public List<Request> findAll();

    public Request findById(Long id);
}
