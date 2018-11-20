<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Expired_Field_Update</fullName>
        <description>update field to true after expiration date</description>
        <field>Expired__c</field>
        <literalValue>1</literalValue>
        <name>Expired Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Expired field in Files</fullName>
        <active>true</active>
        <description>Expired Field Update when Expiration date is greater than today</description>
        <formula>Expiration_Date__c  &gt;=  TODAY()</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expired_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Community_Files__c.Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
