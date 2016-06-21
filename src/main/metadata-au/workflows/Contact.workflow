<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>1</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Salutation</field>
            <operation>equals</operation>
            <value>DRM MBFS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>test</fullName>
        <active>false</active>
        <formula>ISPICKVAL(Salutation,&apos;&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
