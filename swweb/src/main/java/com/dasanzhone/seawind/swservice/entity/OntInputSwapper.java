package com.dasanzhone.seawind.swservice.entity;

import com.dasanzhone.namespace.deviceservice.general.OntInput;
import com.dasanzhone.seawind.swservice.util.ConversionUtil;

import net.logstash.logback.encoder.org.apache.commons.lang.StringUtils;

public class OntInputSwapper {

	private static final String STRING_TAG_PORT_ID = "[PORT_ID]";
	private static final String STRING_TAG_CARD_SLOT_ID = "[CARD_SLOT_ID]";
	private static final String STRING_TAG_ONT_ID = "[ONT_ID]";

	private final OntInput ontInput;

	public OntInputSwapper(OntInput ontInput) {
		this.ontInput = ontInput;
	}

	private Integer ontId = null;
	private Integer cardSlotId = null;
	private Integer portId = null;

	public Integer parseOntId() {
		if (ontId == null && StringUtils.isNotEmpty(ontInput.getOntInterface())) {
			ontId = ConversionUtil.convertAddressToOntId(ontInput.getOntInterface());
		}
		
		if (ontId == null && StringUtils.isNotEmpty(ontInput.getOntSlot())) {
			ontId = ConversionUtil.convertAddressToOntId(ontInput.getOntSlot());
		}
		
		if (ontId == null && StringUtils.isNotEmpty(ontInput.getOntPort())) {
			ontId = ConversionUtil.convertAddressToOntId(ontInput.getOntPort());
		}

		return ontId;
	}

	public Integer parseCardSlotId() {
		if (cardSlotId == null && StringUtils.isNotEmpty(ontInput.getOntSlot())) {
			cardSlotId = ConversionUtil.convertAddressToOntCardSlot(ontInput.getOntSlot());
		}
		
		if (cardSlotId == null && StringUtils.isNotEmpty(ontInput.getOntPort())) {
			cardSlotId = ConversionUtil.convertAddressToOntCardSlot(ontInput.getOntPort());
		}

		return cardSlotId;
	}

	public Integer parsePortId() {
		if (portId == null && StringUtils.isNotEmpty(ontInput.getOntPort())) {
			portId = ConversionUtil.convertAddressToOntPort(ontInput.getOntPort());
		}

		return portId;
	}

	public String assignOidWithTags(String oidWithTag) {
		String result = oidWithTag;

		if (StringUtils.isNotEmpty(result)) {
			if (!result.startsWith(".")) {
				result = "." + result;
			}

			if (result.contains(STRING_TAG_ONT_ID)) {
				Integer ontId = this.parseOntId();

				if (ontId != null) {
					result = result.replace(STRING_TAG_ONT_ID, ontId.toString());
				} else {
					throw new IllegalArgumentException();
				}
			}

			if (result.contains(STRING_TAG_CARD_SLOT_ID)) {
				Integer cardSlotId = this.parseCardSlotId();

				if (cardSlotId != null) {
					result = result.replace(STRING_TAG_CARD_SLOT_ID, cardSlotId.toString());
				} else {
					throw new IllegalArgumentException();
				}
			}

			if (result.contains(STRING_TAG_PORT_ID)) {
				Integer portId = this.parsePortId();

				if (portId != null) {
					result = result.replace(STRING_TAG_PORT_ID, portId.toString());
				} else {
					throw new IllegalArgumentException();
				}
			}
		}

		return result;
	}	

}
