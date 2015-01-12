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
        <fullName>Apply_Status_Approved_Forcancel</fullName>
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
        <fullName>Apply_Status_Cancel_Application</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancel Application</literalValue>
        <name>Apply Status Cancel Application</name>
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
        <fullName>Apply_Status_Confirmed_Forfeedback</fullName>
        <field>Feedback_Status__c</field>
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
    <fieldUpdates>
        <fullName>Feedback_Status_Need_Modify</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Feedback Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>Please_note_that_your_Application_of_Tool_Kit_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱申请已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Tool_Kit_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱申请需要调整后重新提交</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Tool_Kit_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱撤销申请已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Tool_Kit_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱撤销申请已驳回</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Tool_Kit_has_been_Approved_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱反馈已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Tool_Kit_has_been_Rejected_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的工具箱反馈需要调整后重新提交</subject>
    </tasks>
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
