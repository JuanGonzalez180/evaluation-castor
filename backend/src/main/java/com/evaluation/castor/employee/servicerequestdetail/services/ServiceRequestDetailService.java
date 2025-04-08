package com.evaluation.castor.employee.servicerequestdetail.services;

import com.evaluation.castor.employee.servicerequestdetail.model.entity.ServiceRequestDetail;

import java.util.List;

public interface ServiceRequestDetailService {
    List<ServiceRequestDetail> findByRequestId(Long requestId);
}
