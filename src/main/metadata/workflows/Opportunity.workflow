<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Escalation_Mail_To_Manager_IN</fullName>
        <description>Send Escalation Mail To Manager IN</description>
        <protected>false</protected>
        <recipients>
            <recipient>MBIndiaFS_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/FS_Lead_Escalation_After_3_Working_Days_IN</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Dealer_Gatekeeper_Lead</fullName>
        <description>Email to Dealer Gatekeeper Lead</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Assign_to_Dealer_Gatekeeper_Opportunity_TR</template>
    </alerts>
    <alerts>
        <fullName>TDS_Survey_Auto_email_upon_Lead_Status</fullName>
       
        <description>TDS Survey Auto-email upon Lead Status</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_eMail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TR_Lead_Survey_Template</template>
    </alerts>
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
		<fullName>Change_Opp_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>mbtrsupport@customercontact.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Opp Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date</fullName>
        <description>Update closed date based on rule&apos;s condition for IN</description>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Stage_ClosedWon</fullName>
        <description>Update to closed won</description>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Stage ClosedWon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_Date_Time_OPP</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Assigned Date Time_OPP</name>
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
        <fullName>Update_Lead_Email</fullName>
        <description>Update Email from Account</description>
        <field>Lead_eMail__c</field>
        <formula>Account.Email__c</formula>
        <name>Update_Lead_Email</name>
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
        <fullName>Update_Lead_Mobile</fullName>
        <description>Update Lead Mobile from Account</description>
        <field>Lead_Mobile__c</field>
        <formula>Account.Mobile__c</formula>
        <name>Update_Lead_Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
    <fieldUpdates>
        <fullName>Update_Receieved_date_time_OPP</fullName>
        <field>Received_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update Receieved date time_OPP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Accepted_date_time_OPP</fullName>
        <field>Accepted_Date_Time__c</field>
        <formula>now()</formula>
        <name>update Accepted date time_OPP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_dealer_assigned_date_time_OPP</fullName>
        <field>Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>update dealer assigned date time_OPP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ANZ_Update_Lead_Mobile_Email_From_Account</fullName>
        <actions>
            <name>Update_Lead_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Market__c</field>
            <operation>equals</operation>
            <value>AU,NZ</value>
        </criteriaItems>
        <description>Copy Lead mobile Detail from account</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign_Lead_to_CallCenter_Supervisor</fullName>
        <actions>
            <name>Change_Opp_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Please_Contact_the_Lead</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Market__c, &apos;TR&apos;) ,
OR( ISPICKVAL( Lead_DataSource__c , &apos;Facebook&apos;),
ISPICKVAL(Lead_DataSource__c , &apos;Instagram&apos;),
ISPICKVAL(Lead_DataSource__c , &apos;Insurance&apos;) ),
 Owner.Alias = &apos;iinf&apos;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Email To Dealer GateKeeper</fullName>
        <actions>
            <name>Email_to_Dealer_Gatekeeper_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This flow is used to send email to dealer gatekeper. This is on case object when dealer account associated with the case and that dealers account contact (gate keeper) becomes the new owner of the case.</description>
        <formula>NOT(ISNULL( Assigned_Dealer__c )) &amp;&amp; ISCHANGED(Assigned_Dealer__c ) &amp;&amp; PRIORVALUE(OwnerId) != OwnerId &amp;&amp;  ISPICKVAL(Market__c, &apos;TR&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>	
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
        <fullName>Reassigned Lead %28Reverse Forwarding%29</fullName>
        <active>true</active>
        <formula>AND(ISPICKVAL(CAC_Lead_Status__c ,&apos;New&apos;),OR(MD__c =&apos;TH&apos;, ISPICKVAL(Market__c,&apos;TR&apos;)),OR(RecordType.Name =&apos;Sales Lead&apos;,RecordType.Name=&apos;Aftersales Lead&apos;), Assigned_Dealer__c &lt;&gt; NULL)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Assigned_Date_Time_OPP</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Receieved_date_time_OPP</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>update_Accepted_date_time_OPP</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity.Assigned_Date_Time__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TDS Survey Auto-email upon Lead Status</fullName>
        <actions>
            <name>TDS_Survey_Auto_email_upon_Lead_Status</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Market__c, &apos;TR&apos;),
