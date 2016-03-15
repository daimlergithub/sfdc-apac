<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Call_End_Time</fullName>
        <field>End_call_time__c</field>
        <formula>CreatedDate</formula>
        <name>Update Call End Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Call_Start_Time</fullName>
        <field>Start_Call_Time__c</field>
        <formula>CreatedDate - (CallDurationInSeconds /60/60/24)</formula>
        <name>Update Call Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Notification_Email_Flag</fullName>
        <field>Notification_Email_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Notification Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notification to the assigned to user With Time Trigger</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Task,EMC Task,Campaign Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>notEqual</operation>
            <value>Complete,Deferred</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Due_Task_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.ActivityDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>If  &quot;Due Task Notification&quot; flag is checked the system shall send the email notification to the assigned to user a 9.00 am on the due date in case the status is unequal to &quot;Complete&quot; or &quot;Deferred&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Notification_Email_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Task.Notification_Email_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send_Email_To_Owner</fullName>
        <actions>
            <name>When_tasks_are_created_or_assigned_to_DRM_a_notification_Email_will_be_sent</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>DRM</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task created or assigned to DRM</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>DRM Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Market__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <description>When tasks are created or assigned to DRM, a notification Email will be sent</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TestTaskEmail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.Email</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Call Start%2FEnd Time</fullName>
        <actions>
            <name>Update_Call_End_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Call_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Inbound,Outbound</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xxxxx</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
