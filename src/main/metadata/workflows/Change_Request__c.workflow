<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Change_Request_Assignment_Notification</fullName>
        <description>Change Request Assignment Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Assign_to__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_Deployment__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_External__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_Migration__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_Other__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_SFDC_App_Dev_Respond__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person_Testing__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Respond_Person__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_Impact</fullName>
        <description>Change Request Assignment Notification Impact EP</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactBR</fullName>
        <description>Change Request Assignment Notification Impact BR</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactDeployment</fullName>
        <description>Change Request Assignment Notification Impact Deployment</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_Deployment__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactExternal</fullName>
        <description>Change Request Assignment Notification Impact External</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_External__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactMigration</fullName>
        <description>Change Request Assignment Notification Impact Migration</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_Migration__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactOther</fullName>
        <description>Change Request Assignment Notification Impact Other</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_Other__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactSFDCAppDev</fullName>
        <description>Change Request Assignment Notification Impact SFDC App/Dev</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_SFDC_App_Dev_Respond__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <alerts>
        <fullName>Change_Request_Assignment_Notification_ImpactTesting</fullName>
        <description>Change Request Assignment Notification Impact Testing</description>
        <protected>false</protected>
        <recipients>
            <field>Respond_Person_Testing__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Change_Request_Assignment_Notification_Impact</template>
    </alerts>
    <rules>
        <fullName>Change Request Assignment Notification</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Assign_to__c )||ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for BR</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactBR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( User__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for Deployment</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactDeployment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Respond_Person_Deployment__c   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for EP App%2FDev</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_Impact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Respond_Person__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for External</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactExternal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Respond_Person_External__c    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for Migration</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactMigration</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Respond_Person_Migration__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for Other</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactOther</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Respond_Person_Other__c     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for SFDC App%2FDev</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactSFDCAppDev</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Respond_Person_SFDC_App_Dev_Respond__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Request Assignment Notification for Testing</fullName>
        <actions>
            <name>Change_Request_Assignment_Notification_ImpactTesting</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(  Respond_Person_Testing__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
