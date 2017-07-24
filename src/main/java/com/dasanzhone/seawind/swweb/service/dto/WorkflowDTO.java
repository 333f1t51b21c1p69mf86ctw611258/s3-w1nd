package com.dasanzhone.seawind.swweb.service.dto;


import java.time.LocalDate;
import javax.validation.constraints.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import java.util.Objects;
import com.dasanzhone.seawind.swweb.domain.enumeration.WorkflowCode;

/**
 * A DTO for the Workflow entity.
 */
public class WorkflowDTO implements Serializable {

    private Long id;

    @NotNull
    private WorkflowCode workflowCode;

    @NotNull
    @Size(max = 255)
    private String workflowName;

    @Size(max = 1023)
    private String description;

    @NotNull
    private Long createdBy;

    @NotNull
    private LocalDate createdDate;

    @NotNull
    private Long lastModifiedBy;

    @NotNull
    private LocalDate lastModifiedDate;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public WorkflowCode getWorkflowCode() {
        return workflowCode;
    }

    public void setWorkflowCode(WorkflowCode workflowCode) {
        this.workflowCode = workflowCode;
    }

    public String getWorkflowName() {
        return workflowName;
    }

    public void setWorkflowName(String workflowName) {
        this.workflowName = workflowName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDate getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDate createdDate) {
        this.createdDate = createdDate;
    }

    public Long getLastModifiedBy() {
        return lastModifiedBy;
    }

    public void setLastModifiedBy(Long lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
    }

    public LocalDate getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(LocalDate lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        WorkflowDTO workflowDTO = (WorkflowDTO) o;
        if(workflowDTO.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), workflowDTO.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return "WorkflowDTO{" +
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
