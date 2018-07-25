<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Call_End_Time</fullName>
        <field>End_call_time__c</field>
        <formula>CreatedDate</formula>
        <name>Update Call End Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	 <fieldUpdates>
        <fullName>Update_Call_Duration</fullName>
        <field>CallDurationInSeconds</field>
        <formula>FLOOR((End_call_time__c - Start_Call_Time__c)*24*60)</formula>
        <name>Update Call Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Public_to_True</fullName>
        <field>IsVisibleInSelfService</field>
        <formula>true</formula>
        <name>Update Public to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Start_Time</fullName>
        <field>Start_Call_Time__c</field>
        <formula>CreatedDate - (CallDurationInSeconds /60/60/24)</formula>
        <name>Update Call Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_RecordType_for_CTI_OB_Field_Updat</fullName>
        <description>This workflow field update would update the recordtype of the Task to OB Call if the &quot;Call Type&quot; is set as &quot;Outbound via the CTI.</description>
        <field>RecordTypeId</field>
        <lookupValue>OB_Call</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update RecordType for CTI OB Field Updat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
	<rules>
        <fullName>Set Call Duration</fullName>
        <actions>
            <name>Update_Call_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This flow is used to set the call duration by doing this start call time minus end call time</description>
        <formula>IF(((PRIORVALUE(Start_Call_Time__c) != Start_Call_Time__c || PRIORVALUE(End_call_time__c) != End_call_time__c) || (!ISBLANK(Start_Call_Time__c) &amp;&amp; !ISBLANK(End_call_time__c)) &amp;&amp; (TEXT($User.Market__c)==&apos;KR&apos;)), true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Task Sharing for Dealer</fullName>
        <actions>
            <name>Update_Public_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description></description>
        <formula>(RecordType.Name == 'General Task' &amp;&amp; MD__c = &apos;JP&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Call Start%2FEnd Time</fullName>
        <actions>
            <name>Update_Call_End_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Call_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Inbound,Outbound</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>IN</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update RecordType for CTI OB</fullName>
        <actions>
            <name>Update_RecordType_for_CTI_OB_Field_Updat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Outbound</value>
        </criteriaItems>
        <description>This workflow will update the recordtype of the task to OP Call of the Call type is set to Outbound.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
