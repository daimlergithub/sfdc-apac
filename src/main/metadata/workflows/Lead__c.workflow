<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
	<alerts>
        <fullName>Assigned_to_Dealer_Gatekeeper_Lead</fullName>
        <description>Assigned to Dealer Gatekeeper Lead</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/Assigned_to_Dealer_Gatekeeper_Lead</template>
    </alerts>
    <alerts>
        <fullName>Campaign_Lead_Assignment_Notification</fullName>
        <description>Campaign Lead Assignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Lead_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>No_modification_is_made_in_10_days_All_Modifications</fullName>
        <description>No modification is made in 10 days (All Modifications)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/No_modification_is_made_in_10_days_All_Modifications</template>
    </alerts>
    <alerts>
        <fullName>No_modification_is_made_in_15_days_All_Modifications</fullName>
        <description>No modification is made in 15 days (All Modifications)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/No_modification_is_made_in_15_days_All_Modifications</template>
    </alerts>
    <alerts>
        <fullName>No_modification_is_made_in_5_days_All_Modifications</fullName>
        <description>No modification is made in 5 days (All Modifications)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/No_modification_is_made_in_5_days_All_Modifications</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_customer_doesn_t_allow_dealer_contact</fullName>
        <description>Email notification when customer doesn't allow dealer contact</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_customer_doesn_t_allow_dealer_contact</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_interested_vehicle_have_changed</fullName>
        <description>Email notification when interested vehicle have changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_no_status_is_updated_more_than_10_days</fullName>
        <description>Email notification when no status is updated more than 10 days</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Aftersales_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_no_status_is_updated_more_than_10_days</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_no_status_is_updated_more_than_5_days</fullName>
        <description>Email notification when no status is updated more than 5 days</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Aftersales_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_no_status_is_updated_more_than_5_days</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_when_purchase_time_have_changed</fullName>
        <description>Email notification when purchase time have changed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_purchase_time_have_changed</template>
    </alerts>
    <alerts>
        <fullName>Escalated_after_24hrs</fullName>
        <description>Escalated after 24hrs</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_dealer_update_leads</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail_to_Lead_Owner</fullName>
        <description>Send Mail to Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MBK_Email_Templates/Lead_owner_is_updated</template>
    </alerts>
    <alerts>
        <fullName>When_lead_fields_updated_by_dealer_leads_owner_will_receive_an_email_notificatio</fullName>
        <description>When lead fields updated by dealer, leads owner will receive an email notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Email_notification_when_dealer_update_leads</template>
    </alerts>
    <alerts>
        <fullName>X24hrs_Lead_Escalation</fullName>
        <description>24hrs Lead Escalation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Call_Center_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
    <alerts>
        <fullName>abcd</fullName>
        <description>24hrs Lead Escalation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Call_Center_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
    <alerts>
        <fullName>fgefg</fullName>
        <description>fgefg</description>
        <protected>false</protected>
        <recipients>
            <recipient>Call_Center_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
    <fieldUpdates>
        <fullName>Accepted_Date_Time_Update</fullName>
        <field>Accepted_Date_Time__c</field>
        <formula>now()</formula>
        <name>Accepted Date Time_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Assigned_Date_Time_to_Current_Time</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>now()</formula>
        <name>Assigned Date Time to Current Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lost_DateTime_field</fullName>
        <field>Lead_Lost_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Update Lost DateTime field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Lost_Dealer_Date_Time</fullName>
        <field>Lost_Dealer_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Lost Dealer Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_Lead_Creation</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approve Lead Creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
    <fieldUpdates>
        <fullName>CAC_Lead_Status_to_Approved</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CAC Lead Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAC_Lead_Status_to_New</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>CAC Lead Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
    <fieldUpdates>
        <fullName>CAC_Status_Update_from_Dealer</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>CAC Status Update from Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_CAC_Lead_Status_to_Appr</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approving</literalValue>
        <name>Change CAC Lead Status to Appr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_CAC_Lead_Status_to_Approved</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Change CAC Lead Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_CAC_Lead_Status_to_Approving</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approving</literalValue>
        <name>Change CAC Lead Status to Approving</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_CAC_Lead_Status_to_Initial</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>Change CAC Lead Status to Initial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_CAC_Lead_Status_to_New</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>Change CAC Lead Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_approving</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approving</literalValue>
        <name>Change status to approving</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_new</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>Change status to new</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Lead_Status_update</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>On-going</literalValue>
        <name>Dealer Lead Status_update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Set_Assigned_Date_Time_Dealer</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>now()</formula>
        <name>Dealer Set Assigned Date Time Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>	
    <fieldUpdates>
        <fullName>Dealer_Lead_Status_update_from_Dealer</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>On-going</literalValue>
        <name>Dealer Lead Status update from Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>PopulateAssignedDateTimetoCurrent_Date</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>now()</formula>
        <name>PopulateAssignedDateTimetoCurrent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Populate_Assigned_Date_Time</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>now()</formula>
        <name>Populate Assigned Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Populate_CAC_Lead_Status</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Populate CAC Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Populate_Dealer_Lead_Status</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>Purchased(Only Non BDC)</literalValue>
        <name>Populate Dealer Lead Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Populate_Dealer_Lead_Status_to</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>On-going</literalValue>
        <name>Populate Dealer Lead Status to Ongoing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Successful_Call_Number_is_0</fullName>
        <field>Successful_Call_Number__c</field>
        <formula>0</formula>
        <name>Set Successful Call Number is 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Successful_Call_Number_is_1</fullName>
        <field>Successful_Call_Number__c</field>
        <formula>1</formula>
        <name>Set Successful Call Number is 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAC_Lead_Status_to_Accepted</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Update CAC Lead Status to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAC_Lead_Status_to_Assigned</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update CAC Lead Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAC_Lead_Status_to_New</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>New</literalValue>
        <name>Update CAC Lead Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Failed_Date_Time_to_Now</fullName>
        <field>Contact_Failed_For_3_Days_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Contact Failed Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Aftersales_Manager_Email</fullName>
        <field>Dealer_Aftersales_Manager_Email__c</field>
        <formula>Assigned_Dealer__r.Dealer_Aftersales_Manager_Email__c</formula>
        <name>Update Dealer Aftersales Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Dealer_Lead_Status_to</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>Order Placed</literalValue>
        <name>Update Dealer Lead Status to OrderPlaced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Lead_Status_to_Accepted</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Update Dealer Lead Status to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Lead_Status_to_Assigned</fullName>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update Dealer Lead Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Owner_Email</fullName>
        <field>Dealer_Owner_Email__c</field>
        <formula>Assigned_Dealer__r.Owner.Email</formula>
        <name>Update Dealer Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Accepted_Date_Time_to_Now</fullName>
        <field>Accepted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Accepted Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Lead_Lost_Date_Time</fullName>
        <field>Lead_Lost_Date_Time__c</field>
        <formula>now()</formula>
        <name>Update Lead Lost Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Assigned_Date_Time_to_Now</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Assigned Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Recieved_Date_Time_to_Now</fullName>
        <field>Received_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Recieved Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lost_CAC_Date_Time_to_Now</fullName>
        <field>Lost_CAC_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Update Lost(CAC) Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lost_CAC_Date_to_Now</fullName>
        <field>Lost_CAC_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Lost(CAC) Date to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Contact_Failed</fullName>
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
)</formula>
        <name>Update Proxy Date Time to Contact Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_First_Contact</fullName>
        <field>First_Contact_Customer_Date__c</field>
        <formula>IF ( 
ISBLANK(First_Contact_Customer_Date__c), 
TODAY(), 
First_Contact_Customer_Date__c 
)</formula>
        <name>Update Proxy Date Time to First Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Lost_Dealer</fullName>
        <field>Lost_Dealer_Date__c</field>
        <formula>IF ( 
ISBLANK(Lost_Dealer_Date__c), 
TODAY(), 
Lost_Dealer_Date__c 
)</formula>
        <name>Update Proxy Date Time to Lost(Dealer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Order_Placed</fullName>
        <field>Order_Placed_Date__c</field>
        <formula>IF ( 
ISBLANK(Order_Placed_Date__c), 
TODAY(), 
Order_Placed_Date__c 
)</formula>
        <name>Update Proxy Date Time to Order Placed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Purchased</fullName>
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
)</formula>
        <name>Update Proxy Date Time to Purchased</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Test_Drive</fullName>
        <field>Test_Drive_Date__c</field>
        <formula>IF ( 
ISBLANK(Test_Drive_Date__c), 
TODAY(), 
Test_Drive_Date__c 
)</formula>
        <name>Update Proxy Date Time to Test Drive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Visited_Showro</fullName>
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
)</formula>
        <name>Update Proxy Date Time to Visited Showro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Purchased_CAC_Date_Time_to_Now</fullName>
        <field>Purchased_CAC_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Purchased(CAC) Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Service_Completed_Date_To_Today</fullName>
        <field>Service_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Service Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>	
    <fieldUpdates>
        <fullName>Update_Purchased_Date_Time_to_Now</fullName>
        <field>Purchased_CAC_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Update Purchased Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Qualified_Date_Time_to_Now</fullName>
        <field>Qualified_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Qualified Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Visited_Showroom_Date_Time_to_Now</fullName>
        <field>Visited_Showroom_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Visited Showroom Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Link_Social_Media_Leads</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://benz.social360.com.cn/LinkLead.asmx</endpointUrl>
        <fields>Contact__c</fields>
        <fields>Id</fields>
        <fields>RecordTypeId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>WORKFLOW_INTEGRATION_USER</integrationUser>
        <name>Link Social Media Leads</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Assigned_Dealer_to_EP</fullName>
        <apiVersion>27.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/LmsExportNotification</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>WORKFLOW_INTEGRATION_USER</integrationUser>
        <name>Send Assigned Dealer to EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Campaign Lead Notification to WS Users</fullName>
        <actions>
            <name>Campaign_Lead_Assignment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( OwnerId ),MD__c  = 'JP', OR(NOT(ISBLANK(Source_Campaign__c)),NOT(ISBLANK(Retail_Campaign_Name__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when customer doesn%27t allow dealer contact</fullName>
        <actions>
            <name>Email_notification_when_customer_doesn_t_allow_dealer_contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4) AND (5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Lead__c.Assigned_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Allow_Data_Sharing__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Dealer_LMS__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Aftersales Leads,Retail Sales Leads,Sales Leads</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when interested vehicle have changed</fullName>
        <actions>
            <name>Email_notification_when_interested_vehicle_have_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISBLANK(Assigned_Date_Time__c)), Dealer_LMS__c = 'Salesforce', MD__c = 'KR',  OR (RecordType.Name = 'Sales Leads',RecordType.Name = 'Aftersales Leads',RecordType.Name = 'Retail Sales Leads'), OR( ISCHANGED(Interested_Vehicle_Brand__c),  ISCHANGED(Interested_Vehicle_Class__c),  ISCHANGED(Interested_Vehicle_Model__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when no status is updated more than 10 days</fullName>
        <active>true</active>
        <formula>AND ( ISBLANK(Proxy_Date_Time__c),  OR (RecordType.Name = 'Sales Leads',RecordType.Name = 'Retail Sales Leads'),  MD__c = 'KR'  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_notification_when_no_status_is_updated_more_than_10_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.Accepted_Date_Time__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email notification when no status is updated more than 5 days</fullName>
        <active>true</active>
        <formula>AND ( ISBLANK(Proxy_Date_Time__c),  OR (RecordType.Name = 'Sales Leads',RecordType.Name = 'Retail Sales Leads'),  MD__c = 'KR' )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_notification_when_no_status_is_updated_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.Accepted_Date_Time__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email notification when purchase time have changed</fullName>
        <actions>
            <name>Email_notification_when_purchase_time_have_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(ISBLANK(Assigned_Date_Time__c)), ISCHANGED(Purchase_Time__c),  OR (RecordType.Name = 'Sales Leads',RecordType.Name = 'Retail Sales Leads'),  Dealer_LMS__c = 'Salesforce', MD__c = 'KR' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>No modification is made in 10 days %28All Modifications%29</fullName>
        <active>true</active>
        <description>This will send email to lead gate keeper when the lead is untouched for 10 days.</description>
        <formula>(NOT(ISNULL(Assigned_Dealer__c)))&amp;&amp;( DATEVALUE(LastModifiedDate) - today() == 10)&amp;&amp; MD__c == 'KR'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_modification_is_made_in_10_days_All_Modifications</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>216</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>No modification is made in 15 days %28All Modifications%29</fullName>
        <active>true</active>
        <description>No modification is made in 15 days (All Modifications)</description>
        <formula>(NOT(ISNULL(Assigned_Dealer__c)))&amp;&amp;( DATEVALUE(LastModifiedDate) - today() == 15)&amp;&amp; MD__c == 'KR'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_modification_is_made_in_15_days_All_Modifications</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>336</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>No modification is made in 5 days %28All Modifications%29</fullName>
        <active>true</active>
        <description>This rule will send email if the last activity date on lead record is eqial to 5 days</description>
        <formula>(NOT(ISNULL(Assigned_Dealer__c)))&amp;&amp;( DATEVALUE(LastModifiedDate) - today() == 5)&amp;&amp; MD__c == 'KR'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_modification_is_made_in_5_days_All_Modifications</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>96</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lead_Lost_DateTime New</fullName>
        <actions>
            <name>Update_Lost_DateTime_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Dealer_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Escalation Process Definition - Wholesale CCC</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Aftersales Leads,Retail Sales Leads,Sales Leads,Sales Leads Soft Deleted</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Escalated_after_24hrs</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lead Owner is Changed</fullName>
        <actions>
            <name>Send_Mail_to_Lead_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If Lead Owner is changed, Need to send email to Lead Owner</description>
        <formula>MD__c = 'KR' &amp;&amp;  ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Leads fields update</fullName>
        <actions>
            <name>When_lead_fields_updated_by_dealer_leads_owner_will_receive_an_email_notificatio</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(  CONTAINS( $Profile.Name , 'Dealer'),  OR(    ISCHANGED(Lead_Desired_Service__c),    ISCHANGED(Dealer_Lead_Status__c),    ISCHANGED(Lead_Type__c),    ISCHANGED(Lead_Sub_Type__c),    ISCHANGED(First_Contact_Customer_Date__c ),    ISCHANGED(Lead_Additional_Service__c),    ISCHANGED(Purchased_Date__c),    ISCHANGED(Dealer_Comments__c),    ISCHANGED(Purchase_Time__c),    ISCHANGED(Interested_Vehicle_Brand__c),    ISCHANGED(Interested_Vehicle_Class__c),    ISCHANGED(Interested_Vehicle_Model__c),    ISCHANGED(Test_Drive_Date__c),    ISCHANGED(Feedback_To_MB_Call_Center__c)  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Populate Assigned Date Time Dealer</fullName>
        <actions>
            <name>Populate_Assigned_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_CAC_Lead_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Dealer_Lead_Status_to</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISNEW(),  CONTAINS($Profile.Name , 'Partner Community'),  MD__c = 'JP' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reassigned lead to Non-BDC</fullName>
        <actions>
            <name>Update_Lead_Accepted_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Assigned_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Recieved_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.LastModifiedById</field>
            <operation>notEqual</operation>
            <value>Liam Huang</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Dealer_Lead_Status__c</field>
            <operation>notEqual</operation>
            <value>Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Successful Call Number is 0</fullName>
        <actions>
            <name>Set_Successful_Call_Number_is_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>notEqual</operation>
            <value>OB Call,IB Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>contains</operation>
            <value>Retail Sales Leads,Sales Leads</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Successful Call Number is 1</fullName>
        <actions>
            <name>Set_Successful_Call_Number_is_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>equals</operation>
            <value>OB Call,IB Call</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>contains</operation>
            <value>Retail Sales Leads,Sales Leads</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Social Media Leads Binding</fullName>
        <actions>
            <name>Link_Social_Media_Leads</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>equals</operation>
            <value>Web/Mobile Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Lead_DataSubSource__c</field>
            <operation>equals</operation>
            <value>Weibo,WeChat</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Accepted Date Time</fullName>
        <actions>
            <name>Accepted_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_Lead_Status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Service_Advisor__c ),NOT(ISNULL(Service_Advisor__c)),  MD__c = 'JP')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Failed For 3 Days Date Time</fullName>
        <actions>
            <name>Update_Contact_Failed_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Proxy_Date_Time_to_Contact_Failed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"Contact Failed For 3 Days(Only Non BDC)"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Dealer Aftersales Manager and Dealer Owner Email Field</fullName>
        <actions>
            <name>Update_Dealer_Aftersales_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Aftersales Leads</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Update Dealer Lead Status</fullName>
        <actions>
            <name>Populate_Dealer_Lead_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISNEW()), MD__c = 'JP',
   OR(AND(ISPICKVAL( Lead_Latest_Phase__c,'Registration' ),  RecordType.Name = 'Sales Leads')
   ,AND(ISPICKVAL(Lead_Latest_Phase__c, 'Invoiced'), RecordType.Name = 'Aftersales Leads') )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Update Lead Lost Date Time</fullName>
        <actions>
            <name>Update_Lost_Dealer_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Dealer_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update First Contact Customer Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_First_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"First Contact Customer"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Qualified Date Time</fullName>
        <actions>
            <name>Update_Qualified_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-18) 
Function: update Qualified Date Time to now() when CAC Lead Status is Qualified, detail refer to DT-13050287

Used in: 

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>AND(ISPICKVAL(CAC_Lead_Status__c , "Qualified"),  OR (RecordType.Name = 'Sales Leads',RecordType.Name = 'Retail Sales Leads'), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
	<rules>
        <fullName>Update Lead Status to Order Placed</fullName>
        <actions>
            <name>Update_Dealer_Lead_Status_to</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Lead_Latest_Phase__c ), MD__c = 'JP', ISPICKVAL(Lead_Latest_Phase__c, 'Order Confirmed'),  RecordType.Name = 'Sales Leads')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lost%28CAC%29 Date Time</fullName>
        <actions>
            <name>Update_Lost_CAC_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lost_CAC_Date_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Lost(CAC)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>contains</operation>
            <value>Retail Sales Leads,Sales Leads,Aftersales Leads</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lost%28Dealer%29 Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Lost_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"Lost(Dealer)"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Order Placed Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Order_Placed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"Order Placed"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Purchased%28CAC%29 Date Time</fullName>
        <actions>
            <name>Update_Purchased_CAC_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Purchased(Only Non BDC)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Service Completed Date</fullName>
        <actions>
            <name>Update_Service_Completed_Date_To_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Dealer_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Service Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Purchased%28Only Non BDC%29 Date Time</fullName>
        <actions>
            <name>Update_Purchased_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Purchased(Only Non BDC)")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>	
    <rules>
        <fullName>Update Leads Dealer Status for dealer create</fullName>
        <actions>
            <name>CAC_Status_Update_from_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_Lead_Status_update_from_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_Set_Assigned_Date_Time_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Contains( $Profile.Name, 'Japan Dealer' )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Status and Date time of BDC Dealer</fullName>
        <actions>
            <name>Update_CAC_Lead_Status_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Assigned_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Assigned_Dealer_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-15) 
Function: update assigned date to today and status to assigned when Is Qualified is Qualified and Prefer Dealer is not null
Used in:

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>AND(Assigned_Dealer__c &lt;&gt; NULL, MD__c = 'KR', ISPICKVAL(CAC_Lead_Status__c,"Qualified") )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status and Date time of Non-BDC Dealer</fullName>
        <actions>
            <name>Update_Lead_Accepted_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Recieved_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created by: Mouse Liu 
Used by: Lead__c (US-Lead-14) 
Function: update assigned date, recieved data and accepted date to now, and status to Accepted when Dealer LMS is No, Is Qualified is Qualified and Prefer Dealer is not null</description>
        <formula>AND(Assigned_Dealer__c &lt;&gt; NULL, MD__c = 'KR', ISPICKVAL(Dealer_Lead_Status__c,"Accepted"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Test Drive Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Test_Drive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"Test Drive"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Visited Showroom%28Only Non BDC%29 Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Visited_Showro</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Visited_Showroom_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Dealer_Lead_Status__c,"Visited Showroom"), MD__c = 'KR')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
