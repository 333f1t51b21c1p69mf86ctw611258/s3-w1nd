package com.dasanzhone.seawind.swweb.repository;

import com.dasanzhone.seawind.swweb.domain.Workflow;
import com.dasanzhone.seawind.swweb.domain.WorkflowStep;
import com.dasanzhone.seawind.swweb.domain.enumeration.WorkflowCode;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.*;


/**
 * Spring Data JPA repository for the Workflow entity.
 */
@SuppressWarnings("unused")
@Repository
public interface WorkflowRepository extends JpaRepository<Workflow,Long> {

    @Query("select w from Workflow w where (w.workflowCode = :workflowCode)")
    Workflow findByWorkflowCode(@Param("workflowCode") WorkflowCode workflowCode);

}
