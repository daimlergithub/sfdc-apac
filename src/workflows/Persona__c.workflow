<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Junction_field</fullName>
        <description>To remove duplicate combination of functionality and market</description>
        <field>Combination_of_Market_and_Functionality__c</field>
        <formula>Functionality_Access__r.Name +  Market_Access__r.Name</formula>
        <name>Junction field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Combination of functionality and market</fullName>
        <actions>
            <name>Junction_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
