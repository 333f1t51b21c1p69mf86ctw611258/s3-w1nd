package com.dasanzhone.seawind.swservice.controller;

import java.util.ArrayList;
import java.util.List;

import com.dasanzhone.seawind.swservice.util.ReflectionUtil;
import com.dasanzhone.seawind.swweb.domain.Workflow;
import com.dasanzhone.seawind.swweb.domain.WorkflowStep;
import com.dasanzhone.seawind.swweb.domain.enumeration.WorkflowCode;
import com.dasanzhone.seawind.swweb.repository.WorkflowRepository;
import com.dasanzhone.seawind.swweb.repository.WorkflowStepRepository;
import com.google.common.base.CaseFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.adventnet.snmp.snmp2.SnmpPDU;
import com.dasanzhone.namespace.deviceservice.general.CommonOperationReturn;
import com.dasanzhone.namespace.deviceservice.general.DeviceInformationReturn;
import com.dasanzhone.namespace.deviceservice.general.ForecastRequest;
import com.dasanzhone.namespace.deviceservice.general.ForecastReturn;
import com.dasanzhone.namespace.deviceservice.general.OntInput;
import com.dasanzhone.seawind.swservice.entity.OntInputParamMapper;
import com.dasanzhone.seawind.swservice.entity.OntInputSwapper;
import com.dasanzhone.seawind.swservice.snmp.SnmpOid;
import com.dasanzhone.seawind.swservice.snmp.SnmpOperation;
import com.dasanzhone.seawind.swservice.snmp.SnmpOperationInput;
import com.dasanzhone.seawind.swservice.snmp.SnmpUtil;
import com.dasanzhone.seawind.swservice.util.ConversionUtil;

import net.logstash.logback.encoder.org.apache.commons.lang.StringUtils;
import net.logstash.logback.encoder.org.apache.commons.lang.exception.ExceptionUtils;

import javax.transaction.NotSupportedException;

/*
 *  Example-Controller:
 *  This Class would be responsible for Mapping from Request to internal Datamodel (and backwards),
 *  for calling Backend-Services and handling Backend-Exceptions
 *  So it decouples the WSDL-generated Classes from the internal Classes - for when the former changes,
 *  nothing or only the mapping has to be changed
 */
@Component
public class DeviceServiceController {

	private static final Logger LOG = LoggerFactory.getLogger(DeviceServiceController.class);

	@Autowired
    private WorkflowRepository workflowRepository;

	@Autowired
    private WorkflowStepRepository workflowStepRepository;

	public ForecastReturn getCityForecastByZIP(ForecastRequest forecastRequest) {
		/*
		 * We leave out inbound transformation, plausibility-checking, logging,
		 * backend-calls e.g. for the moment
		 *
		 * Just some Log-Statements here :)
		 */
		LOG.info("Starting inbound transformation into internal datamodel");

		LOG.info("Checking plausibility of data");

		LOG.info("Calling Backend No. 1");

		LOG.info("Calling Backend No. 2");

		LOG.info("Starting outbound transformation into external datamodel");

		return null; // GetCityForecastByZIPOutMapper.mapGeneralOutlook2Forecast();
	}

	/*
	 * Other Methods would follow here...
	 */
	// public DeviceReturn getCityDeviceByZIP(ForecastRequest forecastRequest)
	// throws BusinessException {}

	public DeviceInformationReturn getDeviceInformation(String zip) throws NotSupportedException {
        throw new NotSupportedException();
	}

