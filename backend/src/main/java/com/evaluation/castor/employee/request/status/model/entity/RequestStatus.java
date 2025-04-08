package com.evaluation.castor.employee.request.status.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

import java.util.Date;

@Entity
@Table(name = "request_status")
@Getter
public class RequestStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_id")
    private Long statusId;

    @NotNull(message = "El nombre del cargo")
    private String name;

    private String description;

    private String color;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationAt;
}
