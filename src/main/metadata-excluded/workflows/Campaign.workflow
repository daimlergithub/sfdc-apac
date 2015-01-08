<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Activate_Campaign</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Activate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_ExecutionIndex_Calculation</fullName>
        <field>Index__c</field>
        <formula>IF( Previous_Campaign_Execution__c == &apos;&apos; , 1,  Previous_Campaign_Execution__r.Index__c + 1 )</formula>
        <name>Campaign ExecutionIndex Calculation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deactivate_Campaign</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Ative_to_True</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Update Ative to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Campaign_Code</fullName>
        <field>Campaign_Code__c</field>
        <formula>CASE(
RecordType.Name,
&apos;S&amp;M Event BMBS Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+TEXT(Region__c) +&quot;_&quot;+Auto_Number__c,
&apos;S&amp;M Media BMBS Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+TEXT(Region__c) +&quot;_&quot;+Auto_Number__c,
&apos;AS BMBS Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+TEXT(Region__c) +&quot;_&quot;+Auto_Number__c,
&apos;Central Marketing Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c,
&apos;CAC CRM Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c,
&apos;CAS Marketing Campaign&apos;, &apos;L1&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c,
&apos;Campaign Execution - Simple&apos;, &apos;L3&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c,
&apos;Campaign Execution - Complex&apos;, &apos;L3&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c,
&apos;L2&apos;+&quot;_&quot;+TEXT(YEAR(DATEVALUE(CreatedDate)))+&quot;_&quot;+Auto_Number__c)</formula>
        <name>Update Campaign Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Content_Preview</fullName>
        <description>To display the Message Detail of selected Template</description>
        <field>Content_Preview__c</field>
        <formula>Template__r.Message_Detail__c</formula>
        <name>Update Content Preview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>record_Close_Date</fullName>
        <field>Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>record Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>record_Publish_Date</fullName>
        <field>Publish_Date_del__c</field>
        <formula>TODAY()</formula>
        <name>record Publish Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_Campaign_ID_to_EP</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/CampaignExecutionProcess</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Send Campaign ID to EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Activate Campaign When Status Changes to %22Started%22</fullName>
        <actions>
            <name>Activate_Campaign</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Started</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>CAC CRM Campaign,CAS Marketing Campaign,Central Marketing Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When Status changed to Started, update Active to true.
Record Type = CAC CRM Campaign,CAS Marketing Campaign,Central Marketing Campaign</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Index Calculation</fullName>
        <actions>
            <name>Campaign_ExecutionIndex_Calculation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution - Simple,Campaign Execution - Complex</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record Close Date</fullName>
        <actions>
            <name>record_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>AS BMBS Campaign,S&amp;M Event BMBS Campaign,S&amp;M Media BMBS Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Record Publish Date</fullName>
        <actions>
            <name>record_Publish_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>AS BMBS Campaign,S&amp;M Event BMBS Campaign,S&amp;M Media BMBS Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Campaign ID to EP</fullName>
        <actions>
            <name>Send_Campaign_ID_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(
RecordType.Name=&apos;CAC Campaign&apos;,
OR(ISCHANGED(IsActive),ISCHANGED(Repeat_Frequency__c))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To update Content Preview</fullName>
        <actions>
            <name>Update_Content_Preview</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED( Template__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Active of Campaign Execution</fullName>
        <actions>
            <name>Update_Ative_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution - Simple,Campaign Execution - Complex</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Campaign Code</fullName>
        <actions>
            <name>Update_Campaign_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
