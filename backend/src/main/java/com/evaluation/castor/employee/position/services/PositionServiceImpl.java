package com.evaluation.castor.employee.position.services;

import com.evaluation.castor.employee.position.model.dao.PositionDao;
import com.evaluation.castor.employee.position.model.entity.Position;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PositionServiceImpl implements PositionService {
    @Autowired
    private PositionDao positionDao;

    @Override
    public Position findById(Long id) {
        return positionDao.findById(id).orElse(null);
    }
}
