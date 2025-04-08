package com.evaluation.castor.employee.request.status.controller;

import com.evaluation.castor.employee.request.status.model.entity.RequestStatus;
import com.evaluation.castor.employee.request.status.services.RequestStatusService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/request-status")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class RequestStatusController {
    private final RequestStatusService requestStatusService;

    public RequestStatusController(RequestStatusService requestStatusService){
        this.requestStatusService = requestStatusService;
    }

    @GetMapping("")
    public ResponseEntity<List<RequestStatus>> getRequestStatus() {
        List<RequestStatus> requestStatus = requestStatusService.findAll();
        return new ResponseEntity<>(requestStatus, HttpStatus.OK);
    }
}
