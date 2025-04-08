package com.evaluation.castor.employee.position.model.dao;

import com.evaluation.castor.employee.position.model.entity.Position;
import org.springframework.data.repository.CrudRepository;

public interface PositionDao extends CrudRepository<Position, Long> {
}
