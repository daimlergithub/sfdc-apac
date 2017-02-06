<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Dealer_Name</fullName>
        <field>Dealer_Name__c</field>
        <formula>CreatedBy.Contact.Account.Name</formula>
        <name>Update Dealer Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origin_field_as_Retail</fullName>
        <field>Origin__c</field>
        <literalValue>Dealer</literalValue>
        <name>Update Origin field as Retail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origin_field_as_Wholesale</fullName>
        <field>Origin__c</field>
        <literalValue>Wholesale</literalValue>
        <name>Update Origin field as Wholesale</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Dealer Name</fullName>
        <actions>
            <name>Update_Dealer_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Origin field As Retail</fullName>
        <actions>
            <name>Update_Origin_field_as_Retail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;) &amp;&amp; ($Profile.Name != &apos;Integration API&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Origin field As Wholesale</fullName>
        <actions>
            <name>Update_Origin_field_as_Wholesale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;)) &amp;&amp; ($Profile.Name != &apos;Integration API&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
