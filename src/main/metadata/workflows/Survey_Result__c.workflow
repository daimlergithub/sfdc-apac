<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_InvoiceMonthNumber</fullName>
        <field>InvoiceMonth__c</field>
        <formula>MONTH(InvoiceDate__c)</formula>
        <name>Update InvoiceMonthNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update InvoiceMonthNumber</fullName>
        <actions>
            <name>Update_InvoiceMonthNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Survey_Result__c.InvoiceDate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Survey_Result__c.InvoiceMonth__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
