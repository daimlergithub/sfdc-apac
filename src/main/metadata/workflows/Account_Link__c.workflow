<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Name_field_on_Account_Link</fullName>
        <field>Name</field>
        <formula>Retail_DMS_Customer_ID__c</formula>
        <name>Update Name field on Account Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Name field on Account Link</fullName>
        <actions>
            <name>Update_Name_field_on_Account_Link</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Retail_DMS_Customer_ID__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
