public class AddressSearchValidationFM extends AddressSearchValidationDefault implements AddressSearchValidation{

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
        deduplicationMap.put('buttons',new List<String>{Label.OnLine_Deduplication,Label.Cancel_Button,Label.Save_Button}); 
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
			}
		}
        System.debug('address----'+address);
		try{
			if(address.Address_Type__c == null || address.Address_Type__c == '--None--' || address.Address_Type__c == ''){
				if((address.Address_Line_1__c!=null || address.Address_Line_2__c!=null || address.Address_Line_3__c!=null || address.ZipCode__c!=null) ){
                        errorMsgs.add(Label.AddressTypeValidationFM);
                        errorMsg+=Label.AddressTypeValidationFM;
                        errorMsg+='-';
                } else {
                    String returnValue=saveAccountDetailsFM(account);
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
                    String returnValue=validateAddressFM(address,account);
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
                saveMap.put('buttons',new List<String>{Label.OnLine_Deduplication,Label.Cancel_Button,Label.Save_Button}); 
            }
        }
        system.debug(saveMap);
}
    //save account details for FM markets
    private String saveAccountDetailsFM(Account objAccount){
        String msgs='Error-';
        try{
            String recordType=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(objAccount.RecordTypeId).getName();
            if(recordType == Label.PersonAccount){
                objAccount.status__C = Label.ProspectStatus;
            } 
            Boolean phValidate = true;
            if((objAccount.Individual_Home_Phone__c == ''|| objAccount.Individual_Home_Phone__c ==null) && (objAccount.Mobile__c == '' || objAccount.Mobile__c == null) &&  (objAccount.Work_Phone__c  == '' || objAccount.Work_Phone__c  == null) && (objAccount.Email__c == null || objAccount.Email__c == '') ){        
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
   
    public String validateAddressFM(Address__c addressobj, Account objAccount){ 
        String msgs='Error-';
        String accountCombId='';
        try{ 
            String recordType=Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(objAccount.RecordTypeId).getName();            
            //String ZipCheck = '^([0-9]{5,6})'; 
            if(AddressObj.Address_Type__c != null ){
                //CoC review feedback:Removed Validation on Zipcode 
                /*if(addressobj.ZipCode__c != null  && (!Pattern.matches(ZipCheck,addressobj.ZipCode__c))){         
                    msgs+=label.PostalCodeValidationANZ;  
                    msgs+='-';
                }
                if(addressobj.ZipCode__c == null){       
                    msgs+=label.PostalCodeMandatoryANZ;   
                    msgs+='-';
                }*/
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
                if(String.isNotBlank(addressobj.Address_Line_2__c) && addressobj.Address_Line_2__c.length()>100){        
                    msgs+=label.Addressline2LengthANZ;   
                    msgs+='-';
                }
                if(String.isNotBlank(addressobj.Address_Line_3__c) && addressobj.Address_Line_3__c.length()>100){ 
                    msgs+=label.Addressline3LengthANZ;    
                    msgs+='-';
                }  
                if(msgs=='Error-'){
                    accountCombId=SaveAccountDetailsFM(objAccount);
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
}