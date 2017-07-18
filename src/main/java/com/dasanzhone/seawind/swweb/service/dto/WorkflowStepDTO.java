package com.dasanzhone.seawind.swweb.service.dto;


import java.time.LocalDate;
import javax.validation.constraints.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
import java.util.Objects;
import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyName;
import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyType;

/**
 * A DTO for the WorkflowStep entity.
 */
public class WorkflowStepDTO implements Serializable {

    private Long id;

    @NotNull
    @Size(max = 255)
    private String stepName;

    @NotNull
    private Integer stepNumber;

    private PropertyName propertyName;

    @NotNull
    private PropertyType propertyType;

    @Size(max = 255)
    private String defaultValue;

    @Size(max = 1023)
    private String mapValues;

    @NotNull
    @Size(max = 255)
    private String oidPattern;

    @Size(max = 1023)
    private String description;

    private Boolean customizedStep;

    @NotNull
    private Boolean setOrGet;

    private String getExpectedValue;

    @NotNull
    private Long createdBy;

    @NotNull
    private LocalDate createdDate;

    @NotNull
    private Long lastModifiedBy;

    @NotNull
    private LocalDate lastModifiedDate;

    private Long workflowId;

    private String workflowWorkflowName;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getStepName() {
        return stepName;
    }

    public void setStepName(String stepName) {
        this.stepName = stepName;
    }

    public Integer getStepNumber() {
        return stepNumber;
    }

    public void setStepNumber(Integer stepNumber) {
        this.stepNumber = stepNumber;
    }

    public PropertyName getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(PropertyName propertyName) {
        this.propertyName = propertyName;
    }

    public PropertyType getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(PropertyType propertyType) {
        this.propertyType = propertyType;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getMapValues() {
        return mapValues;
    }

    public void setMapValues(String mapValues) {
        this.mapValues = mapValues;
    }

    public String getOidPattern() {
        return oidPattern;
    }

    public void setOidPattern(String oidPattern) {
        this.oidPattern = oidPattern;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean isCustomizedStep() {
        return customizedStep;
    }

    public void setCustomizedStep(Boolean customizedStep) {
        this.customizedStep = customizedStep;
    }

    public Boolean isSetOrGet() {
        return setOrGet;
    }

    public void setSetOrGet(Boolean setOrGet) {
        this.setOrGet = setOrGet;
    }

    public String getGetExpectedValue() {
        return getExpectedValue;
    }

    public void setGetExpectedValue(String getExpectedValue) {
        this.getExpectedValue = getExpectedValue;
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

    public Long getWorkflowId() {
        return workflowId;
    }

    public void setWorkflowId(Long workflowId) {
        this.workflowId = workflowId;
    }

    public String getWorkflowWorkflowName() {
        return workflowWorkflowName;
    }

    public void setWorkflowWorkflowName(String workflowWorkflowName) {
        this.workflowWorkflowName = workflowWorkflowName;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        WorkflowStepDTO workflowStepDTO = (WorkflowStepDTO) o;
        if(workflowStepDTO.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), workflowStepDTO.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return "WorkflowStepDTO{" +
            "id=" + getId() +
            ", stepName='" + getStepName() + "'" +
            ", stepNumber='" + getStepNumber() + "'" +
            ", propertyName='" + getPropertyName() + "'" +
            ", propertyType='" + getPropertyType() + "'" +
            ", defaultValue='" + getDefaultValue() + "'" +
            ", mapValues='" + getMapValues() + "'" +
            ", oidPattern='" + getOidPattern() + "'" +
            ", description='" + getDescription() + "'" +
            ", customizedStep='" + isCustomizedStep() + "'" +
            ", setOrGet='" + isSetOrGet() + "'" +
            ", getExpectedValue='" + getGetExpectedValue() + "'" +
            ", createdBy='" + getCreatedBy() + "'" +
            ", createdDate='" + getCreatedDate() + "'" +
            ", lastModifiedBy='" + getLastModifiedBy() + "'" +
            ", lastModifiedDate='" + getLastModifiedDate() + "'" +
            "}";
    }
}
