<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PublicCheckBoxToTrue</fullName>
        <field>IsVisibleInSelfService</field>
        <literalValue>1</literalValue>
        <name>PublicCheckBoxToTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>Update_Origin_field_as_Retail</fullName>
        <field>Origin__c</field>
        <literalValue>Dealer</literalValue>
        <name>Update Origin field as Retail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Origin_field_as_Wholesale</fullName>
        <field>Origin__c</field>
        <literalValue>Wholesale</literalValue>
        <name>Update Origin field as Wholesale</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_with_Dealer_name</fullName>
        <field>Dealer_Name__c</field>
        <formula>CreatedBy.Contact.Account.Name</formula>
        <name>Update field with Dealer name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>General Task Email</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notification to the assigned to user With Time Trigger</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Fleet,Fleet (Delete),EMC</value>
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
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
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
        <fullName>Send Email On Task Creation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Fleet,Fleet (Delete),System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <description>Whenever a Task is created by Fleet or Fleet Delete profile User email will be sent out to task owner.
Content of email will be reference the task number and due date.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send_Email_To_DRM_User_After_24hrs_DueDate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>notEqual</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>If status is not completed 24 hours after the due date, send an email notification to DRM user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send_Email_To_NSM_On_Status_Visit</fullName>
        <active>false</active>
        <description>Whenever Status field changes from visit 1 to visit 2 and so on and email notification will be sent to NSM</description>
        <formula>((PRIORVALUE(Subject)==&apos;1st Meeting Metro Visit&apos;) &amp;&amp; Subject == &apos;2nd Visit reporting penetration and volume&apos;) || ((PRIORVALUE(Subject)==&apos;2nd Visit reporting penetration and volume&apos;) &amp;&amp; Subject == &apos;3rd visit (leads) update on leads&apos;) || ((PRIORVALUE(Subject)==&apos;3rd visit (leads) update on leads&apos;) &amp;&amp; Subject == &apos;4th follow up or touch base&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send_Email_To_NSR_User_After_48hrs_DueDate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If status is not completed 48 hours after the due date, send an email notification to DRM user and the National Sales Manager user</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send_Email_To_Owner</fullName>
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
        <active>true</active>
        <description>When tasks are created or assigned to DRM, a notification Email will be sent</description>
        <formula>OR(AND(ISNEW(), RecordType.DeveloperName = &apos;DRM_Task&apos;,MD__c = &apos;AU&apos;), AND( ISCHANGED(OwnerId) ,RecordType.DeveloperName = &apos;DRM_Task&apos;,MD__c = &apos;AU&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TaskUpdatePublicCheckBoxTrue</fullName>
        <actions>
            <name>PublicCheckBoxToTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Whenever a task is created by dealer user then update public(IsVisibleInSelfService) as true</description>
        <formula>IF(     AND(       OR(Owner:User.Profile.Name  = &apos;Dealer CRM Manager&apos;  ,            Owner:User.Profile.Name = &apos;Dealer Divisional Manager&apos;,           Owner:User.Profile.Name = &apos;Dealer Consultant&apos;         ),  MD__c = &apos;AU&apos;       ) ,    true, false   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <active>true</active>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Inbound,Outbound</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Dealer name on task object</fullName>
        <actions>
            <name>Update_field_with_Dealer_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Origin field As Retail</fullName>
        <actions>
            <name>Update_Origin_field_as_Retail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Origin field based on as Retail for General and Marketing tasks</description>
        <formula>ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;) &amp;&amp; ($Profile.Name != &apos;Integration API&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Origin field As Wholesale</fullName>
        <actions>
            <name>Update_Origin_field_as_Wholesale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Origin field based on as Wholesale for General and Marketing tasks</description>
        <formula>NOT(ISPICKVAL($Profile.UserType,&quot;PowerPartner&quot;)) &amp;&amp; ($Profile.Name != &apos;Integration API&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update_Comment_With_TimeStamp</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>DRM Task</value>
        </criteriaItems>
        <description>Updating the comment field with time stamp. Refer to BRD 1.3.</description>
        <triggerType>onAllChanges</triggerType>
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
