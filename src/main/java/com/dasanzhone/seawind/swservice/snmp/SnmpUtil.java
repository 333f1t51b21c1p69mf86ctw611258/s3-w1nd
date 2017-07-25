package com.dasanzhone.seawind.swservice.snmp;

import com.adventnet.snmp.beans.SnmpTarget;
import com.adventnet.snmp.mibs.LeafSyntax;
import com.adventnet.snmp.mibs.MibNode;
import com.adventnet.snmp.mibs.MibOperations;
import com.adventnet.snmp.mibs.MibTC;
import com.adventnet.snmp.snmp2.*;

import java.io.File;
import java.lang.reflect.Field;

public class SnmpUtil {

    public static String getMibNodeInformation(String mibfile, String OID) {

//        if( args.length < 2)
//        {
//            System.out.println("Usage : java MibNodeInfo mibfile OID ");
//            System.exit(0);
//        }

        // Take care of getting OID and the MIB file name

//        String mibfile = args[0];
//        String OID = args[1];

        SnmpTarget target = new SnmpTarget();
        try {
            target.loadMibs(mibfile);
        } catch (Exception ex) {
            System.out.println(ex);
        }

        // load the MIB file
        MibOperations mibops = target.getMibOperations();
        try {
            mibops.loadMibModules(mibfile);
        } catch (Exception ex) {
            System.err.println("Error loading MIBs: " + ex);
        }

        // add OIDs

        SnmpOID oid = mibops.getSnmpOID(OID);
        MibNode node = mibops.getMibNode(oid);

        if (node == null) {
            System.out.println("Invalid OID / the node " + oid + " is not available");
        } else {
            String result = "Syntax:" + node.getSyntax() + "\n" +
                "Access:" + node.printAccess() + "\n" +
                "Status:" + node.getStatus() + "\n" +
                "Reference:" + node.getReference() + "\n" +
                "OID:" + node.getNumberedOIDString() + "\n" +
                "Node:" + node.getOIDString() + "\n" +
                "Description:" + node.getDescription() + "\n";

            System.out.println(result);

            return result;
        }

        return null;
    }

    public static SnmpVar getSnmpVar(String type, String value) {

        byte dataType;
        if (type.equals("INTEGER")) {
            dataType = SnmpAPI.INTEGER;
        } else if (type.equals("STRING")) {
            dataType = SnmpAPI.STRING;
        } else if (type.equals("GAUGE")) {
            dataType = SnmpAPI.GAUGE;
        } else if (type.equals("TIMETICKS")) {
            dataType = SnmpAPI.TIMETICKS;
        } else if (type.equals("OPAQUE")) {
            dataType = SnmpAPI.OPAQUE;
        } else if (type.equals("IPADDRESS")) {
            dataType = SnmpAPI.IPADDRESS;
        } else if (type.equals("COUNTER")) {
            dataType = SnmpAPI.COUNTER;
        } else if (type.equals("OID")) {
            dataType = SnmpAPI.OBJID;
        } else if (type.equals("BITS")) {
            dataType = SnmpAPI.STRING;
        } else {
            System.err.println("Invalid variable type: " + type);
            return null;
        }

        SnmpVar var = null;
        try {
            // create SnmpVar instance for the value and the type
            var = SnmpVar.createVariable(value, dataType);
        } catch (SnmpException e) {
            System.err.println("Cannot create variable for: " + value);
            return null;
        }
        return var;
    }

    /**
     * adds the varbind with specified oid, type and value to the pdu
     */
    public static void addVarBind(SnmpPDU pdu, SnmpOID oid, SnmpVar var) {

        // create varbind
        SnmpVarBind varbind = new SnmpVarBind(oid, var);

        // add variable binding
        pdu.addVariableBinding(varbind);
    }

    private static final int DEBUG = 0;
//    private static final int MIBS = 6;

