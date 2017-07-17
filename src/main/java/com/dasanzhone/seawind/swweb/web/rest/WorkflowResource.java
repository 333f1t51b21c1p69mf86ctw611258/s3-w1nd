package com.dasanzhone.seawind.swweb.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.dasanzhone.seawind.swweb.domain.Workflow;

import com.dasanzhone.seawind.swweb.repository.WorkflowRepository;
import com.dasanzhone.seawind.swweb.web.rest.util.HeaderUtil;
import com.dasanzhone.seawind.swweb.web.rest.util.PaginationUtil;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowDTO;
import com.dasanzhone.seawind.swweb.service.mapper.WorkflowMapper;
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
 * REST controller for managing Workflow.
 */
@RestController
@RequestMapping("/api")
public class WorkflowResource {

    private final Logger log = LoggerFactory.getLogger(WorkflowResource.class);

    private static final String ENTITY_NAME = "workflow";

    private final WorkflowRepository workflowRepository;

    private final WorkflowMapper workflowMapper;

    public WorkflowResource(WorkflowRepository workflowRepository, WorkflowMapper workflowMapper) {
        this.workflowRepository = workflowRepository;
        this.workflowMapper = workflowMapper;
    }

    /**
     * POST  /workflows : Create a new workflow.
     *
     * @param workflowDTO the workflowDTO to create
     * @return the ResponseEntity with status 201 (Created) and with body the new workflowDTO, or with status 400 (Bad Request) if the workflow has already an ID
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PostMapping("/workflows")
    @Timed
    public ResponseEntity<WorkflowDTO> createWorkflow(@Valid @RequestBody WorkflowDTO workflowDTO) throws URISyntaxException {
        log.debug("REST request to save Workflow : {}", workflowDTO);
        if (workflowDTO.getId() != null) {
            return ResponseEntity.badRequest().headers(HeaderUtil.createFailureAlert(ENTITY_NAME, "idexists", "A new workflow cannot already have an ID")).body(null);
        }
        Workflow workflow = workflowMapper.toEntity(workflowDTO);
        workflow = workflowRepository.save(workflow);
        WorkflowDTO result = workflowMapper.toDto(workflow);
        return ResponseEntity.created(new URI("/api/workflows/" + result.getId()))
            .headers(HeaderUtil.createEntityCreationAlert(ENTITY_NAME, result.getId().toString()))
            .body(result);
    }

    /**
     * PUT  /workflows : Updates an existing workflow.
     *
     * @param workflowDTO the workflowDTO to update
     * @return the ResponseEntity with status 200 (OK) and with body the updated workflowDTO,
     * or with status 400 (Bad Request) if the workflowDTO is not valid,
     * or with status 500 (Internal Server Error) if the workflowDTO couldn't be updated
     * @throws URISyntaxException if the Location URI syntax is incorrect
     */
    @PutMapping("/workflows")
    @Timed
    public ResponseEntity<WorkflowDTO> updateWorkflow(@Valid @RequestBody WorkflowDTO workflowDTO) throws URISyntaxException {
        log.debug("REST request to update Workflow : {}", workflowDTO);
        if (workflowDTO.getId() == null) {
            return createWorkflow(workflowDTO);
        }
        Workflow workflow = workflowMapper.toEntity(workflowDTO);
        workflow = workflowRepository.save(workflow);
        WorkflowDTO result = workflowMapper.toDto(workflow);
        return ResponseEntity.ok()
            .headers(HeaderUtil.createEntityUpdateAlert(ENTITY_NAME, workflowDTO.getId().toString()))
            .body(result);
    }

    /**
     * GET  /workflows : get all the workflows.
     *
     * @param pageable the pagination information
     * @return the ResponseEntity with status 200 (OK) and the list of workflows in body
     */
    @GetMapping("/workflows")
    @Timed
    public ResponseEntity<List<WorkflowDTO>> getAllWorkflows(@ApiParam Pageable pageable) {
        log.debug("REST request to get a page of Workflows");
        Page<Workflow> page = workflowRepository.findAll(pageable);
        HttpHeaders headers = PaginationUtil.generatePaginationHttpHeaders(page, "/api/workflows");
        return new ResponseEntity<>(workflowMapper.toDto(page.getContent()), headers, HttpStatus.OK);
    }

    /**
     * GET  /workflows/:id : get the "id" workflow.
     *
     * @param id the id of the workflowDTO to retrieve
     * @return the ResponseEntity with status 200 (OK) and with body the workflowDTO, or with status 404 (Not Found)
     */
    @GetMapping("/workflows/{id}")
    @Timed
    public ResponseEntity<WorkflowDTO> getWorkflow(@PathVariable Long id) {
        log.debug("REST request to get Workflow : {}", id);
        Workflow workflow = workflowRepository.findOne(id);
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);
        return ResponseUtil.wrapOrNotFound(Optional.ofNullable(workflowDTO));
    }

    /**
     * DELETE  /workflows/:id : delete the "id" workflow.
     *
     * @param id the id of the workflowDTO to delete
     * @return the ResponseEntity with status 200 (OK)
     */
    @DeleteMapping("/workflows/{id}")
    @Timed
    public ResponseEntity<Void> deleteWorkflow(@PathVariable Long id) {
        log.debug("REST request to delete Workflow : {}", id);
        workflowRepository.delete(id);
        return ResponseEntity.ok().headers(HeaderUtil.createEntityDeletionAlert(ENTITY_NAME, id.toString())).build();
    }
}
