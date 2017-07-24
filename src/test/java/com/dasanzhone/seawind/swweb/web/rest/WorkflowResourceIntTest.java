package com.dasanzhone.seawind.swweb.web.rest;

import com.dasanzhone.seawind.swweb.SwwebApp;

import com.dasanzhone.seawind.swweb.domain.Workflow;
import com.dasanzhone.seawind.swweb.repository.WorkflowRepository;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowDTO;
import com.dasanzhone.seawind.swweb.service.mapper.WorkflowMapper;
import com.dasanzhone.seawind.swweb.web.rest.errors.ExceptionTranslator;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.hasItem;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.dasanzhone.seawind.swweb.domain.enumeration.WorkflowCode;
/**
 * Test class for the WorkflowResource REST controller.
 *
 * @see WorkflowResource
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SwwebApp.class)
public class WorkflowResourceIntTest {

    private static final WorkflowCode DEFAULT_WORKFLOW_CODE = WorkflowCode.DECLARE_ONT_ID;
    private static final WorkflowCode UPDATED_WORKFLOW_CODE = WorkflowCode.ACTIVATE_DEACTIVATE_ONT_ID;

    private static final String DEFAULT_WORKFLOW_NAME = "AAAAAAAAAA";
    private static final String UPDATED_WORKFLOW_NAME = "BBBBBBBBBB";

    private static final String DEFAULT_DESCRIPTION = "AAAAAAAAAA";
    private static final String UPDATED_DESCRIPTION = "BBBBBBBBBB";

    private static final Long DEFAULT_CREATED_BY = 1L;
    private static final Long UPDATED_CREATED_BY = 2L;

    private static final LocalDate DEFAULT_CREATED_DATE = LocalDate.ofEpochDay(0L);
    private static final LocalDate UPDATED_CREATED_DATE = LocalDate.now(ZoneId.systemDefault());

    private static final Long DEFAULT_LAST_MODIFIED_BY = 1L;
    private static final Long UPDATED_LAST_MODIFIED_BY = 2L;

    private static final LocalDate DEFAULT_LAST_MODIFIED_DATE = LocalDate.ofEpochDay(0L);
    private static final LocalDate UPDATED_LAST_MODIFIED_DATE = LocalDate.now(ZoneId.systemDefault());

    @Autowired
    private WorkflowRepository workflowRepository;

    @Autowired
    private WorkflowMapper workflowMapper;

    @Autowired
    private MappingJackson2HttpMessageConverter jacksonMessageConverter;

    @Autowired
    private PageableHandlerMethodArgumentResolver pageableArgumentResolver;

    @Autowired
    private ExceptionTranslator exceptionTranslator;

    @Autowired
    private EntityManager em;

    private MockMvc restWorkflowMockMvc;

    private Workflow workflow;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        WorkflowResource workflowResource = new WorkflowResource(workflowRepository, workflowMapper);
        this.restWorkflowMockMvc = MockMvcBuilders.standaloneSetup(workflowResource)
            .setCustomArgumentResolvers(pageableArgumentResolver)
            .setControllerAdvice(exceptionTranslator)
            .setMessageConverters(jacksonMessageConverter).build();
    }

    /**
     * Create an entity for this test.
     *
     * This is a static method, as tests for other entities might also need it,
     * if they test an entity which requires the current entity.
     */
    public static Workflow createEntity(EntityManager em) {
        Workflow workflow = new Workflow()
            .workflowCode(DEFAULT_WORKFLOW_CODE)
            .workflowName(DEFAULT_WORKFLOW_NAME)
            .description(DEFAULT_DESCRIPTION)
            .createdBy(DEFAULT_CREATED_BY)
            .createdDate(DEFAULT_CREATED_DATE)
            .lastModifiedBy(DEFAULT_LAST_MODIFIED_BY)
            .lastModifiedDate(DEFAULT_LAST_MODIFIED_DATE);
        return workflow;
    }

    @Before
    public void initTest() {
        workflow = createEntity(em);
    }

    @Test
    @Transactional
    public void createWorkflow() throws Exception {
        int databaseSizeBeforeCreate = workflowRepository.findAll().size();

        // Create the Workflow
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);
        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isCreated());

        // Validate the Workflow in the database
        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeCreate + 1);
        Workflow testWorkflow = workflowList.get(workflowList.size() - 1);
        assertThat(testWorkflow.getWorkflowCode()).isEqualTo(DEFAULT_WORKFLOW_CODE);
        assertThat(testWorkflow.getWorkflowName()).isEqualTo(DEFAULT_WORKFLOW_NAME);
        assertThat(testWorkflow.getDescription()).isEqualTo(DEFAULT_DESCRIPTION);
        assertThat(testWorkflow.getCreatedBy()).isEqualTo(DEFAULT_CREATED_BY);
        assertThat(testWorkflow.getCreatedDate()).isEqualTo(DEFAULT_CREATED_DATE);
        assertThat(testWorkflow.getLastModifiedBy()).isEqualTo(DEFAULT_LAST_MODIFIED_BY);
        assertThat(testWorkflow.getLastModifiedDate()).isEqualTo(DEFAULT_LAST_MODIFIED_DATE);
    }

    @Test
    @Transactional
    public void createWorkflowWithExistingId() throws Exception {
        int databaseSizeBeforeCreate = workflowRepository.findAll().size();

        // Create the Workflow with an existing ID
        workflow.setId(1L);
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        // An entity with an existing ID cannot be created, so this API call must fail
        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        // Validate the Alice in the database
        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeCreate);
    }

    @Test
    @Transactional
    public void checkWorkflowCodeIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setWorkflowCode(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkWorkflowNameIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setWorkflowName(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkCreatedByIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setCreatedBy(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkCreatedDateIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setCreatedDate(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkLastModifiedByIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setLastModifiedBy(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkLastModifiedDateIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowRepository.findAll().size();
        // set the field null
        workflow.setLastModifiedDate(null);

        // Create the Workflow, which fails.
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        restWorkflowMockMvc.perform(post("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isBadRequest());

        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void getAllWorkflows() throws Exception {
        // Initialize the database
        workflowRepository.saveAndFlush(workflow);

        // Get all the workflowList
        restWorkflowMockMvc.perform(get("/api/workflows?sort=id,desc"))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.[*].id").value(hasItem(workflow.getId().intValue())))
            .andExpect(jsonPath("$.[*].workflowCode").value(hasItem(DEFAULT_WORKFLOW_CODE.toString())))
            .andExpect(jsonPath("$.[*].workflowName").value(hasItem(DEFAULT_WORKFLOW_NAME.toString())))
            .andExpect(jsonPath("$.[*].description").value(hasItem(DEFAULT_DESCRIPTION.toString())))
            .andExpect(jsonPath("$.[*].createdBy").value(hasItem(DEFAULT_CREATED_BY.intValue())))
            .andExpect(jsonPath("$.[*].createdDate").value(hasItem(DEFAULT_CREATED_DATE.toString())))
            .andExpect(jsonPath("$.[*].lastModifiedBy").value(hasItem(DEFAULT_LAST_MODIFIED_BY.intValue())))
            .andExpect(jsonPath("$.[*].lastModifiedDate").value(hasItem(DEFAULT_LAST_MODIFIED_DATE.toString())));
    }

    @Test
    @Transactional
    public void getWorkflow() throws Exception {
        // Initialize the database
        workflowRepository.saveAndFlush(workflow);

        // Get the workflow
        restWorkflowMockMvc.perform(get("/api/workflows/{id}", workflow.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.id").value(workflow.getId().intValue()))
            .andExpect(jsonPath("$.workflowCode").value(DEFAULT_WORKFLOW_CODE.toString()))
            .andExpect(jsonPath("$.workflowName").value(DEFAULT_WORKFLOW_NAME.toString()))
            .andExpect(jsonPath("$.description").value(DEFAULT_DESCRIPTION.toString()))
            .andExpect(jsonPath("$.createdBy").value(DEFAULT_CREATED_BY.intValue()))
            .andExpect(jsonPath("$.createdDate").value(DEFAULT_CREATED_DATE.toString()))
            .andExpect(jsonPath("$.lastModifiedBy").value(DEFAULT_LAST_MODIFIED_BY.intValue()))
            .andExpect(jsonPath("$.lastModifiedDate").value(DEFAULT_LAST_MODIFIED_DATE.toString()));
    }

    @Test
    @Transactional
    public void getNonExistingWorkflow() throws Exception {
        // Get the workflow
        restWorkflowMockMvc.perform(get("/api/workflows/{id}", Long.MAX_VALUE))
            .andExpect(status().isNotFound());
    }

    @Test
    @Transactional
    public void updateWorkflow() throws Exception {
        // Initialize the database
        workflowRepository.saveAndFlush(workflow);
        int databaseSizeBeforeUpdate = workflowRepository.findAll().size();

        // Update the workflow
        Workflow updatedWorkflow = workflowRepository.findOne(workflow.getId());
        updatedWorkflow
            .workflowCode(UPDATED_WORKFLOW_CODE)
            .workflowName(UPDATED_WORKFLOW_NAME)
            .description(UPDATED_DESCRIPTION)
            .createdBy(UPDATED_CREATED_BY)
            .createdDate(UPDATED_CREATED_DATE)
            .lastModifiedBy(UPDATED_LAST_MODIFIED_BY)
            .lastModifiedDate(UPDATED_LAST_MODIFIED_DATE);
        WorkflowDTO workflowDTO = workflowMapper.toDto(updatedWorkflow);

        restWorkflowMockMvc.perform(put("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isOk());

        // Validate the Workflow in the database
        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeUpdate);
        Workflow testWorkflow = workflowList.get(workflowList.size() - 1);
        assertThat(testWorkflow.getWorkflowCode()).isEqualTo(UPDATED_WORKFLOW_CODE);
        assertThat(testWorkflow.getWorkflowName()).isEqualTo(UPDATED_WORKFLOW_NAME);
        assertThat(testWorkflow.getDescription()).isEqualTo(UPDATED_DESCRIPTION);
        assertThat(testWorkflow.getCreatedBy()).isEqualTo(UPDATED_CREATED_BY);
        assertThat(testWorkflow.getCreatedDate()).isEqualTo(UPDATED_CREATED_DATE);
        assertThat(testWorkflow.getLastModifiedBy()).isEqualTo(UPDATED_LAST_MODIFIED_BY);
        assertThat(testWorkflow.getLastModifiedDate()).isEqualTo(UPDATED_LAST_MODIFIED_DATE);
    }

    @Test
    @Transactional
    public void updateNonExistingWorkflow() throws Exception {
        int databaseSizeBeforeUpdate = workflowRepository.findAll().size();

        // Create the Workflow
        WorkflowDTO workflowDTO = workflowMapper.toDto(workflow);

        // If the entity doesn't have an ID, it will be created instead of just being updated
        restWorkflowMockMvc.perform(put("/api/workflows")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowDTO)))
            .andExpect(status().isCreated());

        // Validate the Workflow in the database
        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeUpdate + 1);
    }

    @Test
    @Transactional
    public void deleteWorkflow() throws Exception {
        // Initialize the database
        workflowRepository.saveAndFlush(workflow);
        int databaseSizeBeforeDelete = workflowRepository.findAll().size();

        // Get the workflow
        restWorkflowMockMvc.perform(delete("/api/workflows/{id}", workflow.getId())
            .accept(TestUtil.APPLICATION_JSON_UTF8))
            .andExpect(status().isOk());

        // Validate the database is empty
        List<Workflow> workflowList = workflowRepository.findAll();
        assertThat(workflowList).hasSize(databaseSizeBeforeDelete - 1);
    }

    @Test
    @Transactional
    public void equalsVerifier() throws Exception {
        TestUtil.equalsVerifier(Workflow.class);
        Workflow workflow1 = new Workflow();
        workflow1.setId(1L);
        Workflow workflow2 = new Workflow();
        workflow2.setId(workflow1.getId());
        assertThat(workflow1).isEqualTo(workflow2);
        workflow2.setId(2L);
        assertThat(workflow1).isNotEqualTo(workflow2);
        workflow1.setId(null);
        assertThat(workflow1).isNotEqualTo(workflow2);
    }

    @Test
    @Transactional
    public void dtoEqualsVerifier() throws Exception {
        TestUtil.equalsVerifier(WorkflowDTO.class);
        WorkflowDTO workflowDTO1 = new WorkflowDTO();
        workflowDTO1.setId(1L);
        WorkflowDTO workflowDTO2 = new WorkflowDTO();
        assertThat(workflowDTO1).isNotEqualTo(workflowDTO2);
        workflowDTO2.setId(workflowDTO1.getId());
        assertThat(workflowDTO1).isEqualTo(workflowDTO2);
        workflowDTO2.setId(2L);
        assertThat(workflowDTO1).isNotEqualTo(workflowDTO2);
        workflowDTO1.setId(null);
        assertThat(workflowDTO1).isNotEqualTo(workflowDTO2);
    }

    @Test
    @Transactional
    public void testEntityFromId() {
        assertThat(workflowMapper.fromId(42L).getId()).isEqualTo(42);
        assertThat(workflowMapper.fromId(null)).isNull();
    }
}