NOT(ISPICKVAL(PRIORVALUE(StageName), &apos;Test drive completed&apos;) ) ,
 ISPICKVAL(StageName, &apos;Test drive completed&apos;)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Need To Be Created</fullName>
        <actions>
            <name>Follow_up</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>If a preferred contact date is added, then a task needs to be created for that user for that day</description>
        <formula>AND($Permission.INGeneric,     $Profile.Name != &apos;IntegrationAPI&apos;,     NOT(ISNULL(Preferred_Contact_Time__c)),     OR((ISCHANGED(Preferred_Contact_Time__c)),      ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Accepted Date Time</fullName>
        <actions>
            <name>Accepted_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To update Accepted Date Time field with current date time value when StageName is changed to Accepted</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Accepted&apos;),OR($Permission.INGeneric,$Permission.TRGeneric),$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed Date</fullName>
        <actions>
            <name>Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used for IN market to update closed date when status changed to closed won/lost</description>
        <formula>AND(OR(ISPICKVAL(StageName, &apos;Closed Won&apos;),ISPICKVAL(StageName, &apos;Closed Lost&apos;)),OR(ISPICKVAL(Market__c, &apos;IN&apos;),ISPICKVAL(Market__c, &apos;TR&apos;)))</formula>
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
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Aftersales Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market__c</field>
            <operation>equals</operation>
            <value>TR</value>
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
        <formula>AND(ISPICKVAL(StageName, &apos;Qualified&apos;), ISNULL(Qualified_Date_Time__c),  OR($Permission.INGeneric,$Permission.AUGeneric,$Permission.NZGeneric,$Permission.TRGeneric), $Profile.Name != &apos;IntegrationAPI&apos;)</formula>
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
        <formula>AND(ISPICKVAL(StageName, &apos;Closed Lost&apos;), ISNULL(Lost_Date__c),OR($Permission.INGeneric,$Permission.TRGeneric),$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
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
        <fullName>WF_Opportunity_Escalation_IN</fullName>
        <active>true</active>
        <formula>AND(
	ISPICKVAL(StageName,&apos;New&apos;),
        $RecordType.Name = &quot;Finance Lead&quot;,
	$Permission.INGeneric,
	$Profile.Name != &apos;IntegrationAPI&apos;, 
	NOT(ISNULL(Opp_SLA_Time__c))
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Escalation_Mail_To_Manager_IN</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Opp_SLA_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Purchase Date</fullName>
        <actions>
            <name>Update_Purchase_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When status is made Closed Won, the purchase date need to be updated</description>
        <formula>AND(ISPICKVAL(StageName, &apos;Closed Won&apos;), ISNULL(Purchase_Date__c),OR($Permission.INGeneric,$Permission.TRGeneric),$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update dealer assigned datetime</fullName>
        <actions>
            <name>update_dealer_assigned_date_time_OPP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Assigned_Dealer__c &lt;&gt;null, ISPICKVAL(Market__c, &apos;TR&apos;) ,or(RecordType.Name=&apos;Sales Lead&apos;,RecordType.Name=&apos;Aftersales Lead&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update stage to Closed Won ANZ</fullName>
        <actions>
            <name>Stage_ClosedWon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Invoiced</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Market__c</field>
            <operation>equals</operation>
            <value>AU,NZ</value>
        </criteriaItems>
        <description>update Stage &apos;Invoiced&apos; are updated to &apos;Closed Won&apos; stage as per MBANZ-150</description>
        <triggerType>onAllChanges</triggerType>
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
    <tasks>
        <fullName>Please_Contact_the_Lead</fullName>
        <assignedTo>mbtrsupport@customercontact.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please contact the Lead.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>General</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Please Contact the Lead</subject>
    </tasks>
</Workflow>
