<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Rejected_Duplicate_Log_Sync</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>WORKFLOW_OUTBOUND_MESSAGE_ENDPOINTURL</endpointUrl>
        <fields>DUPNumber__c</fields>
        <fields>Duplicate_Account__c</fields>
        <fields>Duplicate_Reason_Code__c</fields>
        <fields>Id</fields>
        <fields>MD__c</fields>
        <fields>Master_Account__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>WORKFLOW_INTEGRATION_USER</integrationUser>
        <name>Rejected Duplicate Log Sync</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Rejected Duplicate Log Sync</fullName>
        <actions>
            <name>Rejected_Duplicate_Log_Sync</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created by: Sneha Chail
CreatedDate: 12/18/2015
Used by: Account Workflow(US-DD-002)
Function: After a suspect account is rejected, send duplicate account id, master account id and dup reason code to EP</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
