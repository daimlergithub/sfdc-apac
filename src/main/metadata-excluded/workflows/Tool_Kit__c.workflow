<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Tool Kit finished by Vendor</fullName>
        <actions>
            <name>Please_note_that_your_tool_kit_has_completed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Tool_Kit__c.Apply_Status__c</field>
            <operation>equals</operation>
            <value>Tool Kit Finished</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Please_note_that_your_tool_kit_has_completed</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Please note that your tool kit has completed</subject>
    </tasks>
</Workflow>
