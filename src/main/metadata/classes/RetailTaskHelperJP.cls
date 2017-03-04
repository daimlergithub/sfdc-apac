/*
  1.New Account Link record will create when Supporting Dealer is populated.
  Created By: Venkataramana Cheedara
  Date: 2016-10-20
*/
public class RetailTaskHelperJP {

    public static void RetailTaskDetails(list<Retail_Task__c> rtlst, map<id,Retail_Task__c> leadOldMap, boolean isInsert, boolean isUpdate){
        
        set<String> contactId = new set<String>();
        set<Id> sId = new set<Id>();
        set<Id> aId = new set<Id>();
        
        for(Retail_Task__c rt : rtlst){
            if(rt.Supporting_Dealer__c != null && (rt.MD__c == Label.MarketKR || rt.MD__c == label.MarketJP)){
                if(isInsert || (isUpdate && rt.Supporting_Dealer__c != leadOldMap.get(rt.id).Supporting_Dealer__c)){
                    System.debug('Is Insert OR Update called -----:::::');
                    contactId.add(rt.id);
                    sId.add(rt.Supporting_Dealer__c);
                    aId.add(rt.Account__c);
                    
                }
            }
                
        }
        system.debug('++++++++++++sId'+sId);
        system.debug('++++++++++++aId'+aId);
        system.debug('++++++++++++contact'+contactId);
        
        List<Account_Link__c> acli = [Select id,fromRole__c,toRole__c From Account_Link__c Where fromRole__c =:sId AND toRole__c =:aId AND Retail_Delete_Flag__c= false AND (RecordType.Name IN ('Retail Company') OR RecordType.Name IN ('Retail Person'))];
        system.debug('++++++++++aci'+acli );
        if(!contactId.isEmpty() && acli.size() == 0 && acli.isEmpty()){
            createAccountLinkRecord(contactId);
            system.debug('++++++++++++Id'+contactId);
        }
        
    }
    
    public static void createAccountLinkRecord(set<String> contactId){        
        List<Retail_Task__c> rtlst = [select Id, Account__c, Supporting_Dealer__c ,Account__r.LastName, Account__r.FirstName,Account__r.LastName_Native_1__c, 
                                 Account__r.FirstName_Native_1__c, Account__r.PersonBirthdate, Account__r.Special_Care__c, Account__r.Individual_Home_Phone__c, Account__r.Work_Phone__c,
                                 Account__r.Mobile__c, Account__r.Fax, Account__r.Email__c, Account__r.Primary_Address_Reference__r.City__c, Account__r.Primary_Address_Reference__r.District__c,
                                 Account__r.Primary_Address_Reference__r.Block__c, Account__r.Primary_Address_Reference__r.Address_Line_1__c,
                                 Account__r.Primary_Address_Reference__r.Address_Line_2__c, Account__r.Primary_Address_Reference__r.ZipCode__c,
                                 Account__r.Primary_Address_Reference__r.CreatedDate, Account__r.Primary_Address_Reference__r.LastModifiedDate,
                                 Account__r.gender__c, Account__r.Occupation__c, Account__r.Industry,Account__r.Preferred_Language__c,
                                 Account__r.Special_Needs_Class__c, Account__r.Allow_Data_Sharing2__c, Account__r.Primary_Address_Reference__r.Address_Type__c, 
                                 Account__r.Primary_Address_Reference__r.Province__c, Account__r.Preferred_Contact_Method__c,MD__c,
                                 Account__r.UCID__c, Account__r.RecordtypeId, Account__r.Name, Account__r.Company_Name_Native_1__c,Account__r.Foundation_Date__c,
                                 Account__r.Website                                             
                                 from Retail_Task__c WHERE id IN : contactId
                                ];
         List<Account_Link__c> accLst = new List<Account_Link__c>();     
         Account_Link__c acclnk = new Account_Link__c();  
         Map<String,Id> recordTypes = new Map<String,Id>();
         for(RecordType rt : [select id,DeveloperName from RecordType WHERE DeveloperName IN ( 'ContactSector' ,'Retail_Company', 'Retail_Person' ) ] ){
             recordTypes.put(rt.DeveloperName,rt.Id) ;
         }
         Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
         Id AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId(); 
         for(Retail_Task__c led : rtlst){            
            if(led.Supporting_Dealer__c != null){
                 //Account_Link__c acclnk = new Account_Link__c(RecordTypeId = recordTypes.get('ContactSector'), Name = led.Account__r.UCID__c, fromRole__c = led.Account__c, toRole__c = led.Supporting_Dealer__c,ContractId__c=led .Id);
                 //accLst.add(acclnk);
                 if(led.Account__r.RecordTypeId == PersonRecordTypeId){
            acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Person'), fromRole__c = led.Supporting_Dealer__c , toRole__c = led.Account__c );                                                                     
                                                                                  
                                                                        
                  }else if(led.Account__r.RecordTypeId == AccountCompanyId){
                acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Company'), fromRole__c = led.Supporting_Dealer__c , toRole__c = led.Account__c);         
                                                       
                                        
                      
                  }
                  
                  
                  
                  
                  if(led.Account__r.Primary_Address_Reference__c != null){
                     acclnk.Retail_Address_Reference__c = led.Account__r.Primary_Address_Reference__c;
                                                                      
                    }                // Changed Due To SFDCJP-1897
                   accLst.add(acclnk);            
            }
         }  
         if(!accLst.isEmpty()){
            insert accLst;
         }          
    }   
}