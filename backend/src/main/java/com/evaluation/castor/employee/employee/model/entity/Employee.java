package com.evaluation.castor.employee.employee.model.entity;

import java.util.Date;

import com.evaluation.castor.employee.position.model.entity.Position;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "employees")
@Getter
@Setter
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "El número de identificación es obligatorio")
    @Column(name = "identification_number")
    private Long identificationNumber;

    @NotNull(message = "El nombre es obligatorio")
    private String name;

    @NotNull(message = "La fecha de contratación es obligatoria")
    @Column(name = "hire_date")
    private Date hireDate;

    @NotNull(message = "El ID de posición es obligatorio")
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "position_id")
    private Position position;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @PrePersist
    public void prePersist() {
        this.createdAt = new Date();
    }
}
