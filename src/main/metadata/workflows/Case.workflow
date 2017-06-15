<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <template>unfiled$public/Change_Complaint_Assignment_To_Dealer_GateKeeper_Notification</template>
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
        <fullName>Approval_Update</fullName>
        <field>Status</field>
        <literalValue>Final approval done</literalValue>
        <name>Approval Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
        <literalValue>Requires Manager Review</literalValue>
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
        <fullName>Case Deadline Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.DeadLine__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
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
            <value>B</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Yellow = 3</value>
        </criteriaItems>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 50 hours before the deadline,If the case Priority is B and Yellow = 3.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_need_to_be_handle_before_deadline_KR</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>-50</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification KR After 240 hours</fullName>
        <active>false</active>
        <description>When deadline date and time has been set on the case then an automated mail gets sent to the case owners 240 hours after the deadline,If the case Priority is C and Green &lt;= 2.</description>
        <formula>IF(AND(NOT(ISNULL(DeadLine__c)), MD__c=&apos;KR&apos;,NOT(ISPICKVAL( Status , &apos;Closed&apos;)),OR(ISPICKVAL(Priority, &apos;C&apos;),ISPICKVAL( Priority , &apos;Green &lt;= 2&apos;)), CreatedBy.Profile.Name &lt;&gt; &apos;Dealer Community User&apos;), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Deadline_Notification_KR_after_240_Hours</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>240</timeLength>
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
        <formula>ISCHANGED(OwnerId) &amp;&amp; MD__c = &apos;KR&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case escalation_Inquiry after 120 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
        <active>true</active>
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
        <active>true</active>
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
        <active>true</active>
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
        <fullName>Case escalation_Inquiry after 72 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
        <fullName>Case escalation_MB Complaint after 144 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
        <fullName>Case escalation_MB Complaint after 24 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
        <fullName>Case escalation_MB Complaint after 72 hours_TH</fullName>
        <actions>
            <name>Case_owner_manager_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
            <value>TH</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_escalation_for_MB_Complaint_TH</name>
                <type>Alert</type>
            </actions>
            <timeLength>72</timeLength>
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
        <booleanFilter>1 AND( 2 or 3) AND 4 AND 5 AND 6</booleanFilter>
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
        <booleanFilter>(1 AND 2 AND 3) OR (1 AND 2 AND 4 AND 5)</booleanFilter>
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
            <operation>equals</operation>
            <value>Thailand System Admin</value>
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
        <booleanFilter>1 AND (2 OR 3 OR 4) AND (5 OR 6)</booleanFilter>
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
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Thailand</value>
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
        <description>When a MB Complaint created by RO/CO,  Update Complaint Creator Department To RO/CO.</description>
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
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.SendEmailToGateKeeper__c</field>
            <operation>equals</operation>
            <value>True</value>
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
        <description>This WF is created for Sending email to gate keeper for Thailand users</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Case to Overdue</fullName>
        <actions>
            <name>Update_Overdue_to_Yes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
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
        <workflowTimeTriggers>
            <offsetFromField>Case.DeadLine__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Case status to %22Waiting for Response approval%22</fullName>
        <actions>
            <name>Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Owner:Queue.QueueName  &lt;&gt;  &apos;Supervisor Team B&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
