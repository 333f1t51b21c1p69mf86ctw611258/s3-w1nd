package com.dasanzhone.seawind.swweb.web.rest;

import com.dasanzhone.seawind.swweb.SwwebApp;

import com.dasanzhone.seawind.swweb.domain.WorkflowStep;
import com.dasanzhone.seawind.swweb.domain.Workflow;
import com.dasanzhone.seawind.swweb.repository.WorkflowStepRepository;
import com.dasanzhone.seawind.swweb.service.dto.WorkflowStepDTO;
import com.dasanzhone.seawind.swweb.service.mapper.WorkflowStepMapper;
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

import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyName;
import com.dasanzhone.seawind.swweb.domain.enumeration.PropertyType;
/**
 * Test class for the WorkflowStepResource REST controller.
 *
 * @see WorkflowStepResource
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SwwebApp.class)
public class WorkflowStepResourceIntTest {

    private static final String DEFAULT_STEP_NAME = "AAAAAAAAAA";
    private static final String UPDATED_STEP_NAME = "BBBBBBBBBB";

    private static final Integer DEFAULT_STEP_NUMBER = 1;
    private static final Integer UPDATED_STEP_NUMBER = 2;

    private static final PropertyName DEFAULT_PROPERTY_NAME = PropertyName.ONT_INTERFACE;
    private static final PropertyName UPDATED_PROPERTY_NAME = PropertyName.ONT_SLOT;

    private static final PropertyType DEFAULT_PROPERTY_TYPE = PropertyType.STRING;
    private static final PropertyType UPDATED_PROPERTY_TYPE = PropertyType.INTEGER;

    private static final String DEFAULT_DEFAULT_VALUE = "AAAAAAAAAA";
    private static final String UPDATED_DEFAULT_VALUE = "BBBBBBBBBB";

    private static final String DEFAULT_OID_PATTERN = "AAAAAAAAAA";
    private static final String UPDATED_OID_PATTERN = "BBBBBBBBBB";

    private static final String DEFAULT_DESCRIPTION = "AAAAAAAAAA";
    private static final String UPDATED_DESCRIPTION = "BBBBBBBBBB";

    private static final Boolean DEFAULT_CUSTOMIZED_STEP = false;
    private static final Boolean UPDATED_CUSTOMIZED_STEP = true;

    private static final Boolean DEFAULT_SET_OR_GET = false;
    private static final Boolean UPDATED_SET_OR_GET = true;

    private static final String DEFAULT_GET_EXPECTED_VALUE = "AAAAAAAAAA";
    private static final String UPDATED_GET_EXPECTED_VALUE = "BBBBBBBBBB";

    private static final Long DEFAULT_CREATED_BY = 1L;
    private static final Long UPDATED_CREATED_BY = 2L;

    private static final LocalDate DEFAULT_CREATED_DATE = LocalDate.ofEpochDay(0L);
    private static final LocalDate UPDATED_CREATED_DATE = LocalDate.now(ZoneId.systemDefault());

    private static final Long DEFAULT_LAST_MODIFIED_BY = 1L;
    private static final Long UPDATED_LAST_MODIFIED_BY = 2L;

    private static final LocalDate DEFAULT_LAST_MODIFIED_DATE = LocalDate.ofEpochDay(0L);
    private static final LocalDate UPDATED_LAST_MODIFIED_DATE = LocalDate.now(ZoneId.systemDefault());

    @Autowired
    private WorkflowStepRepository workflowStepRepository;

    @Autowired
    private WorkflowStepMapper workflowStepMapper;

    @Autowired
    private MappingJackson2HttpMessageConverter jacksonMessageConverter;

    @Autowired
    private PageableHandlerMethodArgumentResolver pageableArgumentResolver;

    @Autowired
    private ExceptionTranslator exceptionTranslator;

    @Autowired
    private EntityManager em;

    private MockMvc restWorkflowStepMockMvc;

    private WorkflowStep workflowStep;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        WorkflowStepResource workflowStepResource = new WorkflowStepResource(workflowStepRepository, workflowStepMapper);
        this.restWorkflowStepMockMvc = MockMvcBuilders.standaloneSetup(workflowStepResource)
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
    public static WorkflowStep createEntity(EntityManager em) {
        WorkflowStep workflowStep = new WorkflowStep()
            .stepName(DEFAULT_STEP_NAME)
            .stepNumber(DEFAULT_STEP_NUMBER)
            .propertyName(DEFAULT_PROPERTY_NAME)
            .propertyType(DEFAULT_PROPERTY_TYPE)
            .defaultValue(DEFAULT_DEFAULT_VALUE)
            .oidPattern(DEFAULT_OID_PATTERN)
            .description(DEFAULT_DESCRIPTION)
            .customizedStep(DEFAULT_CUSTOMIZED_STEP)
            .setOrGet(DEFAULT_SET_OR_GET)
            .getExpectedValue(DEFAULT_GET_EXPECTED_VALUE)
            .createdBy(DEFAULT_CREATED_BY)
            .createdDate(DEFAULT_CREATED_DATE)
            .lastModifiedBy(DEFAULT_LAST_MODIFIED_BY)
            .lastModifiedDate(DEFAULT_LAST_MODIFIED_DATE);
        // Add required entity
        Workflow workflow = WorkflowResourceIntTest.createEntity(em);
        em.persist(workflow);
        em.flush();
        workflowStep.setWorkflow(workflow);
        return workflowStep;
    }

    @Before
    public void initTest() {
        workflowStep = createEntity(em);
    }

    @Test
    @Transactional
    public void createWorkflowStep() throws Exception {
        int databaseSizeBeforeCreate = workflowStepRepository.findAll().size();

        // Create the WorkflowStep
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);
        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isCreated());

        // Validate the WorkflowStep in the database
        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeCreate + 1);
        WorkflowStep testWorkflowStep = workflowStepList.get(workflowStepList.size() - 1);
        assertThat(testWorkflowStep.getStepName()).isEqualTo(DEFAULT_STEP_NAME);
        assertThat(testWorkflowStep.getStepNumber()).isEqualTo(DEFAULT_STEP_NUMBER);
        assertThat(testWorkflowStep.getPropertyName()).isEqualTo(DEFAULT_PROPERTY_NAME);
        assertThat(testWorkflowStep.getPropertyType()).isEqualTo(DEFAULT_PROPERTY_TYPE);
        assertThat(testWorkflowStep.getDefaultValue()).isEqualTo(DEFAULT_DEFAULT_VALUE);
        assertThat(testWorkflowStep.getOidPattern()).isEqualTo(DEFAULT_OID_PATTERN);
        assertThat(testWorkflowStep.getDescription()).isEqualTo(DEFAULT_DESCRIPTION);
        assertThat(testWorkflowStep.isCustomizedStep()).isEqualTo(DEFAULT_CUSTOMIZED_STEP);
        assertThat(testWorkflowStep.isSetOrGet()).isEqualTo(DEFAULT_SET_OR_GET);
        assertThat(testWorkflowStep.getGetExpectedValue()).isEqualTo(DEFAULT_GET_EXPECTED_VALUE);
        assertThat(testWorkflowStep.getCreatedBy()).isEqualTo(DEFAULT_CREATED_BY);
        assertThat(testWorkflowStep.getCreatedDate()).isEqualTo(DEFAULT_CREATED_DATE);
        assertThat(testWorkflowStep.getLastModifiedBy()).isEqualTo(DEFAULT_LAST_MODIFIED_BY);
        assertThat(testWorkflowStep.getLastModifiedDate()).isEqualTo(DEFAULT_LAST_MODIFIED_DATE);
    }

    @Test
    @Transactional
    public void createWorkflowStepWithExistingId() throws Exception {
        int databaseSizeBeforeCreate = workflowStepRepository.findAll().size();

        // Create the WorkflowStep with an existing ID
        workflowStep.setId(1L);
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        // An entity with an existing ID cannot be created, so this API call must fail
        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        // Validate the Alice in the database
        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeCreate);
    }

    @Test
    @Transactional
    public void checkStepNameIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setStepName(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkStepNumberIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setStepNumber(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkPropertyNameIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setPropertyName(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkPropertyTypeIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setPropertyType(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkOidPatternIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setOidPattern(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkSetOrGetIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setSetOrGet(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkCreatedByIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setCreatedBy(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkCreatedDateIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setCreatedDate(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkLastModifiedByIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setLastModifiedBy(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void checkLastModifiedDateIsRequired() throws Exception {
        int databaseSizeBeforeTest = workflowStepRepository.findAll().size();
        // set the field null
        workflowStep.setLastModifiedDate(null);

        // Create the WorkflowStep, which fails.
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        restWorkflowStepMockMvc.perform(post("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isBadRequest());

        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeTest);
    }

    @Test
    @Transactional
    public void getAllWorkflowSteps() throws Exception {
        // Initialize the database
        workflowStepRepository.saveAndFlush(workflowStep);

        // Get all the workflowStepList
        restWorkflowStepMockMvc.perform(get("/api/workflow-steps?sort=id,desc"))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.[*].id").value(hasItem(workflowStep.getId().intValue())))
            .andExpect(jsonPath("$.[*].stepName").value(hasItem(DEFAULT_STEP_NAME.toString())))
            .andExpect(jsonPath("$.[*].stepNumber").value(hasItem(DEFAULT_STEP_NUMBER)))
            .andExpect(jsonPath("$.[*].propertyName").value(hasItem(DEFAULT_PROPERTY_NAME.toString())))
            .andExpect(jsonPath("$.[*].propertyType").value(hasItem(DEFAULT_PROPERTY_TYPE.toString())))
            .andExpect(jsonPath("$.[*].defaultValue").value(hasItem(DEFAULT_DEFAULT_VALUE.toString())))
            .andExpect(jsonPath("$.[*].oidPattern").value(hasItem(DEFAULT_OID_PATTERN.toString())))
            .andExpect(jsonPath("$.[*].description").value(hasItem(DEFAULT_DESCRIPTION.toString())))
            .andExpect(jsonPath("$.[*].customizedStep").value(hasItem(DEFAULT_CUSTOMIZED_STEP.booleanValue())))
            .andExpect(jsonPath("$.[*].setOrGet").value(hasItem(DEFAULT_SET_OR_GET.booleanValue())))
            .andExpect(jsonPath("$.[*].getExpectedValue").value(hasItem(DEFAULT_GET_EXPECTED_VALUE.toString())))
            .andExpect(jsonPath("$.[*].createdBy").value(hasItem(DEFAULT_CREATED_BY.intValue())))
            .andExpect(jsonPath("$.[*].createdDate").value(hasItem(DEFAULT_CREATED_DATE.toString())))
            .andExpect(jsonPath("$.[*].lastModifiedBy").value(hasItem(DEFAULT_LAST_MODIFIED_BY.intValue())))
            .andExpect(jsonPath("$.[*].lastModifiedDate").value(hasItem(DEFAULT_LAST_MODIFIED_DATE.toString())));
    }

    @Test
    @Transactional
    public void getWorkflowStep() throws Exception {
        // Initialize the database
        workflowStepRepository.saveAndFlush(workflowStep);

        // Get the workflowStep
        restWorkflowStepMockMvc.perform(get("/api/workflow-steps/{id}", workflowStep.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON_UTF8_VALUE))
            .andExpect(jsonPath("$.id").value(workflowStep.getId().intValue()))
            .andExpect(jsonPath("$.stepName").value(DEFAULT_STEP_NAME.toString()))
            .andExpect(jsonPath("$.stepNumber").value(DEFAULT_STEP_NUMBER))
            .andExpect(jsonPath("$.propertyName").value(DEFAULT_PROPERTY_NAME.toString()))
            .andExpect(jsonPath("$.propertyType").value(DEFAULT_PROPERTY_TYPE.toString()))
            .andExpect(jsonPath("$.defaultValue").value(DEFAULT_DEFAULT_VALUE.toString()))
            .andExpect(jsonPath("$.oidPattern").value(DEFAULT_OID_PATTERN.toString()))
            .andExpect(jsonPath("$.description").value(DEFAULT_DESCRIPTION.toString()))
            .andExpect(jsonPath("$.customizedStep").value(DEFAULT_CUSTOMIZED_STEP.booleanValue()))
            .andExpect(jsonPath("$.setOrGet").value(DEFAULT_SET_OR_GET.booleanValue()))
            .andExpect(jsonPath("$.getExpectedValue").value(DEFAULT_GET_EXPECTED_VALUE.toString()))
            .andExpect(jsonPath("$.createdBy").value(DEFAULT_CREATED_BY.intValue()))
            .andExpect(jsonPath("$.createdDate").value(DEFAULT_CREATED_DATE.toString()))
            .andExpect(jsonPath("$.lastModifiedBy").value(DEFAULT_LAST_MODIFIED_BY.intValue()))
            .andExpect(jsonPath("$.lastModifiedDate").value(DEFAULT_LAST_MODIFIED_DATE.toString()));
    }

    @Test
    @Transactional
    public void getNonExistingWorkflowStep() throws Exception {
        // Get the workflowStep
        restWorkflowStepMockMvc.perform(get("/api/workflow-steps/{id}", Long.MAX_VALUE))
            .andExpect(status().isNotFound());
    }

    @Test
    @Transactional
    public void updateWorkflowStep() throws Exception {
        // Initialize the database
        workflowStepRepository.saveAndFlush(workflowStep);
        int databaseSizeBeforeUpdate = workflowStepRepository.findAll().size();

        // Update the workflowStep
        WorkflowStep updatedWorkflowStep = workflowStepRepository.findOne(workflowStep.getId());
        updatedWorkflowStep
            .stepName(UPDATED_STEP_NAME)
            .stepNumber(UPDATED_STEP_NUMBER)
            .propertyName(UPDATED_PROPERTY_NAME)
            .propertyType(UPDATED_PROPERTY_TYPE)
            .defaultValue(UPDATED_DEFAULT_VALUE)
            .oidPattern(UPDATED_OID_PATTERN)
            .description(UPDATED_DESCRIPTION)
            .customizedStep(UPDATED_CUSTOMIZED_STEP)
            .setOrGet(UPDATED_SET_OR_GET)
            .getExpectedValue(UPDATED_GET_EXPECTED_VALUE)
            .createdBy(UPDATED_CREATED_BY)
            .createdDate(UPDATED_CREATED_DATE)
            .lastModifiedBy(UPDATED_LAST_MODIFIED_BY)
            .lastModifiedDate(UPDATED_LAST_MODIFIED_DATE);
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(updatedWorkflowStep);

        restWorkflowStepMockMvc.perform(put("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isOk());

        // Validate the WorkflowStep in the database
        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeUpdate);
        WorkflowStep testWorkflowStep = workflowStepList.get(workflowStepList.size() - 1);
        assertThat(testWorkflowStep.getStepName()).isEqualTo(UPDATED_STEP_NAME);
        assertThat(testWorkflowStep.getStepNumber()).isEqualTo(UPDATED_STEP_NUMBER);
        assertThat(testWorkflowStep.getPropertyName()).isEqualTo(UPDATED_PROPERTY_NAME);
        assertThat(testWorkflowStep.getPropertyType()).isEqualTo(UPDATED_PROPERTY_TYPE);
        assertThat(testWorkflowStep.getDefaultValue()).isEqualTo(UPDATED_DEFAULT_VALUE);
        assertThat(testWorkflowStep.getOidPattern()).isEqualTo(UPDATED_OID_PATTERN);
        assertThat(testWorkflowStep.getDescription()).isEqualTo(UPDATED_DESCRIPTION);
        assertThat(testWorkflowStep.isCustomizedStep()).isEqualTo(UPDATED_CUSTOMIZED_STEP);
        assertThat(testWorkflowStep.isSetOrGet()).isEqualTo(UPDATED_SET_OR_GET);
        assertThat(testWorkflowStep.getGetExpectedValue()).isEqualTo(UPDATED_GET_EXPECTED_VALUE);
        assertThat(testWorkflowStep.getCreatedBy()).isEqualTo(UPDATED_CREATED_BY);
        assertThat(testWorkflowStep.getCreatedDate()).isEqualTo(UPDATED_CREATED_DATE);
        assertThat(testWorkflowStep.getLastModifiedBy()).isEqualTo(UPDATED_LAST_MODIFIED_BY);
        assertThat(testWorkflowStep.getLastModifiedDate()).isEqualTo(UPDATED_LAST_MODIFIED_DATE);
    }

    @Test
    @Transactional
    public void updateNonExistingWorkflowStep() throws Exception {
        int databaseSizeBeforeUpdate = workflowStepRepository.findAll().size();

        // Create the WorkflowStep
        WorkflowStepDTO workflowStepDTO = workflowStepMapper.toDto(workflowStep);

        // If the entity doesn't have an ID, it will be created instead of just being updated
        restWorkflowStepMockMvc.perform(put("/api/workflow-steps")
            .contentType(TestUtil.APPLICATION_JSON_UTF8)
            .content(TestUtil.convertObjectToJsonBytes(workflowStepDTO)))
            .andExpect(status().isCreated());

        // Validate the WorkflowStep in the database
        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeUpdate + 1);
    }

    @Test
    @Transactional
    public void deleteWorkflowStep() throws Exception {
        // Initialize the database
        workflowStepRepository.saveAndFlush(workflowStep);
        int databaseSizeBeforeDelete = workflowStepRepository.findAll().size();

        // Get the workflowStep
        restWorkflowStepMockMvc.perform(delete("/api/workflow-steps/{id}", workflowStep.getId())
            .accept(TestUtil.APPLICATION_JSON_UTF8))
            .andExpect(status().isOk());

        // Validate the database is empty
        List<WorkflowStep> workflowStepList = workflowStepRepository.findAll();
        assertThat(workflowStepList).hasSize(databaseSizeBeforeDelete - 1);
    }

    @Test
    @Transactional
    public void equalsVerifier() throws Exception {
        TestUtil.equalsVerifier(WorkflowStep.class);
        WorkflowStep workflowStep1 = new WorkflowStep();
        workflowStep1.setId(1L);
        WorkflowStep workflowStep2 = new WorkflowStep();
        workflowStep2.setId(workflowStep1.getId());
        assertThat(workflowStep1).isEqualTo(workflowStep2);
        workflowStep2.setId(2L);
        assertThat(workflowStep1).isNotEqualTo(workflowStep2);
        workflowStep1.setId(null);
        assertThat(workflowStep1).isNotEqualTo(workflowStep2);
    }

    @Test
    @Transactional
    public void dtoEqualsVerifier() throws Exception {
        TestUtil.equalsVerifier(WorkflowStepDTO.class);
        WorkflowStepDTO workflowStepDTO1 = new WorkflowStepDTO();
        workflowStepDTO1.setId(1L);
        WorkflowStepDTO workflowStepDTO2 = new WorkflowStepDTO();
        assertThat(workflowStepDTO1).isNotEqualTo(workflowStepDTO2);
        workflowStepDTO2.setId(workflowStepDTO1.getId());
        assertThat(workflowStepDTO1).isEqualTo(workflowStepDTO2);
        workflowStepDTO2.setId(2L);
        assertThat(workflowStepDTO1).isNotEqualTo(workflowStepDTO2);
        workflowStepDTO1.setId(null);
        assertThat(workflowStepDTO1).isNotEqualTo(workflowStepDTO2);
    }

    @Test
    @Transactional
    public void testEntityFromId() {
        assertThat(workflowStepMapper.fromId(42L).getId()).isEqualTo(42);
        assertThat(workflowStepMapper.fromId(null)).isNull();
    }
}
