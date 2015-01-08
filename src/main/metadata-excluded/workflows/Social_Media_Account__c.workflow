<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Link_Social_Media_Account</fullName>
        <apiVersion>28.0</apiVersion>
        <description>Link Social media account to Ruishi</description>
        <endpointUrl>https://benz.social360.com.cn/LinkAccount.asmx</endpointUrl>
        <fields>Account_Name__c</fields>
        <fields>Account__c</fields>
        <fields>Contact_ID__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Type__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Link Social Media Account</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Social Media Account Binding</fullName>
        <actions>
            <name>Link_Social_Media_Account</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Social_Media_Account__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