    public CommonOperationReturn group1_declareOntId(OntInput ontInput) throws ClassNotFoundException {
        Workflow workflow = workflowRepository.findByWorkflowCode(WorkflowCode.DECLARE_ONT_ID);
        List<WorkflowStep> steps = workflowStepRepository.findByWorkflowId(workflow.getId());

        CommonOperationReturn result = new CommonOperationReturn();

        OntInputSwapper ontInputSwapper = new OntInputSwapper(ontInput);

        SnmpOperationInput input = new SnmpOperationInput();

        input.setHost("10.72.200.125");
        input.setVersion("v2");
        input.setOids(new ArrayList<>());

        SnmpOid snmpOid;
        OntInputParamMapper mapper;

        for (WorkflowStep step : steps) {
            Class<?> clazz = Class.forName("com.dasanzhone.namespace.deviceservice.general.OntInput");
            Object instance = clazz.cast(ontInput);
            String rawValue = null;
            if (step.getPropertyName() != null) {
                String propertyName = CaseFormat.UPPER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, step.getPropertyName().toString());
                rawValue = ReflectionUtil.get(instance, propertyName);
            }

            if (step.isCustomizedStep()) {
                rawValue = getCustomizedRawValue(workflow, step, rawValue);
            }

            mapper = new OntInputParamMapper(step.getDefaultValue(), rawValue);

            if (StringUtils.isNotEmpty(step.getMapValues())) {
                String lines[] = step.getMapValues().split("\\r?\\n");
                for (String line : lines) {
                    String segments[] = line.split(":");
                    mapper.getMapValues().put(segments[0].trim(), segments[1].trim());
                }
            }

            if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
                snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags(step.getOidPattern()), SnmpUtil.getSnmpVar(step.getPropertyType().toString(), mapper.getFinalValue()));
                input.getOids().add(snmpOid);
            }
        }

        try {
            SnmpPDU snmpPDU = SnmpOperation.setWithoutMib_Low(input);
            if (snmpPDU.getErrstat() == 0) {
                result.setSuccess(true);
                result.setResponseText("SUCCESSFUL");
                result.setDescription(snmpPDU.printVarBinds());
            } else {
                result.setSuccess(false);
                result.setResponseText("UNSUCCESSFUL");
                result.setDescription(snmpPDU.getError());
            }

            return result;

        } catch (Exception e) {

            result.setSuccess(false);
            result.setResponseText(e.toString());
            result.setDescription(ExceptionUtils.getFullStackTrace(e));
            return result;
        }
    }

    private String getCustomizedRawValue(Workflow workflow, WorkflowStep step, String rawValue) {
        if (workflow.getWorkflowCode() == WorkflowCode.DECLARE_ONT_ID) {
            if (step.getPropertyName().equalsIgnoreCase("alaOntSernum") || step.getPropertyName().equalsIgnoreCase("SERNUM")) {
                rawValue = ConversionUtil.convertSerialNumberHexStringToSerialNumberByteArrayString(rawValue);
            }
        }
        return rawValue;
    }

    public CommonOperationReturn declareOntId(OntInput ontInput) {
		CommonOperationReturn result = new CommonOperationReturn();

		OntInputSwapper ontInputSwapper = new OntInputSwapper(ontInput);

		SnmpOperationInput input = new SnmpOperationInput();

		input.setHost("10.72.200.125");
		input.setVersion("v2");
		input.setOids(new ArrayList<SnmpOid>());

		SnmpOid snmpOid = null;
		OntInputParamMapper mapper = new OntInputParamMapper("4", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.2.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		String sernum_byteArrayString = ConversionUtil.convertSerialNumberHexStringToSerialNumberByteArrayString(ontInput.getSernum());
		mapper = new OntInputParamMapper(null, sernum_byteArrayString);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.5.[ONT_ID]"), SnmpUtil.getSnmpVar("STRING", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("0", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.8.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getSwVerPland());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.11.[ONT_ID]"), SnmpUtil.getSnmpVar("STRING", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("8000", ontInput.getBerint());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.18.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("*", ontInput.getProvversion());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.21.[ONT_ID]"), SnmpUtil.getSnmpVar("STRING", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getFecUp());
		mapper.getMapValues().put(OntInputParamMapper.STRING_ENABLE, "1");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DISABLE, "2");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.39.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getSwDnloadVersion());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.60.[ONT_ID]"), SnmpUtil.getSnmpVar("STRING", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getOpticsHist());
		mapper.getMapValues().put(OntInputParamMapper.STRING_ENABLE, "1");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DISABLE, "2");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.63.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getPlndVar());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.65.[ONT_ID]"), SnmpUtil.getSnmpVar("STRING", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("8", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.47.6.1.1.18.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("2", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.47.6.1.1.19.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getEnableAes());
		mapper.getMapValues().put(OntInputParamMapper.STRING_ENABLE, "1");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DISABLE, "0");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.1.1.75.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		try {
			SnmpPDU snmpPDU = SnmpOperation.setWithoutMib_Low(input);
			if (snmpPDU.getErrstat() == 0) {
				result.setSuccess(true);
				result.setResponseText("SUCCESSFUL");
				result.setDescription(snmpPDU.printVarBinds());
			} else {
				result.setSuccess(false);
				result.setResponseText("UNSUCCESSFUL");
				result.setDescription(snmpPDU.getError());
			}

			return result;

		} catch (Exception e) {

			result.setSuccess(false);
			result.setResponseText(e.toString());
			result.setDescription(ExceptionUtils.getFullStackTrace(e));
			return result;
		}
	}

	public CommonOperationReturn activateDeactivateOntId(OntInput ontInput) {
		CommonOperationReturn result = new CommonOperationReturn();

		OntInputSwapper ontInputSwapper = new OntInputSwapper(ontInput);

		SnmpOperationInput input = new SnmpOperationInput();

		input.setHost("10.72.200.125");
		input.setVersion("v2");
		input.setOids(new ArrayList<SnmpOid>());

		SnmpOid snmpOid = null;
		OntInputParamMapper mapper = new OntInputParamMapper(null, ontInput.getAdminState());
		mapper.getMapValues().put(OntInputParamMapper.STRING_UP, "1");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DOWN, "2");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.2.1.2.2.1.7.[ONT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		try {
			SnmpPDU snmpPDU = SnmpOperation.setWithoutMib_Low(input);
			if (snmpPDU.getErrstat() == 0) {
				result.setSuccess(true);
				result.setResponseText("SUCCESSFUL");
				result.setDescription(snmpPDU.printVarBinds());
			} else {
				result.setSuccess(false);
				result.setResponseText("UNSUCCESSFUL");
				result.setDescription(snmpPDU.getError());
			}

			return result;

		} catch (Exception e) {

			result.setSuccess(false);
			result.setResponseText(e.toString());
			result.setDescription(ExceptionUtils.getFullStackTrace(e));
			return result;
		}
	}

	public CommonOperationReturn declarePpptpCard(OntInput ontInput) {
		CommonOperationReturn result = new CommonOperationReturn();

		OntInputSwapper ontInputSwapper = new OntInputSwapper(ontInput);

		SnmpOperationInput input = new SnmpOperationInput();

		input.setHost("10.72.200.125");
		input.setVersion("v2");
		input.setOids(new ArrayList<SnmpOid>());

		SnmpOid snmpOid = null;
		OntInputParamMapper mapper = new OntInputParamMapper("4", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.2.1.3.[ONT_ID].[CARD_SLOT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getPlannedCardType());
		mapper.getMapValues().put("10_100base", "24");
		mapper.getMapValues().put("veip", "48");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.2.1.4.[ONT_ID].[CARD_SLOT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getAdminState());
		mapper.getMapValues().put(OntInputParamMapper.STRING_UP, "0");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DOWN, "1");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.2.1.6.[ONT_ID].[CARD_SLOT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getPlndnumdataports());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.2.1.10.[ONT_ID].[CARD_SLOT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper("1", null);
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.35.10.2.1.12.[ONT_ID].[CARD_SLOT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		// TODO:
		// mapper = new OntInputParamMapper(null, ontInput.getPlndnumvoiceports());
		// snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("???????????????"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
		// input.getOids().add(snmpOid);

		try {
			SnmpPDU snmpPDU = SnmpOperation.setWithoutMib_Low(input);
			if (snmpPDU.getErrstat() == 0) {
				result.setSuccess(true);
				result.setResponseText("SUCCESSFUL");
				result.setDescription(snmpPDU.printVarBinds());
			} else {
				result.setSuccess(false);
				result.setResponseText("UNSUCCESSFUL");
				result.setDescription(snmpPDU.getError());
			}

			return result;

		} catch (Exception e) {

			result.setSuccess(false);
			result.setResponseText(e.toString());
			result.setDescription(ExceptionUtils.getFullStackTrace(e));
			return result;
		}
	}

	public CommonOperationReturn configureUniLanPorts(OntInput ontInput) {
		CommonOperationReturn result = new CommonOperationReturn();

		OntInputSwapper ontInputSwapper = new OntInputSwapper(ontInput);

		SnmpOperationInput input = new SnmpOperationInput();

		input.setHost("10.72.200.125");
		input.setVersion("v2");
		input.setOids(new ArrayList<SnmpOid>());

		SnmpOid snmpOid = null;
		OntInputParamMapper mapper = new OntInputParamMapper(null, ontInput.getAdminState());
		mapper.getMapValues().put(OntInputParamMapper.STRING_UP, "1");
		mapper.getMapValues().put(OntInputParamMapper.STRING_DOWN, "2");
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.2.1.2.2.1.7.[PORT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		mapper = new OntInputParamMapper(null, ontInput.getAutoDetect());
		if (StringUtils.isNotEmpty(mapper.getFinalValue())) {
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.47.6.1.1.4.[PORT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
			snmpOid = new SnmpOid(ontInputSwapper.assignOidWithTags("1.3.6.1.4.1.637.61.1.47.6.1.1.6.[PORT_ID]"), SnmpUtil.getSnmpVar("INTEGER", mapper.getFinalValue()));
			input.getOids().add(snmpOid);
		}

		try {
			SnmpPDU snmpPDU = SnmpOperation.setWithoutMib_Low(input);
			if (snmpPDU.getErrstat() == 0) {
				result.setSuccess(true);
				result.setResponseText("SUCCESSFUL");
				result.setDescription(snmpPDU.printVarBinds());
			} else {
				result.setSuccess(false);
				result.setResponseText("UNSUCCESSFUL");
				result.setDescription(snmpPDU.getError());
			}

			return result;

		} catch (Exception e) {

			result.setSuccess(false);
			result.setResponseText(e.toString());
			result.setDescription(ExceptionUtils.getFullStackTrace(e));
			return result;
		}
	}

}
