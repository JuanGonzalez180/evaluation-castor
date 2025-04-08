package com.evaluation.castor.employee.request.model.dao;

import com.evaluation.castor.employee.request.model.entity.Request;
import org.springframework.data.repository.CrudRepository;

public interface RequestDao  extends CrudRepository<Request, Long> {
}
