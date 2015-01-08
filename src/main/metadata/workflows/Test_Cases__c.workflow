<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Blocked</fullName>
        <field>Status__c</field>
        <literalValue>Blocked</literalValue>
        <name>Blocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InDev</fullName>
        <field>Status__c</field>
        <literalValue>In Development</literalValue>
        <name>InDev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Not Completed</literalValue>
        <name>Not Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Start</fullName>
        <field>Status__c</field>
        <literalValue>Not Start</literalValue>
        <name>Not Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pass</fullName>
        <field>Status__c</field>
        <literalValue>Pass</literalValue>
        <name>Pass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>fail</fullName>
        <field>Status__c</field>
        <literalValue>Failed</literalValue>
        <name>fail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>notstart</fullName>
        <field>Status__c</field>
        <literalValue>Not Start</literalValue>
        <name>notstart</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Blocked</fullName>
        <actions>
            <name>Blocked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Count_Blocked_Step__c  &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fail</fullName>
        <actions>
            <name>fail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Test_Cases__c.Count_Failed_Step__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InDev</fullName>
        <actions>
            <name>InDev</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Count_Dev_Step__c &gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Not Completed</fullName>
        <actions>
            <name>Not_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Count_Steps__c &gt;  Count_Passed_Step__c &amp;&amp;  Count_Failed_Step__c =0 &amp;&amp; Count_Blocked_Step__c = 0 &amp;&amp;  Count_Passed_Step__c  &gt; 0 &amp;&amp; Count_Dev_Step__c =0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Not Start</fullName>
        <actions>
            <name>Not_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Count_Steps__c &gt;  0 &amp;&amp;  Count_Failed_Step__c =0  &amp;&amp;  Count_Passed_Step__c  = 0 &amp;&amp; Count_Blocked_Step__c = 0 &amp;&amp; Count_Dev_Step__c =0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pass</fullName>
        <actions>
            <name>Pass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Count_Passed_Step__c  &lt;&gt; 0 &amp;&amp;  Count_Passed_Step__c  =  Count_Steps__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
