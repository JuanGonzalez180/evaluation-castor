package com.evaluation.castor.employee.request.status.services;

import com.evaluation.castor.employee.request.status.model.dao.RequestStatusDao;
import com.evaluation.castor.employee.request.status.model.entity.RequestStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RequestStatusServiceImpl implements RequestStatusService {

    private final RequestStatusDao requestStatusDao;

    public RequestStatusServiceImpl(RequestStatusDao requestStatusDao) {
        this.requestStatusDao = requestStatusDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<RequestStatus> findAll() {
        return (List<RequestStatus>) requestStatusDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public RequestStatus findById(Long id) {
        return requestStatusDao.findById(id).orElse(null);
    }
}
