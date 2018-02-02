<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CustomerLabelName</fullName>
        <field>Customer_Label_Name__c</field>
        <formula>IF(TEXT(Address__r.TitleOfHonor__c)=&apos;To Person&apos;, Company_Name__c&amp; &apos; &apos;  &amp; LastName__c &amp; &apos; &apos;  &amp;FirstName__c , Company_Name__c )</formula>
        <name>CustomerLabelName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Duplicate_campaign_Member</fullName>
        <description>This will populate the value based on Segmentation Base field</description>
        <field>Duplicate_Campaign_Member__c</field>
        <formula>IF(NOT(ISBLANK(Campaign_ID__c)),
IF( AND(ISPICKVAL( Campaign_ID__r.Segmentation_Base__c , &apos;Customer&apos;) , NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Preferred_Dealer__c))), Campaign_ID__c + Contact_Id__c + Preferred_Dealer__c , IF(AND(ISPICKVAL(Campaign_ID__r.Segmentation_Base__c,&apos;Vehicle&apos;),NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Vehicle__c)),NOT(ISBLANK(Preferred_Dealer__c))), Campaign_ID__c+Contact_Id__c+Vehicle__c+Preferred_Dealer__c, IF(AND(ISPICKVAL(Campaign_ID__r.Segmentation_Base__c,&apos;Contract&apos;),NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Contract__c))), Campaign_ID__c+Contact_Id__c+Contract__c, &apos;&apos;))),
IF(NOT(ISBLANK(Retail_Campaign_Id__c)), 
IF(AND(ISPICKVAL(Retail_Campaign_Id__r.Segmentation_Base__c,&apos;Customer&apos;),NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Preferred_Dealer__c))),Retail_Campaign_Id__c+Contact_Id__c + Preferred_Dealer__c, IF(AND(ISPICKVAL(Retail_Campaign_Id__r.Segmentation_Base__c,&apos;Vehicle&apos;),NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Vehicle__c)),NOT(ISBLANK(Preferred_Dealer__c))), Retail_Campaign_Id__c+Contact_Id__c+Vehicle__c+Preferred_Dealer__c, IF(AND(ISPICKVAL(Retail_Campaign_Id__r.Segmentation_Base__c,&apos;Contract&apos;),NOT(ISBLANK(Contact_Id__c)),NOT(ISBLANK(Contract__c))), Retail_Campaign_Id__c+Contact_Id__c+Contract__c, &apos;&apos;) ) ) , &apos;&apos;))</formula>
        <name>Populate Duplicate campaign Member</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AutopopulateAddress</fullName>
        <actions>
            <name>CustomerLabelName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>MD__c =&apos;JP&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Avoid Duplicate campaign Member</fullName>
        <actions>
            <name>Populate_Duplicate_campaign_Member</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign_Member__c.MD__c</field>
            <operation>equals</operation>
            <value>JP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
