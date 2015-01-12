<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_when_customer_doesn_t_allow_dealer_contact</fullName>
        <description>Email notification when customer doesn&apos;t allow dealer contact</description>
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
        <fullName>Change_MBDA_Lead_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>MBDA_Speciallist</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change MBDA Lead Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
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
        <fullName>Update_Accepted_Date</fullName>
        <description>Update Accepted Date</description>
        <field>Accepted_Date_Time__c</field>
        <name>Update Accepted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_Date</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Assigned Date</name>
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
        <fullName>Update_CAC_Leads_Status</fullName>
        <description>Update Leads Status</description>
        <field>CAC_Lead_Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update CAC Leads Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
        <fullName>Update_Dealer_Leads_Status</fullName>
        <description>Update Dealer Leads Status</description>
        <field>Dealer_Lead_Status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Update Dealer Leads Status</name>
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
        <fullName>Update_First_Contact_Date_Time_to_Now</fullName>
        <field>First_Contact_Customer_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update First Contact Date Time to Now</name>
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
        <fullName>Update_Lost_Dealer_Date_Time_to_Now</fullName>
        <field>Lost_Dealer_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Lost(Dealer) Date Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Order_Placed_Date_Time_to_Now</fullName>
        <field>Order_Placed_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Order Placed Date Time to Now</name>
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
        <fullName>Update_Received_Date</fullName>
        <description>Update Received Date</description>
        <field>Received_Date_Time__c</field>
        <name>Update Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Test_Drive_Date_Time_to_Now</fullName>
        <field>Test_Drive_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Test Drive Date Time to Now</name>
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
    <fieldUpdates>
        <fullName>Update_the_Proxy_Date_Time</fullName>
        <description>Created by: Mouse Liu 
