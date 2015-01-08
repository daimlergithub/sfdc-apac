<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>User_Story_Acceptance_Criteria_has_been_changed</fullName>
        <description>User Story Acceptance Criteria has been changed</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Requirement_Follow_Up_Test_Team</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Unique_Id</fullName>
        <field>Req_Unique_Id__c</field>
        <formula>Name</formula>
        <name>Update Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Requirement Unique Id</fullName>
        <actions>
            <name>Update_Unique_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED( Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
