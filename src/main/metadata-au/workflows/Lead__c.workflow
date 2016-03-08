<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <template>Lead_Email_Template/Email_notification_when_interested_vehicle_have_changed</template>
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
        <fullName>Lead_Untouched_for_4_days_after_creation</fullName>
        <description>Lead Untouched for 4 days after creation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Lead_not_touched_for_4_days</template>
    </alerts>
    <alerts>
        <fullName>Once_Fleet_Vans_lead_is_created_an_email_alert_will_be_sent_to_Fleet_MBaup_Delet</fullName>
        <description>Once Fleet Vans lead is created an email alert will be sent to Fleet-MBaup (Delete) users</description>
        <protected>false</protected>
        <recipients>
            <recipient>Fleet_Delete</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Notification_Email</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_lead_owner_when_the_created_lead_was_not_touched_for_7_days</fullName>
        <description>Send an email to lead owner when the created lead was not touched for 7 days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Lead_not_touched_for_7_days</template>
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
    <fieldUpdates>
        <fullName>Close_Date_Update</fullName>
        <field>Close_Date__c</field>
        <formula>Today()</formula>
        <name>Close Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Doc_fee_updation_on_Fee_type</fullName>
        <description>Update Documentation Fee to “0” when the Fee Type is selected as Waived.</description>
        <field>Doc_Fee__c</field>
        <formula>0</formula>
        <name>Doc fee updation on Fee type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Orig_fee_updation_on_Fee_type</fullName>
        <description>Update Origination Fee to “0” when the Fee Type is selected as Waived.</description>
        <field>Orig_Fee__c</field>
        <formula>0</formula>
        <name>Orig fee updation on Fee type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Update_24H_Untouched</fullName>
        <description>/*
Created By Polaris Yu 2013-8-27
Function: Checked the '*24H Untouched' field for Qualified Vehicle Leads and Service/Parts Leads if they haven't been updated for 24 hours
Used By: Workflow Rule - Lead Auto Check '*24H Untouched'
*/</description>
        <field>X24H_Untouched__c</field>
        <literalValue>1</literalValue>
        <name>Update 24H Untouched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_72H_Untouched</fullName>
        <description>/* 
Created By Polaris Yu 2013-8-29
Function: Checked the '*72H Untouched' field for Qualified Vehicle Leads and Service/Parts Leads if they haven't been updated for 72 hours 
Used By: Workflow Rule - Lead Auto Check '*72H Untouched' 
*/</description>
        <field>X72H_Untouched__c</field>
        <literalValue>1</literalValue>
        <name>Update 72H Untouched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAC_Lead_Status_to_Accepted</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Offer Accepted</literalValue>
        <name>Update CAC Lead Status to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CAC_Lead_Status_to_Assigned</fullName>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Actioned</literalValue>
        <name>Update CAC Lead Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Collectioner_Notes</fullName>
        <description>Updating Collectioner Notes field with the contact value.</description>
        <field>Collectioner_Notes__c</field>
        <formula>Contact__r.Display_Name__c</formula>
        <name>Update Collectioner Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Failed_Date_Time_to_Now</fullName>
        <field>Contact_Failed_For_3_Days_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Contact Failed Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Type_to_Existing_Custome</fullName>
        <field>Customer_Type__c</field>
        <literalValue>Existing Customer</literalValue>
        <name>Update Customer Type to Existing Custome</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Type_to_New_Customer</fullName>
        <field>Customer_Type__c</field>
        <literalValue>New Customer</literalValue>
        <name>Update Customer Type to New Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Update_Finance_Send_Email_Before_15_Days</fullName>
        <field>Is_Finance_Send_Email_Before_15_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Finance Send Email Before 15 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Finance_Send_Email_Before_20_Days</fullName>
        <field>Is_Finance_Send_Email_Before_20_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Finance Send Email Before 20 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Finance_Send_Email_Before_45_Days</fullName>
        <field>Is_Fleet_Send_Email_Before_45_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Finance Send Email Before 45 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Finance_Send_Email_Before_60_Days</fullName>
        <field>Is_Finance_Send_Email_Before_60_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Finance Send Email Before 60 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Fleet_Send_Email_Before_15_Days</fullName>
        <field>Is_Fleet_Send_Email_Before_15_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Fleet Send Email Before 15 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Fleet_Send_Email_Before_20_Days</fullName>
        <field>Is_Fleet_Send_Email_Before_20_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Fleet Send Email Before 20 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Fleet_Send_Email_Before_60_Days</fullName>
        <field>Is_Fleet_Send_Email_Before_60_Days__c</field>
        <literalValue>1</literalValue>
        <name>Update Fleet Send Email Before 60 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
)</formula>
        <name>Update Proxy Date Time to First Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Lost_Dealer</fullName>
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
)</formula>
        <name>Update Proxy Date Time to Lost(Dealer)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Proxy_Date_Time_to_Order_Placed</fullName>
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
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
        <field>Proxy_Date_Time__c</field>
        <formula>IF ( 
ISBLANK(Proxy_Date_Time__c), 
NOW(), 
Proxy_Date_Time__c 
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
        <fullName>Update_Purchased_Date_Time_to_Now</fullName>
        <field>Purchased_Date_Time__c</field>
        <formula>NOW()</formula>
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
        <field>Visited_Showroom_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Visited Showroom Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Notification to Lead Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Fleet Lead</value>
        </criteriaItems>
        <description>Email notification to lead owner whenever the leads are untouched for 4 days.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lead_Untouched_for_4_days_after_creation</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email notification when customer doesn%27t allow dealer contact</fullName>
        <actions>
            <name>Email_notification_when_customer_doesn_t_allow_dealer_contact</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
            <value>Sales Leads</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when interested vehicle have changed</fullName>
        <actions>
            <name>Email_notification_when_interested_vehicle_have_changed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( NOT(ISBLANK(Assigned_Date_Time__c)), Dealer_LMS__c = 'No', RecordType.Name = 'Sales Leads', OR( ISCHANGED(Interested_Vehicle_Brand__c),  ISCHANGED(Interested_Vehicle_Class__c),  ISCHANGED(Interested_Vehicle_Model__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when no status is updated more than 10 days</fullName>
        <active>false</active>
        <formula>AND ( ISBLANK(Proxy_Date_Time__c), RecordTypeId =='012O00000004Wxm' )</formula>
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
        <active>false</active>
        <formula>AND ( ISBLANK(Proxy_Date_Time__c), RecordTypeId =='012O00000004Wxm' )</formula>
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
        <active>false</active>
        <formula>AND( NOT(ISBLANK(Assigned_Date_Time__c)), ISCHANGED(Purchase_Time__c), RecordType.Name = 'Sales Leads', Dealer_LMS__c = 'No' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalation%3A Lead not touched for 7 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Fleet Lead</value>
        </criteriaItems>
        <description>This Lead has not been touched for 7 days after creation.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Finance Send Notification Email To Dealer Recipients Before 15 Days</fullName>
        <actions>
            <name>Update_Finance_Send_Email_Before_15_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = 'Finance_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 15 ,  Is_Finance_Send_Email_Before_15_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finance Send Notification Email To Dealer Recipients Before 20 Days</fullName>
        <actions>
            <name>Update_Finance_Send_Email_Before_20_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = 'Finance_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 20 ,  Is_Finance_Send_Email_Before_20_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finance Send Notification Email To Dealer Recipients Before 45 Days</fullName>
        <actions>
            <name>Update_Finance_Send_Email_Before_45_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = 'Finance_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 45 ,  Is_Fleet_Send_Email_Before_45_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finance Send Notification Email To Dealer Recipients Before 60 Days</fullName>
        <actions>
            <name>Update_Finance_Send_Email_Before_60_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = 'Finance_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 60 ,  Is_Finance_Send_Email_Before_60_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Send Notification Email To Dealer Recipients Before 15 Days</fullName>
        <actions>
            <name>Update_Fleet_Send_Email_Before_15_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.DeveloperName = 'Fleet_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 15 ,  Is_Fleet_Send_Email_Before_15_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Send Notification Email To Dealer Recipients Before 20 Days</fullName>
        <actions>
            <name>Update_Fleet_Send_Email_Before_20_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.DeveloperName = 'Fleet_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 20 ,  Is_Fleet_Send_Email_Before_20_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fleet Send Notification Email To Dealer Recipients Before 60 Days</fullName>
        <actions>
            <name>Update_Fleet_Send_Email_Before_60_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  RecordType.DeveloperName = 'Fleet_Lead',   Status_Category__c = 'Open',   ISPICKVAL(Lead_Source__c, 'End of Contract'), Existing_Contract__r.EndDate__c = TODAY() + 60 ,  Is_Fleet_Send_Email_Before_60_Days__c = FALSE )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Auto Check %27*24%2F72H Untouched%27</fullName>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vehicle Lead,Service/Parts Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>New Enquiry</value>
        </criteriaItems>
        <description>/*
Created By Polaris Yu 2013-8-27
Function: Checked the '*24H Untouched' field for Qualified Vehicle Leads and Service/Parts Leads if they haven't been updated for 24 hours
Used By:
Modified By Polaris Yu 2013-8-29 Added '*72H Untouched'
*/</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_72H_Untouched</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_24H_Untouched</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead__c.LastModifiedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
        <fullName>Notify_Manager_Ob_Creation_Fleet_Van_Lead</fullName>
        <actions>
            <name>Once_Fleet_Vans_lead_is_created_an_email_alert_will_be_sent_to_Fleet_MBaup_Delet</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fleet Vans</value>
        </criteriaItems>
        <description>Once Fleet Vans lead is created an email alert will be sent to Fleet-MBaup (Delete) users</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Origination and Documentation field updation</fullName>
        <actions>
            <name>Doc_fee_updation_on_Fee_type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Orig_fee_updation_on_Fee_type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance Fleet Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Fee_Type__c</field>
            <operation>equals</operation>
            <value>Waived</value>
        </criteriaItems>
        <description>Update Origination Fee and Documentation Fee to “0” when the Fee Type is selected as Waived.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
            <operation>equals</operation>
            <value>Liam Huang</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Dealer_Lead_Status__c</field>
            <operation>notEqual</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Successful Call Number is 0</fullName>
        <actions>
            <name>Set_Successful_Call_Number_is_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>notEqual</operation>
            <value>OB Call,IB Call</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Successful Call Number is 1</fullName>
        <actions>
            <name>Set_Successful_Call_Number_is_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>equals</operation>
            <value>OB Call,IB Call</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Close Date With Status Category Closed Won</fullName>
        <actions>
            <name>Close_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Status_Category__c</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Finance Fleet Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Collectioner Notes with contact name</fullName>
        <actions>
            <name>Update_Collectioner_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as per the Jira ticket  SFDCAU-485,making contact searchable as a global.</description>
        <formula>Contact__c != null</formula>
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
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Contact Failed For 3 Days(Only Non BDC)")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Type on Lead1</fullName>
        <actions>
            <name>Update_Customer_Type_to_New_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Customer Type field with the values
New Customer - IF all of PC/CV/Van Status fields are 'Prospect'</description>
        <formula>IF(AND((Contact__c = null || Contact__c =''),RecordType.Name = 'Vehicle Lead'),   IF(  ISPICKVAL(Company_Account__r.CV_Status__c , 'Prospect') &amp;&amp;  ISPICKVAL(Company_Account__r.PC_Status__c , 'Prospect') &amp;&amp;  ISPICKVAL(Company_Account__r.VAN_Status__c , 'Prospect'),  true, false),    IF(  ISPICKVAL( Contact__r.CV_Status__c , 'Prospect') &amp;&amp;  ISPICKVAL( Contact__r.PC_Status__c , 'Prospect') &amp;&amp;  ISPICKVAL( Contact__r.VAN_Status__c , 'Prospect'),  true, false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Type on Lead2</fullName>
        <actions>
            <name>Update_Customer_Type_to_Existing_Custome</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Customer Type field with the values 
Existing Customer -- IF any of PC/CV/Van Status fields are 'Customer'</description>
        <formula>IF(AND((Contact__c = null || Contact__c =''),RecordType.Name = 'Vehicle Lead'),   IF(  ISPICKVAL(Company_Account__r.CV_Status__c , 'Customer') ||  ISPICKVAL(Company_Account__r.PC_Status__c , 'Customer') ||  ISPICKVAL(Company_Account__r.VAN_Status__c , 'Customer'),  true, false),    IF(  ISPICKVAL( Contact__r.CV_Status__c , 'Customer') ||  ISPICKVAL( Contact__r.PC_Status__c , 'Customer') ||  ISPICKVAL( Contact__r.VAN_Status__c , 'Customer'),  true, false))</formula>
        <triggerType>onAllChanges</triggerType>
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
        <fullName>Update First Contact Customer Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_First_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"First Contact Customer")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Qualified Date Time</fullName>
        <actions>
            <name>Update_Qualified_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-18) 
Function: update Qualified Date Time to now() when CAC Lead Status is Qualified, detail refer to DT-13050287

Used in: 

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>ISPICKVAL(CAC_Lead_Status__c , "Qualified")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lost%28Dealer%29 Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Lost_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Lost(Dealer)")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Order Placed Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Order_Placed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Order Placed")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Purchased%28CAC%29 Date Time</fullName>
        <actions>
            <name>Update_Purchased_CAC_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Policy Sold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Purchased%28Only Non BDC%29 Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Purchased</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Purchased_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Purchased(Only Non BDC)")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status and Date time of BDC Dealer</fullName>
        <actions>
            <name>Update_CAC_Lead_Status_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Lead_Status_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Assigned_Date_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-15) 
Function: update assigned date to today and status to assigned when Is Qualified is Qualified and Prefer Dealer is not null
Used in:

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>AND( RecordTypeId == "01290000000rXmP",  Need_Assign_To_Dealer__c == "Need",  Assigned_Dealer__c &lt;&gt; NULL,  Dealer_LMS__c == "Yes",  ISPICKVAL(CAC_Lead_Status__c,"Qualified") )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status and Date time of Non-BDC Dealer</fullName>
        <actions>
            <name>Update_CAC_Lead_Status_to_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Lead_Status_to_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
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
        <description>Created by: Mouse Liu 
Used by: Lead__c (US-Lead-14) 
Function: update assigned date, recieved data and accepted date to now, and status to Accepted when Dealer LMS is No, Is Qualified is Qualified and Prefer Dealer is not null</description>
        <formula>OR(  AND(RecordTypeId == "01290000000rXmP", Need_Assign_To_Dealer__c == "Need", Assigned_Dealer__c &lt;&gt; NULL, Dealer_LMS__c == "No", ISPICKVAL(CAC_Lead_Status__c,"Qualified") ),  AND(RecordTypeId == "01290000000rXmO", Assigned_Dealer__c &lt;&gt; NULL,ISPICKVAL(CAC_Lead_Status__c,"Qualified") )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Test Drive Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Test_Drive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Test Drive")</formula>
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
        <active>false</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,"Visited Showroom")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