Used by: Lead__c (US-Lead-46) 
Function: If any one Dealer Untouched(In 72H) realted Date Time is not null and Proxy Date Time is not null,
assigned the updated Date Time to Proxy Date Time</description>
        <field>Proxy_Date_Time__c</field>
        <formula>IF (
    NOT(ISNULL(Contact_Failed_For_3_Days_Date_Time__c)),
    Contact_Failed_For_3_Days_Date_Time__c,

    IF (
        NOT(ISNULL(First_Contact_Customer_Date_Time__c)),
        First_Contact_Customer_Date_Time__c,

        IF (
            NOT(ISNULL(Test_Drive_Date_Time__c)),
            Test_Drive_Date_Time__c,

            IF (
                NOT(ISNULL(Visited_Showroom_Date_Time__c)),
                Visited_Showroom_Date_Time__c,

                IF (
                    NOT(ISNULL(Order_Placed_Date_Time__c)),
                    Order_Placed_Date_Time__c,

                    IF (
                        NOT(ISNULL(Purchased_Date_Time__c)),
                        Purchased_Date_Time__c,

                        IF (
                            NOT(ISNULL(Lost_Dealer_Date_Time__c)),
                            Lost_Dealer_Date_Time__c,

                            null
                        )
                    )
                )
            )
        )
    )
)</formula>
        <name>Update the Proxy Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Assign_Retail_Leads_to_EP</fullName>
        <apiVersion>31.0</apiVersion>
        <endpointUrl>https://crm.mercedes-benz.com.cn/webservices/LmsExportNotification</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Assign Retail Leads to EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Link_Social_Media_Leads</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>https://benz.social360.com.cn/LinkLead.asmx</endpointUrl>
        <fields>Contact__c</fields>
        <fields>Id</fields>
        <fields>RecordTypeId</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>tony.li@bp.daimler.prod</integrationUser>
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
        <integrationUser>ep.user1@daimler.prod</integrationUser>
        <name>Send Assigned Dealer to EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_LMS_To_EP</fullName>
        <apiVersion>30.0</apiVersion>
        <endpointUrl>https://crm-int.mercedes-benz.com.cn/webservices/LmsExportNotification</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>sichao.lai@nttdata.com.production</integrationUser>
        <name>Send LMS To EP</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Change MBDA Lead Owner</fullName>
        <actions>
            <name>Change_MBDA_Lead_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>MBDA Leads</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when customer doesn%27t allow dealer contact</fullName>
        <actions>
            <name>Email_notification_when_customer_doesn_t_allow_dealer_contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
        <active>true</active>
        <formula>AND(
NOT(ISBLANK(Assigned_Date_Time__c)),
Dealer_LMS__c = &apos;No&apos;,
RecordType.Name = &apos;Sales Leads&apos;,
OR(
ISCHANGED(Interested_Vehicle_Brand__c), 
ISCHANGED(Interested_Vehicle_Class__c), 
ISCHANGED(Interested_Vehicle_Model__c)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification when no status is updated more than 10 days</fullName>
        <active>true</active>
        <formula>AND ( ISBLANK(Proxy_Date_Time__c), RecordTypeId ==&apos;012O00000004Wxm&apos; )</formula>
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
        <formula>AND ( ISBLANK(Proxy_Date_Time__c), RecordTypeId ==&apos;012O00000004Wxm&apos; )</formula>
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
        <formula>AND(
NOT(ISBLANK(Assigned_Date_Time__c)),
ISCHANGED(Purchase_Time__c),
RecordType.Name = &apos;Sales Leads&apos;,
Dealer_LMS__c = &apos;No&apos;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>For retail campaign leads passed to LMS by EP</fullName>
        <actions>
            <name>Send_LMS_To_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail Sales Leads</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead__c.Dealer_LMS__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Leads fields update</fullName>
        <actions>
            <name>When_lead_fields_updated_by_dealer_leads_owner_will_receive_an_email_notificatio</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  CONTAINS( $Profile.Name , &apos;Dealer&apos;),  OR(    ISCHANGED(Lead_Desired_Service__c),    ISCHANGED(Dealer_Lead_Status__c),    ISCHANGED(Lead_Type__c),    ISCHANGED(Lead_Sub_Type__c),    ISCHANGED(First_Contact_Customer_Date__c ),    ISCHANGED(Lead_Additional_Service__c),    ISCHANGED(Purchased_Date__c),    ISCHANGED(Dealer_Comments__c),    ISCHANGED(Purchase_Time__c),    ISCHANGED(Interested_Vehicle_Brand__c),    ISCHANGED(Interested_Vehicle_Class__c),    ISCHANGED(Interested_Vehicle_Model__c),    ISCHANGED(Test_Drive_Date__c),    ISCHANGED(Feedback_To_MB_Call_Center__c)  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reassigned lead to LMS</fullName>
        <actions>
            <name>Update_Accepted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Assigned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CAC_Leads_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Leads_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Assigned_Dealer_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead__c.LastModifiedById</field>
            <operation>equals</operation>
            <value>Liam Huang</value>
        </criteriaItems>
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
        <fullName>Retails leads passed toEP</fullName>
        <actions>
            <name>Assign_Retail_Leads_to_EP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND( 
RecordTypeId== &quot;01290000001FaND&quot;, 
Dealer_LMS__c == &quot;Yes&quot; 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Successful Call Number is 0</fullName>
        <actions>
            <name>Set_Successful_Call_Number_is_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
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
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.Lead_DataSource__c</field>
            <operation>equals</operation>
            <value>OB Call,IB Call</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Social Media Leads Binding</fullName>
        <actions>
            <name>Link_Social_Media_Leads</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
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
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Contact Failed For 3 Days(Only Non BDC)&quot;)</formula>
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
        <active>true</active>
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
        <active>true</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;First Contact Customer&quot;)</formula>
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
        <formula>ISPICKVAL(CAC_Lead_Status__c , &quot;Qualified&quot;)</formula>
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
        <active>true</active>
        <criteriaItems>
            <field>Lead__c.CAC_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Lost(CAC)</value>
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
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Lost(Dealer)&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Order Placed Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Order_Placed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Order Placed&quot;)</formula>
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
        <active>true</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Purchased(Only Non BDC)&quot;)</formula>
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
        <formula>AND(
RecordTypeId == &quot;01290000000rXmP&quot;, 
Need_Assign_To_Dealer__c == &quot;Need&quot;, 
Assigned_Dealer__c &lt;&gt; NULL, 
Dealer_LMS__c == &quot;Yes&quot;, 
ISPICKVAL(CAC_Lead_Status__c,&quot;Qualified&quot;)
)</formula>
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
        <active>true</active>
        <description>Created by: Mouse Liu 
Used by: Lead__c (US-Lead-14) 
Function: update assigned date, recieved data and accepted date to now, and status to Accepted when Dealer LMS is No, Is Qualified is Qualified and Prefer Dealer is not null</description>
        <formula>OR( 
AND(RecordTypeId == &quot;01290000000rXmP&quot;, Need_Assign_To_Dealer__c == &quot;Need&quot;, Assigned_Dealer__c &lt;&gt; NULL, Dealer_LMS__c == &quot;No&quot;, Owner:Queue.Id &lt;&gt; &quot;00G90000001WVWA&quot;, ISPICKVAL(CAC_Lead_Status__c,&quot;Qualified&quot;) ), 
AND(RecordTypeId == &quot;01290000000rXmO&quot;, Assigned_Dealer__c &lt;&gt; NULL, Owner:Queue.Id &lt;&gt; &quot;00G90000001WVWA&quot;, ISPICKVAL(CAC_Lead_Status__c,&quot;Qualified&quot;) ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Test Drive Date Time</fullName>
        <actions>
            <name>Update_Proxy_Date_Time_to_Test_Drive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Test Drive&quot;)</formula>
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
        <formula>ISPICKVAL(Dealer_Lead_Status__c,&quot;Visited Showroom&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
