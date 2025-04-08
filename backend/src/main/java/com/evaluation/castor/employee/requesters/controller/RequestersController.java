package com.evaluation.castor.employee.requesters.controller;

import com.evaluation.castor.employee.requesters.model.entity.Requesters;
import com.evaluation.castor.employee.requesters.services.RequestersService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/requesters")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class RequestersController {
    private final RequestersService requestersService;

    public RequestersController(RequestersService requestersService){
        this.requestersService = requestersService;
    }

    @GetMapping("")
    public ResponseEntity<List<Requesters>> getRequesters() {
        List<Requesters> requesters = requestersService.findAll();
        return new ResponseEntity<>(requesters, HttpStatus.OK);
    }
}
