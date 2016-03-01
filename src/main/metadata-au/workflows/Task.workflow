<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_On_Task_Creation</fullName>
        <description>Email On Task Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Task_AU_Emails</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TestTaskEmail</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_the_task_owner</fullName>
        <description>Email notification to the task owner</description>
        <protected>false</protected>
        <recipients>
            <recipient>Task_AU_Emails</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TestTaskEmail</template>
    </alerts>
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
        <fullName>Send_Email_On_Task_Creation</fullName>
        <actions>
            <name>Email_On_Task_Creation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Whenever a Task is created by Fleet or Fleet Delete profile User email will be sent out to task owner.</description>
        <formula>OR(Owner:User.Profile.Name ==&apos;Fleet&apos;,Owner:User.Profile.Name ==&apos;Fleet Delete&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Task.ActivityDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send_Email_To_DFM_User</fullName>
        <active>false</active>
        <description>If the status is not Completed, due date is over and Owner’s profile is ‘Fleet or ‘Fleet Delete’’ then send email notification to  .users who has KAM as their Role.</description>
        <formula>AND(OR(Owner:User.Profile.Name ==&apos;Fleet&apos;,Owner:User.Profile.Name ==&apos;Fleet Delete&apos;),  NOT(ISPICKVAL( Status , &apos;Completed&apos;) ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_notification_to_the_task_owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ActivityDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
