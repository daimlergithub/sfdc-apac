<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dealer_Email_Notification_on_Amount_of_Assigned_Leads</fullName>
        <description>Dealer Email Notification on Amount of Assigned Leads</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Lead_Gate_Keeper__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Dealer_Account_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>zhiyuan.pan1@daimler.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Dealer Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Person_Account_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ep.user1@daimler.prod</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Person Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Preferred_Phone</fullName>
        <field>Preferred_Phone__c</field>
        <name>Change Preferred Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ep.user1@daimler.prod</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Customer Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_EP_De_Duplication</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/CustomerUpdateNotification</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Account EP De Duplication</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>EP_Dealer_Codes</fullName>
        <apiVersion>28.0</apiVersion>
        <description>Send Dealer codes to EP</description>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/DealerMappingUpdate</endpointUrl>
        <fields>Dealer_DMS_CRM_Code_2__c</fields>
        <fields>Dealer_DMS_CRM_Code__c</fields>
        <fields>Dealer_DMS_SR_Code_2__c</fields>
        <fields>Dealer_DMS_SR_Code__c</fields>
        <fields>Dealer_Default_Flag__c</fields>
        <fields>Dealer_SSI_Participation__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Dealer Codes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>EP_Merge_Suspect_Duplicates</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/AccountMergeProcess</endpointUrl>
        <fields>Id</fields>
        <fields>Master_Account_Id__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Merge Suspect Duplicates</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account EP Duplicate Check</fullName>
        <actions>
            <name>Account_EP_De_Duplication</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Function: Workflow Outbound Message of Account for EP De-Duplication</description>
        <formula>AND($Profile.Name != &apos;IntegrationAPI&apos;, RecordType.Name = &apos;Person Account&apos;,  OR(ISNEW(),ISCHANGED(FirstName),ISCHANGED(LastName),ISCHANGED(Province__c ),ISCHANGED(Primary_Address__c),ISCHANGED( City_CN__c),ISCHANGED(ZipCode__c),ISCHANGED(ID_Number__c),ISCHANGED( PersonEmail),ISCHANGED(PersonHomePhone),ISCHANGED( PersonMobilePhone),ISCHANGED(Phone),ISCHANGED( PersonOtherPhone) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Dealer Account Owner</fullName>
        <actions>
            <name>Change_Dealer_Account_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>ep.user1</value>
        </criteriaItems>
        <description>change dealer account owner to regional info data manager</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Person Account Owner</fullName>
        <actions>
            <name>Change_Person_Account_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Person Account Soft Deleted&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Preferred phone to null</fullName>
        <actions>
            <name>Change_Preferred_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When field “Preferred contact method” value is set to others from “Phone”,the field value changes to null</description>
        <formula>AND( ISPICKVAL(PRIORVALUE( Preferred_Contact_Method__c ),&apos;Phone&apos;), NOT(ISPICKVAL(Preferred_Contact_Method__c, &apos;Phone&apos;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dealer Mapping Update</fullName>
        <actions>
            <name>EP_Dealer_Codes</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Send updates to DMS system when the DMS codes or Default Flag have been updated in SFDC</description>
        <formula>OR( ISCHANGED( Dealer_Default_Flag__c ) , ISCHANGED( Dealer_DMS_SR_Code__c ) ,  ISCHANGED( Dealer_DMS_SR_Code_2__c )  ,  ISCHANGED( Dealer_DMS_CRM_Code__c )  ,  ISCHANGED( Dealer_DMS_CRM_Code_2__c ),  ISCHANGED( Dealer_SSI_Participation__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Assigned Leads to Dealer Everyday</fullName>
        <actions>
            <name>Dealer_Email_Notification_on_Amount_of_Assigned_Leads</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-14) 
Function: Send Assigned Dealer Amount to dealer everyday
Used in: 

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>AND (     Assigned_Lead_Amount_of_Everyday__c &gt; 0,     ISCHANGED(Assigned_Lead_Amount_of_Everyday__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Suspect Duplicate Merge</fullName>
        <actions>
            <name>EP_Merge_Suspect_Duplicates</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created by: Mouse Liu 
CreatedDate: 2013-7-29 
Used by: Account Workflow(US-DD-002) 
Function: After a suspect account is merged, send the master account id and merged duplicate account id to EP.</description>
        <formula>AND (      RecordType.DeveloperName == &apos;Person_Account_Manual_Merge&apos;,     NOT(ISBLANK(Master_Account_Id__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Owner</fullName>
        <actions>
            <name>Update_Customer_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>equals</operation>
            <value>VIP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
