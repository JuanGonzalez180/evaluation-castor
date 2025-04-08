package com.evaluation.castor.employee.request.controller;

import com.evaluation.castor.employee.request.model.entity.Request;
import com.evaluation.castor.employee.request.services.RequestService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/request")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class RequestController {
    private final RequestService requestService;

    public RequestController(RequestService requestService){
        this.requestService = requestService;
    }

    @GetMapping("")
    public ResponseEntity<List<Request>> getRequest() {
        List<Request> request = requestService.findAll();
        return new ResponseEntity<>(request, HttpStatus.OK);
    }
}
