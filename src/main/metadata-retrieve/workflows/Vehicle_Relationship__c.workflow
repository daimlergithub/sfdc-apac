<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Validate_Vehicle_Relationship</fullName>
        <description>As a CAC user, I want system to validate vehicle relationship based on the field car relation automatically, when I create or update vehicle relationship in salesforce manually.</description>
        <field>Validity__c</field>
        <literalValue>Yes</literalValue>
        <name>Validate Vehicle Relationship</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Validate Vehicle Relationship</fullName>
        <actions>
            <name>Validate_Vehicle_Relationship</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Vehicle_Relationship__c.Car_Relation__c</field>
            <operation>equals</operation>
            <value>Owner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>IntegrationAPI</value>
        </criteriaItems>
        <description>As a CAC user, I want system to validate vehicle relationship based on the field car relation automatically, when I create or update vehicle relationship in salesforce manually.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
