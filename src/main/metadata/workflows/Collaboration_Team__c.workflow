<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Collaboration_Team_Send_Email_to_Member</fullName>
        <description>Collaboration Team_Send Email to Member</description>
        <protected>false</protected>
        <recipients>
            <field>Member_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Collaboration_Team_Notification_Template</template>
    </alerts>
    <rules>
        <fullName>CollaborationTeam_SendEmailToMember</fullName>
        <actions>
            <name>Collaboration_Team_Send_Email_to_Member</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Collaboration_Team__c.Member_Name__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
