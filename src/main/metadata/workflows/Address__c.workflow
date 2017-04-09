<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Account_customer_modified_field</fullName>
        <field>Customer_LastUpdatedDate__c</field>
        <formula>Now()</formula>
        <name>Update Account customer modified field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Customer__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Account Customer LastUpdatedDate when I%2FF fields changed</fullName>
        <actions>
            <name>Update_Account_customer_modified_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Province_Native__c) || ISCHANGED(City_Native__c) ||  ISCHANGED( District_Native__c ) || ISCHANGED( Block_Native__c ) ||  ISCHANGED( Address_Line_1_Native__c) || ISCHANGED( Address_Line_2_Native__c) ||  ISCHANGED( Province__c ) || ISCHANGED( City__c ) ||  ISCHANGED( District__c ) || ISCHANGED( Block__c ) ||  ISCHANGED( Address_Line_1__c ) || ISCHANGED( Address_Line_2__c) || ISCHANGED( ZipCode__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
