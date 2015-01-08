<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Vehicle_Relationship_Record_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ep.user1@daimler.prod</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Vehicle Relationship Record Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <outboundMessages>
        <fullName>EP_Send_Vehicle_Relationship_Sync</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/VehicleRelationshipSyncProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Send Vehicle Relationship Sync</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Change Vehicle Relationship Record Owner</fullName>
        <actions>
            <name>Change_Vehicle_Relationship_Record_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Vehicle Relationship Soft Deleted&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Vehicle Relationship Sync</fullName>
        <actions>
            <name>EP_Send_Vehicle_Relationship_Sync</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Created by: Mouse Liu 
Used by: Lead__c (US-CP-007) 
Function: Workflow Outbound message of Vehicle Relationship de-duplication</description>
        <formula>$Profile.Name != &apos;IntegrationAPI&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
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
