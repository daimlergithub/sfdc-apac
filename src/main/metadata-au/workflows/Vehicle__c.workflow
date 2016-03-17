<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Comment_with_Brand_and_Car_Model</fullName>
        <field>Comment__c</field>
        <formula>TEXT(Brand__c) + &apos; &apos; + Car_Model__r.Name</formula>
        <name>Update Comment with Brand and Car Model</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Generic Vehicle Search String</fullName>
        <actions>
            <name>Update_Comment_with_Brand_and_Car_Model</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>        
        <formula>AND(MD__c = &apos;AU&apos;, RecordType.DeveloperName = &apos;Competitor&apos;, TEXT(Brand__c) != null, TEXT(Brand__c) != &apos;&apos;, Car_Model__c != null, Car_Model__c != &apos;&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
