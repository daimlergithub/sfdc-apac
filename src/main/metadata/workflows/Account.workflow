<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dealer_Email_Notification_on_Amount_of_Assigned_Leads</fullName>
        <description>Dealer Email Notification on Amount of Assigned Leads</description>
        <protected>false</protected>
        <recipients>
            <field>Dealer_Lead_Gate_Keeper__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Template/Dealer_Email_Notification_of_Everyday_Assigned_Leads_Amount</template>
    </alerts>
	<fieldUpdates>
        <fullName>Agreement_Date_for_Marketing_Consent_fie</fullName>
        <field>Agreement_Date_for_Marketing_Consent__c</field>
        <formula>TODAY()</formula>
        <name>Agreement Date for Marketing Consent fie</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Agreement_date_Update</fullName>
        <field>Agreement_Date_for_Contact_Method__c</field>
        <formula>Today()</formula>
        <name>Agreement date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Agreement_date_for_CC_New_field_update</fullName>
        <field>Agreement_Date_for_CC_New__c</field>
        <formula>TODAY()</formula>
        <name>Agreement date for CC New field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Agreement_date_for_CC_old_field_update</fullName>
        <field>Agreement_Date_for_CC_Old__c</field>
        <formula>TODAY()</formula>
        <name>Agreement date for CC old field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Agreement_date_service_24hfield_update</fullName>
        <field>Agreement_Date_for_Service_24h_Consent__c</field>
        <formula>TODAY()</formula>
        <name>Agreement date service 24hfield update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Allow_Data_Sharing_to_NO_for_KR</fullName>
        <field>Allow_Data_Sharing2__c</field>
        <literalValue>No</literalValue>
        <name>Allow Data Sharing to NO for KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Preferred_Phone</fullName>
        <field>Preferred_Phone__c</field>
        <name>Change Preferred Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>	
	<fieldUpdates>
        <fullName>Change_Status_To_Prospect</fullName>
        <field>Status__c</field>
        <literalValue>Prospect</literalValue>
        <name>Change Status To Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Source_field_update</fullName>
        <description>Added DataSource as Dealer Outlet</description>
        <field>Data_Source__c</field>
        <literalValue>Dealer Outlet</literalValue>
        <name>Data Source field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Consent_Date</fullName>
        <field>First_Consent_Date__c</field>
        <formula>Today()</formula>
        <name>First Consent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Consent_User</fullName>
        <field>First_Consent_User__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>First Consent User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HomePhone_Update</fullName>
        <field>Individual_Home_Phone__c</field>
        <formula>IF(ISNEW() &amp;&amp; NOT(ISBLANK(Individual_Home_Phone__c)), &apos;+66&apos; + Individual_Home_Phone__c, IF(NOT(ISBLANK(Individual_Home_Phone__c)) &amp;&amp; LEFT(Individual_Home_Phone__c,3) &lt;&gt; &apos;+66&apos;,&apos;+66&apos; + Individual_Home_Phone__c,Individual_Home_Phone__c))</formula>
        <name>HomePhone_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBTH_UpdateDataSource</fullName>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>MBTH_UpdateDataSource</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBTH_UpdatedConsentUser</fullName>
        <field>Updated_Consent_User__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>MBTH_UpdatedConsentUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBTH_Updated_Consent_Date</fullName>
        <field>Updated_Consent_Date__c</field>
        <formula>TODAY()</formula>
        <name>MBTH_Updated Consent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mobile_Update</fullName>
        <field>Mobile__c</field>
        <formula>IF(ISNEW() &amp;&amp; NOT(ISBLANK(Mobile__c)), &apos;+66&apos; + Mobile__c, IF(NOT(ISBLANK(Mobile__c)) &amp;&amp; LEFT(Mobile__c,3) &lt;&gt; &apos;+66&apos;,&apos;+66&apos; + Mobile__c,Mobile__c))</formula>
        <name>Mobile_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mobile_phone_checkbox_update</fullName>
        <field>Mobile_Phone_Checkbox__c</field>
        <literalValue>1</literalValue>
        <name>Mobile phone checkbox update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Tel_Display_field_auto_populate</fullName>
        <field>Primary_Phone_Display__c</field>
        <formula>Mobile__c</formula>
        <name>&apos;Sales Tel Display&apos; field auto populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Tel_Display_field_auto_populate_Co</fullName>
        <field>Primary_Phone_Display__c</field>
        <formula>IF(Mobile__c!=NULL,Mobile__c,IF(Individual_Home_Phone__c!=NULL,Individual_Home_Phone__c,IF(Work_Phone__c!=NULL,Work_Phone__c,Work_Phone_2__c)))</formula>
        <name>&apos;Sales Tel Display&apos; field auto populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Tel_field_auto_populate</fullName>
        <field>Primary_Phone__c</field>
        <literalValue>Home Phone</literalValue>
        <name>&apos;Sales Tel &apos; field auto populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Tel_field_auto_populate_Mobile</fullName>
        <field>Primary_Phone__c</field>
        <literalValue>Mobile</literalValue>
        <name>&apos;Sales Tel&apos; field auto populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Tel_field_personaccount</fullName>
        <field>Primary_Phone__c</field>
        <literalValue>Mobile</literalValue>
        <name>&apos;Sales Tel&apos; field auto populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	
	<fieldUpdates>
        <fullName>Status_Deceased</fullName>
        <description>On selecting the checkbox  Deceased and saving the record, it updates the status of customer is updated as &apos;Deceased&apos;</description>
        <field>Status__c</field>
        <literalValue>Unknown</literalValue>
        <name>Status Deceased</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	
    <fieldUpdates>
        <fullName>System_Data_Source</fullName>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>System Data Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>	
    <fieldUpdates>
        <fullName>UpdateData_Source_to_Others</fullName>
        <field>Data_Source__c</field>
        <literalValue>Others</literalValue>
        <name>UpdateData Source to Others</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Data_Source_2</fullName>
        <description>System Data Source equals to Salesforce</description>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>System Data Source 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDataSource</fullName>
        <field>System_Data_Source__c</field>
        <formula>&apos;Salesforce&apos;</formula>
        <name>UpdateDataSource</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Allow_Data_Sharing</fullName>
        <description>Set Allow Data Sharing to &apos;Yes&apos;</description>
        <field>Allow_Data_Sharing2__c</field>
        <literalValue>Yes</literalValue>
        <name>Update Allow Data Sharing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Company_Name</fullName>
        <field>Company_Name__c</field>
        <formula>Name</formula>
        <name>Update Company Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Consent_Date</fullName>
        <description>Update Consent Date to Today&apos;s date</description>
        <field>Updated_Consent_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Consent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Consent_User</fullName>
        <description>Update Consent User as the current username</description>
        <field>Updated_Consent_User__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>Update Consent User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Country_Field_AU</fullName>
        <field>Country__c</field>
        <literalValue>Australia</literalValue>
        <name>Update Country Field AU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Field_JP</fullName>
        <field>Country__c</field>
        <literalValue>Japan</literalValue>
        <name>Update Country Field JP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Field_KR</fullName>
        <field>Country__c</field>
        <literalValue>South Korea</literalValue>
        <name>Update Country Field KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Field_MY</fullName>
        <field>Country__c</field>
        <literalValue>Malaysia</literalValue>
        <name>Update Country Field MY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>update_data_source_Retail_added</fullName>
        <field>Data_Source__c</field>
        <literalValue>Retailer added</literalValue>
        <name>update data source Retail addded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>update_data_source</fullName>
        <description>If the customer number sequence is 
