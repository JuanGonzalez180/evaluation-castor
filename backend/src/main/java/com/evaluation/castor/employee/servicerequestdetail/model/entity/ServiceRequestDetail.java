package com.evaluation.castor.employee.servicerequestdetail.model.entity;

import com.evaluation.castor.employee.services.model.entity.Services;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "service_request_detail")
@Getter
@Setter
public class ServiceRequestDetail {
    @Id
    @Column(name = "detail_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "service_id")
    private Services service;

    @Column(name = "request_id")
    private Long request;

    private String observations;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationAt;
}
