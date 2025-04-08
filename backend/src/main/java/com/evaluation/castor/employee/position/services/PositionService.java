package com.evaluation.castor.employee.position.services;

import com.evaluation.castor.employee.position.model.entity.Position;

import java.util.List;

public interface PositionService {
    public List<Position> findAll();

    public Position findById(Long id);
}
