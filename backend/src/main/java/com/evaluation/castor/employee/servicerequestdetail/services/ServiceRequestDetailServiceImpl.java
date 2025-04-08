package com.evaluation.castor.employee.servicerequestdetail.services;

import com.evaluation.castor.employee.servicerequestdetail.model.dao.ServiceRequestDetailDao;
import com.evaluation.castor.employee.servicerequestdetail.model.entity.ServiceRequestDetail;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceRequestDetailServiceImpl implements ServiceRequestDetailService{
    private final ServiceRequestDetailDao serviceRequestDetailDao;

    public ServiceRequestDetailServiceImpl(ServiceRequestDetailDao serviceRequestDetailDao){
        this.serviceRequestDetailDao = serviceRequestDetailDao;
    }

    @Override
    public List<ServiceRequestDetail> findByRequestId(Long requestId) {
        return this.serviceRequestDetailDao.findByRequest(requestId);
    }
}
