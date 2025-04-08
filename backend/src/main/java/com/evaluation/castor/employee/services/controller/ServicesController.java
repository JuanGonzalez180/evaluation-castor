package com.evaluation.castor.employee.services.controller;

import com.evaluation.castor.employee.services.model.entity.Services;
import com.evaluation.castor.employee.services.services.ServicesService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/service")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class ServicesController {
    private final ServicesService servicesService;

    public ServicesController(ServicesService servicesService){
        this.servicesService = servicesService;
    }

    @GetMapping("")
    public ResponseEntity<List<Services>> getServices() {
        List<Services> services = servicesService.findAll();
        return new ResponseEntity<>(services, HttpStatus.OK);
    }
}
