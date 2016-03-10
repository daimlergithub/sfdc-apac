<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_To_Notify_To_Fleet_Vans_on_Order_Task_Creation</fullName>
        <description>Email To Notify To Fleet Vans on Order Task Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Fleet_Delete</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Order_notification_email</template>
    </alerts>
    <alerts>
        <fullName>Email_To_Notify_To_Fleet_Vans_on_Quote_Task_Creation</fullName>
        <description>Email To Notify To Fleet Vans on Quote Task Creation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Fleet_Delete</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_notification_email</template>
    </alerts>
    <rules>
        <fullName>Notify_To_Fleet_Vans_on_Customer_Contact_Task_Creation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead_Product__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead_Product__c.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <description>Once Customer Contact is created as Task with record type as Customer Contact an email alert will be sent to Fleet-MBaup (Delete) users</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify_To_Fleet_Vans_on_Order_Task_Creation</fullName>
        <actions>
            <name>Email_To_Notify_To_Fleet_Vans_on_Order_Task_Creation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead_Product__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead_Product__c.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <description>Once Order is created as Task with record type as Order an email alert will be sent to Fleet-MBaup (Delete) users</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify_To_Fleet_Vans_on_Quote_Task_Creation</fullName>
        <actions>
            <name>Email_To_Notify_To_Fleet_Vans_on_Quote_Task_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead_Product__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Quote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead_Product__c.MD__c</field>
            <operation>equals</operation>
            <value>AU</value>
        </criteriaItems>
        <description>Once Quote is created as Task with record type as Quote an email alert will be sent to Fleet-MBaup (Delete) users.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
