<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Colour_field_in_Car_Model</fullName>
        <field>Colour__c</field>
        <formula>&quot;NA&quot;</formula>
        <name>Update Colour field in Car Model</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Colour field</fullName>
        <actions>
            <name>Update_Colour_field_in_Car_Model</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Car_Model__c.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Car_Model__c.Colour__c</field>
            <operation>equals</operation>
            <value>null</value>
        </criteriaItems>
        <description>/* Used for Thailand */ 
If the Colour__c field is blank during record creation, add the default value as &quot;No colour added&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
