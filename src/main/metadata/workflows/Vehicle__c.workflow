<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Warranty_End_Date_for_NewCar</fullName>
        <field>Warranty_End_Date__c</field>
        <formula>IF(
AND(
MONTH( Latest_Invoice_Date__c ) = 2,
DAY( Latest_Invoice_Date__c ) = 29,
NOT( 
OR( 
MOD( YEAR( Latest_Invoice_Date__c), 400 ) = 0, 
AND( 
MOD( YEAR(Latest_Invoice_Date__c ), 4 ) = 0,
MOD( YEAR( Latest_Invoice_Date__c ), 100 ) != 0
)
)
) 
),
Date( YEAR( Latest_Invoice_Date__c ) + 2, 3, 1),
Date( YEAR( Latest_Invoice_Date__c ) + 2, MONTH( Latest_Invoice_Date__c ), DAY( Latest_Invoice_Date__c ) )
)</formula>
        <name>Warranty_End_Date_for_NewCar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Warranty_End_Date_for_UsedCar</fullName>
        <field>Warranty_End_Date__c</field>
        <formula>IF 
( 
MONTH( Latest_Invoice_Date__c) &gt; 6 
, 
DATE 
( 
YEAR( Latest_Invoice_Date__c) + 1, 
MOD( MONTH( Latest_Invoice_Date__c) + 6 , 12 ), 
DAY( Latest_Invoice_Date__c) 
) 
, 
DATE 
( 
YEAR( Latest_Invoice_Date__c), 
MONTH( Latest_Invoice_Date__c) + 6, 
DAY( Latest_Invoice_Date__c) 
) 
)</formula>
        <name>Warranty_End_Date_for_UsedCar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Warranty_StartDate_as_InvoiceOrSalesDate</fullName>
        <field>Warranty_Start_Date__c</field>
        <formula>Latest_Invoice_Date__c</formula>
        <name>Warranty_StartDate_as_InvoiceOrSalesDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Warranty_End _Date_for_NewCar</fullName>
        <actions>
            <name>Warranty_End_Date_for_NewCar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the vehicle is checked as NEW then warranty end date should be &quot;invoice date + 2 years&quot;</description>
        <formula>AND( ISPICKVAL( New_Used__c , &apos;Used&apos;) , ISPICKVAL( Market__c , &apos;TR&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Warranty_End_Date_for_UsedCar</fullName>
        <actions>
            <name>Warranty_End_Date_for_UsedCar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the vehicle is checked as USED then warranty end date should be &quot;invoice date + 6 months&quot;</description>
        <formula>AND( ISPICKVAL( New_Used__c , &apos;Used&apos;) , ISPICKVAL(  Market__c , &apos;TR&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Warranty_Start_Date%5F%5Fas_InvoiceOrSalesDate</fullName>
        <actions>
            <name>Warranty_StartDate_as_InvoiceOrSalesDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Warranty start date should be always set as &quot;invoice/sales date&quot;</description>
        <formula>AND((ISPICKVAL(Market__c,&apos;TR&apos;)),NOT(ISNULL(Latest_Invoice_Date__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
