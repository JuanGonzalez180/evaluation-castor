package com.evaluation.castor.employee.request.services;

import com.evaluation.castor.employee.request.model.dao.RequestDao;
import com.evaluation.castor.employee.request.model.entity.Request;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RequestServiceImpl implements RequestService {

    private final RequestDao requestDao;

    public RequestServiceImpl(RequestDao requestDao) {
        this.requestDao = requestDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Request> findAll() {
        return (List<Request>) requestDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Request findById(Long id) {
        return requestDao.findById(id).orElse(null);
    }
}
