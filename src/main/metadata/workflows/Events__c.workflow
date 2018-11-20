<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Events_to_Expired</fullName>
        <field>Expired__c</field>
        <literalValue>1</literalValue>
        <name>Update Events to Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RCP Update Events to Expired</fullName>
        <active>true</active>
        <description>This workflow will update event to expired based on End Date Time</description>
        <formula>End_Time__c &gt;=  DATETIMEVALUE(TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Events_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Events__c.End_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
