<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Apply_Status_Approved</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Apply Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Cancel_Application</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancel Application</literalValue>
        <name>Apply Status Cancel Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Cancelled</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Apply Status Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Confirmed</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Apply Status Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Status_Need_Modify</fullName>
        <field>Apply_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Apply Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feedback_Status_Approved</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Feedback Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feedback_Status_Confirmed</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>等待区域审批</literalValue>
        <name>Feedback Status Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feedback_Status_Need_Modify</fullName>
        <field>Feedback_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Feedback Status Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_Approved</fullName>
        <field>Y_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Updated Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_Confirmed</fullName>
        <field>Y_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Status Updated Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_Need_Modify</fullName>
        <field>Y_Status__c</field>
        <literalValue>Need Modify</literalValue>
        <name>Status Updated Need Modify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submit_Date_Updated</fullName>
        <field>Submit_Date__c</field>
        <formula>TODAY()</formula>
        <name>Submit Date Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BP_Status_to_Final_Submit</fullName>
        <field>BP_Status__c</field>
        <literalValue>Final Submit</literalValue>
        <name>Update BP Status to Final Submit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BP_Status_to_Region_Submit</fullName>
        <field>BP_Status__c</field>
        <literalValue>Region Submit</literalValue>
        <name>Update BP Status to Region Submit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BP_Status_to_Retail_Submit</fullName>
        <field>BP_Status__c</field>
        <literalValue>Retail Submit</literalValue>
        <name>Update BP Status to Retail Submit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Submit Date Updated</fullName>
        <actions>
            <name>Submit_Date_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.Apply_Status__c</field>
            <operation>equals</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BP Status to Final Submit</fullName>
        <actions>
            <name>Update_BP_Status_to_Final_Submit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail MB Best Practice,Retail smart Best Practice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.Final_Best_Practice__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.Final_Best_Practice_Forsmart__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update BP Status to Region Submit</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail MB Best Practice,Retail smart Best Practice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.BP_Region_Due_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.BP_Status__c</field>
            <operation>equals</operation>
            <value>Retail Submit</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_BP_Status_to_Region_Submit</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.BP_Region_Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update BP Status to Retail Submit</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Campaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retail MB Best Practice,Retail smart Best Practice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.BP_Retail_Due_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Retail_Campaign__c.BP_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_BP_Status_to_Retail_Submit</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Campaign__c.BP_Retail_Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动计划已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Campaign_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动计划需要调整后重新提交</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Yearly_TA_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的年度计划已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_Application_of_Yearly_TA_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的年度计划需要调整后重新提交</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Campaign_has_been_Approved_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动撤销申请已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_cancel_Application_of_Campaign_has_been_Rejected_by_Region</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动撤销申请已驳回</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Campaign_has_been_Approved_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>普通</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动反馈已审批通过</subject>
    </tasks>
    <tasks>
        <fullName>Please_note_that_your_feedback_Application_of_Campaign_has_been_Rejected_by_Regi</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>高</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>您的活动反馈需要调整后重新提交</subject>
    </tasks>
</Workflow>
