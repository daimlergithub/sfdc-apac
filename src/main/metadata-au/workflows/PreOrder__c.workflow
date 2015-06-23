<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Preorder_Closed_Date_To_Today</fullName>
        <description>The system shall set the closed date to system date automatically when selecting the status &quot;Closed&quot;.</description>
        <field>ClosedDate__c</field>
        <formula>Today()</formula>
        <name>Set Preorder Closed Date To Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Preorder Closed Date To Today When Status Closed</fullName>
        <actions>
            <name>Set_Preorder_Closed_Date_To_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PreOrder__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>The system shall set the closed date to system date automatically when selecting the status &quot;Closed&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
