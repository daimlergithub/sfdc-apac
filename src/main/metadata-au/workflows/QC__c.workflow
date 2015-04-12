<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_an_email_notification_to_user_when_the_calibration_record_is_changed_to_use</fullName>
        <description>Send an email notification to user when the calibration record is changed to user</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Collaboration_Team_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>When_QC_has_the_Appeal_flag_check_send_an_email_to_QC_SV</fullName>
        <description>When QC has the “Appeal” flag check, send an email to QC SV</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAC_QC_SV_TM</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appeal_QC</template>
    </alerts>
    <rules>
        <fullName>Appeal QC</fullName>
        <actions>
            <name>When_QC_has_the_Appeal_flag_check_send_an_email_to_QC_SV</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QC__c.Appeal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When QC has the “Appeal” flag check, send an email to QC SV</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
