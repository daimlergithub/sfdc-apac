<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Opt_Out_Notification</fullName>
        <description>Email Opt Out Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Portal_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Opt_Out_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Name_field_on_Account_Link</fullName>
        <field>Name</field>
        <formula>Retail_DMS_Customer_ID__c</formula>
        <name>Update Name field on Account Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Notification Opt-in%2FOpt -Out</fullName>
        <actions>
            <name>Email_Opt_Out_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification on Opt in/Opt out changes</description>
        <formula>AND((ISPICKVAL(Market__c,&apos;TR&apos;)), 
OR( 
AND( 
ISCHANGED(  Retail_Email_OptIn__c ), 
Retail_Email_OptIn__c = true), 
AND( 
ISCHANGED( Retail_Phone_OptIn__c ), 
Retail_Phone_OptIn__c = true), 
AND( 
ISCHANGED( Retail_Postal_OptIn__c ), 
Retail_Postal_OptIn__c = true), 
AND( 
ISCHANGED( Retail_SMS_OptIn__c ), 
Retail_SMS_OptIn__c = true) 
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Name field on Account Link</fullName>
        <actions>
            <name>Update_Name_field_on_Account_Link</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Retail_DMS_Customer_ID__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
