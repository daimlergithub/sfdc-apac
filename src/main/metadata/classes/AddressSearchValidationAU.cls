/**************************************************************************************************************************************************************************** 
* File Name     : AddressSearchValidationAU
* Description   : This Class is part of the Factory model and is the Market Specific Class
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with AddressSearchValidationDefault,AddressSearchValidationFactory,AddressSearchValidation are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys  
* Author Modification & Ver.Date : Sravani & 22/08/2018
**************************************************************************************************************************************************************/ 
public class AddressSearchValidationAU extends AddressSearchValidationDefault implements AddressSearchValidation{
    // use recordType , componentName to put appropriate values in map 
    // override method here  
    
    public override void onLineDeduplicationCheck(List<sObject> sObjList, String filterName){
        Account account;
        Opportunity oppty;
        Contact contact;
        Address__c address;
        list<String> errorMsgs = new List<String>();
        String errorMsg='Error-';
        if(filterName=='AddressSearchValidation'){
            for(sObject sObj:sObjList){
                if (sObj.getSObjectType() == Schema.Contact.sObjectType) {
                    contact = (Contact) sObj;
                } else if (sObj.getSObjectType() == Opportunity.sObjectType){
                    oppty = (Opportunity) sObj;
                } else if (sObj.getSObjectType() == Schema.Account.sObjectType){
                    account = (Account) sObj;
                    system.debug(account);
                } else if (sObj.getSObjectType() == Address__c.sObjectType) {
                    address =(Address__c) sObj;
                    if(address.Market__c=='AU')
                    	address.Country__c='Australia';
                    else if(address.Market__c=='NZ')
                    	address.Country__c='New Zealand';
                }
            }
            try{
                boolean errorFlag=true;
                boolean mandatoryFlag=True;
                boolean recordCheck=true;
                if(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId)!=null){
                    if(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()!=Label.PersonAccount && Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()!=Label.Company){
                        recordCheck=false;
                        errorMsgs.add(Label.RecordTypeError);
                        errorMsg+=Label.RecordTypeError;
                        errorMsg+='-';
                    }
                    if(recordCheck && Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()== Label.PersonAccount?account.FirstName==null || account.LastName==null:false){
                        mandatoryFlag=false;
                        errorMsgs.add(Label.PersonAccountSearchErrorANZ);
                        errorMsg+=Label.PersonAccountSearchErrorANZ;
                        errorMsg+='-';
                    }
                    if(recordCheck && mandatoryFlag && Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()==Label.Company?account.name==null:false){   
                        mandatoryFlag=false;
                        errorMsgs.add(Label.CompanyAccountSearchErrorANZ);  
                        errorMsg+=Label.CompanyAccountSearchErrorANZ;
                        errorMsg+='-';
                    }
                    if(recordCheck && mandatoryFlag){
                        if(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()==Label.PersonAccount && account.Individual_Home_Phone__c==null && account.Mobile__c==null && account.Work_Phone__c==null && account.Email__c == null && account.ID_Number__c==null){        
                            errorMsgs.add(Label.PersonAccountSearchErrorANZ);       
                            errorFlag=false;
                            errorMsg+=Label.PersonAccountSearchErrorANZ;
                            errorMsg+='-';
                        } 
                        if(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(account.RecordTypeId).getName()==Label.Company && string.isblank(account.Email__c) && string.isblank(account.Work_Phone__c) && errorFlag && string.isblank(account.Mobile__c)  ){        
                            errorMsgs.add(Label.CompanyAccountSearchErrorANZ);       
                            errorFlag=false;
                            errorMsg+=Label.CompanyAccountSearchErrorANZ;
                            errorMsg+='-';
                        }
                    }
                }else{
                    errorMsgs.add(Label.RecordTypeError);
                    errorMsg+=Label.RecordTypeError;
                    errorMsg+='-';
                }
                if(errorMsg!='Error-'){
                    AuraHandledException auraExp=new AuraHandledException(errorMsg);
                    auraExp.setMessage(errorMsg);
                    throw auraExp;
                }
            }catch(Exception e){
                errorMsgs.add(e.getMessage());
                AuraHandledException auraExp=new AuraHandledException(e.getMessage());
                auraExp.setMessage(e.getMessage());
                throw auraExp;
            }
        }
        if(errorMsgs.size()>0){
            deduplicationMap.put('Error',errorMsgs);
        }else{
            deduplicationMap.put('Error',new List<String>());
            deduplicationMap.put('buttons',new List<String>{Label.Cancel_Button,Label.Save_Button}); 
            deduplicationMap.put('fromCDM',new List<String>{'false'});
        }
        system.debug(deduplicationMap);
    }
    
    public override void saveForm(List<sObject> sObjList, String filterName){
        Account account;
        Opportunity oppty;
        Contact contact;
        Address__c address;
        list<String> errorMsgs = new List<String>();
        String errorMsg='Error-';
        if(filterName=='AddressSearchValidation'){
            for(sObject sObj:sObjList){
                if (sObj.getSObjectType() == Schema.Contact.sObjectType) {
                    contact = (Contact) sObj;
                } else if (sObj.getSObjectType() == Opportunity.sObjectType){
                    oppty = (Opportunity) sObj;
                } else if (sObj.getSObjectType() == Schema.Account.sObjectType){
                    account = (Account) sObj;
                } else if (sObj.getSObjectType() == Address__c.sObjectType) {
                    address =(Address__c) sObj;
                    if(address.Market__c=='AU')
                    	address.Country__c='Australia';
                    else if(address.Market__c=='NZ')
                    	address.Country__c='New Zealand';
                }
            }
            try{
                if(address.Address_Type__c == null || address.Address_Type__c == '--None--' || address.Address_Type__c == ''){
                    if(((address.Address_Line_1__c!=null && address.Address_Line_1__c!='') || (address.Address_Line_2__c!=null && address.Address_Line_2__c!='') || (address.Address_Line_3__c!=null && address.Address_Line_3__c!='') || (address.ZipCode__c!=null && address.ZipCode__c!='')) && (address.Country__c=='Australia' || address.Country__c=='New Zealand')){
                        errorMsgs.add(Label.AddressTypeValidationANZ);
                        errorMsg+=Label.AddressTypeValidationANZ;
                        errorMsg+='-';
                    }else{
                        String returnValue=saveAccountDetailsANZ(account);
                        if(returnValue.contains('-') && returnValue!='Error-'){
                            String[] receivedMsgs=returnValue.split('-');
                            for(String msg:receivedMsgs){
                                if(msg!='Error' && msg!=null){
                                    errorMsgs.add(msg); 
                                    errorMsg+=msg;
                                    errorMsg+='-';
                                }
                            }
                        }else{
                            if(returnValue!='Error-'){
                                saveMap.put('recordId',new List<String>{returnValue});
                            }
                        }
                    }
                }else if(address.Address_Type__c!= null){
                    String returnValue=validateAddressANZ(address,account);
                    if(returnValue.contains('-') && returnValue!='Error-'){
                        String[] receivedMsgs=returnValue.split('-');
                        for(String msg:receivedMsgs){
                            if(msg!='Error' && msg!=null){
                                errorMsgs.add(msg); 
                                errorMsg+=msg;
                                errorMsg+='-';
                            }
                        }
                    }else{
                        if(returnValue!='Error-'){
                            saveMap.put('recordId',new List<String>{returnValue});
                        }
                    }
                }
                if(errorMsg!='Error-'){
                    AuraHandledException auraExp=new AuraHandledException(errorMsg);
                    auraExp.setMessage(errorMsg);
                    throw auraExp;
                }
            }catch(Exception e){
                errorMsgs.add(e.getMessage());
                AuraHandledException auraExp=new AuraHandledException(e.getMessage());
                auraExp.setMessage(e.getMessage());
                throw auraExp;
            }
            if(errorMsgs.size()>0){
                saveMap.put('Error',errorMsgs);
            }else{
                saveMap.put('Error',new List<String>());
                saveMap.put('buttons',new List<String>{Label.Cancel_Button,Label.Save_Button}); 
            }
        }
        system.debug(saveMap);
    }
    
    public String saveAccountDetailsANZ(Account objAccount){    
        String msgs='Error-';
        try{
            if(objAccount.Individual_Home_Phone__c==null)
            	objAccount.Individual_Home_Phone__c='';
            if(objAccount.Mobile__c==null)
            	objAccount.Mobile__c='';
            if(objAccount.Work_Phone__c==null)
            	objAccount.Work_Phone__c='';
            String recordType=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(objAccount.RecordTypeId).getName();
            if(recordType == Label.PersonAccount){
                objAccount.status__C = Label.ProspectStatus;
            }  
            Boolean phValidate = true;
            //Email validation 
            if(objAccount.Email__c != null && recordType == System.Label.PersonAccount ){
                string emailraw = objAccount.Email__c; 
                String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; 
                emailraw = emailraw.replace('@@', '@'); //replace @@ to single @
                emailraw = emailraw.replace('..', '.'); //replace .. to single .
                emailraw = emailraw.replace('.@', '@'); //replace .@ to single @
                emailraw = emailraw.replace('@.', '@'); //replace @. to single @
                emailraw = emailraw.removeStart('.');// remove “.” as the first character of an e-mail address.
                emailraw = emailraw.removeEnd('.');// remove “.” as the last character of an e-mail address.
                emailraw= emailraw.replaceAll( '\\s+', ''); // remove spaces
                if(!Pattern.matches(emailRegex,emailraw)){
                    phValidate = false;
                    msgs += label.EmailValidationANZ;
                }
                else{
                    objAccount.Email__c = emailraw; 
                }
            }
            if(objAccount.Name == '' && recordType == System.Label.Company){        
                phValidate = false; 
                msgs+=label.Account_Name_is_mandatory;
                msgs+='-';
            }
            if(objAccount.LastName == '' && recordType == System.Label.PersonAccount){        
                phValidate = false;                    
                msgs+=label.Last_Name_is_mandatory;
                msgs+='-';
            }
            if(objAccount.FirstName == '' && recordType == System.Label.PersonAccount){        
                phValidate = false;
                msgs+=label.First_Name_is_mandatory;
                msgs+='-';
            }
            if(objAccount.Individual_Home_Phone__c == '' && objAccount.Mobile__c == '' &&  objAccount.Work_Phone__c  == '' && objAccount.Email__c == null ){        
                phValidate = false; //Added for check
                msgs+=Label.contact_information;
                msgs+='-';
            }else{
                if(phValidate){
                    DMLManagerService.insertAsSystem(objAccount);  
                    return objAccount.Id; 
                }else{
                    AuraHandledException auraExp=new AuraHandledException(msgs);
                    auraExp.setMessage(msgs);
                    throw auraExp;
                }
            } 
            if(msgs!='Error-'){
                AuraHandledException auraExp=new AuraHandledException(msgs);
                auraExp.setMessage(msgs);
                throw auraExp;
            }
        }catch(DMLException e){     
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            system.debug('enetered exception dml');
            if(e.getdmlMessage(0).contains('bad field') ){
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
                msgs+='Please remove the firstname , lastname  for saving company account and account name for person account';
                msgs+='-';
                auraExp.setMessage('Please remove the firstname , lastname  for saving company account and account name for person account');
            }else{               
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + e);
                msgs+=e.getdmlMessage(0);
                msgs+='-';
                auraExp.setMessage(e.getdmlMessage(0));
            }
            throw auraExp;
        }catch(Exception e){
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;
        }              
        return msgs;
    }
    
    public String validateAddressANZ(Address__c addressobj, Account objAccount){ 
        String msgs='Error-';
        String accountCombId='';
        try{ 
            String recordType=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(objAccount.RecordTypeId).getName();            
            String ZipCheck = '^([0-9]{3,4})'; 
            if(AddressObj.Address_Type__c != null ){
                if(addressobj.ZipCode__c != null  && (!Pattern.matches(ZipCheck,addressobj.ZipCode__c))){         
                    msgs+=label.PostalCodeValidationANZ;  
                    msgs+='-';
                } 
                if(addressobj.ZipCode__c == null){       
                    msgs+=label.PostalCodeMandatoryANZ;   
                    msgs+='-';
                }
                if(addressobj.Address_Line_1__c == null){       
                    msgs+=label.Addressline1Mandatory; 
                    msgs+='-';
                }       
                else{       
                    if(addressobj.Address_Line_1__c.length()>100){         
                        msgs+=label.MYAddressline1Length;    
                        msgs+='-';
                    }       
                } 
                if(addressobj.State_City__c == null){       
                    msgs+=label.StateMandatoryANZ;    
                    msgs+='-';
                }       
                if(String.isNotBlank(addressobj.Address_Line_2__c) && addressobj.Address_Line_2__c.length()>100){        
                    msgs+=label.Addressline2LengthANZ;   
                    msgs+='-';
                }
                if(String.isNotBlank(addressobj.Address_Line_3__c) && addressobj.Address_Line_3__c.length()>100){ 
                    msgs+=label.Addressline3LengthANZ;    
                    msgs+='-';
                }  
                if(msgs=='Error-'){
                    accountCombId=SaveAccountDetailsANZ(objAccount);
                    if(!accountCombId.contains('Error')){
                        String accountId=accountCombId;
                        addressobj.Customer__c = accountId; 
                        addressobj.Preferred__c=true; 
                        DMLManagerService.insertAsSystem(addressobj);
                        return accountId;
                    }else{
                        msgs+=accountCombId;
                    }
                }
                if(msgs!='Error-'){
                    AuraHandledException auraExp=new AuraHandledException(msgs);
                    auraExp.setMessage(msgs);
                    throw auraExp;
                }else{
                    return null;
                }
            }else{
                return null;
            }        
        }catch(DMLException e){         
            CustomLogUtil.CustomLoggingEntry('error' + e);    
            msgs+=e.getdmlMessage(0);
            msgs+='-';
            AuraHandledException auraExp=new AuraHandledException(e.getdmlMessage(0));
            auraExp.setMessage(e.getdmlMessage(0));
            throw auraExp;
        }catch(Exception e){         
            CustomLogUtil.CustomLoggingEntry('error' + e);    
            msgs+=e.getMessage();
            msgs+='-';
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;
        }  
    }
    
    /** Mehtod to generate CDM End Point URL **/
    public override String getCDMURLMarket(String Recordtype, Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
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
                //endUrl+='&ip_IDTYPE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Type__c,'UTF-8'):''); 
                //endUrl+='&ip_IDVALUE='+((string.isnotblank(objAccount.ID_Type__c)&& string.isnotblank(objAccount.ID_Number__c))?EncodingUtil.URLENCODE(objAccount.ID_Number__c,'UTF-8'):'');
                
            }else if(recordType == 'Company'){
                endUrl+='ip_Orgname='+(string.isnotblank(objAccount.Name)?EncodingUtil.URLENCODE(objAccount.Name,'UTF-8'):'');
                endUrl+='&ip_MobileTelephone='+(string.isnotblank(objAccount.Mobile__c)?EncodingUtil.URLENCODE(objAccount.Mobile__c,'UTF-8'):'');
                //endUrl+='&ip_HomeTelephone='+(string.isnotblank(objAccount.Individual_Home_Phone__c)?EncodingUtil.URLENCODE(objAccount.Individual_Home_Phone__c,'UTF-8'):'');
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
            endUrl+='&ip_geographicalRegion='+(String.isnotblank(objAccount.Market__c)?EncodingUtil.URLENCODE(ObjAccount.Market__c,'UTF-8'):'');
        system.debug(endUrl);
        }catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + 'Error Details :  '+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        return endUrl;
    } 
}