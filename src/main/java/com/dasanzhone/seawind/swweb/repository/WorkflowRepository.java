package com.dasanzhone.seawind.swweb.repository;

import com.dasanzhone.seawind.swweb.domain.Workflow;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.*;


/**
 * Spring Data JPA repository for the Workflow entity.
 */
@SuppressWarnings("unused")
@Repository
public interface WorkflowRepository extends JpaRepository<Workflow,Long> {
    
}
