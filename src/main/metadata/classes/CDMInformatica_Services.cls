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
        /*VB20180727:Added for JP Market*/
        Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        Boolean jpSwitchEnabledFlag = false;
        String sourceSystem='';
        /*VB20180727*/
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
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Person Account'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/                 
                }
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
                /*VB20180727:Added for JP Market*/
                if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                    jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== Label.JP && jpSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, acc, Market, context, sourceSystem);
                    
                }
                /*VB20180727*/
            }
        } 
        if (companyacc.size() > 0) {
            serializedAccountobj = generateJson(companyacc);
            serializedAccountobj = EncodingUtil.URLENCODE(serializedAccountobj, 'UTF-8');
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Company'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/
                }
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
                /*VB20180727:Added for JP Market*/
                if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                    jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== Label.JP && jpSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, acc, Market, context, sourceSystem);
                }
                /*VB20180727*/  
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
        List < Account_Link__c > accountlinksstosend = [Select id, recordtypeid from Account_Link__c where id IN: AccountlinkID and (Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false) ];
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
                System.debug('res878' + res);

            }
        }

    }
    
    @future(callout = true)
    public static void createOpportunity(Set < Id > LeadId, string Market, string context) {
        List < ID > SalesLeadId = new List < ID > ();
        List < ID > AftersalesLeadId = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedLeadobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();


        String SalesLeadRType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordtypeID();
        String AfterSalesLeadRType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordtypeID();
        List < Opportunity > LeadtoSend = [Select id, recordtypeid from Opportunity where id IN: LeadId];
        for (Opportunity ld: LeadtoSend) {
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
                   /* if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Opportunity","url":"/services/data/v41.0/sobjects/Opportunity/' + SalesLeadId[i] + '"},"Id":"' + SalesLeadId[i] + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Opportunity","url":"/services/data/v41.0/sobjects/Opportunity/' + SalesLeadId[i] + '"},"Id":"' + SalesLeadId[i] + '"}';*/
             body = body + '{"Id":"'+SalesLeadId[i]+'"}';
                }
                body = body + ']';
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                System.debug('***@#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,market);
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
                   /* if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Opportunity","url":"/services/data/v41.0/sobjects/Opportunity/' + AftersalesLeadId[i] + '"},"Id":"' + AftersalesLeadId[i] + '"}';
                    else
                        body = body + ',{"attributes":{"type":"Opportunity","url":"/services/data/v41.0/sobjects/Opportunity/' + AftersalesLeadId[i] + '"},"Id":"' + AftersalesLeadId[i] + '"}';*/
             body = body + '{"Id":"'+AftersalesLeadId[i]+'"}'; 
                }
                body = body + ']';
                System.debug('***#' + Endpoint + ' ' + headerCDM + ' ' + body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,market);
                System.debug('res878' + res);

            }
        }

    }
    
    /*@Owner: Tejbir By TH
     @Description: When case is updated,this method will hit Informatica case update URL to fetch data from case and send back to COS.
    */
     @future(callout = true)
    public static void sendCaseDetailsToCOS(List <Id> caseIdLst, string Market, string context)
    {
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedLeadobj = null;
        
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        
        for (string str: mapURLs.keyset()) {
            if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Case')
               Endpoint = mapURLs.get(str).Informatica_URL__c;
        }
            
            if(String.isNotBlank(Endpoint))
            {
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                
                string body = '[';
                List<Case> caseObjLst=[Select Id,AccountId from case where Id IN:caseIdLst];
                for (integer i = 0; i < caseObjLst.size(); i++) {
                    if (body.length() == 1)
                        body = body + '{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseObjLst[i].Id + '"},"CaseID":"' + caseObjLst[i].Id + '","AccountID":"'+caseObjLst[i].AccountId+'","CaseCommentID":"","ContentVersionId":""}';
                    else
                        body = body + ',{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseObjLst[i].Id + '"},"CaseID":"' + caseObjLst[i].Id + '","AccountID":"'+caseObjLst[i].AccountId+'","CaseCommentID":"","ContentVersionId":""}';
                }
                body = body + ']';
                System.debug('body---'+body);
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,market);
            }
        
    }
    
    /*@Owner: Tejbir By TH
     @Description: When case comment is updated,this method will hit Informatica case update URL to fetch data from case and case comment and send back to COS.
    */
     @future(callout = true)
    public static void sendCaseCommentDetailsToCOS(List <Id> caseCommentIdLst, string Market, string context)
    {
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedLeadobj = null;
        
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        
        for (string str: mapURLs.keyset()) {
            if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Case')
            Endpoint = mapURLs.get(str).Informatica_URL__c;
        }
            if(String.isNotBlank(Endpoint))
            {
                Map < string, string > headerCDM = new Map < string, string > ();
                headerCDM.put('Content-Type', 'application/json');
                
                string body = '[';
                List<Case_Comment__c> caseCommentLst;
                List<Case> caseObjLst;
                Map<Id,Id> caseCommentId2caseIdMap=new Map<Id,Id>();
                Map<Id,Id> caseId2AccountIdMap=new Map<Id,Id>();
                Map<Id,Id> contentDocId2ContentVersionIdMap=new Map<Id,Id>();
                List<ContentDocumentLink> conDocLinkLst;
                List<ContentVersion> contentVersionLst;
                List<Id> contentDocumentIdLst=new List<Id>();
                Map<Id,ContentDocumentLink> contDocLinkId2ContDocLinkObjMap;
                
                Map<Id,Id> caseCommentId2ContentDocumentIdMap=new Map<Id,Id>();
                if(caseCommentIdLst!=null && caseCommentIdLst.size()>0)
                {
                    caseCommentLst=[Select Id,Case__c from Case_Comment__c where ID IN:caseCommentIdLst];
                    contDocLinkId2ContDocLinkObjMap=new Map<Id,ContentDocumentLink>([select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN:caseCommentIdLst]);
                    
                    if(contDocLinkId2ContDocLinkObjMap!=null && contDocLinkId2ContDocLinkObjMap.size()>0)
                    {
                        for(ContentDocumentLink link:contDocLinkId2ContDocLinkObjMap.values())
                            contentDocumentIdLst.add(link.contentDocumentId);
                    }
                        contentVersionLst=[select id,contentDocumentId from ContentVersion where contentDocumentId IN:contentDocumentIdLst];
                }
                if(caseCommentLst!=null && caseCommentLst.size()>0)
                {
                    for(Case_Comment__c cc:caseCommentLst)
                    {
                        caseCommentId2caseIdMap.put(cc.Id, cc.Case__c);
                    }
                    if(contDocLinkId2ContDocLinkObjMap!=null && contDocLinkId2ContDocLinkObjMap.size()>0)
                    {
                        for(ContentDocumentLink link:contDocLinkId2ContDocLinkObjMap.values())
                        {
                            caseCommentId2ContentDocumentIdMap.put(link.LinkedEntityId, link.ContentDocumentId);
                        }
                        if(contentVersionLst!=null && contentVersionLst.size()>0)
                        {
                            for(ContentVersion contVersion:contentVersionLst)
                                contentDocId2ContentVersionIdMap.put(contVersion.contentDocumentId, contVersion.Id);
                        }
                    }
                    if(caseCommentId2caseIdMap!=null && caseCommentId2caseIdMap.size()>0)
                    {
                       caseObjLst=[Select Id,AccountId from case where Id IN:caseCommentId2caseIdMap.values()]; 
                    }
                    if(caseObjLst!=null && caseObjLst.size()>0)
                    {
                        for(Case caseObj:caseObjLst)
                        {
                            caseId2AccountIdMap.put(caseObj.Id, caseObj.AccountId);
                        }
                    }
                    
                }
                
                if(caseCommentLst!=null && caseCommentLst.size()>0)
                {
                    for (integer i = 0; i < caseCommentLst.size(); i++) {
                        if (body.length() == 1)
                        {
                            if(caseCommentId2ContentDocumentIdMap!=null && caseCommentId2ContentDocumentIdMap.size()>0 && caseCommentId2ContentDocumentIdMap.get(caseCommentLst[i].Id)!=null)
                                body = body + '{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseCommentLst[i].Id + '"},"CaseID":"' + caseCommentLst[i].Case__c + '","AccountID":"'+caseId2AccountIdMap.get(caseCommentLst[i].Case__c)+'","CaseCommentID":"'+caseCommentLst[i].Id+'","ContentVersionId:":"'+contentDocId2ContentVersionIdMap.get(caseCommentId2ContentDocumentIdMap.get(caseCommentLst[i].Id))+'"}';
                            else
                                body = body + ',{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseCommentLst[i].Id + '"},"CaseID":"' + caseCommentLst[i].Case__c + '","AccountID":"'+caseId2AccountIdMap.get(caseCommentLst[i].Case__c)+'","CaseCommentID":"'+caseCommentLst[i].Id+'","ContentVersionId":""}';
                        }
                            
                        else
                        {
                            if(caseCommentId2ContentDocumentIdMap!=null && caseCommentId2ContentDocumentIdMap.size()>0 && caseCommentId2ContentDocumentIdMap.get(caseCommentLst[i].Id)!=null)
                                body = body + '{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseCommentLst[i].Id + '"},"CaseID":"' + caseCommentLst[i].Case__c + '","AccountID":"'+caseId2AccountIdMap.get(caseCommentLst[i].Case__c)+'","CaseCommentID":"'+caseCommentLst[i].Id+'","ContentVersionId:":"'+contentDocId2ContentVersionIdMap.get(caseCommentId2ContentDocumentIdMap.get(caseCommentLst[i].Id))+'"}';
                            else
                                body = body + ',{"attributes":{"type":"Case","url":"/services/data/v41.0/sobjects/Case/' + caseCommentLst[i].Id + '"},"CaseID":"' + caseCommentLst[i].Case__c + '","AccountID":"'+caseId2AccountIdMap.get(caseCommentLst[i].Case__c)+'","CaseCommentID":"'+caseCommentLst[i].Id+'","ContentVersionId":""}';
                        }
                            
                    }
                    body = body + ']';
                    System.debug('body----'+body);
                    res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
                }
                
            }        
    }
    
      public static Boolean createLeadInAL(Set < Id > LeadId, string Market, string context) {
        List < ID > SalesLeadId = new List < ID > ();
        List < ID > AftersalesLeadId = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedLeadobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        /*VB20180727:Added for JP Market*/
        Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        Boolean jpSwitchEnabledFlag = false;
    Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
          Boolean KRSwitchEnabledFlag = false;
        String sourceSystem='';
        /*VB20180727*/
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
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Lead'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/
            }
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,Market);
                /*VB20180727:Added for JP Market*/
                if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                    jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== Label.JP && jpSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, LeadId, Market, context, sourceSystem);
                }
                  if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Error Handling')){
                    KRSwitchEnabledFlag = KRSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== 'KR' && KRSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, LeadId, Market, context, sourceSystem);
                }
                /*VB20180727*/
                if(res.getStatus() == 'OK' || res.getstatusCode()==200){
                    return true;
                }
                System.debug('res888' + res);
            }
        }
        if (AftersalesLeadId.size() > 0) {
            serializedLeadobj = generateJson(AftersalesLeadId);
            serializedLeadobj = EncodingUtil.URLENCODE(serializedLeadobj, 'UTF-8');
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Lead'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/                 
                }
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,market);
                /*VB20180727:Added for JP Market*/
                if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                    jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== Label.JP && jpSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, LeadId, Market, context, sourceSystem);
                }
                    if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Error Handling')){
                    KRSwitchEnabledFlag = KRSwitchMap.get('Error Handling').Enable_Flag__c;
                }
                if(market== 'KR' && KRSwitchEnabledFlag){
                    errorHandlerRealtimeJP(res, LeadId, Market, context, sourceSystem);
                }                
                /*VB20180727*/  
                if(res.getStatus() == 'OK' || res.getstatusCode()==200){
                    return true;
                }
                System.debug('res878' + res);

            }
        }
        return false;
    }
