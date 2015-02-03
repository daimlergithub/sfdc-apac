<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">   
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
        <fullName>Status_Updated_Confirmed</fullName>
        <field>Y_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Status Updated Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
</Workflow>
