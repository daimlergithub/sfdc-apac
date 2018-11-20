<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Registration_Notification</fullName>
        <description>Registration Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Id__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RCP_Email_Templates/Event_Registration_Notification</template>
    </alerts>
    <rules>
        <fullName>Registration Notification</fullName>
        <actions>
            <name>Registration_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Registration__c.Email_Id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Once register for an event an email should be triggerred to the email I inputted</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
