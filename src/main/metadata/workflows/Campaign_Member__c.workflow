<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CustomerLabelName</fullName>
        <field>Customer_Label_Name__c</field>
        <formula>TEXT(Address__r.TitleOfHonor__c)</formula>
        <name>CustomerLabelName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AutopopulateAddress</fullName>
        <actions>
            <name>CustomerLabelName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Address__c !=null, MD__c =&apos;JP&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
