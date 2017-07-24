package com.dasanzhone.seawind.swweb.service.mapper;

import com.dasanzhone.seawind.swweb.domain.*;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowDTO;

import org.mapstruct.*;

/**
 * Mapper for the entity Workflow and its DTO WorkflowDTO.
 */
@Mapper(componentModel = "spring", uses = {})
public interface WorkflowMapper extends EntityMapper <WorkflowDTO, Workflow> {
    
    @Mapping(target = "workflowSteps", ignore = true)
    Workflow toEntity(WorkflowDTO workflowDTO); 
    default Workflow fromId(Long id) {
        if (id == null) {
            return null;
        }
        Workflow workflow = new Workflow();
        workflow.setId(id);
        return workflow;
    }
}
