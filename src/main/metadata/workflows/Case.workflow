<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_handing_level_email_to_Notification</fullName>
        <description>Case handing level email Notification to Dealer</description>
        <protected>false</protected>
        <recipients>
            <field>Send_Email_Support_Dealer1_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Send_Email_Support_Dealer2_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Send_Email_Support_Dealer3_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Handling_level_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_need_to_be_handle_before_deadline</fullName>
        <description>Case need to be handle before deadline.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_need_to_be_handle_before_deadline_KR</fullName>
        <description>Case need to be handle before deadline KR</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Complaint_Update_Notification</fullName>
        <description>Complaint Update Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>After-sales team</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>CRM Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Dealer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>PR</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Technical</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Complaint_update_notification</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Dealer_when_Retail_Campaign_Case_is_assigned</fullName>
        <description>Email to Dealer when Retail Campaign Case is assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Retail_Campaign_Inquiry_Assignment_To_Dealer_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper</fullName>
        <description>Send Email to Gate Keeper</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Assignment_To_Dealer_GateKeeper_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper_For_Support_Dealer1</fullName>
        <description>Send Email to Gate Keeper For Support Dealer1</description>
        <protected>false</protected>
        <recipients>
            <field>Send_Email_Support_Dealer1_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Support_Dealer_GateKeeper_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper_For_Support_Dealer2</fullName>
        <description>Send Email to Gate Keeper For Support Dealer2</description>
        <protected>false</protected>
        <recipients>
            <field>Send_Email_Support_Dealer2_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Support_Dealer_GateKeeper_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper_For_Support_Dealer3</fullName>
        <description>Send Email to Gate Keeper For Support Dealer3</description>
        <protected>false</protected>
        <recipients>
            <field>Send_Email_Support_Dealer3_Keeper_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Support_Dealer_GateKeeper_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChangeStatus</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>ChangeStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeStatusforApproval</fullName>
        <description>Change Status to &apos;Waiting for final approval&apos;</description>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>ChangeStatusforApproval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Final_Approval_Rejecte</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Change Status to &apos;Final Approval Rejecte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Final_approval_don</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Change Status to &apos;Final approval don</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Final_approval_done</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Change Status to &apos;Final approval done&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Final_approval_rejec</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Change Status to &apos;Final approval rejec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Final_approval_reject</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Change Status to &apos;Final approval reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Change Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Waiting_for_Reponse_app</fullName>
        <field>Status</field>
        <literalValue>Waiting for Response approval</literalValue>
        <name>Change Status to Waiting for Reponse app</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Waiting_for_final_appr</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Change Status to &apos;Waiting for final appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Email_to_Gate_Keeper</fullName>
        <field>SendEmailToGateKeeper__c</field>
        <literalValue>0</literalValue>
        <name>Send Email to Gate Keeper</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Final_approval_done</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Status Final approval done</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Final_approval_rejected</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Status Final approval rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Waiting_for_Reponse_approval</fullName>
        <field>Status</field>
        <literalValue>Waiting for Response approval</literalValue>
        <name>Status Waiting for Reponse approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Final_approval_done</fullName>
        <description>Change Status to &apos;Final approval done&apos;</description>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Status to Final approval done</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Final_approval_rejected</fullName>
        <description>Change Status to &apos;Final approval rejected&apos;</description>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Status to Final approval rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Waiting_for_Reponse_approval</fullName>
        <description>Change Status to Waiting for Reponse approval</description>
        <field>Status</field>
        <literalValue>Waiting for Response approval</literalValue>
        <name>Status to Waiting for Reponse approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovalSubmit</fullName>
        <description>Update Approval_Submit_Date__C  with System.today()</description>
        <field>Approval_Submit_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approval_Submit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ApprovalSubmit_Date</fullName>
        <description>Update Approval_Submit_Date__C  with System.today()</description>
        <field>Approval_Submit_Date__c</field>
        <formula>NOW()</formula>
        <name>Update ApprovalSubmit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_submit_date</fullName>
        <field>Approval_Submit_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approval submit date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Origin_To_CAC</fullName>
        <field>Origin</field>
        <literalValue>From CAC</literalValue>
        <name>Update Case Origin To CAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CheckFlag_After_48H</fullName>
        <field>CheckFlag_48H__c</field>
        <literalValue>1</literalValue>
        <name>Update CheckFlag After 48H</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CheckFlag_After_72H</fullName>
        <field>CheckFlag_72H__c</field>
        <literalValue>1</literalValue>
        <name>Update CheckFlag After 72H</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Complaint_Creator_Department_toCA</fullName>
        <field>Complaint_Creator_Department__c</field>
        <literalValue>CAC</literalValue>
        <name>Update Complaint Creator Department toCA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Creator_Department_To_ROCO</fullName>
        <field>Complaint_Creator_Department__c</field>
        <literalValue>RO/CO</literalValue>
        <name>Update Creator Department To ROCO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Creator_Department_to_Dealer</fullName>
        <field>Complaint_Creator_Department__c</field>
        <literalValue>Dealer</literalValue>
        <name>Update Creator Department to Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Overdue_to_Yes</fullName>
        <field>Overdue__c</field>
        <literalValue>Y</literalValue>
        <name>Update Overdue to Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Dealer1_Email_FlgToFalse</fullName>
        <field>Send_Email_Support_Dealer1_Keeper__c</field>
        <literalValue>0</literalValue>
        <name>Update Support Dealer1 Email FlgToFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Dealer2_Email_FlgToFalse</fullName>
        <field>Send_Email_Support_Dealer2_Keeper__c</field>
        <literalValue>0</literalValue>
        <name>Update Support Dealer2 Email FlgToFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Dealer3_Email_FlgToFalse</fullName>
        <field>Send_Email_Support_Dealer3_Keeper__c</field>
        <literalValue>0</literalValue>
        <name>Update Support Dealer3 Email FlgToFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_workflow_order</fullName>
        <field>Workflow_Order__c</field>
        <literalValue>0</literalValue>
        <name>update workflow order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>waiting_for_Final_Approval</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Change Status to &apos;Waiting for final appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case 48%2672H Check Notification</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Repeat_Complaint_Times__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreateByCAC__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>Yes,No</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_CheckFlag_After_72H</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_CheckFlag_After_48H</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification JP</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated email gets sent to the case owners 15 mins before the deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_need_to_be_handle_before_deadline</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.X15_Minutes_Before_Deadline__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification KR</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 24 hours before the deadline</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_need_to_be_handle_before_deadline_KR</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case handling level Assignment Notification to Dealer</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Korea</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <description>When RO change handling level to Dealer, send a email to Dealer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case handling level Assignment Notification to RO</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND (5 OR 6 OR 7)</booleanFilter>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Regional Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Central Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>equals</operation>
            <value>Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Dealer Community User</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Dealer Delegate Admin</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <description>When RO change handling level to RO, send a email to RO.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Case Origin To BMBS CAC</fullName>
        <actions>
            <name>Update_Case_Origin_To_CAC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Complaint_Creator_Department_toCA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>CAC</value>
        </criteriaItems>
        <description>When a MB Complaint created by CAC, Update Complaint Creator Department To CAC.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Case Origin To Central CAC</fullName>
        <actions>
            <name>Update_Case_Origin_To_CAC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Complaint_Creator_Department_toCA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>CAC</value>
        </criteriaItems>
        <description>When a MB Complaint created by CAC, Update Complaint Creator Department To CAC.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Complaint Creator Department To Dealer</fullName>
        <actions>
            <name>Update_Creator_Department_to_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <description>When a MB Complaint created by Dealer, Update Complaint Creator Department To Dealer.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Update Complaint Creator Department To RO%2FCO</fullName>
        <actions>
            <name>Update_Creator_Department_To_ROCO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Korea</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <description>When a MB Complaint created by RO/CO,  Update Complaint Creator Department To RO/CO.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Complaint Update Notification</fullName>
        <actions>
            <name>Complaint_Update_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Case team memeber update a case on specific fields, system will send an email to case team members.</description>
        <formula>AND( OR( $Profile.Name == &apos;BMBS Regional CRM Manager&apos;, $Profile.Name == &apos;BMBS Service Technical Manager&apos;, $Profile.Name ==&apos;BMBS PL/WL Manager&apos;, CONTAINS($Profile.Name, &apos;Dealer&apos;)  ), AND(Urgent__c, OR(  ISCHANGED(OwnerId),   ISCHANGED(Follow_Up_Inquiry__c),  ISCHANGED(Complaint_Date__c),  ISCHANGED(Case_Involvement_MPC__c),  ISCHANGED(Case_Source__c),  ISCHANGED(ParentId),  ISCHANGED(AccountId),  ISCHANGED(Region__c),  ISCHANGED(Handling_Level__c),   ISCHANGED(Data_Source__c),  ISCHANGED(Case_Department__c),  ISCHANGED(Data_Subsource__c),  ISCHANGED(Case_Status__c),  ISCHANGED(Progress_Status__c),  ISCHANGED(Escalate_Date_to_RO__c),  ISCHANGED(Escalate_Date_to_CO__c),  ISCHANGED(Suspended_Date__c),  ISCHANGED(Suspended_Reason__c),  ISCHANGED(Overdue__c),  ISCHANGED(Overdue_Reason__c),  ISCHANGED(X1st_FP_Position_Release_Date__c),  ISCHANGED(X2nd_FP_Position_Release_Date__c),  ISCHANGED(SFPositionDate__c),  ISCHANGED(FFPositionDate__c),  ISCHANGED(Release_Date__c),  ISCHANGED(Resolved_Date__c),  ISCHANGED(Contact_Person__c),  ISCHANGED(Perferred_Contact_Number__c),  ISCHANGED(Contact_Person_Tele__c),  ISCHANGED(Perferred_Contact_Email__c),  ISCHANGED(Customer_Background_Info__c),  ISCHANGED(Government_Background__c),  ISCHANGED(Car_Owner__c),  ISCHANGED(Gender__c),  ISCHANGED(Occupation__c),  ISCHANGED(Title__c),  ISCHANGED(Owner_Tele__c),  ISCHANGED(Date_of_Birth__c),  ISCHANGED(Address__c),  ISCHANGED(Licence_Number__c),  ISCHANGED(Other_Brand__c),  ISCHANGED(Owned_MB_Vehicle__c),  ISCHANGED(Vehicle_In_Workshop__c),  ISCHANGED(Dealer_Provides_Transport__c),  ISCHANGED(Customer_Requests_Transport__c),  ISCHANGED(Selling_Dealer__c),  ISCHANGED(Order_No__c),  ISCHANGED(Last_Known_Sales_Person__c),  ISCHANGED(Date_of_Warranty_Expiry__c),  ISCHANGED(Last_Known_Mileage__c),  ISCHANGED(Date_of_1st_Registration__c),  ISCHANGED(US_VIN__c),  ISCHANGED(EU_VIN__c),  ISCHANGED(Defective_Item__c),  ISCHANGED(Defective_SubItem__c),  ISCHANGED(Car_Type__c),  ISCHANGED(Vehicle_Source__c),  ISCHANGED(Vehicle_Model__c),  ISCHANGED(Vehicle_Brand__c),  ISCHANGED(Engine_Number__c),  ISCHANGED(Vehicle_Class__c),  ISCHANGED(Special_Goodwill__c),  ISCHANGED(Goodwill_Category__c),  ISCHANGED(Goodwill_Details__c),  ISCHANGED(Goodwill_Cost__c),  ISCHANGED(Case_Dealer__c),  ISCHANGED(Dealer_Case_Category__c),  ISCHANGED(Dealer_Case_Type__c), ISCHANGED(Subject),   ISCHANGED( Ref_No_Central__c ),   ISCHANGED( Ref_No_Regional__c ),   ISCHANGED(  PR_Comment_Central_Internal__c ),   ISCHANGED( MPC_Internal_Notes__c ),   ISCHANGED(Dealer_Case_SubType__c)  )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Retail Campaign Case Notification for Dealer</fullName>
        <actions>
            <name>Email_to_Dealer_when_Retail_Campaign_Case_is_assigned</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Retail_Case_Notice_Dealer_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notification to new User When add attachment</fullName>
        <actions>
            <name>Complaint_Update_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update_workflow_order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Workflow_Order__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Gate Keeper</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Gate_Keeper</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.SendEmailToGateKeeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Gate Keeper For Support Dealer1</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper_For_Support_Dealer1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Support_Dealer1_Email_FlgToFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Send_Email_Support_Dealer1_Keeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Gate Keeper For Support Dealer2</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper_For_Support_Dealer2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Support_Dealer2_Email_FlgToFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Send_Email_Support_Dealer2_Keeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Gate Keeper For Support Dealer3</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper_For_Support_Dealer3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Support_Dealer3_Email_FlgToFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Send_Email_Support_Dealer3_Keeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Set Case to Overdue</fullName>
        <actions>
            <name>Update_Overdue_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
