package com.dasanzhone.seawind.swweb.service.mapper;

import com.dasanzhone.seawind.swweb.domain.*;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowStepDTO;

import org.mapstruct.*;

/**
 * Mapper for the entity WorkflowStep and its DTO WorkflowStepDTO.
 */
@Mapper(componentModel = "spring", uses = {WorkflowMapper.class, })
public interface WorkflowStepMapper extends EntityMapper <WorkflowStepDTO, WorkflowStep> {

    @Mapping(source = "workflow.id", target = "workflowId")
    @Mapping(source = "workflow.workflowName", target = "workflowWorkflowName")
    WorkflowStepDTO toDto(WorkflowStep workflowStep); 

    @Mapping(source = "workflowId", target = "workflow")
    WorkflowStep toEntity(WorkflowStepDTO workflowStepDTO); 
    default WorkflowStep fromId(Long id) {
        if (id == null) {
            return null;
        }
        WorkflowStep workflowStep = new WorkflowStep();
        workflowStep.setId(id);
        return workflowStep;
    }
}
