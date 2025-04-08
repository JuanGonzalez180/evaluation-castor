package com.evaluation.castor.employee.servicerequestdetail.controller;

import com.evaluation.castor.employee.servicerequestdetail.model.entity.ServiceRequestDetail;
import com.evaluation.castor.employee.servicerequestdetail.services.ServiceRequestDetailService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/service-request-details")
public class ServiceRequestDetailController {
    private final ServiceRequestDetailService serviceRequestDetailService;

    public ServiceRequestDetailController(ServiceRequestDetailService serviceRequestDetailService) {
        this.serviceRequestDetailService = serviceRequestDetailService;
    }

    @GetMapping("/by-request/{requestId}")
    public ResponseEntity<?> findByRequestId(@PathVariable Long requestId) {
        try {
            List<ServiceRequestDetail> details = this.serviceRequestDetailService.findByRequestId(requestId);

            if (details.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "No se encontraron detalles para la solicitud con ID: " + requestId);
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            return new ResponseEntity<>(details, HttpStatus.OK);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Error al buscar detalles por ID de solicitud");
            response.put("error", e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}