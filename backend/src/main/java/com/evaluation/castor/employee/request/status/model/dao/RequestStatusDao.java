package com.evaluation.castor.employee.request.status.model.dao;

import com.evaluation.castor.employee.request.status.model.entity.RequestStatus;
import org.springframework.data.repository.CrudRepository;

public interface RequestStatusDao  extends CrudRepository<RequestStatus, Long> {
}
