package com.evaluation.castor.employee.requesters.model.dao;

import com.evaluation.castor.employee.requesters.model.entity.Requesters;
import org.springframework.data.repository.CrudRepository;

public interface RequestersDao  extends CrudRepository<Requesters, Long> {
}
