package com.evaluation.castor.employee.requesters.services;

import com.evaluation.castor.employee.requesters.model.dao.RequestersDao;
import com.evaluation.castor.employee.requesters.model.entity.Requesters;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RequestersServiceImpl implements RequestersService {

    private final RequestersDao requestersDao;

    public RequestersServiceImpl(RequestersDao requestersDao) {
        this.requestersDao = requestersDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Requesters> findAll() {
        return (List<Requesters>) requestersDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Requesters findById(Long id) {
        return requestersDao.findById(id).orElse(null);
    }
}
