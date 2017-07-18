package com.dasanzhone.seawind.swweb.repository;

import com.dasanzhone.seawind.swweb.domain.WorkflowStep;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.*;

import java.util.List;

/**
 * Spring Data JPA repository for the WorkflowStep entity.
 */
@SuppressWarnings("unused")
@Repository
public interface WorkflowStepRepository extends JpaRepository<WorkflowStep,Long> {

    @Query("select s from WorkflowStep s join s.workflow w where (w.id = :workflowId) order by s.stepNumber")
    Page<WorkflowStep> findByWorkflowId(Pageable pageable, @Param("workflowId") Long workflowId);

    @Query("select s from WorkflowStep s join s.workflow w where (w.id = :workflowId) order by s.stepNumber")
    List<WorkflowStep> findByWorkflowId(@Param("workflowId") Long workflowId);

}
