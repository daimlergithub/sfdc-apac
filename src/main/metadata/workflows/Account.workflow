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
        <fullName>First_Consent_Date</fullName>
        <field>First_Consent_Date__c</field>
        <formula>Today()</formula>
        <name>First Consent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Consent_User</fullName>
        <field>First_Consent_User__c</field>
        <formula>$User.Username</formula>
        <name>First Consent User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Data_Source</fullName>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>System Data Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDataSource</fullName>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>UpdateDataSource</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Update_Country_Field_TH</fullName>
        <field>Country__c</field>
        <literalValue>Thailand</literalValue>
        <name>Update Country Field TH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_LastUpdatedDate</fullName>
        <field>Customer_LastUpdatedDate__c</field>
        <formula>Now()</formula>
        <name>Update Customer LastUpdatedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
	<fieldUpdates>
        <fullName>Update_Preferred_Language_Field_TH</fullName>
        <field>Preferred_Language__c</field>
        <literalValue>Thai</literalValue>
        <name>Update Preferred Language Field TH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatedConsentDate</fullName>
        <field>Updated_Consent_Date__c</field>
        <formula>today()</formula>
        <name>UpdatedConsentDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatedConsentUser</fullName>
        <field>Updated_Consent_User__c</field>
        <formula>$User.Username</formula>
        <name>UpdatedConsentUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>MBTH_Update_Consent_data_Source</fullName>
        <actions>
            <name>First_Consent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>First_Consent_User</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Data_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Account.Personal_Agreement__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <description>Update the Data Source,First Consent User and First Consent Date when Personal_Agreement__c is &quot;YES&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer LastUpdatedDate when I%2FF fields changed</fullName>
        <actions>
            <name>Update_Customer_LastUpdatedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( RecordTypeId) || ISCHANGED(Gender__c) || ISCHANGED( FirstName ) || ISCHANGED( LastName ) || 
ISCHANGED( FirstName_Native_1__c ) || ISCHANGED( LastName_Native_1__c ) || ISCHANGED( Company_Name__c ) || 
ISCHANGED( Company_Name_Native_1__c ) || ISCHANGED( Company_Legal_Form__c ) || ISCHANGED( Company_Legal_Form_text__c ) || 
ISCHANGED( Legal_Form_Position__c ) || ISCHANGED( PersonBirthdate ) || ISCHANGED( Foundation_Date__c ) || 
ISCHANGED( Mobile__c ) || ISCHANGED( Individual_Home_Phone__c ) || ISCHANGED( Mobile2__c ) ||
ISCHANGED( Work_Phone__c ) || ISCHANGED( Home_Phone_2__c ) || ISCHANGED( Phone ) ||
ISCHANGED( Fax ) || ISCHANGED( Fax2__c ) || ISCHANGED( Email3__c ) ||
ISCHANGED( Primary_Phone__c ) || ISCHANGED( Primary_Fax__c ) ||(ISCHANGED(Primary_Address_Reference__c)) || (ISCHANGED(Main_Dealer__c))</formula>
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
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for JP</description>
        <formula>ISPICKVAL($User.Market__c,&apos;JP&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
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
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for KR</description>
        <formula>ISPICKVAL($User.Market__c,&apos;KR&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
	<rules>
        <fullName>Update Preferred Language and Country TH</fullName>
        <actions>
            <name>Update_Country_Field_TH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Preferred_Language_Field_TH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for TH</description>
        <formula>ISPICKVAL($User.Market__c,&apos;TH&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>