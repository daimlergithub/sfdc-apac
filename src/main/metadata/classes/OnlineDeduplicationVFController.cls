/********************************************************************************************************************************************
* File Name   : OnlineDeduplicationVFController 
* Description : OnlineDeduplicationVFController apex class supported for OnlineDeduplicationVF which is iFrame in AddressSearchValidationCmp
* Copyright   : Infosys Limited Copyright (c) 2018
* @author     : Infosys Team 
* Author Modification & Ver.Date : Infosys & 22-Aug-2018  
*********************************************************************************************************************************************/
global class OnlineDeduplicationVFController {
    // global static object onLineDeduplicationANZ(String Recordtype, Account objAccount,Boolean firstsave,String market,Address__c AddressObj){// , String Province, String district, String SubDIstrict,String zip
    
    /** Method to fetch duplicate accounts **/
    @RemoteAction
    global static object onLineDeduplicationANZ(String Recordtype, Boolean firstsave,String market,String objAccountString,String AddressObjString){  
        Account objAccount=new Account();
        Address__c AddressObj=new Address__c();
        list<String> errorMsgs = new List<String>();
        Map<String,list<String>> errorMap=new Map<String,list<String>>();
        objAccount=(Account)JSON.deserialize(objAccountString, Account.class);
        AddressObj=(Address__c)JSON.deserialize(AddressObjString, Address__c.class);
        Continuation con=null;    
        String requestLabel=null;
        String Province='';
        String district='';
        String SubDIstrict='';
        String zip='';
        AddressSearchValidation valObj = AddressSearchValidationFactory.retrieveFieldSetValidate(market, Recordtype, 'AddressSearchValidation');
        String EndUrl = valObj.getCDMURL(Recordtype,objAccount,firstsave,market,AddressObj);
        //String EndUrl=generateCDMEndPointURL(Recordtype,objAccount,firstsave,market,AddressObj);
        system.debug(EndUrl);
        try{    
            if(label.New_Component=='true'){
                con = new Continuation(120);     
                con.continuationMethod='processResponse';
                con.state =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                system.debug(con.getRequests());
                return con;
            }
            else{
                errorMsgs.add(Label.No_Match_Found);  
            }
        }catch(Exception e){
            errorMsgs.add(label.InformaticaError);   
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        } 
        if(errorMsgs.size()>0){
            errorMap.put('Error',errorMsgs);
        }
        return errorMap;
    }
    /** Continuation Method  **/
    global static Object processResponse(Object state) {//List<account>
        list<String> errorMsgs = new List<String>();
        errorMsgs.add('Error');
        JSON2ApexCustomerCDM custSearch=null;
        List<account> DedupAccountList=new List<account>();
        HttpResponse res = Continuation.getResponse((String)state);
        system.debug('res11111'+res);
        String responseBody=res.getbody();
        system.debug(responseBody); 
        try{
            CustomLogUtil.CustomLoggingEntry('Continuation Response Body' + responseBody);
            if(responseBody=='{}'){
                CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +responseBody);
                errorMsgs.add(Label.No_Match_Found);
            }
            else if(res.getStatusCode()==500)
            {
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
                errorMsgs.add(Label.The_request_could_not_reach_server);
            }
            else if(res.getStatusCode()==403)
            {
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
                String subStrResponse=responseBody.substringAfterLast('<u>');
                String subStrResponse1=subStrResponse.substringBeforeLast('</u>');
                system.debug(subStrResponse1);
                errorMsgs.add(subStrResponse1);
            }
            else if(res.getStatusCode()==400)
            {
              //  CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
             //   errorMsgs.add('Error from Informatica with Response Code 400');
          		  CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +responseBody);
                  errorMsgs.add(Label.No_Match_Found);
 			}
            else
            {
                custSearch=JSON2ApexCustomerCDM.parse(responseBody);
                list<string> set_accounts= new list<string>();
                For(JSON2ApexCustomerCDM.cls_OP_UCID cust : custSearch.OP_UCID){
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                    if(string.valueof(m.get(Label.AdminClientNum))!=null)
                        set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                }
                system.debug(set_accounts.size());
                if(set_accounts.size()==0){
                    errorMsgs.add(Label.No_Match_Found);
                }
                if(set_accounts.size()>0){
                    string querytxt='select id,firstname,UCID__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,ID_Number__c,Lastmodifieddate  from account where <Search> in (';
                    querytxt=querytxt.replace('<Search>',label.SearchKey); 
                    set<String> valueSet = new set<String>();
                    for(Integer i=0; i<set_accounts.size(); i++){
                        valueSet.add('\'' + String.escapeSingleQuotes(set_accounts[i]) + '\'');
                    }
                    if (valueSet.isEmpty()){
                        valueSet.add('\'\'');
                    }
                    querytxt=querytxt+ String.join(new list<String>(valueSet),',') + ') ORDER BY Lastmodifieddate DESC limit ' +label.limitsize;
                    for(account acc :database.query(querytxt)){
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company')
                            DedupAccountList.add(acc);
                    }
                    system.debug(DedupAccountList.size());
                    if(DedupAccountList.size()==0){
                        errorMsgs.add(Label.No_Match_Found);
                    }
                }
            }
        }
        catch (Exception e){
            errorMsgs.add(label.InformaticaError);       
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        if(errorMsgs.size()>1){
            return errorMsgs;
        }else{
            return DedupAccountList;
        }
    }
    /** Mehtod to generate CDM End Point URL **/
  /*  public static String generateCDMEndPointURL(String Recordtype, Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
        String endUrl='';
        String Birthdate='';
        try{
            if(objAccount.PersonBirthdate!= null){   
                Birthdate = String.valueOf(objAccount.PersonBirthdate);
            }
            map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
            for(string str: mapURLs.keyset()){
                if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                    endUrl+=mapURLs.get(str).Informatica_URL__c;
                }
            }
            //endUrl+='https://stwnodered.herokuapp.com/addresscheck?';
            if(recordType == 'Person Account'){
                endUrl+='ip_Firstname='+((string.isnotblank(objAccount.firstname))?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
                endUrl+='&ip_LastName='+((string.isnotblank(objAccount.LastName))?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+((string.isnotblank(objAccount.Mobile__c))?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&ip_HomeTelephone='+((string.isnotblank(objAccount.Individual_Home_Phone__c ))?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&ip_PersonalEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');
                endUrl+='&ip_IDTYPE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Type__c,'UTF-8'):''); 
                endUrl+='&ip_IDVALUE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Number__c,'UTF-8'):'');
                
            }else if(recordType == 'Company'){
                endUrl+='ip_Orgname='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&ip_HomeTelephone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&ip_BusinessEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');
                endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                
            }
            endUrl+='&ip_AddressUsageValue='+(string.isnotblank(AddressObj.Address_Type__c)?EncodingUtil.URLENCODE(AddressObj.Address_Type__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineOne='+(string.isnotblank(AddressObj.Address_Line_1__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineTwo='+(string.isnotblank(AddressObj.Address_Line_2__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineThree='+(string.isnotblank(AddressObj.Address_Line_3__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_3__c,'UTF-8'):'');
            endUrl+='&ip_StateCityValue='+(string.isnotblank(AddressObj.State_City__c)?EncodingUtil.URLENCODE(AddressObj.State_City__c,'UTF-8'):'');
            endUrl+='&ip_SubUrbValue='+(string.isnotblank(AddressObj.Suburb__c)?EncodingUtil.URLENCODE(AddressObj.Suburb__c,'UTF-8'):'');
            endUrl+='&ip_ZipPostalCode='+(string.isnotblank(AddressObj.ZipCode__c)?EncodingUtil.URLENCODE(AddressObj.ZipCode__c,'UTF-8'):'');
            endUrl+='&ip_Country='+(String.isnotblank(AddressObj.Country__c)?EncodingUtil.URLENCODE(AddressObj.Country__c,'UTF-8'):'');
            
        }catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        return endUrl;
    } */
    
	//implemented for FM markets
    @RemoteAction
    global static object onLineDeduplicationFM(String Recordtype, Boolean firstsave,String market,String objAccountString,String AddressObjString){  
        Account objAccount=new Account();
        Address__c AddressObj=new Address__c();
        list<String> errorMsgs = new List<String>();
        Map<String,list<String>> errorMap=new Map<String,list<String>>();
        objAccount=(Account)JSON.deserialize(objAccountString, Account.class);
        AddressObj=(Address__c)JSON.deserialize(AddressObjString, Address__c.class);
        Continuation con=null;    
        String requestLabel=null;
        String Province='';
        String district='';
        String SubDIstrict='';
        String zip='';
        String EndUrl=generateCDMEndPointURLFM(Recordtype,objAccount,firstsave,market,AddressObj);
        system.debug(EndUrl);
        try{    
            if(label.New_Component=='true'){
                con = new Continuation(120);     
                con.continuationMethod='processResponse';
                con.state =CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl,con);
                system.debug(con.getRequests());
                return con;
            }
            else{
                errorMsgs.add(Label.No_Match_Found);  
            }
        }catch(Exception e){
            errorMsgs.add(label.InformaticaError);   
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        } 
        if(errorMsgs.size()>0){
            errorMap.put('Error',errorMsgs);
        }
        return errorMap;
    }
    
    /** Mehtod to generate CDM End Point URL for FM markets**/
    public static String generateCDMEndPointURLFM(String Recordtype, Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
        String endUrl='';
        String Birthdate='';
        List<IntegrationURL_parameters__mdt> parametersLst;
        try{
            if(objAccount.PersonBirthdate!= null){   
                Birthdate = String.valueOf(objAccount.PersonBirthdate);
            }
            map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
            for(string str: mapURLs.keyset()){
                if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                    endUrl+=mapURLs.get(str).Informatica_URL__c;
                }
            }
            //endUrl+='https://stwnodered.herokuapp.com/addresscheck?';
            if(recordType == 'Person Account'){
                parametersLst=[select Parameters__c from IntegrationURL_parameters__mdt where sObject__c='Account' and Record_Type__c=:recordType and market__c=:market];
                endUrl=getEndURL(parametersLst,endUrl,objAccount);
                /*endUrl+='ip_Firstname='+((string.isnotblank(objAccount.firstname))?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
                endUrl+='&ip_LastName='+((string.isnotblank(objAccount.LastName))?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+((string.isnotblank(objAccount.Mobile__c))?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&ip_HomeTelephone='+((string.isnotblank(objAccount.Individual_Home_Phone__c ))?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&ip_PersonalEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');
                endUrl+='&ip_IDTYPE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Type__c,'UTF-8'):''); 
                endUrl+='&ip_IDVALUE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Number__c,'UTF-8'):'');*/
                
            }else if(recordType == 'Company'){
                parametersLst=[select Parameters__c from IntegrationURL_parameters__mdt where sObject__c='Account' and Record_Type__c=:recordType and market__c=:market];
                endUrl=getEndURL(parametersLst,endUrl,objAccount);
                /*endUrl+='ip_Orgname='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&ip_HomeTelephone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&ip_BusinessEmail='+(string.isnotblank(objAccount.Email__c)?objAccount.Email__c:'');
                endUrl+='&ip_BusinessTelephone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');*/
                
            }
            parametersLst=[select Parameters__c from IntegrationURL_parameters__mdt where sObject__c='Address' and market__c=:market];
            endUrl=getEndURL(parametersLst,endUrl,AddressObj);
            /*endUrl+='&ip_AddressUsageValue='+(string.isnotblank(AddressObj.Address_Type__c)?EncodingUtil.URLENCODE(AddressObj.Address_Type__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineOne='+(string.isnotblank(AddressObj.Address_Line_1__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_1__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineTwo='+(string.isnotblank(AddressObj.Address_Line_2__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_2__c,'UTF-8'):'');
            endUrl+='&ip_AddressLineThree='+(string.isnotblank(AddressObj.Address_Line_3__c)?EncodingUtil.URLENCODE(AddressObj.Address_Line_3__c,'UTF-8'):'');
            endUrl+='&ip_StateCityValue='+(string.isnotblank(AddressObj.State_City__c)?EncodingUtil.URLENCODE(AddressObj.State_City__c,'UTF-8'):'');
            endUrl+='&ip_SubUrbValue='+(string.isnotblank(AddressObj.Suburb__c)?EncodingUtil.URLENCODE(AddressObj.Suburb__c,'UTF-8'):'');
            endUrl+='&ip_ZipPostalCode='+(string.isnotblank(AddressObj.ZipCode__c)?EncodingUtil.URLENCODE(AddressObj.ZipCode__c,'UTF-8'):'');
            endUrl+='&ip_Country='+(String.isnotblank(AddressObj.Country__c)?EncodingUtil.URLENCODE(AddressObj.Country__c,'UTF-8'):'');*/
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('endUrl---'+endUrl);
        return endUrl;
    } 
    
    public static String getEndURL(List<IntegrationURL_parameters__mdt> parametersLst,String endUrl,sObject sObj)
    {
        if(parametersLst!=null && parametersLst.size()>0)
        {
            String urlParameters=parametersLst[0].Parameters__c;
            if(urlParameters!=null && urlParameters!='' && urlParameters.length()>0)
            {
                List<String> fieldsLst=urlParameters.split(',');
                for(String field:fieldsLst)
                {
                    List<String> urlParameter2FieldAPI=field.split(':');
                    String urlParameter=urlParameter2FieldAPI[0];
                    String fieldApiName=urlParameter2FieldAPI[1];
                    //if it is a first element of list
                    if(field==fieldsLst[0])
                        endUrl+='ip_'+urlParameter+'='+((string.isnotblank((String)sObj.get(fieldApiName)))?EncodingUtil.URLENCODE((String)sObj.get(fieldApiName),'UTF-8'):'');
                    else
                        endUrl+='&ip_'+urlParameter+'='+((string.isnotblank((String)sObj.get(fieldApiName)))?EncodingUtil.URLENCODE((String)sObj.get(fieldApiName),'UTF-8'):'');     
                }
            }
        }
        return endUrl;
    }
    
    /*India Start*/
    public String generateCDMEndPointURLIN(String Recordtype, Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
        String endUrl='';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                endUrl+=mapURLs.get(str).Informatica_URL__c+'?';
            }
        }
        
        if(recordType == 'Person Account')
        {
            if(market == System.Label.IN){
                endUrl+='inp_JSON_FirstName='+(string.isnotblank(objAccount.firstname)?EncodingUtil.URLENCODE(objAccount.FirstName,'UTF-8'):'');
                endUrl+='&inp_JSON_LastName='+(string.isnotblank(objAccount.LastName)?EncodingUtil.URLENCODE(objAccount.LastName,'UTF-8'):'');
                endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c )?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
                endUrl+='&inp_JSON_PAN='+(string.isnotblank(objAccount.PAN__c)?EncodingUtil.URLENCODE(objAccount.PAN__c,'UTF-8'):''); 
                endUrl+='&inp_JSON_Aadhar='+(string.isnotblank(objAccount.Aadhaar__c)?EncodingUtil.URLENCODE(objAccount.Aadhaar__c,'UTF-8'):'');
            }
            else if(market == System.Label.TR){
                endUrl += 'in_JSON_FirstName=' + ((string.isnotblank(objAccount.firstname)) ? EncodingUtil.URLENCODE(objAccount.FirstName, 'UTF-8') : '');
                endUrl += '&in_JSON_LastName=' + ((string.isnotblank(objAccount.LastName)) ? EncodingUtil.URLENCODE(objAccount.LastName, 'UTF-8') : '');
                endUrl += '&in_JSON_Mobile=' + ((string.isnotblank(objAccount.Mobile__c)) ? EncodingUtil.URLENCODE(objAccount.Mobile__c, 'UTF-8') : '');
                endUrl += '&in_JSON_Email=' + (string.isnotblank(objAccount.Email__c) ? objAccount.Email__c : '');
                endUrl += '&in_JSON_SocialID=' + (string.isnotblank(String.valueof(objAccount.Social_Id__c)) ?  EncodingUtil.URLENCODE(String.valueof(objAccount.Social_Id__c), 'UTF-8') : '');
            }
        }
        else if(recordType == 'Company'){
            if(market == System.Label.IN){
                endUrl+='inp_JSON_CompanyName='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                endUrl+='&inp_JSON_Mobile='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                endUrl+='&inp_JSON_HomePhone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_WorkPhone='+(string.isnotblank(objAccount.Work_Phone__c)?EncodingUtil.URLENCODE(objAccount.Work_Phone__c,'UTF-8'):'');
                endUrl+='&inp_JSON_Email='+(string.isnotblank(objAccount.Email__c)?EncodingUtil.URLENCODE(objAccount.Email__c,'UTF-8'):'');
                endUrl+='&inp_JSON_GSTIN='+(string.isnotblank(objAccount.GSTN_Number__c)?EncodingUtil.URLENCODE(objAccount.GSTN_Number__c,'UTF-8'):'');
                endUrl+='&inp_JSON_CIN='+(string.isnotblank(objAccount.CIN_Number__c)?EncodingUtil.URLENCODE(objAccount.CIN_Number__c,'UTF-8'):'');
            }
            else if(market == System.Label.TR){
                endUrl += 'in_JSON_CompanyName=' + (string.isnotblank(objAccount.Name) ? EncodingUtil.URLENCODE(objAccount.Name, 'UTF-8') : '');
                endUrl += '&in_JSON_WorkPhone=' + (string.isnotblank(objAccount.Work_Phone__c) ? EncodingUtil.URLENCODE(objAccount.Work_Phone__c, 'UTF-8') : '');
                endUrl += '&in_JSON_VATNo=' + (string.isnotblank(String.valueof(objAccount.Vat_No__c)) ? EncodingUtil.URLENCODE(String.valueof(objAccount.Vat_No__c), 'UTF-8') : '');
                endUrl += '&in_JSON_City=' + (string.isnotblank(AddressObj.city__c) ? EncodingUtil.URLENCODE(AddressObj.city__c, 'UTF-8')  : '');
            }
        }
        return endUrl;
    } 
    
    global static Object processResponseIN(Object state) {//List<account>
        list<String> errorMsgs = new List<String>();
        errorMsgs.add('Error');
        JSON2ApexCustomerFromCDM custSearch=null;
        List<account> DedupAccountList=new List<account>();
        HttpResponse res = Continuation.getResponse((String)state);
        system.debug('res11111'+res);
        String responseBody=res.getbody();
        system.debug(responseBody);
        try{
            
            CustomLogUtil.CustomLoggingEntry('Continuation Response Body' + responseBody);
            if(responseBody=='{}'){
                CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +responseBody);
                errorMsgs.add(Label.No_Match_Found);
            }
            else if(res.getStatusCode()==500)
            {
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
                errorMsgs.add(Label.The_request_could_not_reach_server);
            }
            else
            {
                custSearch=JSON2ApexCustomerFromCDM.parse(responseBody);
                list<string> set_accounts= new list<string>();
                For(JSON2ApexCustomerFromCDM.Out_JSON_UCID_List cust : custSearch.out_JSON_UCID_List){
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                    if(string.valueof(m.get(Label.AdminClientNum))!=null)
                        set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                }
                system.debug(set_accounts.size());
                if(set_accounts.size()==0){
                    errorMsgs.add(Label.No_Match_Found);
                }
                if(set_accounts.size()>0){
                    string querytxt='select id,firstname,UCID__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,ID_Number__c,Lastmodifieddate  from account where <Search> in (';
                    querytxt=querytxt.replace('<Search>',label.SearchKey); 
                    set<String> valueSet = new set<String>();
                    for(Integer i=0; i<set_accounts.size(); i++){
                        valueSet.add('\'' + String.escapeSingleQuotes(set_accounts[i]) + '\'');
                    }
                    if (valueSet.isEmpty()){
                        valueSet.add('\'\'');
                    }
                    querytxt=querytxt+ String.join(new list<String>(valueSet),',') + ') ORDER BY Lastmodifieddate DESC limit ' +label.limitsize;
                    for(account acc :database.query(querytxt)){
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company')
                            DedupAccountList.add(acc);
                    }
                    system.debug(DedupAccountList.size());
                    if(DedupAccountList.size()==0){
                        errorMsgs.add(Label.No_Match_Found);
                    }
                }
            }
        }
        catch (Exception e){
            errorMsgs.add(label.InformaticaError);       
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        if(errorMsgs.size()>1){
            return errorMsgs;
        }else{
            return DedupAccountList;
        }
    }
    /*India End*/
}