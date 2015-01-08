<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activity_Complete</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Activity Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activity_Start</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Started</literalValue>
        <name>Activity Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Activity Complete</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Reserved,Started</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activity_Complete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Event.EndDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Activity Start</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Event.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Reserved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activity_Start</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Event.StartDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
