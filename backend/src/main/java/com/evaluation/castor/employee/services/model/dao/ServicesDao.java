package com.evaluation.castor.employee.services.model.dao;

import com.evaluation.castor.employee.services.model.entity.Services;
import org.springframework.data.repository.CrudRepository;

public interface ServicesDao  extends CrudRepository<Services, Long> {
}
