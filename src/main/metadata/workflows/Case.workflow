<?xml version="1.0" encoding="UTF-8"?>  
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata"> 
	<alerts>
        <fullName>Escalate_Case_to_Case_owner_Manager</fullName>
        <description>Escalate Case to Case owner Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_handing_level_email_to_Notification_MY</fullName>
        <description>Case handing level email Notification to Dealer MY</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Handling_level_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Dealer_Manager_Notification_KR_after_24_Hour</fullName>
        <description>Case Deadline Dealer Manager Notification KR after 24 Hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/X24_hours_before_deadline</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Dealer_Manager_Notification_KR_after_72_Hour</fullName>
        <description>Case Deadline : Dealer Manager Notification KR after 72 Hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Dealer_Notification_KR_before_24_Hour</fullName>
        <description>Case Deadline Dealer Notification KR before 24 Hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/X24_hours_before_deadline</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Notification_168_Hours_Before_Case_DeadLine</fullName>
        <description>168 Hours Before Case: DeadLine</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Notification_17_Hours_Before_Case_DeadLine</fullName>
        <description>17 Hours Before Case: DeadLine</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Notification_KR_after_240_Hours</fullName>
        <description>Case Deadline Notification KR after 240 Hours</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Notification_KR_after_24_Hour</fullName>
        <description>Case Deadline Notification KR after 24 Hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Deadline_Notification_KR_after_72_Hour</fullName>
        <description>Case Deadline Notification KR after 72 Hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_Inquiry_after_48_hours_MY</fullName>
        <description>Case escalation_Inquiry after 48 hours_MY</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_48_hours_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_Inquiry_after_72_hours_MY</fullName>
        <description>Case escalation_Inquiry after 72 hours_MY</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_72_hours_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_MB_Complaint_after_120_hours_MY</fullName>
        <description>Case escalation_MB Complaint after 120 hours_MY</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_120_hours_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_MB_Complaint_after_24_hours_MY</fullName>
        <description>Case escalation_MB Complaint after 24 hours_MY</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_24_hours_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_for_Inquiry_after_120_hours_MY</fullName>
        <description>Case escalation for Inquiry after 120 hours_MY</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_120_hours_MY</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_for_Inquiry_after_24_hours_TH</fullName>
        <description>Case escalation for Inquiry_TH</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_Inquiry_after_24_hours_TH</template>
    </alerts>
    <alerts>
        <fullName>Case_escalation_for_MB_Complaint_TH</fullName>
        <description>Case escalation for MB Complaint_TH</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_escalation_MB_Complaint_after_72_hours_TH</template>
    </alerts>
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
        <fullName>Case_re_assigned_to_Supervisor_Team_B</fullName>
        <description>Case re-assigned to Supervisor Team B</description>
        <protected>false</protected>
        <recipients>
            <recipient>Supervisor_Team_B</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseAssignmentNotification</template>
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
        <fullName>Deadline_Notification_to_Owner</fullName>
        <description>Deadline Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification_TH</template>
    </alerts>
    <alerts>
        <fullName>Deadline_Notification_to_Owner1</fullName>
        <description>Deadline Notification to Owner1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification_TH</template>
    </alerts>
    <alerts>
        <fullName>Deadline_Notification_to_Owner_before_1_hour</fullName>
        <description>Deadline Notification to Owner before 1 hour</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification_MY</template>
    </alerts>
    <alerts>
        <fullName>Deadline_Notification_to_Owner_before_1_hourTH</fullName>
        <description>Deadline Notification to Owner before 1 hourTH</description>
        <protected>false</protected>
		 <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification_TH_2</template>
    </alerts>
    <alerts>
        <fullName>Deadline_Notification_to_Owner_before_1_hour_TH</fullName>
        <description>Deadline Notification to Owner before 1 hour TH</description>
        <protected>false</protected>
		 <recipients>
            <field>Case_Owner_manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification_TH_3</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Dealer_Gatekeeper_Case</fullName>
        <description>Email to Dealer Gatekeeper Case</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/Assign_to_Dealer_Gatekeeper_Case</template>
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
        <fullName>Send_Email_To_Case_Owner</fullName>
        <description>Send Email To Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/Case_owner_is_updated</template>
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
        <fullName>Send_Email_to_Gate_Keeper_2_TH</fullName>
        <description>Send Email to Gate Keeper_2_TH</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Assignment_To_Dealer_GateKeeper_Notification2</template>
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
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper_TH</fullName>
        <description>Send Email to Gate Keeper_TH</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Complaint_Assignment_To_Dealer_GateKeeper_Notification2</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Gate_Keeper_TH_Dealer</fullName>
        <description>Send Email to Gate Keeper_TH_Dealer</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_to_Gate_Keeper_TH_Dealer_user</template>
    </alerts>
    <alerts>
        <fullName>ase_Deadline_Dealer_Manager_Notification_KR_after_240_Hours</fullName>
        <description>ase Deadline : Dealer Manager Notification KR after 240 Hours</description>
        <protected>false</protected>
        <recipients>
            <recipient>CommunityAccountPartnerExecutive</recipient>
            <type>portalRole</type>
        </recipients>
        <recipients>
            <recipient>CommunityAccountPartnerManager</recipient>
            <type>portalRole</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Deadline_Notification</template>
    </alerts>
	<fieldUpdates>
        <fullName>Update_Creator_Department_to_Dealer_MY</fullName>
        <field>Complaint_Creator_Department__c</field>
        <literalValue>Dealer</literalValue>
        <name>Update Creator Department to Dealer MY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Update</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Approval Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_EuroVIN</fullName>
        <field>EuroVIN__c</field>
        <formula>Vehicle__r.EuroVIN__c</formula>
        <name>Update EuroVIN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_Supervisor_Team_B</fullName>
        <field>OwnerId</field>
        <lookupValue>Supervisor_Team_B</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to Supervisor Team B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_owner_manager_update</fullName>
        <field>Case_Owner_manager__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>Case owner manager update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>Change_Case_Owner_to_CCC_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>MBF_Customer_Care_CCC_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Case Owner to CCC Team</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
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
        <fullName>Final_Approval</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_1</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_10</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_11</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 11</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_12</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_13</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 13</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_14</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 14</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_15</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 15</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_16</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 16</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_2</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_3</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_4</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_5</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_6</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_7</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_8</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_9</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Final Approval 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_10</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_11</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 11</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_12</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_13</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 13</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_16</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 16</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_17</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 17</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_2</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_3</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_4</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_5</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_6</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_7</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_8</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected_9</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Final Rejected 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Update</fullName>
        <field>Status</field>
        <literalValue>Final approval rejected</literalValue>
        <name>Rejection Update</name>
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
        <fullName>Status</fullName>
        <field>Status</field>
        <literalValue>Waiting for Response approval</literalValue>
        <name>Status</name>
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
        <fullName>Status_Update</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Status Update</name>
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
        <fullName>UpdateCaseOwner</fullName>
        <description>Update the owner of the case to FS Inquiry Team Queue</description>
        <field>OwnerId</field>
        <lookupValue>FS_Inquiry_Team_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>UpdateCaseOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOwnerManager</fullName>
        <field>Case_Owner_manager__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>UpdateOwnerManager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOwnerManager1</fullName>
        <field>Case_Owner_manager__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>UpdateOwnerManager1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>Update_Creator_Department_To_MBTH</fullName>
        <field>Complaint_Creator_Department__c</field>
        <literalValue>MBTH</literalValue>
        <name>Update Creator Department To MBTH</name>
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
        <fullName>Update_Send_email_to_GateKeeper</fullName>
        <field>SendEmailToGateKeeper__c</field>
        <literalValue>1</literalValue>
        <name>Update Send email to GateKeeper</name>
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
        <fullName>Waiting_For_Response</fullName>
        <field>Status</field>
        <literalValue>Waiting for Response approval</literalValue>
        <name>Waiting For Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Ap</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Ap</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_App</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_1</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_10</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_11</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 11</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_12</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_13</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 13</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_2</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_3</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_4</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_5</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_6</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_7</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_8</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiting_for_Final_Approval_9</fullName>
        <field>Status</field>
        <literalValue>Waiting for final approval</literalValue>
        <name>Waiting for Final Approval 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Escalate_Date_to_CO_field</fullName>
        <field>Escalate_Date_to_CO__c</field>
        <formula>TODAY()</formula>
        <name>update Escalate Date to CO field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_owner_manager</fullName>
        <field>Case_Owner_manager__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>update owner manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Case handling level Assignment Notification to Dealer_MY</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification_MY</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Gate_Keeper</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When RO change handling level to Dealer, send a email to Dealer for Malaysia users</description>
        <formula>AND(NOT(ISPICKVAL($Profile.UserType, &quot;PowerPartner&quot;)),  $Permission.MYGeneric, ISPICKVAL(Handling_Level__c, &quot;Dealer&quot;),  MD__c = &quot;MY&quot;,  SendEmailToGateKeeper__c = true,  OR(RecordType.Name = &quot;MB Complaint&quot;, RecordType.Name = &quot;Inquiry&quot;), ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Auto Populate Eurovin TH</fullName>
        <actions>
            <name>Update_EuroVIN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Vehicle__c  &lt;&gt; null&amp;&amp; MD__c =&apos;TH&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Deadline %3A Dealer Notification KR after 72 Hour</fullName>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 50 hours after the deadline,If the case Priority is B and Yellow = 3.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL( Status , &apos;Closed&apos;)),OR(ISPICKVAL(Priority, &apos;B&apos;),ISPICKVAL( Priority , &apos;Yellow = 3&apos;)), CreatedBy.Profile.Name = &apos;Dealer Community User&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Dealer_Manager_Notification_KR_after_72_Hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline %3ADealer Notification KR Before 24 Hours</fullName>
        <active>true</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 24 hours before  the deadline.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL(Status,&apos;Closed&apos;))), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Dealer_Notification_KR_before_24_Hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-24</timeLength>
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
        <fullName>Case Deadline Notification KR after 24 Hours</fullName>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 50 hours after the deadline,If the case Priority is B and Yellow = 3.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL( Status , &apos;Closed&apos;)),OR(ISPICKVAL(Priority, &apos;A&apos;),ISPICKVAL( Priority , &apos;Red &gt;= 4&apos;)), CreatedBy.Profile.Name &lt;&gt; &apos;Dealer Community User&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Notification_KR_after_24_Hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification KR after 72 Hour</fullName>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 50 hours after the deadline,If the case Priority is B and Yellow = 3.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL( Status , &apos;Closed&apos;)),OR(ISPICKVAL(Priority, &apos;B&apos;),ISPICKVAL( Priority , &apos;Yellow = 3&apos;)), CreatedBy.Profile.Name &lt;&gt; &apos;Dealer Community User&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Notification_KR_after_72_Hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification KR before 168 hours</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>C</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Green &lt;= 2</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 168 hours before the deadline,If the case Priority is C and Green &lt;= 2.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Notification_168_Hours_Before_Case_DeadLine</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-168</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification KR before 17 hours</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Red &gt;= 4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 17 hours before the deadline,If the Priority is Red &gt;= 4.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Notification_17_Hours_Before_Case_DeadLine</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-17</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated email gets sent to the case owners an hour before the deadline and will be escalated to the case owner&apos;s manager after it surpasses the deadline.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Escalate_Case_to_Case_owner_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deadline_Notification_to_Owner_before_1_hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification TH</fullName>
		 <actions>
            <name>UpdateOwnerManager1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated email gets sent to the case owners</description>
        <formula>AND( 
     MD__c = &apos;TH&apos;,
     ISPICKVAL( Owner:User.UserType,&apos;Standard&apos;),
     NOT( ISNULL(DeadLine__c  ) ),
     NOT( ISPICKVAL( Status , &apos;Closed&apos;) ) ,
    OR(
       RecordType.Name=&apos;Inquiry&apos;,         
       RecordType.Name=&apos;MB Complaint&apos;
      ) 
 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deadline_Notification_to_Owner_before_1_hourTH</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification TH 2 - Dealer</fullName>
		 <actions>
            <name>UpdateOwnerManager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated email gets sent to the case owners</description>
        <formula>AND( 
     MD__c = &apos;TH&apos;,
     ISPICKVAL( Owner:User.UserType,&apos;PowerPartner&apos;),
     NOT( ISNULL(DeadLine__c  ) ),
     NOT( ISPICKVAL( Status , &apos;Closed&apos;) ) ,
    OR(
       RecordType.Name=&apos;Inquiry&apos;,         
       RecordType.Name=&apos;MB Complaint&apos;
      ) 
 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deadline_Notification_to_Owner_before_1_hour_TH</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification TH1</fullName>
        <actions>
            <name>Deadline_Notification_to_Owner1</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated email gets sent to the case owners</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline%3A Dealer Notification KR After 240 hours</fullName>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 240 hours after the deadline,If the case Priority is C and Green &lt;= 2.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL( Status , &apos;Closed&apos;)),OR(ISPICKVAL(Priority, &apos;C&apos;),ISPICKVAL( Priority , &apos;Green &lt;= 2&apos;)), CreatedBy.Profile.Name = &apos;Dealer Community User&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ase_Deadline_Dealer_Manager_Notification_KR_after_240_Hours</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>240</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Email To Dealer GateKeeper</fullName>
        <actions>
            <name>Email_to_Dealer_Gatekeeper_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This flow is used to send email to dealer gatekeper. This is on case object when dealer account associated with the case and that dealers account contact (gate keeper) becomes the new owner of the case.</description>
        <formula>NOT(ISNULL(Case_Dealer__c))  &amp;&amp;  ISCHANGED(Case_Dealer__c) &amp;&amp;  PRIORVALUE(OwnerId) != OwnerId &amp;&amp; MD__c == &apos;KR&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Owner Changed</fullName>
        <actions>
            <name>Send_Email_To_Case_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If Case Owner changed, email need to send to case owner.</description>
        <formula>ISCHANGED(OwnerId) &amp;&amp; MD__c = &apos;KR&apos; &amp;&amp; NOT(ISCHANGED(Case_Dealer__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 120 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>C</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_120_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 120 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>C</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_24_hours_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 24 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>A</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_24_hours_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 240 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>D</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_24_hours_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>240</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 360 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>E</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_24_hours_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>360</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 48 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>A</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This is used to send email notification after 48 hours for MY</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_Inquiry_after_48_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 72 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>B</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_Inquiry_after_72_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 72 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>B</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_Inquiry_after_24_hours_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 120 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Green &lt;= 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
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
        <description>This is used for MY market to escalate case after 120 hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_MB_Complaint_after_120_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 144 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Green &lt;= 2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_MB_Complaint_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>144</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 24 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Red &gt;= 4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
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
        <description>This is used for MY market to escalate case after 24 hours</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_MB_Complaint_after_24_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 24 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Red &gt;= 4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_MB_Complaint_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 72 hours_MY</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Yellow = 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_Inquiry_after_72_hours_MY</name>
                <type>Alert</type>
            </actions>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case escalation_MB Complaint after 72 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_MB_Complaint_TH</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case handling level Assignment Notification to Dealer</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
        <fullName>Case handling level Assignment Notification to Dealer_TH</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Gate_Keeper</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND( 2 or 3 or 7) AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Thailand</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SendEmailToGateKeeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Thailand System Admin</value>
        </criteriaItems>
        <description>When RO change handling level to Dealer, send a email to Dealer. for Thailand users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case handling level Assignment Notification to RO</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
        <fullName>Case%3A Update Complaint Creator Department To Dealer</fullName>
        <actions>
            <name>Update_Creator_Department_to_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR ((1 OR 6) AND 5  AND 4)</booleanFilter>
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
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
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
        <booleanFilter>1 AND (2 OR 3 ) AND 4</booleanFilter>
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
        <fullName>Update Complaint Creator Department To RO%2FCO MY</fullName>
        <actions>
            <name>Update_Creator_Department_To_ROCO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.UserType</field>
            <operation>notEqual</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Market__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <description>When a MB Complaint created by WholeSaler, Update Complaint Creator Department To RO/CO.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case-Set overdue as Yes</fullName>
        <actions>
            <name>Update_Overdue_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the Overdue as Yes When the Case deadline has missed out</description>
        <formula>IF(DeadLine__c&lt;Now(), true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Inquiry Share to Regional Office</fullName>
        <actions>
            <name>Case_re_assigned_to_Supervisor_Team_B</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_to_Supervisor_Team_B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Share_to_Regional_Office__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
        <fullName>Send Email to Gate Keeper_TH</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper_TH</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Email_to_Gate_Keeper</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF is created for Sending email to gate keeper for Thailand wholesale users</description>
        <formula>AND( MD__c = &apos;TH&apos;, ISPICKVAL( Owner:User.UserType,&apos;Standard&apos;), OR( AND( ISNEW(), NOT(ISBLANK(Case_Dealer__c )) ), AND( ISCHANGED(Case_Dealer__c ), NOT(ISBLANK(Case_Dealer__c )) ) ,ischanged(OwnerId)), OR(RecordType.Name=&apos;Inquiry&apos;, RecordType.Name=&apos;MB Complaint&apos; ), Case_Creator__r.Id &lt;&gt; OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Gate Keeper_TH_2</fullName>
        <actions>
            <name>Send_Email_to_Gate_Keeper_TH_Dealer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This WF is created for Sending email to gate keeper for Thailand dealer users.</description>
        <formula>AND( MD__c = &apos;TH&apos;, ISPICKVAL( Owner:User.UserType,&apos;PowerPartner&apos;), OR( AND( ISNEW(), NOT(ISBLANK(Case_Dealer__c )) ), AND( ISCHANGED(Case_Dealer__c ), NOT(ISBLANK(Case_Dealer__c )) ),ischanged(OwnerId) ), OR(RecordType.Name=&apos;Inquiry&apos;, RecordType.Name=&apos;MB Complaint&apos; ), Case_Creator__r.Id &lt;&gt; OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Share to Regional Office</fullName>
        <actions>
            <name>Change_Case_Owner_to_CCC_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Share_to_Regional_Office__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MBF Contract Closing Case,MBF Finance Inquiry Case,MBF Finance Quotation Case,MBF Customer Request Case</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Dependent</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Share_to_Regional_Office__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Complaint Creator Department To Dealer MY</fullName>
		<actions>
            <name>Update_Creator_Department_to_Dealer_MY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>MY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Dealer</value>
        </criteriaItems>
        <description>When a MB Complaint created by Dealer, Update Complaint Creator Department To Dealer.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
	<rules>
        <fullName>Update Complaint Creator Department To MBTH</fullName>
        <actions>
            <name>Update_Creator_Department_To_MBTH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Thailand</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notContain</operation>
            <value>Dealer</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Escalate Date to CO field</fullName>
        <actions>
            <name>update_Escalate_Date_to_CO_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId) &amp;&amp; MD__c = &apos;KR&apos; &amp;&amp; Owner:User.Profile.Name!=&apos;Korea Call Center&apos; &amp;&amp; (CONTAINS( Owner:User.Profile.Name,&apos;Korea&apos;)||Owner:User.Profile.Name==&apos;MBK Support Profile&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCaseOwnerCOS</fullName>
        <actions>
            <name>UpdateCaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the owner of the case coming from COS.</description>
        <formula>!ISNULL( COS_Ticket_Number__c )&amp;&amp;!ISBLANK( COS_Ticket_Number__c )&amp;&amp;ISPICKVAL(Market__c, &apos;TH&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
