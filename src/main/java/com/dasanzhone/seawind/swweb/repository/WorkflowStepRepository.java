package com.dasanzhone.seawind.swweb.repository;

import com.dasanzhone.seawind.swweb.domain.WorkflowStep;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.*;


/**
 * Spring Data JPA repository for the WorkflowStep entity.
 */
@SuppressWarnings("unused")
@Repository
public interface WorkflowStepRepository extends JpaRepository<WorkflowStep,Long> {
    
}
