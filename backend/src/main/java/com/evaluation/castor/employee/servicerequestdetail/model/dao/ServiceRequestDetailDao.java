package com.evaluation.castor.employee.servicerequestdetail.model.dao;

import com.evaluation.castor.employee.servicerequestdetail.model.entity.ServiceRequestDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ServiceRequestDetailDao extends JpaRepository<ServiceRequestDetail, Long> {
    List<ServiceRequestDetail> findByRequest(Long requestId);
}
