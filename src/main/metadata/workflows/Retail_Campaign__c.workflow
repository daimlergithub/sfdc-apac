<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Submit_Date_Updated</fullName>
        <field>Submit_Date__c</field>
        <formula>TODAY()</formula>
        <name>Submit Date Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates> 
    <fieldUpdates>
        <fullName>Feedback_Status_Need_Modify</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Feedback Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>Apply_Status_Need_Modify</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Apply Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates> 
    <fieldUpdates>
        <fullName>Status_Updated_Approved</fullName>
        <field>Y_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Updated Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_Need_Modify</fullName>
        <field>Y_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Status Updated Need Modify</name>
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
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Apply_Status_Cancel_Application</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancel Application</literalValue>
        <name>Apply Status Cancel Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Cancelled</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Apply Status Cancelled</name>
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
    <rules>
        <fullName>Submit Date Updated</fullName>
        <actions>
            <name>Submit_Date_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.Apply_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>	
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Campaign_has_been_Approved_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your feedback has been approved</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Campaign_has_been_Rejected_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your feedback needs to be adjusted to resubmit</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Campaign_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your event you withdraw your application has been approved</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>After adjusting your project needs to resubmit</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Yearly_TA_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Submit your annual plan needs to be adjusted to</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your project has been approved by</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Campaign_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Activities of your revocation request has been rejected</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Yearly_TA_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your annual plan has been approved by the</subject>
    </tasks>
</Workflow>
