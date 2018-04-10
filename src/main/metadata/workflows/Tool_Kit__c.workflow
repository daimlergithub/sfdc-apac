<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Apply_Status_Approved</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Apply Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Cancel</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Apply Status Cancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Confirmed</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Apply Status Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Need_Modify</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Apply Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feedback_Status_Approved</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Feedback Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Tool_Kit_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your Toolbox application has been approved</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Tool_Kit_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your Toolbox applications need to adjust to resubmit</subject>
    </tasks>
</Workflow>
