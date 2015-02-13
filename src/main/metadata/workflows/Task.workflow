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
        <fullName>Update_Call_Start_Time</fullName>
        <field>Start_Call_Time__c</field>
        <formula>CreatedDate - (CallDurationInSeconds /60/60/24)</formula>
        <name>Update Call Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Inbound, outbound</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
