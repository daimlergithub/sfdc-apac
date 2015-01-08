<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Vehicle_Record_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ep.user1@daimler.prod</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Vehicle Record Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>EP_Send_Vehicle_Sync</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/VehicleSyncProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Send Vehicle Sync</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Change Vehicle Record Owner</fullName>
        <actions>
            <name>Change_Vehicle_Record_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name = &apos;Vehicle Soft Deleted&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Vehicle Sync</fullName>
        <actions>
            <name>EP_Send_Vehicle_Sync</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Function: Workflow Outbound Message: Send the Vehicle record to EP for de-duplication</description>
        <formula>$Profile.Name != &apos;IntegrationAPI&apos; &amp;&amp;  RecordType.Name != &apos;Competitor&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
