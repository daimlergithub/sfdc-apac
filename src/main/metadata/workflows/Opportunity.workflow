<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Accepted_Date_Time_Update</fullName>
        <field>Accepted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Accepted Date Time_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_qualified_date_time_will_be_the_cur</fullName>
        <description>When the lead status is set to &quot;Qualified&quot; then the &quot;Lead qualified &quot; date time field need to be updated with current time</description>
        <field>Qualified_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Lead qualified date time will be the cur</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Order_Placed_Date_Update</fullName>
        <field>Order_Placed_Date__c</field>
        <formula>NOW()</formula>
        <name>Order Placed Date_Update</name>
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
        <fullName>Update_Assigned_Time</fullName>
        <description>When lead status = Assigned. Update the assigned time to current time</description>
        <field>Assigned_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Update Assigned Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Update_Dealer_Owner_Email</fullName>
        <field>Dealer_Owner_Email__c</field>
        <formula>Assigned_Dealer__r.Owner.Email</formula>
        <name>Update Dealer Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Escalated_flag</fullName>
        <description>After 24 hours of Assiged date, Escalated flag will be updated to true if Lead status is not Accepted</description>
        <field>Escalated_flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Lead Escalated flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lost_Date_Time</fullName>
        <description>When the lead status is set to &quot;Lost&quot; then the &quot;Lead Lost &quot; date time field will be updated with current time</description>
        <field>Lost_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Lost Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Purchase_Date</fullName>
        <description>When status is Closed Won, the purchase date need to be updated</description>
        <field>Purchase_Date__c</field>
        <formula>Now()</formula>
        <name>Update Purchase Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Lead status %3D assigned then Assigned Time will be updated</fullName>
        <actions>
            <name>Update_Assigned_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When status is assigned the Assigned Time will be updated</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Assigned&apos;),$Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Assigned date</fullName>
        <actions>
            <name>Populate_Assigned_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(CONTAINS($Profile.Name , &apos;Partner Community&apos;),  MD__c = &apos;IN&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Need To Be Created</fullName>
        <actions>
            <name>Follow_up</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>If a preferred contact date is added, then a task needs to be created for that user for that day</description>
        <formula>AND($Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;, NOT(ISNULL(Preferred_Contact_Time__c)),ISCHANGED(Preferred_Contact_Time__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Accepted Date Time</fullName>
        <actions>
            <name>Accepted_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(StageName, &apos;Accepted&apos;),$Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
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
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Aftersales Lead</value>
        </criteriaItems>
        <description>Update Dealer After sales Manager and Dealer Owner Email Field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Escalated flag</fullName>
        <active>true</active>
        <description>Update Lead Escalated flag if an assigned opportunity is not accepted in 24 hours</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Assigned&apos;),$Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;,ISNULL(Accepted_Date_Time__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Lead_Escalated_flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Assigned_Date_Time__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Lead Qualified Date Time</fullName>
        <actions>
            <name>Lead_qualified_date_time_will_be_the_cur</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update qualified date when status is made qualified</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Qualified&apos;), ISNULL(Qualified_Date_Time__c), $Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lost Date Time</fullName>
        <actions>
            <name>Update_Lost_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the lead status is set to &quot;Lost&quot; then the &quot;Lead Lost &quot; date time field need to be updated with current time</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Closed Lost&apos;), ISNULL(Lost_Date__c),$Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Order Placed Date</fullName>
        <actions>
            <name>Order_Placed_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update order placed date when status is made Order placed</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Order placed&apos;), ISNULL(Order_Placed_Date__c), $Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Purchase Date</fullName>
        <actions>
            <name>Update_Purchase_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When status is made Closed Won, the purchase date need to be updated</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Closed Won&apos;), ISNULL(Purchase_Date__c),$Permission.INGeneric,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_up</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.Preferred_Contact_Time__c</offsetFromField>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Follow up</subject>
    </tasks>
</Workflow>
