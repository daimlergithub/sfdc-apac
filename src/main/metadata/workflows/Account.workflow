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
        <fullName>Change_Preferred_Phone</fullName>
        <field>Preferred_Phone__c</field>
        <name>Change Preferred Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Country_Field_JP</fullName>
        <field>Country__c</field>
         <literalValue>Japan</literalValue>
        <name>Update Country Field JP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
	<fieldUpdates>
        <fullName>Update_Country_Field_KR</fullName>
        <field>Country__c</field>
         <literalValue>South Korea</literalValue>
        <name>Update Country Field KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
	<fieldUpdates>
        <fullName>Update_Preferred_Language_Field_JP</fullName>
        <field>Preferred_Language__c</field>
         <literalValue>Japanese</literalValue>
        <name>Update Preferred Language Field JP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
	<fieldUpdates>
        <fullName>Update_Preferred_Language_Field_KR</fullName>
        <field>Preferred_Language__c</field>
         <literalValue>Korean</literalValue>
        <name>Update Preferred Language Field KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Preferred phone to null</fullName>
        <actions>
            <name>Change_Preferred_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When field “Preferred contact method” value is set to others from “Phone”,the field value changes to null</description>
        <formula>AND( ISPICKVAL(PRIORVALUE( Preferred_Contact_Method__c ),&apos;Phone&apos;), NOT(ISPICKVAL(Preferred_Contact_Method__c, &apos;Phone&apos;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Update Preferred Language and Country JP</fullName>
        <actions>
            <name>Update_Country_Field_JP</name>
            <type>FieldUpdate</type>
        </actions>
		<actions>
            <name>Update_Preferred_Language_Field_JP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field" based on Market Discriminator for JP</description>
        <formula>ISPICKVAL($User.Market__c,&apos;JP&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Update Preferred Language and Country KR</fullName>
        <actions>
            <name>Update_Country_Field_KR</name>
            <type>FieldUpdate</type>
        </actions>
		<actions>
            <name>Update_Preferred_Language_Field_KR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update “Preferred Language and Country field" based on Market Discriminator for KR</description>
        <formula>ISPICKVAL($User.Market__c,&apos;KR&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Assigned Leads to Dealer Everyday</fullName>
        <actions>
            <name>Dealer_Email_Notification_on_Amount_of_Assigned_Leads</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
</Workflow>
