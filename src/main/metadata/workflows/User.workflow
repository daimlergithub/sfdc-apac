<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Notification_Lead_No_Update</fullName>
        <field>Notification_Lead_No_Update__c</field>
        <formula>Dealer_ND_Code__c</formula>
        <name>Update Notification Lead No Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Notification Lead No Update</fullName>
        <actions>
            <name>Update_Notification_Lead_No_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISNEW(),ISPICKVAL(Market__c, &apos;JP&apos;), OR( Profile.Name = &apos;Sales Manager&apos;, Profile.Name = &apos;Service Manager&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
