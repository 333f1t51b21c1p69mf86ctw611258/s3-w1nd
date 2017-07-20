package com.dasanzhone.seawind.swservice.snmp;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

public class SnmpUtilTest {
    @Before
    public void setUp() throws Exception {
    }

    @After
    public void tearDown() throws Exception {
    }

    @Test
    public void getMibNodeInformation() throws Exception {
        System.out.println(SnmpUtil.getMibNodeInformation("D://ALU-SMI.mib", ".1.3.6.1.4.1.637.61.1.35.10.1.1.2"));
    }

    @Test
    public void getSnmpVar() throws Exception {
    }

    @Test
    public void addVarBind() throws Exception {
    }

}
