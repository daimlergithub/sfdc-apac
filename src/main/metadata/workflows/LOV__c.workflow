<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_External_Id</fullName>
        <description>Update external Id *Key = Type + Level One + Level Two</description>
        <field>Key__c</field>
        <formula>TEXT( Type__c ) +  Level_One__c  +  Level_Two__c</formula>
        <name>Update External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update external Id</fullName>
        <actions>
            <name>Update_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update external Id = Type + Level One + Level Two</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
