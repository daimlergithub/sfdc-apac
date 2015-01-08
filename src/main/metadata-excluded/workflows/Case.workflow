<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>After_7_days_the_Progress_is_changed_to_1st_FP_Position_Released_or_2nd_FP_Posit</fullName>
        <description>After 7 days the Progress is changed to &quot;1st FP Position Released&quot; or &quot;2nd FP Position Released&quot;, the system will send an notify email to Dealer User.</description>
        <protected>false</protected>
        <recipients>
            <field>Previous_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/To_Dealer_User_for_Close_Complaint</template>
    </alerts>
    <alerts>
        <fullName>CAC_After_sales_Complaint_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>CAC After-sales Complaint  (MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CAC_Pre_sales_Complaint_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <ccEmails>jiao.deng@daimler.com</ccEmails>
        <ccEmails>shuoyan.yao@daimler.com</ccEmails>
        <description>CAC Pre-sales Complaint (MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CAC_Pre_sales_Complaint_MBCL_case_AMG</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <ccEmails>jiao.deng@daimler.com</ccEmails>
        <ccEmails>jens.fischmann@daimler.com</ccEmails>
        <description>CAC Pre-sales Complaint (MBCL case)（AMG）</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CAC_or_smart_Finance_Complaint</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>CAC or smart Finance Complaint</description>
        <protected>false</protected>
        <recipients>
            <field>MBAFC_Team__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Finance_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CAC_or_smart_PR_Complaint_East</fullName>
        <ccEmails>juan.zhou@daimler.com;</ccEmails>
        <ccEmails>weili.su@daimler.com;</ccEmails>
        <ccEmails>customercare_cn@daimler.com;</ccEmails>
        <description>CAC or smart PR  Complaint East</description>
        <protected>false</protected>
        <recipients>
            <recipient>aiqi.shen@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_PR_Complaint_Ad_hoc_Email_Template_PR</template>
    </alerts>
    <alerts>
        <fullName>CAC_or_smart_PR_Complaint_North</fullName>
        <ccEmails>juan.zhou@daimler.com;</ccEmails>
        <ccEmails>weili.su@daimler.com;</ccEmails>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>CAC or smart PR Complaint North</description>
        <protected>false</protected>
        <recipients>
            <recipient>huimin.guo@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xiaoju.zhang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_PR_Complaint_Ad_hoc_Email_Template_PR</template>
    </alerts>
    <alerts>
        <fullName>CAC_or_smart_PR_Complaint_South</fullName>
        <ccEmails>juan.zhou@daimler.com;</ccEmails>
        <ccEmails>weili.su@daimler.com;</ccEmails>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>CAC or smart PR Complaint South</description>
        <protected>false</protected>
        <recipients>
            <field>customercare_cn__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>xunlei.wu1@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_PR_Complaint_Ad_hoc_Email_Template_PR</template>
    </alerts>
    <alerts>
        <fullName>CAC_or_smart_PR_Complaint_West</fullName>
        <ccEmails>juan.zhou@daimler.com;</ccEmails>
        <ccEmails>weili.su@daimler.com;</ccEmails>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>CAC or smart PR Complaint West</description>
        <protected>false</protected>
        <recipients>
            <recipient>feifei.wang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_PR_Complaint_Ad_hoc_Email_Template_PR</template>
    </alerts>
    <alerts>
        <fullName>Case_Asssignment_Notification_7_days</fullName>
        <description>Case didn&apos;t follow up in last 24 hours</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Escalation_Notification_to_Central_Q</fullName>
        <description>Case Escalation Notification to Central Q</description>
        <protected>false</protected>
        <recipients>
            <recipient>Service_Technical_Manager_E</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Service_Technical_Manager_N</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Service_Technical_Manager_S</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Service_Technical_Manager_W</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Escalation_Notification_to_Region_East_Q</fullName>
        <description>Case Escalation Notification to Region East Q</description>
        <protected>false</protected>
        <recipients>
            <recipient>jinwen.wang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pei.lin@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>weiying.zhu@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zheji.you@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Escalation_Notification_to_Region_North_Q</fullName>
        <ccEmails>regionalcrmmgrN@test.com</ccEmails>
        <description>Case Escalation Notification to Region North Q</description>
        <protected>false</protected>
        <recipients>
            <recipient>fengjun.gao@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yanting.shen@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yujing.he@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Escalation_Notification_to_Region_South_Q</fullName>
        <ccEmails>REGIONALCRMMGRS@TEST.COM</ccEmails>
        <description>Case Escalation Notification to Region South Q</description>
        <protected>false</protected>
        <recipients>
            <recipient>hongmei.liu@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>qiwen.li@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wenjing.huang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zhaoxi.he@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Escalation_Notification_to_Region_West_Q</fullName>
        <description>Case Escalation Notification to Region West Q</description>
        <protected>false</protected>
        <recipients>
            <recipient>deli.liao@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yonghua.zeng@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_Escalation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_didn_t_follow_up_in_last_24_hours_regional_east</fullName>
        <description>Case didn&apos;t  follow up in last 24 hours regional east</description>
        <protected>false</protected>
        <recipients>
            <recipient>jun.li@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pei.lin@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zheji.you@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_follow_up_alert</template>
    </alerts>
    <alerts>
        <fullName>Case_didn_t_follow_up_in_last_24_hours_regional_north</fullName>
        <description>Case didn&apos;t  follow up in last 24 hours regional north</description>
        <protected>false</protected>
        <recipients>
            <recipient>fengjun.gao@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yan.z.zhang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yujing.he@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_follow_up_alert</template>
    </alerts>
    <alerts>
        <fullName>Case_didn_t_follow_up_in_last_24_hours_regional_south</fullName>
        <description>Case didn&apos;t  follow up in last 24 hours regional south</description>
        <protected>false</protected>
        <recipients>
            <recipient>hongmei.liu@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>qiwen.li@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wenjing.huang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zhaoxi.he@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_follow_up_alert</template>
    </alerts>
    <alerts>
        <fullName>Case_didn_t_follow_up_in_last_24_hours_south</fullName>
        <description>Case didn&apos;t  follow up in last 24 hours</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_follow_up_alert</template>
    </alerts>
    <alerts>
        <fullName>Case_didn_t_follow_up_in_last_24_hours_west</fullName>
        <description>Case didn&apos;t  follow up in last 24 hours west</description>
        <protected>false</protected>
        <recipients>
            <recipient>deli.liao@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yonghua.zeng@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Case_follow_up_alert</template>
    </alerts>
    <alerts>
        <fullName>Case_handing_level_email_to_Notification</fullName>
        <description>Case handing level email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Previous_Owner__c</field>
            <type>userLookup</type>
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
        <fullName>Email_alert_to_On_site_Manager</fullName>
        <description>Email alert to On-site Manager.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Chrysler_Compalints_created</template>
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
        <fullName>MBDA_Case_Owner_specialist</fullName>
        <description>MBDA Case Owner-specialist</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBDA_Case_Owner_specialist</template>
    </alerts>
    <alerts>
        <fullName>MBDA_Change_Case_Owner</fullName>
        <description>MBDA Change Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MBDA_Case_Change_Owner</template>
    </alerts>
    <alerts>
        <fullName>MB_Vans</fullName>
        <ccEmails>zhiyong.dong@daimler.com</ccEmails>
        <ccEmails>crm.aftersales@fujianbenz.com</ccEmails>
        <description>Send email to MBCL team for MB Vans（进口）</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Maybach_Complaint</fullName>
        <ccEmails>yanting.shen@daimler.com</ccEmails>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>Maybach  Complaint</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>RSA_Complaint</fullName>
        <ccEmails>fanghong.zhao@daimler.com;</ccEmails>
        <ccEmails>quality.control@allianz-assistance.com.cn;</ccEmails>
        <ccEmails>mac_ops_auto_roadsideadmin@allianz-assistance.com.cn;</ccEmails>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>RSA Complaint</description>
        <protected>false</protected>
        <recipients>
            <field>RSA_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_RSA_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_CRM_team_for_CAC_Marketing_Opportunities</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send Ad-hoc email to CRM team for CAC Marketing Opportunities</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_East_team_for_CAC_Network_Development</fullName>
        <ccEmails>ND_Region_East@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <description>Send Ad-hoc email to East team for CAC Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_MBCL_team_for_CAC_or_smart_Finance_Insurance_Enquiry</fullName>
        <ccEmails>mbafc-crm@daimler.com</ccEmails>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send Ad-hoc email to MBCL team for CAC or smart Finance &amp; Insurance Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_MBCL_team_for_RSA_Enquiry</fullName>
        <ccEmails>qing.zhang@daimler.com</ccEmails>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send Ad-hoc email to MBCL team for RSA Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_MBCL_team_for_smart_Marketing_Opportunities</fullName>
        <ccEmails>wei.he@daimler.com</ccEmails>
        <ccEmails>li.xuanping@daimler.com</ccEmails>
        <description>Send Ad-hoc email to MBCL team for smart Marketing Opportunities</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_North_team_for_CAC_Network_Development</fullName>
        <ccEmails>ND_Region_North@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <description>Send Ad-hoc email to North team for CAC Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Ad_hoc_email_to_South_team_for_CAC_Network_Development</fullName>
        <ccEmails>ND_Region_South@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <description>Send Ad-hoc email to South team for CAC Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_CRM_Team_for_CAC_or_smart_Crisis_Management</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send Email to CRM Team for CAC or smart Crisis Management</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PR_Inquiry_HTML</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_CRM_Team_for_CAC_or_smart_PR_Inquiry</fullName>
        <ccEmails>juan.zhou@daimler.com</ccEmails>
        <description>Send Email to CRM Team for CAC or smart PR Inquiry</description>
        <protected>false</protected>
        <recipients>
            <recipient>huimin.guo@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xiaoju.zhang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_CRM_Team_for_CAC_or_smart_PR_Inquiry_East</fullName>
        <ccEmails>xue.zou@daimler.com</ccEmails>
        <description>Send Email to CRM Team for CAC or smart PR Inquiry (East)</description>
        <protected>false</protected>
        <recipients>
            <recipient>xiaoju.zhang@daimler.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_CRM_Team_for_CAC_or_smart_other_urgent_cases</fullName>
        <ccEmails>qing.zhang@daimler.com</ccEmails>
        <ccEmails>bingyi.zhou@daimler.com</ccEmails>
        <description>Send Email to CRM Team for CAC or smart other urgent cases</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PR_Inquiry_HTML</template>
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
        <fullName>Send_email_to_AD_Department_for_Smart_AD_sales</fullName>
        <ccEmails>wei.he@daimler.com</ccEmails>
        <ccEmails>li.xuanping@daimler.com</ccEmails>
        <description>Send email to AD Department for Smart AD sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_AD_sales</fullName>
        <ccEmails>shan.li@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC AD sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_Dealer_Enquiry</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC Dealer Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_Event</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC Event</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_Other_Inquiry</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC Other Inquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_Pre_owned_Trade_in</fullName>
        <ccEmails>ling.xiong@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC Pre-owned / Trade-in</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_CRM_team_for_CAC_or_smart_Owner_Club</fullName>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to CRM team for CAC or smart  Owner Club</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Dealer_for</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>Send email to Dealer for CAC Pre-salesEnquiry (Delear case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Dealer_for_smart_After_sales_Enquiry_Delear_case</fullName>
        <ccEmails>ccm-enquiry-south@daimler.com</ccEmails>
        <ccEmails>ccm-enquiry-east@daimler.com</ccEmails>
        <ccEmails>complaint-enquiry-north@daimler.com</ccEmails>
        <ccEmails>complaint-enquiry-west@daimler.com</ccEmails>
        <description>Send email to Dealer for smart After-sales Enquiry(Delear case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Dealer_for_smart_Pre_sales_Enquiry_Delear_case</fullName>
        <ccEmails>ccm-enquiry-south@daimler.com</ccEmails>
        <ccEmails>ccm-enquiry-east@daimler.com</ccEmails>
        <ccEmails>complaint-enquiry-north@daimler.com</ccEmails>
        <ccEmails>complaint-enquiry-west@daimler.com</ccEmails>
        <description>Send email to Dealer for smart Pre-sales Enquiry (Delear case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_East_team_for_Smart_Network_Development</fullName>
        <ccEmails>ND_Region_East@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <description>Send email to East team for Smart Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_CAC_Pre_sales_Enquiry_MBCL_case</fullName>
        <ccEmails>RO&apos;s_mailbox@com.com</ccEmails>
        <description>Send email to MBCL team CAC Pre-sales Enquiry (MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_Trucks_Enquiry</fullName>
        <ccEmails>Truckservice_china@daimler.com</ccEmails>
        <description>Send email to MBCL team Trucks Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_CAC_After_sales_Enquiry_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>Send email to MBCL team for CAC After-sales Enquiry(MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_CAC_Corporate_sales</fullName>
        <ccEmails>dongyan.zhao@daimler.com</ccEmails>
        <description>Send email to MBCL team for CAC Corporate sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_CAC_Diplomatic_Sales</fullName>
        <ccEmails>jing.wang@daimler.com</ccEmails>
        <description>Send email to MBCL team for CAC Diplomatic Sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_Maybach</fullName>
        <description>Send email to MBCL team for Maybach</description>
        <protected>false</protected>
        <recipients>
            <recipient>wangyihan@mb-cac.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_Smart_Event</fullName>
        <ccEmails>wei.he@daimler.com</ccEmails>
        <ccEmails>li.xuanping@daimler.com</ccEmails>
        <description>Send email to MBCL team for Smart Event</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_Smart_other</fullName>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>tiantian.zhang@daimler.com</ccEmails>
        <ccEmails>fan.liao@daimler.com</ccEmails>
        <ccEmails>fang.li@daimler.com</ccEmails>
        <ccEmails>wei.he@daimler.com</ccEmails>
        <description>Send email to MBCL team for Smart other</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_Vans_Enquiry</fullName>
        <ccEmails>crm.aftersales@fujianbenz.com</ccEmails>
        <description>Send email to MBCL team for Vans Enquiry (国产)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_smart_After_sales_Enquiry_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>Send email to MBCL team for smart After-sales Enquiry(MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_smart_Corporate_sales</fullName>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to MBCL team for smart Corporate sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_smart_Dealer_Enquiry</fullName>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <description>Send email to MBCL team for smart Dealer Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_smart_Diplomatic_Sales</fullName>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <ccEmails>crm_team@daimler.com</ccEmails>
        <description>Send email to MBCL team for smart Diplomatic Sales</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_MBCL_team_for_smart_Pre_sales_Enquiry_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>Send email to MBCL team for smart Pre-sales Enquiry (MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_North_team_for_Smart_Network_Development</fullName>
        <ccEmails>ND_Region_North@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <description>Send email to North team for Smart Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_South_team_for_Smart_Network_Development</fullName>
        <ccEmails>ND_Region_South@daimler.com</ccEmails>
        <ccEmails>dst_nd@mbcl.mercedes-benz.com</ccEmails>
        <ccEmails>fei.f.wang@daimler.com</ccEmails>
        <ccEmails>zhexian.wei@daimler.com</ccEmails>
        <description>Send email to South team for Smart Network Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Inquiry_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Trucks_Complaint</fullName>
        <ccEmails>Truckservice_china@daimler.com</ccEmails>
        <description>Trucks Complaint</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Truck_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Vans_Complaint</fullName>
        <ccEmails>zhiyong.dong@daimler.com</ccEmails>
        <description>Vans Complaint (进口)</description>
        <protected>false</protected>
        <recipients>
            <field>Vans_Fujianbenz_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Import_Vans_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Vans_Complaint_domestic</fullName>
        <ccEmails>crm.aftersales@fujianbenz.com</ccEmails>
        <description>Vans Complaint (国产)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Domestic_Vans_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>smart_After_sales_Complaint_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>smart After-sales Complaint (MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>smart_Pre_sales_Complaint_MBCL_case</fullName>
        <ccEmails>customercare_cn@daimler.com</ccEmails>
        <description>smart Pre-sales Complaint(MBCL case)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CAC_Complaint_Ad_hoc_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_case_owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Import_On_Site_Manager_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change case owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feed_back</fullName>
        <field>Feedback_Required__c</field>
        <literalValue>1</literalValue>
        <name>Feed back Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBAFC_Team_Email</fullName>
        <field>MBAFC_Team__c</field>
        <formula>&apos;mbafc-crm@daimler.com&apos;</formula>
        <name>MBAFC Team Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PR_Email_Update</fullName>
        <description>Update the &apos;Customercare_cn Email&apos; field with the address &apos;customercare_cn@daimler.com&apos;</description>
        <field>customercare_cn__c</field>
        <formula>&apos;customercare_cn@daimler.com&apos;</formula>
        <name>PR Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>UpdateRegionEast</fullName>
        <field>Region__c</field>
        <literalValue>East</literalValue>
        <name>UpdateRegionEast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRegionNorth</fullName>
        <field>Region__c</field>
        <literalValue>North</literalValue>
        <name>UpdateRegionNorth</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRegionSouth</fullName>
        <field>Region__c</field>
        <literalValue>South</literalValue>
        <name>UpdateRegionSouth</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRegionWest</fullName>
        <field>Region__c</field>
        <literalValue>West</literalValue>
        <name>UpdateRegionWest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Update_RSA_Email</fullName>
        <description>Update RSA Email field to &apos;mb_roadside_assistance@daimler.com&apos;.</description>
        <field>RSA_Email__c</field>
        <formula>&apos;mb_roadside_assistance@daimler.com&apos;</formula>
        <name>Update RSA Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Update_Vans_Fujianbenz_Email_field</fullName>
        <description>Receive Email when CAC create a import vans complaint.</description>
        <field>Vans_Fujianbenz_Email__c</field>
        <formula>&apos;crm.aftersales@fujianbenz.com&apos;</formula>
        <name>Update Vans Fujianbenz Email field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X7_Total_Settlement_Amount</fullName>
        <field>Total_Settlement_Amount__c</field>
        <formula>MB_Settlement_Amount__c + Dealer_Settlement_Amount__c + Customer_Settlement_Amount__c</formula>
        <name>Total Settlement Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>escalate_date_to_co_update</fullName>
        <description>when handling level is central office, the escalate date to co is update to current date.</description>
        <field>Escalate_Date_to_CO__c</field>
        <formula>TODAY()</formula>
        <name>escalate date to co update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>escalate_date_to_ro_update</fullName>
        <description>when the handling level is regional office, the escalate date to ro is updaed to now.</description>
        <field>Escalate_Date_to_RO__c</field>
        <formula>TODAY()</formula>
        <name>escalate date to ro update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>transferred_to_Domestic_On_site_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Domestic_On_site_Manager_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>transferred to Domestic On-site Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>transferred_to_Import_On_site_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Import_On_Site_Manager_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>transferred to Import On-site Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_customercare_cn_emial</fullName>
        <description>Update the &apos;Customercare_cn Email&apos; field with the address &apos;xunlei.wu@daimler.com&apos;</description>
        <field>customercare_cn__c</field>
        <formula>&apos;xunlei.wu@daimler.com&apos;</formula>
        <name>update customercare_cn emial field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_field_feed_back_required_to_true</fullName>
        <field>Feedback_Required__c</field>
        <literalValue>1</literalValue>
        <name>update field feed back required to true</name>
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
    <outboundMessages>
        <fullName>Link_Social_Media_Case</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://benz.social360.com.cn/LinkCase.asmx</endpointUrl>
        <fields>AccountId</fields>
        <fields>Id</fields>
        <fields>RecordTypeId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tony.li@bp.daimler.prod</integrationUser>
        <name>Link Social Media Case</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>CAC After-sales Complaint  %28MBCL case%29</fullName>
        <actions>
            <name>CAC_After_sales_Complaint_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC Pre-sales Complaint %28MBCL case%29</fullName>
        <actions>
            <name>CAC_Pre_sales_Complaint_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Pre-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC Pre-sales Complaint %28MBCL case%29%EF%BC%88AMG%EF%BC%89</fullName>
        <actions>
            <name>CAC_Pre_sales_Complaint_MBCL_case_AMG</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>AMG</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Pre-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC or smart Finance Complaint</fullName>
        <actions>
            <name>CAC_or_smart_Finance_Complaint</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MBAFC_Team_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>contains</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Finance service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC or smart PR  Complaint East</fullName>
        <actions>
            <name>CAC_or_smart_PR_Complaint_East</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>send email to east region recipients for CAC or smart PR  Complaint</description>
        <formula>AND(     OR( ISPICKVAL( Vehicle_Brand__c , &apos;smart&apos;) ,       ISPICKVAL(Vehicle_Brand__c, &apos;MB&apos;) ) ,    ISPICKVAL( Case_Type__c , &apos;Public connection&apos;) ,             RecordType.Name =&apos;MB Complaint&apos;,   IF(ISPICKVAL( Case_Dealer__r.Dealer_Region__c , &apos;EAST&apos;), true, Account.Region__c  = &apos;EAST&apos;)    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC or smart PR  Complaint West</fullName>
        <actions>
            <name>CAC_or_smart_PR_Complaint_West</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>send email to west region recipients for CAC or smart PR  Complaint</description>
        <formula>AND( OR( ISPICKVAL( Vehicle_Brand__c , &quot;smart&quot;) , ISPICKVAL(Vehicle_Brand__c, &quot;MB&quot;) ) , ISPICKVAL( Case_Type__c , &quot;Public connection&quot;) , RecordType.Name=&quot;MB Complaint&quot;, ISPICKVAL( Case_Dealer__r.Dealer_Region__c,&quot;WEST&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC or smart PR Complaint North</fullName>
        <actions>
            <name>CAC_or_smart_PR_Complaint_North</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>send email to north region recipients for CAC or smart PR  Complaint</description>
        <formula>AND( OR( ISPICKVAL( Vehicle_Brand__c , &quot;smart&quot;) , ISPICKVAL(Vehicle_Brand__c, &quot;MB&quot;) ) , ISPICKVAL( Case_Type__c , &quot;Public connection&quot;) , RecordType.Name=&quot;MB Complaint&quot;, IF(ISPICKVAL( Case_Dealer__r.Dealer_Region__c,&quot;NORTH&quot;), true, Account.Region__c  = &quot;NORTH&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAC or smart PR Complaint South</fullName>
        <actions>
            <name>CAC_or_smart_PR_Complaint_South</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update_customercare_cn_emial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>send email to south region recipients for CAC or smart PR Complaint</description>
        <formula>AND( OR( ISPICKVAL( Vehicle_Brand__c , &quot;smart&quot;) , ISPICKVAL(Vehicle_Brand__c, &quot;MB&quot;) ) , ISPICKVAL( Case_Type__c , &quot;Public connection&quot;) , RecordType.Name=&quot;MB Complaint&quot;, IF(ISPICKVAL( Case_Dealer__r.Dealer_Region__c,&quot;SOUTH&quot;), true, Account.Region__c  = &quot;SOUTH&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case 48%2672H Check Notification</fullName>
        <active>true</active>
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
        <fullName>Case Assignment Notification To Central Office Queue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Central Office Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Assignment Notification To Regional Office East Queue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office East Queue</value>
        </criteriaItems>
        <description>Notify user if no change owner from Q to user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_didn_t_follow_up_in_last_24_hours_regional_east</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Assignment Notification To Regional Office North Queue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office North Queue</value>
        </criteriaItems>
        <description>Notify user if no change owner from Q to user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_didn_t_follow_up_in_last_24_hours_regional_north</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Assignment Notification To Regional Office South Queue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office South Queue</value>
        </criteriaItems>
        <description>Notify user if no change owner from Q to user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_didn_t_follow_up_in_last_24_hours_regional_south</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Assignment Notification To Regional Office West Queue</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office West Queue</value>
        </criteriaItems>
        <description>Notify user if no change owner from Q to user.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_didn_t_follow_up_in_last_24_hours_west</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Deadline Notification</fullName>
        <active>true</active>
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
        <fullName>Case Escalation Notification to Central Q</fullName>
        <actions>
            <name>Case_Escalation_Notification_to_Central_Q</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Central Office Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation Notification to Region East Q</fullName>
        <actions>
            <name>Case_Escalation_Notification_to_Region_East_Q</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office East Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation Notification to Region North Q</fullName>
        <actions>
            <name>Case_Escalation_Notification_to_Region_North_Q</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office North Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation Notification to Region South Q</fullName>
        <actions>
            <name>Case_Escalation_Notification_to_Region_South_Q</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office South Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation Notification to Region West Q</fullName>
        <actions>
            <name>Case_Escalation_Notification_to_Region_West_Q</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Regional Office West Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case handling level Assignment Notification to Dealer</fullName>
        <actions>
            <name>Case_handing_level_email_to_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>BMBS Regional CRM Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Previous_Owner__c</field>
            <operation>notEqual</operation>
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
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Regional Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>BMBS Service Technical Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Previous_Owner__c</field>
            <operation>notEqual</operation>
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
        <active>true</active>
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
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>BMBS Regional CRM Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>BMBS Service Technical Manager</value>
        </criteriaItems>
        <description>When a MB Complaint created by RO/CO,  Update Complaint Creator Department To RO/CO.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Change MBDA Case Owner</fullName>
        <actions>
            <name>MBDA_Change_Case_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MBDA Complaint,MBDA Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.User_Role__c</field>
            <operation>equals</operation>
            <value>IB_CSR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change MBDA Case Owner To MBDA</fullName>
        <actions>
            <name>MBDA_Case_Owner_specialist</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MBDA Complaint,MBDA Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>MBDA administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check case progress</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Progress_Status__c</field>
            <operation>equals</operation>
            <value>1st Position Released,2nd Final Position Released</value>
        </criteriaItems>
        <description>After 7 days the Progress is changed to &quot;1st FP Position Released&quot; or &quot;2nd FP Position Released&quot;, the system will send an notify email to Dealer User. The email draft content is the following:

由于厂方已给出最终处理意见，请及时汇报此投诉案件最新进展，客户如无进一步投诉请及时关闭此投诉。</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>After_7_days_the_Progress_is_changed_to_1st_FP_Position_Released_or_2nd_FP_Posit</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Release_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Chrysler Complaints</fullName>
        <actions>
            <name>transferred_to_Import_On_site_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Chrysler  Complaint</value>
        </criteriaItems>
        <description>-Case Record Type=Chrysler Complaints.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Chrysler Complaints created</fullName>
        <actions>
            <name>Email_alert_to_On_site_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Chrysler Complaint</value>
        </criteriaItems>
        <description>For Chrysler Complaints created, there will be an email sent to On-site Manager.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Complaint Update Notification</fullName>
        <actions>
            <name>Complaint_Update_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Case team memeber update a case on specific fields, system will send an email to case team members.</description>
        <formula>AND( OR( $Profile.Name == &apos;BMBS Regional CRM Manager&apos;, $Profile.Name == &apos;BMBS Service Technical Manager&apos;, $Profile.Name ==&apos;BMBS PL/WL Manager&apos;, CONTAINS($Profile.Name, &apos;Dealer&apos;)  ), AND(Urgent__c, OR(  ISCHANGED(OwnerId),   ISCHANGED(Follow_Up_Inquiry__c),  ISCHANGED(Complaint_Date__c),  ISCHANGED(Case_Involvement_MPC__c),  ISCHANGED(Case_Source__c),  ISCHANGED(ParentId),  ISCHANGED(AccountId),  ISCHANGED(Region__c),  ISCHANGED(Handling_Level__c),   ISCHANGED(Data_Source__c),  ISCHANGED(Case_Department__c),  ISCHANGED(Data_Subsource__c),  ISCHANGED(Case_Status__c),  ISCHANGED(Progress_Status__c),  ISCHANGED(Escalate_Date_to_RO__c),  ISCHANGED(Escalate_Date_to_CO__c),  ISCHANGED(Suspended_Date__c),  ISCHANGED(Suspended_Reason__c),  ISCHANGED(Overdue__c),  ISCHANGED(Overdue_Reason__c),  ISCHANGED(X1st_FP_Position_Release_Date__c),  ISCHANGED(X2nd_FP_Position_Release_Date__c),  ISCHANGED(SFPositionDate__c),  ISCHANGED(FFPositionDate__c),  ISCHANGED(Release_Date__c),  ISCHANGED(Resolved_Date__c),  ISCHANGED(Contact_Person__c),  ISCHANGED(Perferred_Contact_Number__c),  ISCHANGED(Contact_Person_Tele__c),  ISCHANGED(Perferred_Contact_Email__c),  ISCHANGED(Customer_Background_Info__c),  ISCHANGED(Government_Background__c),  ISCHANGED(Car_Owner__c),  ISCHANGED(Gender__c),  ISCHANGED(Occupation__c),  ISCHANGED(Title__c),  ISCHANGED(Owner_Tele__c),  ISCHANGED(Date_of_Birth__c),  ISCHANGED(Address__c),  ISCHANGED(Licence_Number__c),  ISCHANGED(Other_Brand__c),  ISCHANGED(Owned_MB_Vehicle__c),  ISCHANGED(Vehicle_In_Workshop__c),  ISCHANGED(Dealer_Provides_Transport__c),  ISCHANGED(Customer_Requests_Transport__c),  ISCHANGED(Selling_Dealer__c),  ISCHANGED(Order_No__c),  ISCHANGED(Last_Known_Sales_Person__c),  ISCHANGED(Date_of_Warranty_Expiry__c),  ISCHANGED(Last_Known_Mileage__c),  ISCHANGED(Date_of_1st_Registration__c),  ISCHANGED(US_VIN__c),  ISCHANGED(EU_VIN__c),  ISCHANGED(Defective_Item__c),  ISCHANGED(Defective_SubItem__c),  ISCHANGED(Car_Type__c),  ISCHANGED(Vehicle_Source__c),  ISCHANGED(Vehicle_Model__c),  ISCHANGED(Vehicle_Brand__c),  ISCHANGED(Engine_Number__c),  ISCHANGED(Vehicle_Class__c),  ISCHANGED(Special_Goodwill__c),  ISCHANGED(Goodwill_Category__c),  ISCHANGED(Goodwill_Details__c),  ISCHANGED(Goodwill_Cost__c),  ISCHANGED(Case_Dealer__c),  ISCHANGED(Dealer_Case_Category__c),  ISCHANGED(Dealer_Case_Type__c), ISCHANGED(Subject),   ISCHANGED( Ref_No_Central__c ),   ISCHANGED( Ref_No_Regional__c ),   ISCHANGED(  PR_Comment_MBCL_Internal__c ),   ISCHANGED( MPC_Internal_Notes__c ),   ISCHANGED(Dealer_Case_SubType__c)  )) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalate Date To Co Update</fullName>
        <actions>
            <name>escalate_date_to_co_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Central Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Date_to_CO__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>when the handling level is &quot;central  office&quot;,&quot;escalate date to co&quot;update to current date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalate Date To RO Update</fullName>
        <actions>
            <name>escalate_date_to_ro_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Handling_Level__c</field>
            <operation>equals</operation>
            <value>Regional Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Date_to_RO__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>when the handling level is &quot;regional office&quot;,&quot;escalate date to ro&quot;update to current date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Maybach  Complaint</fullName>
        <actions>
            <name>Maybach_Complaint</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>Maybach</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <description>Hanxue确认，由于业务流程变更不需要给这个团队发邮件了。迈巴赫的车也按正常流程走</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Retail Campaign Case Notification for Dealer</fullName>
        <actions>
            <name>Email_to_Dealer_when_Retail_Campaign_Case_is_assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Retail_Case_Notice_Dealer_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for  smart After-sales Enquiry%28MBCL case%29</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_smart_After_sales_Enquiry_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send email to MBCL team for smart After-sales Enquiry(MBCL case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC AD sales</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_AD_sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Marketing chance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>AD Sale</value>
        </criteriaItems>
        <description>Send email to CRM team for CAC AD sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC After-sales Enquiry%28MBCL case%29</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_CAC_After_sales_Enquiry_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send email to MBCL team for CAC After-sales Enquiry(MBCL case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Corporate sales</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_CAC_Corporate_sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Product information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Corporate-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for  CAC Corporate sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Dealer Enquiry</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_Dealer_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Dealer contact method</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to CRM team for  CAC Dealer Enquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Diplomatic Sales</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_CAC_Diplomatic_Sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Product information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Diplomatic-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for CAC Diplomatic Sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Event</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_Event</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to CRM team for CAC Event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Marketing Opportunities</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_CRM_team_for_CAC_Marketing_Opportunities</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Marketing chance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Marketing Opportunities</value>
        </criteriaItems>
        <description>Send email to CRM team for CAC Marketing Opportunities</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Network Development East</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_East_team_for_CAC_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to North team for CAC Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;MB&apos;),  OR( (Case_Dealer__r.Region__c=&apos;East&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;East&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Network Development North</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_North_team_for_CAC_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to North team for CAC Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;MB&apos;),  OR( (Case_Dealer__r.Region__c=&apos;North&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;North&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Network Development South</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_South_team_for_CAC_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to North team for CAC Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;MB&apos;),  OR( (Case_Dealer__r.Region__c=&apos;South&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;South&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Other Inquiry</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_Other_Inquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Others</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to CRM team for CAC Other Inquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Pre-owned %2F Trade-in</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_Pre_owned_Trade_in</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Second car exchange</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to CRM team for CAC Pre-owned / Trade-in</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Pre-sales Enquiry %28MBCL case%29</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_CAC_Pre_sales_Enquiry_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send email to MBCL team for CAC Pre-sales Enquiry (MBCL case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC Pre-salesEnquiry %28Delear case%29</fullName>
        <actions>
            <name>Send_email_to_Dealer_for</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>Pre-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to Dealer for CAC Pre-salesEnquiry (Delear case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC or smart  Owner Club</fullName>
        <actions>
            <name>Send_email_to_CRM_team_for_CAC_or_smart_Owner_Club</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Club</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart,MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to CRM team CAC or smart  Owner Club</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for CAC or smart Finance %26 Insurance Enquiry</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_MBCL_team_for_CAC_or_smart_Finance_Insurance_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Finance &amp; Insurance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart,MB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL Team for  CAC or smart Finance &amp; Insurance Enquiry based on the criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for MB Vans%EF%BC%88进口%EF%BC%89</fullName>
        <actions>
            <name>MB_Vans</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to MBCL team for MB Vans（进口）</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), ISPICKVAL(Case_Type__c,&apos;Consultanting MBCL microbus&apos;), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Vehicle__r.CBU_CKD__c,&apos;CBU&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Maybach</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_Maybach</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Maybach</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>Maybach</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for Maybach</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for RSA Enquiry</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_MBCL_team_for_RSA_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>RSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL Team for RSA Enquiry based on the criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart AD sales</fullName>
        <actions>
            <name>Send_email_to_AD_Department_for_Smart_AD_sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Marketing chance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>AD Sale</value>
        </criteriaItems>
        <description>Send email to AD Department for Smart AD sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart Event</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_Smart_Event</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for Smart event.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart Network Development East</fullName>
        <actions>
            <name>Send_email_to_East_team_for_Smart_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to East team for Smart Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;Smart&apos;),  OR( (Case_Dealer__r.Region__c=&apos;East&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;East&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart Network Development North</fullName>
        <actions>
            <name>Send_email_to_North_team_for_Smart_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to North team for Smart Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;Smart&apos;),  OR( (Case_Dealer__r.Region__c=&apos;North&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;North&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart Network Development South</fullName>
        <actions>
            <name>Send_email_to_South_team_for_Smart_Network_Development</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to South team for Smart Network Development</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Case_Type__c,&apos;Network development department&apos;), ISPICKVAL(Vehicle_Brand__c,&apos;Smart&apos;),  OR( (Case_Dealer__r.Region__c=&apos;South&apos;), AND((Case_Dealer__r.Region__c=NULL), (Account.Region__c=&apos;South&apos;)) ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Smart other</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_Smart_other</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Others</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for Smart other</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Trucks Enquiry</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_Trucks_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Consultant MBCL truck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for Trucks Enquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for Vans Enquiry %28国产%29</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_Vans_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to MBCL team for Vans Enquiry (国产)</description>
        <formula>AND( (Feedback_Required__c=True), (TL_Reviewed__c =True), ISPICKVAL(Case_Type__c,&apos;Consultanting MBCL microbus&apos;), (RecordType.DeveloperName=&apos;Inquiry&apos;), ISPICKVAL(Vehicle__r.CBU_CKD__c,&apos;CKD&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart After-sales Enquiry%28Delear case%29</fullName>
        <actions>
            <name>Send_email_to_Dealer_for_smart_After_sales_Enquiry_Delear_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to Dealer for smart After-sales Enquiry(Delear case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Corporate sales</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_smart_Corporate_sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Product information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Corporate-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for smart Corporate sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Dealer Enquiry</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_smart_Dealer_Enquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Dealer contact method</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for smart Dealer Enquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Diplomatic Sales</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_smart_Diplomatic_Sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Product information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Diplomatic-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to MBCL team for smart Diplomatic Sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Marketing Opportunities</fullName>
        <actions>
            <name>Send_Ad_hoc_email_to_MBCL_team_for_smart_Marketing_Opportunities</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Marketing chance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Marketing Opportunities</value>
        </criteriaItems>
        <description>Send email to MBCL Team for smart Marketing Opportunities</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Pre-sales Enquiry %28Delear case%29</fullName>
        <actions>
            <name>Send_email_to_Dealer_for_smart_Pre_sales_Enquiry_Delear_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <description>Send email to Dealer for smart Pre-sales Enquiry (Delear case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Next Working Day Ad-hoc email for smart Pre-sales Enquiry %28MBCL case%29</fullName>
        <actions>
            <name>Send_email_to_MBCL_team_for_smart_Pre_sales_Enquiry_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TL_Reviewed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Equal_to_Case_Dealer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send email to MBCL team for smart Pre-sales Enquiry (MBCL case)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <active>true</active>
        <criteriaItems>
            <field>Case.Workflow_Order__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RSA Complaint</fullName>
        <actions>
            <name>RSA_Complaint</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>contains</operation>
            <value>RSA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Real time send Ad-hoc email for CAC or smart Crisis Management</fullName>
        <actions>
            <name>Send_Email_to_CRM_Team_for_CAC_or_smart_Crisis_Management</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Marketing crisis</value>
        </criteriaItems>
        <description>Send email to CRM Team based on the criteria CAC or smart Crisis Management</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Real time send Ad-hoc email for CAC or smart PR  Inquiry</fullName>
        <actions>
            <name>Send_Email_to_CRM_Team_for_CAC_or_smart_PR_Inquiry</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Public connection</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>North,West,South</value>
        </criteriaItems>
        <description>send email to PR Team based on the criteria  CAC or smart PR  Inquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Real time send Ad-hoc email for CAC or smart PR  Inquiry %28East%29</fullName>
        <actions>
            <name>Send_Email_to_CRM_Team_for_CAC_or_smart_PR_Inquiry_East</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Public connection</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>East</value>
        </criteriaItems>
        <description>send email to PR Team based on the criteria  CAC or smart PR  Inquiry (East)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Real time send Ad-hoc email for CAC or smart other urgent cases</fullName>
        <actions>
            <name>Send_Email_to_CRM_Team_for_CAC_or_smart_other_urgent_cases</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inquiry</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Feedback_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Others</value>
        </criteriaItems>
        <description>Send email to CRM Team based on the criteria CAC or smart other urgent cases</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <criteriaItems>
            <field>Case.SendEmailToGateKeeper__c</field>
            <operation>equals</operation>
            <value>True</value>
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
        <active>true</active>
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
        <active>true</active>
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
        <active>true</active>
        <criteriaItems>
            <field>Case.Send_Email_Support_Dealer3_Keeper__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Social Media Case Binding</fullName>
        <actions>
            <name>Link_Social_Media_Case</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Data_Source__c</field>
            <operation>equals</operation>
            <value>Web/Mobile Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Data_Subsource__c</field>
            <operation>equals</operation>
            <value>We Chat,Weibo</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Trucks Complaint</fullName>
        <actions>
            <name>Trucks_Complaint</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>卡车</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Chrysler Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update field feed back required to true when record is created with specific case type</fullName>
        <actions>
            <name>update_field_feed_back_required_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Campaign,Second car exchange,Marketing chance,Network development department,Others,Consultant MBCL truck,Finance &amp; Insurance,RSA,Maybach,Club,Consultanting MBCL microbus,Dealer contact method</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Class__c</field>
            <operation>equals</operation>
            <value>Sales,After-Sales,Pre-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Product information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Diplomatic-Sales,Corporate-Sales</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRegionEast</fullName>
        <actions>
            <name>UpdateRegionEast</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Case_Dealer__r.Dealer_Region__c, &apos;EAST&apos;) &amp;&amp; Case_Dealer__r.RecordTypeId = &apos;01290000000fpAE&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRegionNorth</fullName>
        <actions>
            <name>UpdateRegionNorth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Case_Dealer__r.Dealer_Region__c, &apos;NORTH&apos;)  &amp;&amp;  Case_Dealer__r.RecordTypeId = &apos;01290000000fpAE&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRegionSouth</fullName>
        <actions>
            <name>UpdateRegionSouth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Case_Dealer__r.Dealer_Region__c, &apos;SOUTH&apos;) &amp;&amp; Case_Dealer__r.RecordTypeId = &apos;01290000000fpAE&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRegionWest</fullName>
        <actions>
            <name>UpdateRegionWest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Case_Dealer__r.Dealer_Region__c, &apos;WEST&apos;) &amp;&amp; Case_Dealer__r.RecordTypeId = &apos;01290000000fpAE&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Vans Complaint %28国产%29</fullName>
        <actions>
            <name>Vans_Complaint_domestic</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>Vans</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Source__c</field>
            <operation>equals</operation>
            <value>Domestic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Vans Complaint %28进口%29</fullName>
        <actions>
            <name>Vans_Complaint</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>Vans</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Source__c</field>
            <operation>equals</operation>
            <value>Import</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>smart After-sales Complaint %28MBCL case%29</fullName>
        <actions>
            <name>smart_After_sales_Complaint_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>After-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>smart Pre-sales Complaint%28MBCL case%29</fullName>
        <actions>
            <name>smart_Pre_sales_Complaint_MBCL_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>equals</operation>
            <value>smart</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>equals</operation>
            <value>Pre-Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>transferred to Domestic On-site Queue</fullName>
        <actions>
            <name>transferred_to_Domestic_On_site_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 6 AND ( 3 OR (4 AND 5) ) AND (7 AND 11) AND (8 AND 10) AND 12) OR 9</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Source__c</field>
            <operation>equals</operation>
            <value>Domestic</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Fire or Gasbag Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Repeat_Complaint_Times__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>notEqual</operation>
            <value>Maybach,Vans</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>notEqual</operation>
            <value>RSA - Waiting Time of Assistance,RSA-RSA service attitude,RSA - Professionalism of Rescue Worker</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Chrysler Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>notEqual</operation>
            <value>Finance service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>00590000001llXB</value>
        </criteriaItems>
        <description>Case Record Type = MB Complaints and Vehicle Source = Domestic and (Dealer Contact=No or (Dealer Contact = Yes and Case Subtype=&quot;Fire or Gasbag Case&quot;))</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>transferred to Import On-site Queue</fullName>
        <actions>
            <name>Change_case_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>transferred_to_Import_On_site_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 6 AND ( 3 OR (4 AND 5) ) AND (7 AND 10) AND (8 AND 9) AND 11</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MB Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Source__c</field>
            <operation>equals</operation>
            <value>Import</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Dealer_Contact__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>equals</operation>
            <value>Fire or Gasbag Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Repeat_Complaint_Times__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>notEqual</operation>
            <value>Maybach,Vans</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_SubType__c</field>
            <operation>notEqual</operation>
            <value>RSA - Waiting Time of Assistance,RSA-RSA service attitude,RSA - Professionalism of Rescue Worker</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Type__c</field>
            <operation>notEqual</operation>
            <value>Finance service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Vehicle_Brand__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>00590000001llXB</value>
        </criteriaItems>
        <description>Case Record Type = MB Complaints and Vehicle Source = Import and (Repeat Complaint has no more than 1 round of Final Position offered) and (Dealer Contact=No or (Dealer Contact = Yes and Case Subtype=&quot;&quot;Fire or Gasbag Case&quot;&quot;)) and (Vehicle Brand != Maybach</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
