<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_smart_status_to_invalid</fullName>
        <field>Status__c</field>
        <literalValue>Invalid</literalValue>
        <name>update smart status to &apos;invalid&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update smart status to %27invalid%27 When Dealer check failed</fullName>
        <actions>
            <name>update_smart_status_to_invalid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>smart_SSI__c.DealerCheck_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <description>When DealerCheck Status is &apos;Reject&apos;, update status to &apos;invalid&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updated smart status to %E2%80%98Invalid%E2%80%99 When CarModelCheck failed</fullName>
        <actions>
            <name>update_smart_status_to_invalid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>smart_SSI__c.CarModelCheck_Status__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
