<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Master_Ucid</fullName> 
        <field>Master_UCID__c</field>
        <formula>if( ISNEW() ,Master_Customer__r.UCID__c,if(PRIORVALUE( Master_Customer__c ) != Master_Customer__c , Master_Customer__r.UCID__c ,PRIORVALUE( Master_UCID__c )))</formula>
        <name>Update Master Ucid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Child_UCID</fullName>
        <field>Duplicate_UCID__c</field>
        <formula>if( ISNEW() ,Duplicate_Customer__r.UCID__c,if(PRIORVALUE( Duplicate_Customer__c) != Duplicate_Customer__c, Duplicate_Customer__r.UCID__c ,PRIORVALUE( Duplicate_UCID__c )))</formula>
        <name>Update Child Ucid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update master and Child UCID</fullName>
        <actions>
            <name>Update_Child_UCID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Master_Ucid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(or(MD__c='MY',MD__c='TH'), OR( NOT(ISBLANK(Master_Customer__c )), NOT( ISBLANK( Duplicate_Customer__c ))), OR( ISBLANK(Duplicate_UCID__c) , ISBLANK(Master_UCID__c )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