/*Mrinalini2018*/
    public String generateEndPointURL(List<Account> accRec, string endUrl, Id dealerId){
        
        if(accRec.size()>0){
            for(integer i = 0; i < accRec.size(); i++){
                if(accRec[i].market__c == 'JP'){
                    endUrl+='inp_JSON_Id='+(string.isnotblank(accRec[i].Id)?EncodingUtil.URLENCODE(accRec[i].Id,'UTF-8'):'');
                    endUrl+='&inp_JSON_RecordType='+(string.isnotblank(accRec[i].recordtypeid)?EncodingUtil.URLENCODE(accRec[i].recordtypeid,'UTF-8'):'');
                    endUrl+='&inp_JSON_DealerId='+(string.isnotblank(dealerId)?EncodingUtil.URLENCODE(dealerId,'UTF-8'):'');
                }                                                                                                  
            }               
        }
        return endUrl;
    }   
     public static HttpResponse createCustCdmSpo(Set < ID > acc, string Market, string context, ID dealerId) {
        List < ID > personacc = new List < ID > ();
        List < ID > companyacc = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String endUrl = null;
        /*VB20180727:Added for JP Market*/
        Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        Boolean jpSwitchEnabledFlag = false;
        String sourceSystem='';
        /*VB20180727*/      
        String serializedAccountobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();       
        List < Account > accountstosend = [Select id, recordtypeid, Warranty_Apply_Status__c,Data_Source__c,Allow_Data_Sharing2__c,Market__c from Account where id IN: acc];
        for (Account accrec: accountstosend) {
            if (accrec.recordtypeid == PersonAccountRecordTypeID) {
                personacc.add(accrec.id);
            } else if (accrec.recordtypeid == companyRecordTypeId) {
                companyacc.add(accrec.id);
            }
        }
        CDMInformatica_Services cdm = new CDMInformatica_Services();
        if (personacc.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Person Account'){
                    endUrl = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/
            }          
            }         
            if (string.isnotblank(endUrl)) {
                serializedAccountobj = generateJson(personacc);
             }               
        }
        if (companyacc.size() > 0) {
            
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Company'){
                    endUrl = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/
                }
            } 
            if (string.isnotblank(endUrl)) {
                serializedAccountobj = generateJson(companyacc);
            }                                                          
        }
        if(string.isnotblank(endUrl)) {
            serializedAccountobj = EncodingUtil.URLENCODE(serializedAccountobj, 'UTF-8');
            Endpoint = cdm.generateEndPointURL(accountstosend, endUrl, dealerId);
            Map < string, string > headerCDM = new Map < string, string > ();
            headerCDM.put('Content-Type', 'application/json');
            res = CalloutHandlerService.sendCallout('GET', Endpoint, 60000, headerCDM, null);   
            /*VB20180727:Added for JP Market*/
            if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
            }
            if(market== Label.JP && jpSwitchEnabledFlag){
                errorHandlerRealtimeJP(res, acc, Market, context, sourceSystem);
         }
        /*VB20180727*/
         }       
       return res;   
    }
    /*Mrinalini2018*/

    
 
    /*VB20180727:Added for JP Market*/
    public static void errorHandlerRealtimeJP(HttpResponse res, Set<Id> recordIDSet, String Market, String Context, String sourceSystem){
        String realTimeRecordTypeId = Schema.SObjectType.Custom_Debug_Info__c.getRecordTypeInfosByName().get('RealTime').getRecordtypeID();
        List<Custom_Debug_Info__c> cdiToBeCreatedList = new List<Custom_Debug_Info__c>();
        if(res.getStatus() == 'SUCCESS' && res.getStatusCode()==200){
            List<Custom_Debug_Info__c> cdiFoundList = [select Id, Name, RecordID__c, Transaction_Id__c, Market__c, External_Id__c, Context_Id__c from Custom_Debug_Info__c WHERE RecordTypeId = :realTimeRecordTypeId AND RecordID__c IN :recordIDSet AND Market__c = :Market AND isSuccess__c=false];
            if(cdiFoundList.size()>0){
                for(Custom_Debug_Info__c cdi : cdiFoundList){
                    Custom_Debug_Info__c cdiNew = new Custom_Debug_Info__c();
                    cdiNew.RecordID__c = cdi.RecordID__c;
                    cdiNew.isSuccess__c = true;
                    cdiNew.Logging_Date_Time__c = System.now();
                    cdiNew.Error_Logged_By__c = 'SFDC';
                    cdiNew.Interface_Name__c = sourceSystem;
                    cdiToBeCreatedList.add(cdiNew);
                }
                if(cdiToBeCreatedList.size()>0){
                    Database.insert(cdiToBeCreatedList,true);
                }
            }
        }
        else{
            for(Id recordId : recordIDSet){
                Custom_Debug_Info__c cdiNew = new Custom_Debug_Info__c();
                cdiNew.RecordID__c=recordId;
                cdiNew.isSuccess__c=false;
                cdiNew.Logging_Date_Time__c = System.now();
                cdiNew.Error_Logged_By__c = 'SFDC';
                cdiNew.Interface_Name__c = sourceSystem;
                cdiToBeCreatedList.add(cdiNew);
            }
            if(cdiToBeCreatedList.size()>0){
                    Database.insert(cdiToBeCreatedList,true);
            }
        }
    }
    /*VB20180726*/
    
    public static HttpResponse createCustCDMJPOS(Set < ID > acc, string Market, string context, Map< ID, ID > accAddMap, Id assignedUserId) {
        List < ID > personacc = new List < ID > ();
        List < ID > companyacc = new List < ID > ();
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        String serializedAccountobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        /*VB20180727:Added for JP Market*/
        Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
        Boolean jpSwitchEnabledFlag = false;
        String sourceSystem='';
        /*VB20180727*/
        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
        List < Account > accountstosend = [Select id,Market__c,md__c,recordtypeid from Account where id IN: acc];
        //List < Address__c > addList = [Select id from Address__c where id IN: AddId];
        for (Account accrec: accountstosend) {
            if (accrec.recordtypeid == PersonAccountRecordTypeID) {
                personacc.add(accrec.id);
            } else if (accrec.recordtypeid == companyRecordTypeId) {
                companyacc.add(accrec.id);
            }
        }
        if (personacc.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Person Account'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/                 
                }
            }
            if (string.isnotblank(Endpoint)) {
                serializedAccountobj = generateJson(personacc);
            }
        }
        if (companyacc.size() > 0) {
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Company'){
                    Endpoint = mapURLs.get(str).Informatica_URL__c;
                    /*VB20180727:Added for JP Market*/
                    sourceSystem = str;
                    /*VB20180727*/
                }
            }
            if (string.isnotblank(Endpoint)) {
                serializedAccountobj = generateJson(companyacc);
            }
        }
        if(string.isnotblank(Endpoint)) {
            serializedAccountobj = EncodingUtil.URLENCODE(serializedAccountobj, 'UTF-8');
            
            if(accountstosend.size()>0){
                for(integer i = 0; i < accountstosend.size(); i++){
                    if(accountstosend[i].market__c == 'JP'){
                        Endpoint+='inp_JSON_Id='+(string.isnotblank(accountstosend[i].Id)?EncodingUtil.URLENCODE(accountstosend[i].Id,'UTF-8'):'');
                        Endpoint+='inp_JSON_AssignedUser='+(string.isnotblank(assignedUserId)?EncodingUtil.URLENCODE(assignedUserId,'UTF-8'):'');
                        Endpoint+='&inp_JSON_RecordType='+(string.isnotblank(accountstosend[i].recordtypeid)?EncodingUtil.URLENCODE(accountstosend[i].recordtypeid,'UTF-8'):'');
                        if(accAddMap.get(accountstosend[i].Id) != null){
                            Endpoint+='&inp_JSON_AddressId='+(string.isnotblank(accAddMap.get(accountstosend[i].Id))?EncodingUtil.URLENCODE(accAddMap.get(accountstosend[i].Id),'UTF-8'):'');
                        }
                    }                                                                                                  
                }               
            }
            Map < string, string > headerCDM = new Map < string, string > ();
            headerCDM.put('Content-Type', 'application/json');
            res = CalloutHandlerService.sendCallout('GET', Endpoint, 60000, headerCDM, null); 
            
            if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Error Handling')){
                jpSwitchEnabledFlag = jpSwitchMap.get('Error Handling').Enable_Flag__c;
            }
            if(market== Label.JP && jpSwitchEnabledFlag){
                errorHandlerRealtimeJP(res, acc, Market, context, sourceSystem);
            }
        }
        return res;

    }
    
    @future(callout=true)
    public static void sendVehicleInfo(Set<Id> vehicleIdSet, String market, String dmlType){
        System.debug('Inside the send vehicle info method------------------------------------->'+vehicleIdSet);
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        Map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        JSONGenerator generator = JSON.createGenerator(true);
        List<Configuration_Rule__c> vrConfigRule= new List<Configuration_Rule__c>();
        vrConfigRule=[SELECT Id,(SELECT Id,Destination__c,Object_API__c 
                                    FROM Configuration_Rule_Items__r WHERE active__c=true) 
                         FROM Configuration_Rule__c 
                         WHERE active__c=true 
                         AND Market__c=:market 
                         AND type__c='Field Mapping' 
                         LIMIT 1];  
                         
        generator.writeStartObject();
        generator.writeFieldName('data');
        generator.writeStartArray();
        if(vrConfigRule.size()>0){
            Configuration_Rule__c cr=vrConfigRule[0];
            if(cr.Configuration_Rule_Items__r!=null && cr.Configuration_Rule_Items__r.size()>0){
                for(Integer i=0; i<cr.Configuration_Rule_Items__r.size();i++){
                    Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                    cri=cr.Configuration_Rule_Items__r[i];
                    if(cri.Object_API__c=='Vehicle__c'){
                        for(String vehicleId : vehicleIdSet ){    
                            generator.writeStartObject();
                            generator.writeFieldName('Vehicle');
                            generator.writeStartObject();
                            generator.writeStringField(cri.Destination__c, vehicleId);           
                            generator.writeEndObject();
                            generator.writeEndObject();
                        }
                    }
                }  
            }
        }
        generator.writeEndArray();
        generator.writeEndObject();
        String body = generator.getAsString();
        System.debug('JSON body is-------------------------------->'+body);
        
        for (string str: mapURLs.keyset()) {
            if (mapURLs.get(str).type__c == dmlType && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Vehicle'){
                endPoint = mapURLs.get(str).Informatica_URL__c;
            }
        }
        System.debug('End url is ----------------------->'+endPoint);
        Map < string, string > headerCDM = new Map < string, string > ();
        headerCDM.put('Content-Type', 'application/json');
        if(endPoint != null){
            res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
        }
    }
    
    @future(callout=true)
    public static void sendVehicleRelationshipInfo(Set<Id> VRIdSet, String market, String dmlType){
        HttpResponse res = new HttpResponse();
        String Endpoint = null;
        Map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        JSONGenerator generator = JSON.createGenerator(true);
        List<Configuration_Rule__c> vrConfigRule = new List<Configuration_Rule__c>();
        vrConfigRule =[SELECT Id,(SELECT Id,Destination__c,Object_API__c 
                                        FROM Configuration_Rule_Items__r 
                                        WHERE Active__c=true ) 
                        FROM Configuration_Rule__c 
                        WHERE active__c=true 
                        //AND Rule_Name__c='V_VR_Rule'
                        AND Market__c=:market 
                        AND type__c ='Field Mapping'
                        LIMIT 1];   
              
        Map<Id,List<Vehicle_Relationship__c>> vIdToVRIdMap = new Map<id,List<Vehicle_Relationship__c>>();
        List<Vehicle_Relationship__c> listVR = [SELECT id,Vehicle_ID__c FROM Vehicle_Relationship__c where Id IN :VRIdSet];
        
        for(Vehicle_Relationship__c vr :listVR){
            if(!vIdToVRIdMap.keyset().contains(vr.Vehicle_ID__c)){
                vIdToVRIdMap.put(vr.Vehicle_ID__c, new List<Vehicle_Relationship__c>() );    
            }
            vIdToVRIdMap.get(vr.Vehicle_ID__c).add(vr); 
        }

        generator.writeStartObject();
        generator.writeFieldName('data');
        generator.writeStartArray();
        
        Configuration_Rule__c c = vrConfigRule[0];
        
        for(Id vId : vIdToVRIdMap.keySet()){
            generator.writeStartObject();
            generator.writeFieldName('vehicle');
            generator.writeStartObject();
            if(c.Configuration_Rule_Items__r != null && c.Configuration_Rule_Items__r.size()>0){
                for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                    Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                    cri = c.Configuration_Rule_Items__r[i];
                    if(cri.Object_API__c=='Vehicle__c'){
                       generator.writeStringField(cri.Destination__c, vId);
                    }
                }
            }        
            generator.writeFieldName('vehicleRelationship');
            generator.writeStartArray();
            for( Vehicle_Relationship__c vr: vIdToVRIdMap.get(vId)){
                if(c.Configuration_Rule_Items__r != null && c.Configuration_Rule_Items__r.size()>0){
                    for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                        Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                        cri = c.Configuration_Rule_Items__r[i];
                        if(cri.Object_API__c=='Vehicle_Relationship__c'){
                            generator.writeStartObject();
                            generator.writeStringField(cri.Destination__c, String.ValueOf(vr.Id));
                            generator.writeEndObject();
                        }
                    }
                }
            }
            generator.writeEndArray();
            generator.writeEndObject();
            generator.writeEndObject();
        }
        
        generator.writeEndArray();
        generator.writeEndObject();
        String body = generator.getAsString();
        System.debug('JSON body is-------------------------------->'+body);
        
        for (string str: mapURLs.keyset()) {
            if (mapURLs.get(str).type__c == dmlType && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Vehicle Relationship'){
                Endpoint = mapURLs.get(str).Informatica_URL__c;
            }
        }
        
        Map < string, string > headerCDM = new Map < string, string > ();
        headerCDM.put('Content-Type', 'application/json');
        if(endPoint != null){
            res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
        }
    }
}