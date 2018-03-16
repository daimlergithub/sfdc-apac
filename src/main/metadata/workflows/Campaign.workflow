<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_Owner</fullName>
        <description>Email to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appeal_QC</template>
    </alerts>
    <alerts>
        <fullName>Execution_Start_Date_Notification_To_Owner</fullName>
        <description>Execution Start Date Notification To Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_notification_on_Execution</template>
    </alerts>
    <alerts>
        <fullName>MBTH_Approval_Given</fullName>
        <description>MBTH_Approval Given</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Approval_Mail</template>
    </alerts>
    <alerts>
        <fullName>MBTH_Intial_Submission_Action</fullName>
        <description>MBTH_Intial Submission Action</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Approval_Submitted</template>
    </alerts>
    <alerts>
        <fullName>MBTH_rejection_Action</fullName>
        <description>MBTH_rejection Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appeal_QC</template>
    </alerts>
    <alerts>
        <fullName>MBTH_rejections_Action</fullName>
        <description>MBTH_rejection Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Rejectd_Mail</template>
    </alerts>
    <alerts>
        <fullName>Segmentation_Email_Notifications_For_WS_Users</fullName>
        <description>Segmentation Email Notifications For WS Users</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Notification_on_Segmentation</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_to_Campaign_Owner</fullName>
        <description>Send Email Notification to Campaign Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/Campaign_owner_is_updated</template>
    </alerts>
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
        <fullName>Active</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Active flag check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approving</fullName>
        <field>Status</field>
        <literalValue>Approving</literalValue>
        <name>Approving</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Rejection</name>
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
'S&amp;M Event BMBS Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+TEXT(Region__c) +"_"+Auto_Number__c,
'S&amp;M Media BMBS Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+TEXT(Region__c) +"_"+Auto_Number__c,
'AS BMBS Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+TEXT(Region__c) +"_"+Auto_Number__c,
'Central Marketing Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'CAC CRM Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'CAS Marketing Campaign', 'L1'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'Campaign Execution - Simple', 'L3'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'Campaign Execution - Complex', 'L3'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'Campaign Execution MBK - Wholesale to Dealer', 'L3'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c,
'L2'+"_"+TEXT(YEAR(DATEVALUE(CreatedDate)))+"_"+Auto_Number__c)</formula>
        <name>Update Campaign Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Content_Preview</fullName>
        <description>To display the Message Detail of selected Template</description>
        <field>Content_Preview__c</field>
        <formula>if(Template__r.Message_Detail__c != '' &amp;&amp; Template__r.MD__c == 'TH',Template__r.Message_Detail__c, if(OBSMSTemplate__r.Message_Detail__c != '' &amp;&amp; Template__r.MD__c == 'KR',OBSMSTemplate__r.Message_Detail__c,''))</formula>
        <name>Update Content Preview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status</field>
        <literalValue>Published</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <field>Publish_Date__c</field>
        <formula>TODAY()</formula>
        <name>record Publish Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_change_based_on_execution_date</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Execution</literalValue>
        <name>status change based on execution date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_change_to_planning</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>status change to planning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_changed_to_segmentation</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Segmentation</literalValue>
        <name>status changed to segmentation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_Campaign_ID_to_EP</fullName>
        <apiVersion>35.0</apiVersion>
        <endpointUrl>WORKFLOW_OUTBOUND_MESSAGE_ENDPOINTURL_SEND_CAMPAIGN_ID_EP</endpointUrl>
        <fields>Id</fields>
        <fields>MD__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>WORKFLOW_INTEGRATION_USER</integrationUser>
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
        <booleanFilter>(1 AND 2 AND 3 AND ( 4 OR 5)) OR (1 AND 3 AND (6 OR 8) AND 7)</booleanFilter>
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
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
		<criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <description>When Status changed to Started, update Active to true.
Record Type = CAC CRM Campaign,CAS Marketing Campaign,Central Marketing Campaign</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Active Flag For Campaign Management</fullName>
        <actions>
            <name>Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <description>Automaticall make active field true for Planning &amp; design /Campaign Execution record types of campaign</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Send Email Notification to Owner is Changed</fullName>
        <actions>
            <name>Send_Email_Notification_to_Campaign_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>MD__c = 'KR' &amp;&amp; ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Execution start date Notification to WS Users</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Execution_Start_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Execution_Start_Date_Notification_To_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.Execution_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MBTH_Update status Published</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Publish_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Publish_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Record Close Date</fullName>
        <actions>
            <name>record_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND (3 OR 4 )) OR (2 AND (5 OR 7) AND 6)</booleanFilter>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Central Marketing Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
		 <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
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
        <booleanFilter>(1 AND 2 AND (3 OR 4)) OR(5 AND 6 AND 2)</booleanFilter>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Central Marketing Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
		 <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
		 <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Segmentation start date Notification to WS Users</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Segmentation_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Segmentation_Email_Notifications_For_WS_Users</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.Segmentation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Campaign ID to EP</fullName>
        <actions>
            <name>Send_Campaign_ID_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND (  RecordType.DeveloperName='CAC_Campaign', OR( ISCHANGED( IsActive ), ISCHANGED( Repeat_Frequency__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Status Change on New Creation of execution Campaign</fullName>
        <actions>
            <name>status_change_to_planning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <description>campaign status will be changed when we create a new campaign record with record type campaign execution</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Time Based Workflow on Campaign</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <description>workflow fire based on segmenation date and execution date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>status_changed_to_segmentation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Segmentation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>status_change_based_on_execution_date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Execution_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>To update Content Preview</fullName>
        <actions>
            <name>Update_Content_Preview</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(ISNEW() || ISCHANGED(Template__c),MD__c='TH'),AND(ISNEW() || ISCHANGED(OBSMSTemplate__c),MD__c='KR'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Active of Campaign Execution</fullName>
        <actions>
            <name>Update_Ative_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND  3 ) OR (2 AND 4 AND 5) OR (2 AND 5 AND 6)</booleanFilter>
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
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
		 <criteriaItems>
            <field>Campaign.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
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
        <formula>AND(1=1,MD__c=&apos;JP&apos; ||MD__c=&apos;KR&apos; || MD__c=&apos;TH&apos; || MD__c=&apos;MY&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
