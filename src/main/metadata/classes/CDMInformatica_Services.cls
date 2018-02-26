/*------------------------------------------------------------
    Author:        Pavan Kumar D
    Company:       Infosys
    Description:   Generic service to callout informatica for CDM purposes
    History
    <Date>      <Authors Name>     <Brief Description of Change> 
    
    Pattern followed:  Separation of Concerns 
                
     Purpose:   This class will be the gateway to interface with CDM
                 Also, deminstrated the    Event logging framework
    
   This class follows the service layer which is part of the SOC and also addresses
   the CDM Informatica Services in place with an handle to leverage the Application error logging framework
    ------------------------------------------------------------*/
public Class CDMInformatica_Services extends CDMServices {



    public override string searchCustomerOnCDM(String method, String endpoint, Integer timeout, Map < String, String > headerKeyByValue, String status) {

        try {
            HttpResponse res = CalloutHandlerService.sendCallout(method, endpoint, timeout, headerKeyByValue, status);
            return CalloutHandlerService.processCalloutResponse(res, null);

        } catch (Exception e) {
            //generic exception if not caught above would be handled and application logger would be invoked
            return null;
        }
    }
    //Will Generate the Required Json format
    Public Static String generateJson(List < ID > idlist) {
        String s = '{"ip_data":[';
        integer lstsize = idlist.size();
        Integer count = 0;
        for (ID inte: idlist) {
            count++;
            s = s + '{"id":' + '"' + inte + '"},';
        }
        s = s + ']}';
        Integer inde = s.lastIndexof(',');
        String str = s.substring(0, inde) + s.substring(inde + 1);
        return str;
    }

    @future(callout = true)
    public static void createCustomerCDM(Set < ID > acc, string Market, string context) {
        List < ID > personacc = new List < ID > ();
        List < ID > companyacc = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedAccountobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();


        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        List < Account > accountstosend = [Select id, recordtypeid from Account where id IN: acc];
        for (Account accrec: accountstosend) {
            if (accrec.recordtypeid == PersonAccountRecordTypeID) {
                personacc.add(accrec.id);
            } else if (accrec.recordtypeid == companyRecordTypeId) {
                companyacc.add(accrec.id);
            }
        }
        if (personacc.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Person Account')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            if (string.isnotblank(Endpoint)) {
                serializedAccountobj = generateJson(personacc);
                serializedAccountobj = EncodingUtil.URLENCODE(serializedAccountobj, 'UTF-8');
                string body = '[';
                for (integer i = 0; i < personacc.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/' + personacc[i] + '"},"Id":"' + personacc[i] + '","RecordTypeId":"' + PersonAccountRecordTypeID + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/' + personacc[i] + '"},"Id":"' + personacc[i] + '","RecordTypeId":"' + PersonAccountRecordTypeID + '"}';
                }
                body = body + ']';
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
            }
        }
        if (companyacc.size() > 0) {
            serializedAccountobj = generateJson(companyacc);
            serializedAccountobj = EncodingUtil.URLENCODE(serializedAccountobj, 'UTF-8');
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Company')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            if (string.isnotblank(Endpoint)) {
                string body = '[';
                for (integer i = 0; i < companyacc.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/' + companyacc[i] + '"},"Id":"' + companyacc[i] + '","RecordTypeId":"' + companyRecordTypeId + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Account","url":"/services/data/v41.0/sobjects/Account/' + companyacc[i] + '"},"Id":"' + companyacc[i] + '","RecordTypeId":"' + companyRecordTypeId + '"}';
                }
                body = body + ']';
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
            }
        }


    }

    @future(callout = true)
    public static void createAccountLink(Set < Id > AccountlinkID, string Market, string context) {
        List < ID > RetailpersonID = new List < ID > ();
        List < ID > RetailCompanyID = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedAccountlinkobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();


        String RetailpersonRtype = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordtypeID();
        String RetailCompanyRtype = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordtypeID();
        List < Account_Link__c > accountlinksstosend = [Select id, recordtypeid from Account_Link__c where id IN: AccountlinkID];
        for (Account_Link__c link: accountlinksstosend) {
            if (link.recordtypeid == RetailpersonRtype) {
                RetailpersonID.add(link.id);
            } else if (link.recordtypeid == RetailCompanyRtype) {
                RetailCompanyID.add(link.id);
            }
        }
        if (RetailpersonID.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Retail Person')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            System.debug('Endpoint888' + Endpoint);




            if (string.isnotblank(Endpoint)) {
                serializedAccountlinkobj = generateJson(RetailpersonID);
                serializedAccountlinkobj = EncodingUtil.URLENCODE(serializedAccountlinkobj, 'UTF-8');
                string body = '[';
                for (integer i = 0; i < RetailpersonID.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Account_Link__c","url":"/services/data/v41.0/sobjects/Account_link__c/' + RetailpersonID[i] + '"},"Id":"' + RetailpersonID[i] + '","RecordTypeId":"' + RetailpersonRtype + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Account_link__c","url":"/services/data/v41.0/sobjects/Account_link__c/' + RetailpersonID[i] + '"},"Id":"' + RetailpersonID[i] + '","RecordTypeId":"' + RetailpersonRtype + '"}';
                }
                body = body + ']';
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                System.debug('***@#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
                System.debug('res888' + res);
            }
        }
        if (RetailCompanyID.size() > 0) {
            serializedAccountlinkobj = generateJson(RetailCompanyID);
            serializedAccountlinkobj = EncodingUtil.URLENCODE(serializedAccountlinkobj, 'UTF-8');
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Retail Company')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            if (string.isnotblank(Endpoint)) {




                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');




                string body = '[';




                for (integer i = 0; i < RetailCompanyID.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Account_link__c","url":"/services/data/v41.0/sobjects/Account_link__c/' + RetailCompanyID[i] + '"},"Id":"' + RetailCompanyID[i] + '","RecordTypeId":"' + RetailCompanyRtype + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Account_link__c","url":"/services/data/v41.0/sobjects/Account_link__c/' + RetailCompanyID[i] + '"},"Id":"' + RetailCompanyID[i] + '","RecordTypeId":"' + RetailCompanyRtype + '"}';




                }
                body = body + ']';
                System.debug('***#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
                System.debug('res878' + res);

            }
        }

    }

    @future(callout = true)
    public static void createLead(Set < Id > LeadId, string Market, string context) {
        List < ID > SalesLeadId = new List < ID > ();
        List < ID > AftersalesLeadId = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedLeadobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();


        String SalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordtypeID();
        String AfterSalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordtypeID();
        List < Lead__c > LeadtoSend = [Select id, recordtypeid from Lead__c where id IN: LeadId];
        for (Lead__c ld: LeadtoSend) {
            if (ld.recordtypeid == SalesLeadRType) {
                SalesLeadId.add(ld.id);
            } else if (ld.recordtypeid == AfterSalesLeadRType) {
                AftersalesLeadId.add(ld.id);
            }
        }
        if (SalesLeadId.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Lead')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            System.debug('Endpoint888' + Endpoint);
            if (string.isnotblank(Endpoint)) {
                serializedLeadobj = generateJson(SalesLeadId);
                serializedLeadobj = EncodingUtil.URLENCODE(serializedLeadobj, 'UTF-8');
                string body = '[';
                for (integer i = 0; i < SalesLeadId.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Lead__c","url":"/services/data/v41.0/sobjects/Lead__c/' + SalesLeadId[i] + '"},"Id":"' + SalesLeadId[i] + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Lead__c","url":"/services/data/v41.0/sobjects/Lead__c/' + SalesLeadId[i] + '"},"Id":"' + SalesLeadId[i] + '"}';
                }
                body = body + ']';
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                System.debug('***@#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
                System.debug('res888' + res);
            }
        }
        if (AftersalesLeadId.size() > 0) {
            serializedLeadobj = generateJson(AftersalesLeadId);
            serializedLeadobj = EncodingUtil.URLENCODE(serializedLeadobj, 'UTF-8');
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Lead')
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
            if (string.isnotblank(Endpoint)) {
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');

                string body = '[';
                for (integer i = 0; i < AftersalesLeadId.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Lead__c","url":"/services/data/v41.0/sobjects/Lead__c/' + AftersalesLeadId[i] + '"},"Id":"' + AftersalesLeadId[i] + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Lead__c","url":"/services/data/v41.0/sobjects/Lead__c/' + AftersalesLeadId[i] + '"},"Id":"' + AftersalesLeadId[i] + '"}';
                }
                body = body + ']';
                System.debug('***#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body);
                System.debug('res878' + res);

            }
        }

    }




}