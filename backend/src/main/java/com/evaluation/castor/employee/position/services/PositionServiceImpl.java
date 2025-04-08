package com.evaluation.castor.employee.position.services;

import com.evaluation.castor.employee.position.model.dao.PositionDao;
import com.evaluation.castor.employee.position.model.entity.Position;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PositionServiceImpl implements PositionService {
    private final PositionDao positionDao;

    public PositionServiceImpl(PositionDao positionDao) {
        this.positionDao = positionDao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Position> findAll() {
        return (List<Position>) positionDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Position findById(Long id) {
        return positionDao.findById(id).orElse(null);
    }
}