• If customer number is between 1 - 10,000,000 = Wholesale added 
• If customer number is between 60,000,000 – 80,000,000 = Wholesale added</description>
        <field>Data_Source__c</field>
        <literalValue>Wholesale added</literalValue>
        <name>update data source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>Update_Country_Field_NZ</fullName>
        <field>Country__c</field>
        <literalValue>New Zealand</literalValue>
        <name>Update Country Field NZ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_Field_TH</fullName>
        <field>Country__c</field>
        <literalValue>Thailand</literalValue>
        <name>Update Country Field TH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_LastUpdatedDate</fullName>
        <field>Customer_LastUpdatedDate__c</field>
        <formula>Now()</formula>
        <name>Update Customer LastUpdatedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Preferred_Language_Field_JP</fullName>
        <field>Preferred_Language__c</field>
        <literalValue>Japanese</literalValue>
        <name>Update Preferred Language Field JP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Preferred_Language_Field_KR</fullName>
        <field>Preferred_Language__c</field>
        <literalValue>Korean</literalValue>
        <name>Update Preferred Language Field KR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Preferred_Language_Field_MY</fullName>
        <field>Preferred_Language__c</field>
        <literalValue>English</literalValue>
        <name>Update Preferred Language Field MY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Preferred_Language_Field_TH</fullName>
        <field>Preferred_Language__c</field>
        <literalValue>Thai</literalValue>
        <name>Update Preferred Language Field TH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatedConsentUser</fullName>
        <field>Updated_Consent_User__c</field>
        <formula>$User.Username</formula>
        <name>UpdatedConsentUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WorkPhone_Update</fullName>
        <field>Work_Phone__c</field>
        <formula>IF(ISNEW() &amp;&amp; NOT(ISBLANK(Work_Phone__c)), &apos;+66&apos; + Work_Phone__c, IF(NOT(ISBLANK(Work_Phone__c)) &amp;&amp; LEFT(Work_Phone__c,3) &lt;&gt; &apos;+66&apos;,&apos;+66&apos; + Work_Phone__c,Work_Phone__c))</formula>
        <name>WorkPhone_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>field_auto_populate_for_comany_account</fullName>
        <field>home_Phone_Checkbox__c</field>
        <literalValue>1</literalValue>
        <name>field auto populate for comany account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>sales_Tel_picklist_value</fullName>
        <field>Primary_Phone__c</field>
        <literalValue>Work Phone</literalValue>
        <name>sales Tel picklist value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>workphone_checkbox_to_true</fullName>
        <field>Work_Phone_Checkbox__c</field>
        <literalValue>1</literalValue>
        <name>workphone checkbox to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>MBMY_Race_to_Special_Care</fullName>
        <field>Special_Care__c</field>
        <formula>TEXT(Race__c)</formula>
        <name>MBMY Account Race to Special Care</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<rules>
        <fullName>MBMY_Copy Race to Special Care</fullName>
        <actions>
            <name>MBMY_Race_to_Special_Care</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To Copy race to special care for MY Market</description>
        <formula>AND(Special_Care__c != TEXT(Race__c), MD__c == &apos;MY&apos;,$Profile.Name != &apos;IntegrationAPI&apos;,$Permission.MYGeneric, RecordType.Name == 'Person Account'  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>%27Sales Tel Display%27 field should be auto-populated with the %27Mobile%27 number</fullName>
        <actions>
            <name>Sales_Tel_Display_field_auto_populate_Co</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>e>
    </rules>
    <rules>
        <fullName>%27Sales Tel Display%27 field should be auto-populated with the %27Mobile%27 number for Person Account Record Type</fullName>
        <actions>
            <name>Sales_Tel_Display_field_auto_populate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Tel_field_personaccount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Mobile__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__pc</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Agreement date CC New field update</fullName>
        <actions>
            <name>Agreement_date_for_CC_New_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(General_Personal_Information_Mandatory__c,&apos;&apos;)),NOT(ISPICKVAL(General_Personal_Information_Optional__c ,&apos;&apos;)),NOT(ISPICKVAL( Unique_Identification_Info_Mandatory__c,&apos;&apos;)),NOT(ISPICKVAL(General_Personal_InfoThirdParty_Optional__c,&apos;&apos;)),NOT(ISPICKVAL(Unique_Identity_Info_ThirdParty_Optional__c,&apos;&apos;)),NOT(ISPICKVAL(Targeted_Advertising_Info_Optional__c,&apos;&apos;)),ISBLANK(PRIORVALUE(Agreement_Date_for_CC_New__c)) ,MD__c == &apos;KR&apos;,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Agreement date field update</fullName>
        <actions>
            <name>Agreement_date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(Personal_Agreement__c,&apos;&apos;)),NOT(ISPICKVAL(Personal_Information_Third_Party_Release__c ,&apos;&apos;)),NOT(ISPICKVAL( Agreement_to_commit_info_processing__c,&apos;&apos;)),NOT(ISPICKVAL(Personal_Abroad_Agreement__c,&apos;&apos;)),ISBLANK(PRIORVALUE(Agreement_Date_for_Contact_Method__c)) ,MD__c == &apos;KR&apos;,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Agreement date for CC old field update</fullName>
        <actions>
            <name>Agreement_date_for_CC_old_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(Personal_Agreement_CC_Old__c,&apos;&apos;)),NOT(ISPICKVAL(Personal_Info_Third_Party_Release_CC_Old__c,&apos;&apos;)),NOT(ISPICKVAL(Agreement_to_commit_info_proces_CC_Old__c,&apos;&apos;)),NOT(ISPICKVAL(Personal_Abroad_Agreement_CC_Old__c,&apos;&apos;)),ISBLANK(PRIORVALUE(Agreement_Date_for_CC_Old__c)) ,MD__c == &apos;KR&apos;,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Agreement date for marketing consent field update</fullName>
        <actions>
            <name>Agreement_Date_for_Marketing_Consent_fie</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(General_Personal_Info_Mandatory__c,&apos;&apos;)),NOT(ISPICKVAL(Person_Agree_Test_Driving_Optional__c ,&apos;&apos;)),NOT(ISPICKVAL( Person_Info_Custom_Service_Optional__c,&apos;&apos;)),NOT(ISPICKVAL(Targeted_Advert_Info_Optional_STCCC__c,&apos;&apos;)),ISBLANK(PRIORVALUE(Agreement_Date_for_Marketing_Consent__c)) ,MD__c == &apos;KR&apos;,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Agreement date service 24h field update</fullName>
        <actions>
            <name>Agreement_date_service_24hfield_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL(Personal_Agreement_Service_24h__c,&apos;&apos;)),ISBLANK(PRIORVALUE(Agreement_Date_for_Service_24h_Consent__c)) ,MD__c == &apos;KR&apos;,$Profile.Name != &apos;IntegrationAPI&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>Change Account Status To Prospect</fullName>
        <actions>
            <name>Change_Status_To_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will Change Account Status To Prospect for thailand accounts at the time of create depends on vehicle amount</description>
        <formula>AND(OR(ISBLANK(Vehicle_Amount__c ),Vehicle_Amount__c  = 0 ),MD__c=&apos;TH&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Change Preferred phone to null</fullName>
        <actions>
            <name>Change_Preferred_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When field “Preferred contact method” value is set to others from “Phone”,the field value changes to null</description>
        <formula>AND( ISPICKVAL(PRIORVALUE( Preferred_Contact_Method__c ),&apos;Phone&apos;), NOT(ISPICKVAL(Preferred_Contact_Method__c, &apos;Phone&apos;))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Home Phone Checkbox autopopulate</fullName>
        <actions>
            <name>Sales_Tel_field_auto_populate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>field_auto_populate_for_comany_account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Account.Mobile__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Individual_Home_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
<rules>
        <fullName>MBANZ Customer Update as Deceased</fullName>
        <actions>
            <name>Status_Deceased</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Deceased__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Market__c</field>
            <operation>equals</operation>
            <value>AU,NZ</value>
        </criteriaItems>
        <description>if &apos;Deceased&apos; checked, and saving the record, it updates the status of customer is updated as &apos;Deceased&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
	
	
	 <rules>
        <fullName>MBAU update data source_Retailer added</fullName>
        <actions>
            <name>update_data_source_Retail_added</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5) AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-5</value>
        </criteriaItems>
		 <criteriaItems>
            <field>Account.Market__c</field>
            <operation>contains</operation>
            <value>AU,NZ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Company,Person Account</value>
        </criteriaItems>
        <description>If the customer number sequence is 
• If customer number is between 10,000,001 – 59,999,999  = Retailer added</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBAU update data source_wholesale added</fullName>
        <actions>
            <name>update_data_source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4) AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-6</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-7</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>startsWith</operation>
            <value>C-8</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Number__c</field>
            <operation>notContain</operation>
            <value>C-1</value>
        </criteriaItems>
		<criteriaItems>
            <field>Account.Market__c</field>
            <operation>contains</operation>
            <value>AU,NZ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Company,Person Account</value>
        </criteriaItems>
        <description>If the customer number sequence is 
