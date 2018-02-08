<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Acknowledge_Approved</fullName>
        <description>Acknowledge Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Acknowledgement_Approved</template>
    </alerts>
    <alerts>
        <fullName>Acknowledge_Email_Notification_to_Approver</fullName>
        <description>Acknowledge Email Notification to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Acknowledgement_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Acknowledge_Rejected</fullName>
        <description>Acknowledge Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Acknowledgement_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_to_submitter_or_owner</fullName>
        <description>Email to submitter or owner</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Approval_Mail</template>
    </alerts>
    <alerts>
        <fullName>MBTH_Approval_Given</fullName>
        <description>MBTH_Approval Given</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Approval_Mail</template>
    </alerts>
    <alerts>
        <fullName>MBTH_Email_Notification_to_Dealers</fullName>
        <description>MBTH_Email Notification to Dealers</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Email_Notification_to_the_Dealer</template>
    </alerts>
	<alerts>
        <fullName>MBMY_Email_Notification_to_Dealers</fullName>
        <description>MBMY_Email Notification to Dealers</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBMY_Email_Template/MBMY_Retail_Campaign_Planning_And_Design_Notification_to_Dealers</template>
    </alerts>
    <alerts>
        <fullName>MBTH_Intial_Submission_Action_Retail_campaign</fullName>
        <description>MBTH_Intial Submission Action_Retail_campaign</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Approval_Email_to_Approver</template>
    </alerts>
    <alerts>
        <fullName>MBTH_rejection_Action</fullName>
        <description>MBTH_rejection Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Rejectd_Mail</template>
    </alerts>
    <alerts>
        <fullName>Rejection_email_to_the_submitter</fullName>
        <description>Rejection email to the submitter</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Retail_Campaign_Rejectd_Mail</template>
    </alerts>
    <alerts>
        <fullName>Retail_Execution_Email_Notification</fullName>
        <description>Retail Execution Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Retail_CampaignnotificationforExecution</template>
    </alerts>
    <alerts>
        <fullName>Retail_Execution_Notification</fullName>
        <description>Retail Execution Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Retail_CampaignnotificationforExecution</template>
    </alerts>
    <alerts>
        <fullName>Retail_Segmentation_Notification</fullName>
        <description>Retail Segmentation Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Retail_CampaignNotificationforSegmen</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_Owner</fullName>
        <description>Send Email Notification Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TH_Email_Notifiacation_Execution_Date_reaches</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Dealer_MY</fullName>
        <description>Send Notification to Dealer MY</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBMY_Email_Template/MBMY_SegmentationEmail_Notification_to_dealers</template>
    </alerts>
	<alerts>
        <fullName>Send_Email_Notification_to_Owner_MY</fullName>
        <description>Send Email Notification to Owner MY</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBMY_Email_Template/MBMY_Email_Notification_Execution_Date_reaches</template>
    </alerts>
	<alerts>
        <fullName>Send_Notification_to_Dealer</fullName>
        <description>Send Notification to Dealer</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TH_SegmentationgEmail_Notification_to_dealers</template>
    </alerts>
    <alerts>
        <fullName>Send_mail_to_approver</fullName>
        <description>Send mail to approver</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBTH_Approval_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Apply_Status_Approved</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Apply Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Confirmed</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Apply Status Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Need_Modify</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Apply Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_Submitted</fullName>
        <field>Budget_Approval__c</field>
        <literalValue>Submitted</literalValue>
        <name>Change status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_approved</fullName>
        <field>Budget_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Change status to approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Completed</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Response_collection</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Response collection</literalValue>
        <name>Update Status to Response collection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_to_submitted</fullName>
        <field>MBTH_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update field to submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Execution</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Execution</literalValue>
        <name>Update status to Execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_Segmentation</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Segmentation</literalValue>
        <name>Update status to Segmentation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_approved</fullName>
        <field>MBTH_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update status to approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_planning</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>Update status to planning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>change_Parent_Campaign_Status_tocomplete</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>change Parent Campaign Status tocomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>change_status_to_Rejected</fullName>
        <field>Budget_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>change status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>retail_campaign_status_for_segmentation</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Segmentation</literalValue>
        <name>retail campaign status for segmentation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>retail_status_changed_to_execution</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Execution</literalValue>
        <name>retail status changed to execution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_change_to_planning_in_retail</fullName>
        <field>Child_Campaign_Status__c</field>
        <literalValue>Planning</literalValue>
        <name>status change to planning in retail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_status_to_rejected</fullName>
        <field>MBTH_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>update status to rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MBTH_Update_Retail Campaign_ApproverEmail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Retail_Campaign__c.Approver__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBTH_update_Campaign Status</fullName>
        <actions>
            <name>Update_status_to_planning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email_Notification_Owner</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_status_to_Execution</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Execution_Start_Date__c</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status_to_Response_collection</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Response_Date__c</offsetFromField>
            <timeLength>11</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status_to_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Close_Date__c</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Notification_to_Dealer</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_status_to_Segmentation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Segmentation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
	<rules>
        <fullName>MBMY_update_Campaign Status</fullName>
        <actions>
            <name>Update_status_to_planning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Email_Notification_to_Owner_MY</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_status_to_Execution</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Execution_Start_Date__c</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Notification_to_Dealer_MY</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_status_to_Segmentation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Segmentation_Date__c</offsetFromField>
			<timeLength>0</timeLength>
			<workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
		</workflowTimeTriggers>
		<workflowTimeTriggers>
			<actions>
			<name>Update_Status_to_Completed</name>
			<type>FieldUpdate</type>
			</actions>
			<offsetFromField>Retail_Campaign__c.Execution_End_Date__c</offsetFromField>
			<timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Retail Execution Start Date Notification To Owner</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Retail_Campaign__c.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.Execution_Start_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Retail_Execution_Email_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Execution_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Segmentation start date Notification to Retail Users</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Retail_Campaign__c.Segmentation_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Retail_Segmentation_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Segmentation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Status change when new record created in Retail Campaign</fullName>
        <actions>
            <name>status_change_to_planning_in_retail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TH_Retail_campaign Status change to completed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Planning &amp; Design Campaign</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>change_Parent_Campaign_Status_tocomplete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Close_Date__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TH_send Email Notification to the Dealer</fullName>
        <actions>
            <name>MBTH_Email_Notification_to_Dealers</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Dealer_Email__c !=null&amp;&amp; MD__c ==&apos;TH&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
	<rules>
        <fullName>MBMY_send Email Notification to the Dealer	</fullName>
        <actions>
            <name>MBMY_Email_Notification_to_Dealers</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Dealer_Email__c !=null&amp;&amp; MD__c ==&apos;MY&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Based Workflow on Retail Campaign</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Campaign Execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>retail_campaign_status_for_segmentation</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Segmentation_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>retail_status_changed_to_execution</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.Execution_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Your project has been approved by</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>After adjusting your project needs to resubmit</subject>
    </tasks>
</Workflow>