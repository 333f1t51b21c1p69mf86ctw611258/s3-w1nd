/* $Id: encodeTableIndex.java,v 1.3.4.3 2012/01/09 14:22:33 sumathi.g Exp $ */ 
/*
 * @(#)encodeTableIndex.java
 * Copyright (c) 2012 ZOHO Corp. All Rights Reserved.
 * Please read the associated COPYRIGHTS file for more details.
 */

/**
 *  An example to encode the index of types like OctetString. 
 *  The Table oid,mib file and index should be given as input.
 */  
import com.adventnet.snmp.mibs.*;
import com.adventnet.snmp.snmp2.*;
import java.util.*;
public class encodeTableIndex{
	public static void main(String args[]){ 
		 if(args.length<3){
			 System.out.println("Usage : java encodeTableIndex tableOID MIB-File index [indices..]");
		     System.exit(0);
		 }
		
		 MibOperations mibOps = new MibOperations();  
		 try{
		 mibOps.loadMibModules(args[1]);
		 }catch(Exception ex){
			 System.out.println(ex.getMessage());
			 System.exit(0);
		 }
		 SnmpOID rootoid = mibOps.getSnmpOID(args[0]);
		 if(rootoid == null) {
			 System.out.println("Invalid TableOID : " + args[0]);
			 System.exit(0);
		 }
		 MibNode node = mibOps.getMibNode(rootoid); 
		 Vector columns = node.getTableItems();
		 if(columns == null) {
			 System.out.println("Invalid TableOID : " + args[0]);
			 System.exit(0);
		 }
		 SnmpOID columnoid = mibOps.getSnmpOID((String)columns.elementAt(0));
		 MibNode columnnode = mibOps.getMibNode(columnoid); 
		 Vector indexNodes = columnnode.getIndexes(mibOps);   		 
		 Vector v =new Vector();
		 for(int i=2;i<args.length;i++)
		 v.addElement(args[i]);
		 String d=mibOps.encodeInstanceString(v, indexNodes);	  	 
		 String str[]=new String[columns.size()];
		 for(int i=0; i< columns.size();i++){
			 str[i]=(String)columns.elementAt(i)+"."+d;
	  	 	 System.out.println(str[i]);
		} 	
		 
	}
		
}
			