• 1 to 10000000 this is mapped to Wholesale added
• 60000000 to 80000000  this is mapped to Wholesale added</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    
    <rules>
        <fullName>MBK Populate Company Name</fullName>
        <actions>
            <name>Update_Company_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used to populate company name with account name when record type is company</description>
        <formula>IF((RecordType.Name == &apos;Company&apos;) &amp;&amp; (TEXT( $User.Market__c)==&apos;KR&apos;), true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBTH_Add_Plus_66</fullName>
        <actions>
            <name>HomePhone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Mobile_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WorkPhone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow is the prefix +66 to all phone numbers</description>
        <formula>OR(CreatedBy.Profile.Name = &apos;IntegrationAPI&apos;, LastModifiedBy.Profile.Name = &apos;IntegrationAPI&apos;) &amp;&amp; OR(ISNEW(), OR(ISCHANGED(Mobile__c),ISCHANGED(Work_Phone__c),ISCHANGED(Individual_Home_Phone__c))) &amp;&amp; MD__c = &apos;TH&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBTH_Update_Consent_data_Source</fullName>
        <actions>
            <name>First_Consent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>First_Consent_User</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Data_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Consent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Consent_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Data Source,First Consent User and First Consent Date when Personal_Agreement__c is &quot;No&quot;</description>
        <formula>AND( ISPICKVAL(Personal_Agreement__c , &apos;No&apos;), MD__c = &apos;TH&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBTH_Update_Consent_data_Source_2</fullName>
        <actions>
            <name>System_Data_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Data_Source_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Consent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Consent_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Data Source,Update Consent User and Update Consent Date when Personal_Agreement__c is &quot;Yes&quot;</description>
        <formula>AND( ISPICKVAL(Personal_Agreement__c , &apos;Yes&apos;), MD__c = &apos;TH&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBTH_Update_consent_Information</fullName>
        <actions>
            <name>MBTH_UpdateDataSource</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MBTH_UpdatedConsentUser</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MBTH_Updated_Consent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Personal_Agreement__c</field>
            <operation>equals</operation>
            <value>Withdrawn</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>TH</value>
        </criteriaItems>
        <description>If personal agreement value change to ‘Withdrawn’ by dealer then will update the updated consent date and updated consent user field and also source field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mobile Phone Checkbox autopopulate</fullName>
        <actions>
            <name>Mobile_phone_checkbox_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Tel_field_auto_populate_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Account.Mobile__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Assigned Leads to Dealer Everyday</fullName>
        <actions>
            <name>Dealer_Email_Notification_on_Amount_of_Assigned_Leads</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>/* 
Created by: Mouse Liu 
Used by: Lead__c (US-Lead-14) 
Function: Send Assigned Dealer Amount to dealer everyday
Used in: 

Modify History 
Modify By: 
Modify Reason: 
*/</description>
        <formula>AND (     Assigned_Lead_Amount_of_Everyday__c &gt; 0,     ISCHANGED(Assigned_Lead_Amount_of_Everyday__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Allow Data Sharing</fullName>
        <actions>
            <name>Update_Allow_Data_Sharing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Personal_Information_Third_Party_Release__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Personal_Agreement__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Agreement_to_commit_info_processing__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <description>Update Allow Data Sharing KR based on Agreement fields.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Allow data sharing to %27No%27</fullName>
        <actions>
            <name>Allow_Data_Sharing_to_NO_for_KR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Allow data sharing to &apos;No&apos; for KR Market</description>
        <formula>AND(MD__c=&quot;KR&quot;, OR (NOT(ISPICKVAL(Personal_Information_Third_Party_Release__c,&quot;Yes&quot;)) ,NOT(ISPICKVAL(Personal_Agreement__c,&quot;Yes&quot;)) ,NOT(ISPICKVAL(Agreement_to_commit_info_processing__c,&quot;Yes&quot;))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer LastUpdatedDate when I%2FF fields changed</fullName>
        <actions>
            <name>Update_Customer_LastUpdatedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(
ISCHANGED( RecordTypeId),ISCHANGED(Gender__c),ISCHANGED( FirstName ),ISCHANGED( LastName ),ISCHANGED( FirstName_Native_1__c ),
ISCHANGED( LastName_Native_1__c ),ISCHANGED( Company_Name__c ),ISCHANGED( Company_Name_Native_1__c ), ISCHANGED( Company_Legal_Form__c ),
ISCHANGED( Company_Legal_Form_text__c ),ISCHANGED( Legal_Form_Position__c ),ISCHANGED( PersonBirthdate ), ISCHANGED( Foundation_Date__c ),
ISCHANGED( Mobile__c ), ISCHANGED( Individual_Home_Phone__c ), ISCHANGED( Mobile2__c ), ISCHANGED( Work_Phone__c ), ISCHANGED( Home_Phone_2__c ),
ISCHANGED( Phone ), ISCHANGED( Fax ), ISCHANGED( Fax2__c ), ISCHANGED( Email3__c ),ISCHANGED( Primary_Phone__c ), ISCHANGED( Primary_Fax__c ), ISCHANGED(Primary_Address_Reference__c),
ISCHANGED(Main_Dealer__c)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Preferred Language and Country JP</fullName>
        <actions>
            <name>Update_Country_Field_JP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Preferred_Language_Field_JP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for JP</description>
        <formula>ISPICKVAL($User.Market__c,&apos;JP&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
	<rules>
        <fullName>Update Preferred Language and Country AU</fullName>
        <actions>
            <name>Update_Country_Field_AU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for AU</description>
        <formula>(AND($Profile.Name != &apos;IntegrationAPI&apos;,ISPICKVAL($User.Market__c,&apos;AU&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	 <rules>
        <fullName>Update Preferred Language and Country NZ</fullName>
        <actions>
            <name>Update_Country_Field_NZ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for NZ</description>
        <formula>(AND($Profile.Name != &apos;IntegrationAPI&apos;,ISPICKVAL($User.Market__c,&apos;NZ&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Preferred Language and Country KR</fullName>
        <actions>
            <name>Update_Country_Field_KR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Preferred_Language_Field_KR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for KR</description>
        <formula>ISPICKVAL($User.Market__c,&apos;KR&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Preferred Language and Country MY</fullName>
        <actions>
            <name>Update_Country_Field_MY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for MY</description>
        <formula>(AND($Profile.Name != 'IntegrationAPI',ISPICKVAL($User.Market__c,&apos;MY&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Preferred Language and Country TH</fullName>
        <actions>
            <name>Update_Country_Field_TH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Preferred_Language_Field_TH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update “Preferred Language and Country field&quot; based on Market Discriminator for TH</description>
        <formula>ISPICKVAL($User.Market__c,&apos;TH&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Work Phone Checkbox autopopulate</fullName>
        <actions>
            <name>sales_Tel_picklist_value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>workphone_checkbox_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 5 AND (4 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Account.Mobile__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Individual_Home_Phone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Work_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.MD__c</field>
            <operation>equals</operation>
            <value>KR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
	<rules>
        <fullName>UpdateData Source for Dealers For CompanyAccount</fullName>
        <actions>
            <name>UpdateData_Source_to_Others</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Contains($Profile.Name, &apos;Japan Dealer&apos; ), MD__c = &apos;JP&apos;,
ISBLANK(Text(Data_Source__c)),RecordType.DeveloperName = &apos;Company&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateData Source for Dealers For Person Account</fullName>
        <actions>
            <name>Data_Source_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Contains($Profile.Name, &apos;Japan Dealer&apos; ), MD__c = &apos;JP&apos;, 
ISBLANK(Text(Data_Source__c)),RecordType.DeveloperName = &apos;PersonAccount&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>