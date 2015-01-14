<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    
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
        <fullName>Update_First_Contact_Date_Time_to_Now</fullName>
        <field>First_Contact_Customer_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update First Contact Date Time to Now</name>
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
   
</Workflow>
