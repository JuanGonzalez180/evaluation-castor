package com.evaluation.castor.employee.requesters.model.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

import java.util.Date;

@Entity
@Table(name = "requesters")
@Getter
public class Requesters {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "requester_id")
    private Long requesterId;

    private String name;
    private String email;
    private String phone;
    private String address;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationAt;
}
