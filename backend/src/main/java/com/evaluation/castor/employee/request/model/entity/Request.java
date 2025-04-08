package com.evaluation.castor.employee.request.model.entity;

import com.evaluation.castor.employee.request.status.model.entity.RequestStatus;
import com.evaluation.castor.employee.requesters.model.entity.Requesters;
import com.evaluation.castor.employee.servicerequestdetail.model.entity.ServiceRequestDetail;
import jakarta.persistence.*;
import lombok.Getter;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "requests")
@Getter
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "request_id")
    private Long requestId;

    @Column(name = "request_date")
    private Date requestDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "requester_id")
    private Requesters requester;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "status_id")
    private RequestStatus status;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationAt;

    @OneToMany(mappedBy = "request")
    private Set<ServiceRequestDetail> serviceRequestDetails = new HashSet<>();
}
