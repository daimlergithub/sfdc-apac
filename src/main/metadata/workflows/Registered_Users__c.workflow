<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_the_Requestor_for_Request_Rejected</fullName>
        <description>Email Alert to the Requestor for Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>emailId__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Rug_Email_Templates/Email_Notification_for_User_Creation_in_IdeaExchange_Community_has_been_rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_the_Approvers_for_User_Creation_in_Community</fullName>
        <description>Email Notification to the Approvers for User Creation in Community</description>
        <protected>false</protected>
        <recipients>
            <recipient>Community_Management_Queue</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Rug_Email_Templates/Email_notification_for_User_Creation_in_IdeaExchange_Community</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Approved</fullName>
        <field>request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_To_Pending_Approval</fullName>
        <field>request_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Status To Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
