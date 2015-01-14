<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Inbound_test</fullName>
        <field>Subject</field>
        <formula>Subject + &quot; &quot; + TEXT(CallType)</formula>
        <name>Inbound test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetIsVisibleInSelfServiceTrue</fullName>
        <description>set IsVisibleInSelfService = True of closed task for defined record types</description>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>SetIsVisibleInSelfServiceTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    
    <fieldUpdates>
        <fullName>Update_Status_to_closed_by_result</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Status to closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Closed</fullName>
        <description>Update status to Closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Closed_1</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Status_to_open_by_result</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>update Status to open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>EP_Send_MMS</fullName>
        <apiVersion>30.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/MmsProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Send MMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>EP_Send_SMS</fullName>
        <apiVersion>27.0</apiVersion>
        <description>Send SMS task IDs to EP</description>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/SmsProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Send SMS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>EP_Send_eDM</fullName>
        <apiVersion>27.0</apiVersion>
        <description>Send eDM task IDs to EP</description>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/EdmProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>EP Send eDM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Send MMS Activity</fullName>
        <actions>
            <name>EP_Send_MMS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>MMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send SMS Activity</fullName>
        <actions>
            <name>EP_Send_SMS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>SMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send eDM Activity</fullName>
        <actions>
            <name>EP_Send_eDM</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>eDM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SetIsVisibleInSelfServiceTrue</fullName>
        <actions>
            <name>SetIsVisibleInSelfServiceTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>DM,IB Call,OB Call,SMS,eDM,Social Media,MMS</value>
        </criteriaItems>
        <description>set IsVisibleInSelfService = True of closed task for defined record types.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    
    <rules>
        <fullName>Update Status to closed by Result</fullName>
        <actions>
            <name>Update_Status_to_closed_by_result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>OB Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Result__c</field>
            <operation>equals</operation>
            <value>Solved</value>
        </criteriaItems>
        <description>Update Status to closed when Result field is equal to sloved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status to open by Result</fullName>
        <actions>
            <name>update_Status_to_open_by_result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>OB Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Result__c</field>
            <operation>equals</operation>
            <value>Unsolved</value>
        </criteriaItems>
        <description>Update Status to open when Result equals to Unsolved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
