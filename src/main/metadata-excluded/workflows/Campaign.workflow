<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Send_Campaign_ID_to_EP</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/CampaignExecutionProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Send Campaign ID to EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    
    
    <rules>
        <fullName>Send Campaign ID to EP</fullName>
        <actions>
            <name>Send_Campaign_ID_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(
RecordType.Name=&apos;CAC Campaign&apos;,
OR(ISCHANGED(IsActive),ISCHANGED(Repeat_Frequency__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    
</Workflow>
