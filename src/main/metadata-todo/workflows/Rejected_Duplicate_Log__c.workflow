<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Rejected_Duplicate_Log_Sync</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/RejectedDuplicateLogSync</endpointUrl>
        <fields>Duplicate_Account__c</fields>
        <fields>Duplicate_Reason_Code__c</fields>
        <fields>Id</fields>
        <fields>Master_Account__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
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
        <description>Created by: Mouse Liu 
CreatedDate: 2013-7-29 
Used by: Account Workflow(US-DD-002) 
Function: After a suspect account is rejected, send duplicate account id, master account id and dup reason code to EP</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
