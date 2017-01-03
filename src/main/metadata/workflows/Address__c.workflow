<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Sales_Address_Display_KR</fullName>
        <description>To populate customer address</description>
        <field>Primary_Address_Display__c</field>
        <formula>Address_Line_1__c + &apos; &apos; +  Address_Line_2__c  + &apos; &apos; +  City__c + &apos; &apos; + TEXT(Province__c) + &apos; &apos; +  District__c</formula>
        <name>Populate Sales Address Display KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Customer__c</targetObject>
    </fieldUpdates>
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
        <fullName>Populate Sales Address KR</fullName>
        <actions>
            <name>Populate_Sales_Address_Display_KR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Address__c.Preferred__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Address__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
