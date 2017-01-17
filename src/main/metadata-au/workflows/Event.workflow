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
</Workflow>
