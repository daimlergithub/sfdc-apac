<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DRM_Assigned_Task</fullName>
        <description>DRM_Assigned_Task</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DRM</template>
    </alerts>
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
        <fullName>Activate_Dealer</fullName>
        <field>Dealer_Active__c</field>
        <literalValue>1</literalValue>
        <name>Activate Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Credit_License_Number</fullName>
        <field>Credit_License_Number__c</field>
        <formula>&quot;247271&quot;</formula>
        <name>Credit License Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deactivate_Dealer</fullName>
        <field>Dealer_Active__c</field>
        <literalValue>0</literalValue>
        <name>Deactivate Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Frist_Name_Change</fullName>
        <field>FirstName</field>
        <formula>UPPER(LEFT( FirstName , 1)) + RIGHT( FirstName , LEN(FirstName) - 1 )</formula>
        <name>Frist Name Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Surname_Change</fullName>
        <field>LastName</field>
        <formula>UPPER(LEFT( LastName , 1)) + RIGHT( LastName , LEN(LastName) - 1 )</formula>
        <name>Surname Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Frist Name Change Capital</fullName>
        <actions>
            <name>Frist_Name_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.FirstName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Surname Change Capital</fullName>
        <actions>
            <name>Surname_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Activate Dealer</fullName>
        <actions>
            <name>Activate_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(  MD__c = &apos;AU&apos;, ISPICKVAL( Dealer_Allocation__c , &apos;MBAuP&apos;), Activation_Date__c &lt;= TODAY() ), AND( ISPICKVAL( Dealer_Allocation__c , &apos;MBFS&apos;), MBFS_Activation_Date__c &lt;= TODAY() ), AND( ISPICKVAL( Dealer_Allocation__c , &apos;Both&apos;), Activation_Date__c &lt;= TODAY(), MBFS_Activation_Date__c &lt;= TODAY() ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Activate Dealer With Time Trigger</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Dealer_Active__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Activation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Activation_Date__c</field>
            <operation>notEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Activate_Dealer</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Activation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
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
        <fullName>Deactivate Dealer</fullName>
        <actions>
            <name>Deactivate_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(  MD__c = &apos;AU&apos;,(RecordType.Name = &apos;Dealer&apos;), (Dealer_Active__c = true), (Inactivation_Date__c &lt;= TODAY()), (NOT(ISBLANK(Inactivation_Date__c))), OR( ( ISPICKVAL( Dealer_Allocation__c , &apos;MBAuP&apos;) ), ( ISPICKVAL( Dealer_Allocation__c , &apos;MBFS&apos;)) ) ), AND( MD__c = &apos;AU&apos;, (RecordType.Name = &apos;Dealer&apos;), (Dealer_Active__c = true), ( Inactivation_Date__c &lt;= TODAY()), ( ISPICKVAL( Dealer_Allocation__c , &apos;Both&apos;) ), ( MBFS_Inactivation_Date__c &lt;= TODAY() ), (NOT(ISBLANK( MBFS_Inactivation_Date__c ))), (NOT(ISBLANK(Inactivation_Date__c))) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deactivate Dealer With Time Trigger</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND ((3 AND 6 AND 8) OR  (4 AND 5 AND 9)OR  (3 AND 4 AND 7 AND 8 AND 9)) AND 10</booleanFilter>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Dealer_Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MBFS_Inactivation_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Inactivation_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Dealer_Allocation__c</field>
            <operation>equals</operation>
            <value>MBAuP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Dealer_Allocation__c</field>
            <operation>equals</operation>
            <value>MBFS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Dealer_Allocation__c</field>
            <operation>equals</operation>
            <value>Both</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MBFS_Inactivation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Inactivation_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_Dealer</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.Inactivation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
        <fullName>Send_Email_To_DRM_Account</fullName>
        <actions>
            <name>DRM_Assigned_Task</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Whenever the ownership of Account changes an email notification will be triggered to the new Assigned user.</description>
        <formula>IF( ISCHANGED(OwnerId) , true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Credit License Number</fullName>
        <actions>
            <name>Credit_License_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.Credit_License__c</field>
            <operation>equals</operation>
            <value>P.O.S. License</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Credit_License__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
