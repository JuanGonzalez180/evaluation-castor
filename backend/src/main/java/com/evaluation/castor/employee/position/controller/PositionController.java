package com.evaluation.castor.employee.position.controller;

import com.evaluation.castor.employee.position.model.entity.Position;
import com.evaluation.castor.employee.position.services.PositionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/position")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class PositionController {
    private final PositionService positionService;

    public PositionController(PositionService positionService) {
        this.positionService = positionService;
    }

    @GetMapping("")
    public ResponseEntity<List<Position>> getPositions() {
        List<Position> positions = positionService.findAll();
        return new ResponseEntity<>(positions, HttpStatus.OK);
    }
}
