package com.evaluation.castor.employee.requesters.services;

import com.evaluation.castor.employee.requesters.model.entity.Requesters;

import java.util.List;

public interface RequestersService {
    public List<Requesters> findAll();

    public Requesters findById(Long id);
}
