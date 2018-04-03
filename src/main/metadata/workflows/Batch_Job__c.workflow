<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_the_email_of_fail_reason_to_recipient</fullName>
        <description>Send the email of fail reason to recipient</description>
        <protected>false</protected>
        <recipients>
            <field>Recipient_Eamil__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Batch_Job_Email_Template/Email_notification_when_batch_job_is_fail</template>
    </alerts>
</Workflow>
