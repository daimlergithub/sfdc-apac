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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body, market);
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,Market);
                if(res.getStatus() != 'OK' || res.getstatusCode()!=200){
                    return false;
                }
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
                res = CalloutHandlerService.sendCalloutForPost('POST', Endpoint, 60000, headerCDM, null, body,market);
                if(res.getStatus() != 'OK' || res.getstatusCode()!=200){
                    return false;
                }
                System.debug('res878' + res);

            }
        }
        return true;
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
        String serializedAccountobj = null;
        map < String, CDM_Integration_URLs__c > mapURLs = CDM_Integration_URLs__c.getAll();
        String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
        String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();       
        List < Account > accountstosend = [Select id, recordtypeid, Warranty_Apply_Status__c,Data_Source__c,Allow_Data_Sharing2__c from Account where id IN: acc];
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
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Person Account')
                    endUrl = mapURLs.get(str).Informatica_URL__c;
            }		   
            if (string.isnotblank(endUrl)) {
                serializedAccountobj = generateJson(personacc);
			 }				 
        }
        if (companyacc.size() > 0) {
            
            for (string str: mapURLs.keyset()) {
                if (mapURLs.get(str).type__c == context && mapURLs.get(str).country__c == Market && MapUrls.get(str).Context__c == 'Company')
                    endUrl = mapURLs.get(str).Informatica_URL__c;
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
		 }
        return res;	 
    }
    /*Mrinalini2018*/

}