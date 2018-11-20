<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>News_Approval_Email_Alert</fullName>
        <description>News Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RCP_Email_Templates/NewsApprovedTemplate</template>
    </alerts>
    <alerts>
        <fullName>News_Approved_Email_Alert</fullName>
        <description>News Approved Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RCP_Email_Templates/NewsApprovedTemplate</template>
    </alerts>
    <alerts>
        <fullName>News_Rejection_Email_Alert</fullName>
        <description>News Rejection Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RCP_Email_Templates/News_Rejected_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_to_Approved</fullName>
        <description>This will update Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Pending</fullName>
        <description>This field update will update approval status to Pending</description>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Recalled</fullName>
        <description>Approval Status to Recalled</description>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Approval Status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_Rejected</fullName>
        <description>This will update Approval Status to Rejected</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_to_empty</fullName>
        <field>Approval_Status__c</field>
        <name>Approval Status to empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_to_Empty</fullName>
        <field>Document_Status__c</field>
        <name>Document Status to Empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_to_Pending_for_Approval</fullName>
        <description>Once News is Submitted for Approval Document Status will be moved to Pending for Approval</description>
        <field>Document_Status__c</field>
        <literalValue>Pending for Approval</literalValue>
        <name>Document Status to Pending for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_to_Published</fullName>
        <field>Document_Status__c</field>
        <literalValue>Published</literalValue>
        <name>Document Status to Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Document_Status_to_Ready_to_Publish</fullName>
        <description>This will update Document Status to Ready to Publish</description>
        <field>Document_Status__c</field>
        <literalValue>Ready to Publish</literalValue>
        <name>Document Status to Ready to Publish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expired_Field_Update</fullName>
        <field>Document_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Expired Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>News_Owner_Update</fullName>
        <description>Updating News owner when News is expired.</description>
        <field>OwnerId</field>
        <lookupValue>MBDINA_RCP_Admin</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>News Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Document_Status_to_Published</fullName>
        <description>Update Document Status to Published</description>
        <field>Document_Status__c</field>
        <literalValue>Published</literalValue>
        <name>Update Document Status to Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Document_Status_to_Recalled</fullName>
        <description>Updating Document Status to Recalled</description>
        <field>Document_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update Document Status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Document_Status_to_Rejected</fullName>
        <description>Updating Document Status to Rejected</description>
        <field>Document_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Document Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_News</fullName>
        <description>This will update record type to News</description>
        <field>RecordTypeId</field>
        <lookupValue>News</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to News</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_News_Afte_Approval</fullName>
        <description>This will update record type to News After Approval</description>
        <field>RecordTypeId</field>
        <lookupValue>News_After_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to News Afte Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_News_Approval</fullName>
        <description>This will update record type to News Approval</description>
        <field>RecordTypeId</field>
        <lookupValue>News_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to News Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Reminder_to_false</fullName>
        <field>Send_Reminder__c</field>
        <literalValue>0</literalValue>
        <name>Update Send Reminder to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Send_Reminder_to_true</fullName>
        <field>Send_Reminder__c</field>
        <literalValue>1</literalValue>
        <name>Update Send Reminder to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_mail_sent_to_false</fullName>
        <field>Mail_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Update mail sent to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>News doesn%27t need approval</fullName>
        <actions>
            <name>Update_Record_Type_to_News_Afte_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>News__c.Save_As_Draft__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>News__c.Need_Approval__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If news is not a draft and doesn&apos;t need approval then we are chaning record type to &quot;News After Approval&quot; recordtype.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Publish News based on Document Status Published</fullName>
        <active>true</active>
        <booleanFilter>1 AND 4 AND 5 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>News__c.Document_Status__c</field>
            <operation>equals</operation>
            <value>Ready to Publish</value>
        </criteriaItems>
        <criteriaItems>
            <field>News__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>News__c.Approval_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>News__c.Save_As_Draft__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>News__c.Start_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Update Document Status to Published based on criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Document_Status_to_Published</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>News__c.Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Approval Status if Record is edited</fullName>
        <actions>
            <name>Approval_Status_to_empty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Document_Status_to_Empty</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_mail_sent_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>We will update approval status to empty when record was already approved and edited</description>
        <formula>AND(  OR(ISPICKVAL(Approval_Status__c , &apos;Approved&apos;), ISPICKVAL(Approval_Status__c , &apos;&apos;) ),  OR( ISCHANGED( Title__c ), ISCHANGED( Start_Date__c ), ISCHANGED( Expiration_Date__c ),  ISCHANGED( Share_With_Groups__c ),  ISCHANGED( Category_Type__c ),  ISCHANGED( Save_As_Draft__c ),  ISCHANGED( Description__c ),  ISCHANGED( Remarks__c ), ISCHANGED( WorkFlow_Group__c ), ISCHANGED( Approver_List__c ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Expired Field</fullName>
        <active>true</active>
        <description>Expired Field Update when End date is greater than today</description>
        <formula>Expiration_Date__c  &gt;=  TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expired_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>News_Owner_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>News__c.Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