    public static void initWorkflowStep(String strOid) throws NoSuchFieldException, IllegalAccessException {

        ClassLoader classLoader = SnmpUtil.class.getClassLoader();
        File alu = new File(classLoader.getResource("snmp/ALU-SMI.mib").getFile());

        // Take care of getting options
        String usage = "java mibnodeinfo [-d] -m MIB_files [-n] [-s] [-l] [-D] [-P] OID";
        String options[] = {"-d", "-n", "-s", "-l", "-D", "-P", "-m"};
        String values[] = {"None", "None", "None", "None", "None", "None", null};

        usage += "\n Options:" +
            "\n[-d]                - Debug output. By default off." +
            "\n[-s]                _ prints the String OID (in the form .iso.org.dod.internet.mgmt.mib-2)" +
            "\n[-n]                - prints the associated numeric oid." +
            "\n[-l]                - prints the associated syntax of the node." +
            "\n[-D]                _ prints the associated description of the node." +
            "\n[-P]                - prinys all the properties of the MibNode." +
            "\n-m   <MIBfile>      - MIB files.To load multiple mibs give within double quotes files seperated by a blank space. Mandatory." +
            "\n<OID>  Mandatory    - Object Identifier.";

//        ParseOptions opt = new ParseOptions(args, options, values, usage);
//        if (opt.remArgs.length < 1 || opt.remArgs.length > 1) {
//            opt.usage_error();
//        }

        MibOperations mibOps = new MibOperations();

        if (true)
            mibOps.setDebug(true);

        // To load MIBs from compiled file
        mibOps.setLoadFromCompiledMibs(false);

        // Loading MIBS
        if (alu.exists()) {
            try {
                System.out.println("Loading MIBs: " + alu.getAbsolutePath());
                mibOps.loadMibModules(alu.getAbsolutePath());
            } catch (Exception ex) {
                System.out.println("Error loading MIBs: " + ex);
            }
        } else {
            System.out.println("Loading MIBs is mandatory");
            System.exit(0);
        }

        SnmpOID oid = mibOps.getSnmpOID(strOid);
        MibNode node = mibOps.getMibNode(oid);
        if (node == null) {
            System.out.println("Invalid OID / the node " + strOid + " is not avialable");
        }

        if (true) {
            System.out.println("\nNumbered OID: " + oid);
        }

        if (true) {
            System.out.println("\nString OID: " + node.getOIDString());
        }

        if (true) {
            LeafSyntax syntax = mibOps.getLeafSyntax(oid);
            System.out.println("\nSyntax: " + syntax);

            Field field_MibNode_syntax = MibNode.class.getDeclaredField("syntax");
            field_MibNode_syntax.setAccessible(true);
            Object value_syntax = field_MibNode_syntax.get(node);
            if (value_syntax != null) {
                System.out.println("### syntax: " + value_syntax);

                Field field_MibTC_range = MibTC.class.getSuperclass().getDeclaredField("range");
                field_MibTC_range.setAccessible(true);
                Object value_range = field_MibTC_range.get(value_syntax);
                System.out.println("### syntax.range: " + value_range);

                Class<?> innerClass = value_range.getClass();
                Field field_RangeList_values = innerClass.getDeclaredField("values");
                Field field_RangeList_labels = innerClass.getDeclaredField("labels");
                field_RangeList_values.setAccessible(true);
                field_RangeList_labels.setAccessible(true);
                Object value_values = field_RangeList_values.get(value_range);
                Object value_labels = field_RangeList_labels.get(value_range);
                System.out.println("### syntax.range.values: " + value_values);
                System.out.println("### syntax.range.values: " + value_labels);

                if (value_values != null && value_labels != null) {
                    long[] cast_values = (long[]) value_values;
                    String[] cast_labels = (String[]) value_labels;
                    for (int i = 0; i < cast_values.length; i++) {
                        long cast_value = cast_values[i];
                        String cast_label = cast_labels[i];
                        System.out.println(cast_label + " : " + cast_value);
                    }
                }
            }
        }

        if (true) {
            System.out.println("\nDescription: " + node.getDescription());
        }

        if (true) {
            System.out.println("\n" + node.toTagString());
        }

    }

}
