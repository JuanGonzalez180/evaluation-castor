package com.evaluation.castor.employee.request.status.services;

import com.evaluation.castor.employee.request.status.model.entity.RequestStatus;

import java.util.List;

public interface RequestStatusService {
    public List<RequestStatus> findAll();

    public RequestStatus findById(Long id);
}
