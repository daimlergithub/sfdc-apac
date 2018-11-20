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
        <senderAddress>donotreply@mercedes-benz.com.tr</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Email_Opt_Out_Notification</template>
    </alerts>
     <alerts>
        <fullName>Retail_DOC_Notification</fullName>
        <description>Retail_DOC_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email2__c</field>
            <type>email</type>
        </recipients>
      	<senderAddress>donotreply@mercedes-benz.com.tr</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Retail_DOC_Notification_update</template>
    </alerts>
     <fieldUpdates>
        <fullName>Copy_UCID_Values</fullName>
        <field>Retail_UCID__c</field>
        <formula>UCID2__c</formula>
        <name>Copy UCID Values</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Name_field_on_Account_Link</fullName>
        <field>Name</field>
        <formula>Retail_DMS_Customer_ID__c</formula>
        <name>Update Name field on Account Link</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
		<fieldUpdates>
        <fullName>Update_Name_field_on_Account_Link_ANZ</fullName>
        <field>Name</field>
        <formula>PRIORVALUE(   Name   )</formula>
        <name>Update Name field on Account Link ANZ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_to_inactive</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Update field to inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Copy_UCID2_Retail_UCID</fullName>
        <actions>
            <name>Copy_UCID_Values</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>copy the value from UCID2__c (formula field) into Retail_UCID__c on create of a Account link (Retail Person, Retail Company)</description>
        <formula>AND(OR( RecordType.Name == &apos;Retail Company&apos;,RecordType.Name == &apos;Retail Person&apos;),
 NOT(ISBLANK( UCID2__c ) ) ,
   ISBLANK( Retail_UCID__c ) ,
 ISPICKVAL(Market__c, &apos;TR&apos;),
 CreatedBy.Alias == &apos;FAssmbly&apos; 
)</formula>
      <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
    <rules>
        <fullName>Retail_DOC_Notification_Update</fullName>
        <actions>
            <name>Retail_DOC_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Market__c, &apos;TR&apos;) , 
OR(AND(ISNEW(),
OR(Retail_Email_OptIn__c == TRUE,Retail_Phone_OptIn__c == TRUE, Retail_SMS_OptIn__c == TRUE,
Retail_Postal_OptIn__c == TRUE)), 
AND(NOT( ISNEW() ),
(OR( ISCHANGED( Retail_Email_OptIn__c ), 
ISCHANGED( Retail_Phone_OptIn__c ), 
ISCHANGED( Retail_SMS_OptIn__c ), 
ISCHANGED( Retail_Postal_OptIn__c ) ) ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	    <rules>
        <fullName>TH_Inactive C2C AccountLink</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account_Link__c.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Link__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Link__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Contact2Contact</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_field_to_inactive</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account_Link__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Name field on Account Link ANZ</fullName>
        <actions>
            <name>Update_Name_field_on_Account_Link_ANZ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISPICKVAL(Market__c, &apos;AU&apos;) ,ISPICKVAL(Market__c, &apos;NZ&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
