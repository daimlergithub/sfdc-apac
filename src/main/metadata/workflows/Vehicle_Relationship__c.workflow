<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Warranty_Type_Task</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Vehicle_Relationship__c.Car_Relation__c</field>
            <operation>equals</operation>
            <value>Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vehicle_Relationship__c.Market__c</field>
            <operation>equals</operation>
            <value>TR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Vehicle_Relationship__c.End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Vehicle_Relationship__c.Purchase_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Vehicle_Relationship__c.Warranty_Type__c</field>
            <operation>equals</operation>
            <value>Service Plus</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Contact_Customer_on_Warranty_Change</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Vehicle_Relationship__c.Task_Limit__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Contact_Customer_on_Warranty_Change</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please contact the Customer to extend the Warranty.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Contact Customer on Warranty Change</subject>
    </tasks>
</Workflow>
