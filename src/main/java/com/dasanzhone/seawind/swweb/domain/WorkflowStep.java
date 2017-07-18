package com.dasanzhone.seawind.swweb.domain;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.*;
import javax.validation.constraints.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.Objects;

import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyName;

import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyType;

/**
 * The WorkflowStep entity.
 */
@ApiModel(description = "The WorkflowStep entity.")
@Entity
@Table(name = "workflow_step")
public class WorkflowStep implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @Size(max = 255)
    @Column(name = "step_name", length = 255, nullable = false)
    private String stepName;

    @NotNull
    @Column(name = "step_number", nullable = false)
    private Integer stepNumber;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "property_name", nullable = false)
    private PropertyName propertyName;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "property_type", nullable = false)
    private PropertyType propertyType;

    @Size(max = 255)
    @Column(name = "default_value", length = 255)
    private String defaultValue;

    @Size(max = 1023)
    @Column(name = "map_values", length = 1023)
    private String mapValues;

    @NotNull
    @Size(max = 255)
    @Column(name = "oid_pattern", length = 255, nullable = false)
    private String oidPattern;

    @Size(max = 1023)
    @Column(name = "description", length = 1023)
    private String description;

    @Column(name = "customized_step")
    private Boolean customizedStep;

    @NotNull
    @Column(name = "set_or_get", nullable = false)
    private Boolean setOrGet;

    @Column(name = "get_expected_value")
    private String getExpectedValue;

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
     * Another side of the same relationship
     */
    @ApiModelProperty(value = "Another side of the same relationship")
    @ManyToOne(optional = false)
    @NotNull
    private Workflow workflow;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getStepName() {
        return stepName;
    }

    public WorkflowStep stepName(String stepName) {
        this.stepName = stepName;
        return this;
    }

    public void setStepName(String stepName) {
        this.stepName = stepName;
    }

    public Integer getStepNumber() {
        return stepNumber;
    }

    public WorkflowStep stepNumber(Integer stepNumber) {
        this.stepNumber = stepNumber;
        return this;
    }

    public void setStepNumber(Integer stepNumber) {
        this.stepNumber = stepNumber;
    }

    public PropertyName getPropertyName() {
        return propertyName;
    }

    public WorkflowStep propertyName(PropertyName propertyName) {
        this.propertyName = propertyName;
        return this;
    }

    public void setPropertyName(PropertyName propertyName) {
        this.propertyName = propertyName;
    }

    public PropertyType getPropertyType() {
        return propertyType;
    }

    public WorkflowStep propertyType(PropertyType propertyType) {
        this.propertyType = propertyType;
        return this;
    }

    public void setPropertyType(PropertyType propertyType) {
        this.propertyType = propertyType;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public WorkflowStep defaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
        return this;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }

    public String getMapValues() {
        return mapValues;
    }

    public WorkflowStep mapValues(String mapValues) {
        this.mapValues = mapValues;
        return this;
    }

    public void setMapValues(String mapValues) {
        this.mapValues = mapValues;
    }

    public String getOidPattern() {
        return oidPattern;
    }

    public WorkflowStep oidPattern(String oidPattern) {
        this.oidPattern = oidPattern;
        return this;
    }

    public void setOidPattern(String oidPattern) {
        this.oidPattern = oidPattern;
    }

    public String getDescription() {
        return description;
    }

    public WorkflowStep description(String description) {
        this.description = description;
        return this;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean isCustomizedStep() {
        return customizedStep;
    }

    public WorkflowStep customizedStep(Boolean customizedStep) {
        this.customizedStep = customizedStep;
        return this;
    }

    public void setCustomizedStep(Boolean customizedStep) {
        this.customizedStep = customizedStep;
    }

    public Boolean isSetOrGet() {
        return setOrGet;
    }

    public WorkflowStep setOrGet(Boolean setOrGet) {
        this.setOrGet = setOrGet;
        return this;
    }

    public void setSetOrGet(Boolean setOrGet) {
        this.setOrGet = setOrGet;
    }

    public String getGetExpectedValue() {
        return getExpectedValue;
    }

    public WorkflowStep getExpectedValue(String getExpectedValue) {
        this.getExpectedValue = getExpectedValue;
        return this;
    }

    public void setGetExpectedValue(String getExpectedValue) {
        this.getExpectedValue = getExpectedValue;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public WorkflowStep createdBy(Long createdBy) {
        this.createdBy = createdBy;
        return this;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDate getCreatedDate() {
        return createdDate;
    }

    public WorkflowStep createdDate(LocalDate createdDate) {
        this.createdDate = createdDate;
        return this;
    }

    public void setCreatedDate(LocalDate createdDate) {
        this.createdDate = createdDate;
    }

    public Long getLastModifiedBy() {
        return lastModifiedBy;
    }

    public WorkflowStep lastModifiedBy(Long lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
        return this;
    }

    public void setLastModifiedBy(Long lastModifiedBy) {
        this.lastModifiedBy = lastModifiedBy;
    }

    public LocalDate getLastModifiedDate() {
        return lastModifiedDate;
    }

    public WorkflowStep lastModifiedDate(LocalDate lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
        return this;
    }

    public void setLastModifiedDate(LocalDate lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    public Workflow getWorkflow() {
        return workflow;
    }

    public WorkflowStep workflow(Workflow workflow) {
        this.workflow = workflow;
        return this;
    }

    public void setWorkflow(Workflow workflow) {
        this.workflow = workflow;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        WorkflowStep workflowStep = (WorkflowStep) o;
        if (workflowStep.getId() == null || getId() == null) {
            return false;
        }
        return Objects.equals(getId(), workflowStep.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(getId());
    }

    @Override
    public String toString() {
        return "WorkflowStep{" +
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
