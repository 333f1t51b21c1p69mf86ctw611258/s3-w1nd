package com.dasanzhone.seawind.swweb.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.*;
import javax.validation.constraints.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;
import java.util.Objects;

import com.dasanzhone.seawind.swweb.domain.enumeration.WorkflowCode;

/**
 * Workflow entity.
 */
@ApiModel(description = "Workflow entity.")
@Entity
@Table(name = "workflow")
public class Workflow implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "workflow_code", nullable = false)
    private WorkflowCode workflowCode;

    @NotNull
    @Size(max = 255)
    @Column(name = "workflow_name", length = 255, nullable = false)
    private String workflowName;

    @Size(max = 1023)
    @Column(name = "description", length = 1023)
    private String description;

    @NotNull
    @Column(name = "created_by", nullable = false)
    private Long createdBy;

    @NotNull
    @Column(name = "created_date", nullable = false)
    private LocalDate createdDate;

    @NotNull
    @Column(name = "last_modified_by", nullable = false)
    private Long lastModifiedBy;

    @NotNull
    @Column(name = "last_modified_date", nullable = false)
    private LocalDate lastModifiedDate;

    /**
     * The relationship of Workflow entity and WorkflowStep entity.
     */
    @ApiModelProperty(value = "The relationship of Workflow entity and WorkflowStep entity.")
    @OneToMany(mappedBy = "workflow")
    @JsonIgnore
    private Set<WorkflowStep> workflowSteps = new HashSet<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public WorkflowCode getWorkflowCode() {
        return workflowCode;
    }

    public Workflow workflowCode(WorkflowCode workflowCode) {
        this.workflowCode = workflowCode;
        return this;
    }

    public void setWorkflowCode(WorkflowCode workflowCode) {
        this.workflowCode = workflowCode;
    }

    public String getWorkflowName() {
        return workflowName;
    }

    public Workflow workflowName(String workflowName) {
        this.workflowName = workflowName;
        return this;
    }

    public void setWorkflowName(String workflowName) {
        this.workflowName = workflowName;
    }

    public String getDescription() {
        return description;
    }

    public Workflow description(String description) {
        this.description = description;
        return this;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public Workflow createdBy(Long createdBy) {
        this.createdBy = createdBy;
        return this;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDate getCreatedDate() {
        return createdDate;
    }

    public Workflow createdDate(LocalDate createdDate) {
        this.createdDate = createdDate;
        return this;
    }

    public void setCreatedDate(LocalDate createdDate) {
        this.createdDate = createdDate;
    }

    public Long getLastModifiedBy() {
        return lastModifiedBy;
    }

    public Workflow lastModifiedBy(Long lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
        return this;
    }

    public void setLastModifiedBy(Long lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
    }

    public LocalDate getLastModifiedDate() {
        return lastModifiedDate;
    }

    public Workflow lastModifiedDate(LocalDate lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
        return this;
    }

    public void setLastModifiedDate(LocalDate lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    public Set<WorkflowStep> getWorkflowSteps() {
        return workflowSteps;
    }

    public Workflow workflowSteps(Set<WorkflowStep> workflowSteps) {
        this.workflowSteps = workflowSteps;
        return this;
    }

    public Workflow addWorkflowStep(WorkflowStep workflowStep) {
        this.workflowSteps.add(workflowStep);
        workflowStep.setWorkflow(this);
        return this;
    }

    public Workflow removeWorkflowStep(WorkflowStep workflowStep) {
        this.workflowSteps.remove(workflowStep);
        workflowStep.setWorkflow(null);
        return this;
    }

    public void setWorkflowSteps(Set<WorkflowStep> workflowSteps) {
        this.workflowSteps = workflowSteps;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Workflow workflow = (Workflow) o;
        if (workflow.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), workflow.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return "Workflow{" +
            "id=" + getId() +
            ", workflowCode='" + getWorkflowCode() + "'" +
            ", workflowName='" + getWorkflowName() + "'" +
            ", description='" + getDescription() + "'" +
            ", createdBy='" + getCreatedBy() + "'" +
            ", createdDate='" + getCreatedDate() + "'" +
            ", lastModifiedBy='" + getLastModifiedBy() + "'" +
            ", lastModifiedDate='" + getLastModifiedDate() + "'" +
            "}";
    }
}
