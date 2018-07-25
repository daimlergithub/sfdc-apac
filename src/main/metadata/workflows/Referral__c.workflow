<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_to_Dealer_when_referral_is_submitted</fullName>
        <description>Email notification to Dealer when referral is submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Email_address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>bbqreferraldonotreply@daimler.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BBQ_Email_Templates/Email_Notification_to_Dealer</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_referral_in_Japanese</fullName>
        <description>Email notification to referral in Japanese</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>bbqreferraldonotreply@daimler.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BBQ_Email_Templates/Email_notification_to_the_referral_in_Japanese</template>
    </alerts>
    <alerts>
        <fullName>an_email_will_be_sent_to_the_submitter_informing_that_the_referral_has_been_shar</fullName>
        <description>an email will be sent to the submitter informing that the referral has been shared with Mercedes Benz</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>bbqreferraldonotreply@daimler.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BBQ_Email_Templates/Email_notification_to_the_referral</template>
    </alerts>
    <rules>
        <fullName>Send Email to Dealer</fullName>
        <actions>
            <name>Email_notification_to_Dealer_when_referral_is_submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Referral__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Send Email to dealer when the referral is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Referral when status is submitted</fullName>
        <actions>
            <name>an_email_will_be_sent_to_the_submitter_informing_that_the_referral_has_been_shar</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Referral__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Referral__c.Market__c</field>
            <operation>notEqual</operation>
            <value>JP</value>
        </criteriaItems>
        <description>An email will be sent to the referral informing that the referral has been shared with Mercedes Benz</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Referral when status is submittedJP</fullName>
        <actions>
            <name>Email_notification_to_referral_in_Japanese</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Referral__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Referral__c.Market__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <description>send email to referral when referrral is shared with mercedes benz in JP</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
