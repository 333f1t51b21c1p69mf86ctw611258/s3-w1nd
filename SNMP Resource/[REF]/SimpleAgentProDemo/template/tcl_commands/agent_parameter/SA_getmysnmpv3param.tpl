<!DOCTYPE Template>
<Template>
 <Version>1.0</Version>
 <Name>SA_getmysnmpv3param</Name>
 <Contributor>SimpleSoft</Contributor>
 <Language>Tcl</Language>
 <Description>Returns the value of the requested &lt;param_id>.  Valid param_ids are  COUNTER_UNKNOWN_SEC_MODEL, COUNTER_INVALID_MSG, COUNTER_UNKNOWN_PDU_HANDLER, COUNTER_UNAVAILABLE_CONTEXT, COUNTER_UNSUPPORTED_SECLEVEL, COUNTER_NOT_IN_TIME_WINDOW, COUNTER_UNKNOWN_USER_NAME, COUNTER_UNKNOWN_ENGINEID, COUNTER_WRONG_DIGEST, COUNTER_DECRYPTION_ERROR, COUNTER_ENGINEBOOTS, COUNTER_ENGINETIME, SNMP_ENGINE_ID, CONTEXT_ENGINE_ID, CONTEXT_NAME.

Example: SA_getmysnmpv3param COUNTER_ENGINEBOOTS</Description>
 <InputList>
  <Input>
   <label>Parameter ID :</label>
   <type>0</type>
   <value>0</value>
   <variable>param_id</variable>
   <combomap>
    <mapitem>
     <displayval>CONTEXT_ENGINE_ID</displayval>
     <actualval>0</actualval>
    </mapitem>
    <mapitem>
     <displayval>CONTEXT_NAME</displayval>
     <actualval>1</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_DECRYPTION_ERROR</displayval>
     <actualval>2</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_ENGINEBOOTS</displayval>
     <actualval>3</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_ENGINETIME</displayval>
     <actualval>4</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_INVALID_MSG</displayval>
     <actualval>5</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_NOT_IN_TIME_WINDOW</displayval>
     <actualval>6</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNAVAILABLE_CONTEXT</displayval>
     <actualval>7</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNKNOWN_ENGINEID</displayval>
     <actualval>8</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNKNOWN_PDU_HANDLER</displayval>
     <actualval>9</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNKNOWN_SEC_MODEL</displayval>
     <actualval>10</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNKNOWN_USER_NAME</displayval>
     <actualval>11</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_UNSUPPORTED_SECLEVEL</displayval>
     <actualval>12</actualval>
    </mapitem>
    <mapitem>
     <displayval>COUNTER_WRONG_DIGEST</displayval>
     <actualval>13</actualval>
    </mapitem>
    <mapitem>
     <displayval>SNMP_ENGINE_ID</displayval>
     <actualval>14</actualval>
    </mapitem>
   </combomap>
  </Input>
 </InputList>
 <OutputVariables></OutputVariables>
 <script>set param_id
SA_getmysnmpv3param $param_id</script>
</Template>