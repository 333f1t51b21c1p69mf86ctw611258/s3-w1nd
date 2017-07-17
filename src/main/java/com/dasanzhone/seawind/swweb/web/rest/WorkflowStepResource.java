package com.dasanzhone.seawind.swweb.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.dasanzhone.seawind.swweb.domain.WorkflowStep;

import com.dasanzhone.seawind.swweb.repository.WorkflowStepRepository;
import com.dasanzhone.seawind.swweb.web.rest.util.HeaderUtil;
import com.dasanzhone.seawind.swweb.web.rest.util.PaginationUtil;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowStepDTO;
import com.dasanzhone.seawind.swweb.service.mapper.WorkflowStepMapper;
import io.swagger.annotations.ApiParam;
import io.github.jhipster.web.util.ResponseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.net.URI;
import java.net.URISyntaxException;

import java.util.List;
import java.util.Optional;

/**
 * REST controller for managing WorkflowStep.
 */
@RestController
@RequestMapping("/api")
public class WorkflowStepResource {

    private final Logger log = LoggerFactory.getLogger(WorkflowStepResource.class);

    private static final String ENTITY_NAME = "workflowStep";

    private final WorkflowStepRepository workflowStepRepository;

    private final WorkflowStepMapper workflowStepMapper;

    public WorkflowStepResource(WorkflowStepRepository workflowStepRepository, WorkflowStepMapper workflowStepMapper) {
        this.workflowStepRepository = workflowStepRepository;
        this.workflowStepMapper = workflowStepMapper;
    }

    /**
     * POST  /workflow-steps : Create a new workflowStep.
     *
     * @param workflowStepDTO the workflowStepDTO to create
     * @return the ResponseEntity with status 201 (Created) and with body the new workflowStepDTO, or with status 400 (Bad Request) if the workflowStep has already an ID
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PostMapping("/workflow-steps")
    @Timed
    public ResponseEntity<WorkflowStepDTO> createWorkflowStep(@Valid @RequestBody WorkflowStepDTO workflowStepDTO) throws URISyntaxException {
        log.debug("REST request to save WorkflowStep : {}", workflowStepDTO);
        if (workflowStepDTO.getId() != null) {
            return ResponseEntity.badRequest().headers(HeaderUtil.createFailureAlert(ENTITY_NAME, "idexists", "A new workflowStep cannot already have an ID")).body(null);
        }
        WorkflowStep workflowStep = workflowStepMapper.toEntity(workflowStepDTO);
        workflowStep = workflowStepRepository.save(workflowStep);
        WorkflowStepDTO result = workflowStepMapper.toDto(workflowStep);
        return ResponseEntity.created(new URI("/api/workflow-steps/" + result.getId()))
            .headers(HeaderUtil.createEntityCreationAlert(ENTITY_NAME, result.getId().toString()))
            .body(result);
    }

    /**
     * PUT  /workflow-steps : Updates an existing workflowStep.
     *
     * @param workflowStepDTO the workflowStepDTO to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated workflowStepDTO,
     * or with status 400 (Bad Request) if the workflowStepDTO is not valid,
     * or with status 500 (Internal Server Error) if the workflowStepDTO couldn't be updated
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PutMapping("/workflow-steps")
    @Timed
    public ResponseEntity<WorkflowStepDTO> updateWorkflowStep(@Valid @RequestBody WorkflowStepDTO workflowStepDTO) throws URISyntaxException {
        log.debug("REST request to update WorkflowStep : {}", workflowStepDTO);
        if (workflowStepDTO.getId() == null) {
            return createWorkflowStep(workflowStepDTO);
        }
        WorkflowStep workflowStep = workflowStepMapper.toEntity(workflowStepDTO);
        workflowStep = workflowStepRepository.save(workflowStep);
        WorkflowStepDTO result = workflowStepMapper.toDto(workflowStep);
        return ResponseEntity.ok()
            .headers(HeaderUtil.createEntityUpdateAlert(ENTITY_NAME, workflowStepDTO.getId().toString()))
            .body(result);
    }

    /**
     * GET  /workflow-steps : get all the workflowSteps.
     *
     * @param pageable the pagination information
     * @return the ResponseEntity with status 200 (OK) and the list of workflowSteps in body
     */
    @GetMapping("/workflow-steps")
    @Timed
    public ResponseEntity<List<WorkflowStepDTO>> getAllWorkflowSteps(@ApiParam Pageable pageable) {
        log.debug("REST request to get a page of WorkflowSteps");
        Page<WorkflowStep> page = workflowStepRepository.findAll(pageable);
        HttpHeaders headers = PaginationUtil.generatePaginationHttpHeaders(page, "/api/workflow-steps");
        return new ResponseEntity<>(workflowStepMapper.toDto(page.getContent()), headers, HttpStatus.OK);
    }

    /**
     * GET  /workflow-steps/:id : get the "id" workflowStep.
     *
     * @param id the id of the workflowStepDTO to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the workflowStepDTO, or with status 404 (Not Found)
     */
    @GetMapping("/workflow-steps/{id}")
    @Timed
    public ResponseEntity<WorkflowStepDTO> getWorkflowStep(@PathVariable Long id) {
        log.debug("REST request to get WorkflowStep : {}", id);
        WorkflowStep workflowStep = workflowStepRepository.findOne(id);
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);
        return ResponseUtil.wrapOrNotFound(Optional.ofNullable(workflowStepDTO));
    }

    /**
     * DELETE  /workflow-steps/:id : delete the "id" workflowStep.
     *
     * @param id the id of the workflowStepDTO to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @DeleteMapping("/workflow-steps/{id}")
    @Timed
    public ResponseEntity<Void> deleteWorkflowStep(@PathVariable Long id) {
        log.debug("REST request to delete WorkflowStep : {}", id);
        workflowStepRepository.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert(ENTITY_NAME, id.toString())).build();
    }
}
