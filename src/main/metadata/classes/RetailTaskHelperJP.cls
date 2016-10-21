/*
  1.New Account Link record will create when Supporting Dealer is populated.
  Created By: Venkataramana Cheedara
  Date: 2016-10-20
*/
public class RetailTaskHelperJP {

    public static void RetailTaskDetails(list<Retail_Task__c> rtlst, map<id,Retail_Task__c> leadOldMap, boolean isInsert, boolean isUpdate){
        
        set<String> contactId = new set<String>();
        
        for(Retail_Task__c rt : rtlst){
            if(rt.Supporting_Dealer__c != null && (rt.MD__c == Label.MarketKR || rt.MD__c == label.MarketJP)){
                if(isInsert || (isUpdate && rt.Supporting_Dealer__c != leadOldMap.get(rt.id).Supporting_Dealer__c)){
                    System.debug('Is Insert OR Update called -----:::::');
                    contactId.add(rt.id);
                }
            }
                
        }
        
        if(! contactId.isEmpty() ){
            createAccountLinkRecord(contactId);
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
            acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Person'), Name = led.Account__r.UCID__c, fromRole__c = led.Account__c, toRole__c = led.Supporting_Dealer__c, ContractId__c=led .Id ,                                                                     
                                                                        Retail_Full_Name__c = ((led.Account__r.LastName!=null ? led.Account__r.LastName : '') + ' ' + (led.Account__r.FirstName != null ? led.Account__r.FirstName : '')).left(25) , 
                                                                        Retail_PersonBirthdate__c = led.Account__r.PersonBirthdate, Retail_Special_Care__c = led.Account__r.Special_Care__c, Retail_Individual_Home_Phone__c = led.Account__r.Individual_Home_Phone__c,
                                                                        Retail_Work_Phone__c = led.Account__r.Work_Phone__c, Retail_Mobile__c = led.Account__r.Mobile__c, Retail_Email__c = led.Account__r.Email__c,                                                                        
                                                                        Retail_Gender__c = led.Account__r.Gender__c, Retail_Occupation__c = led.Account__r.Occupation__c,
                                                                        Retail_Preferred_Language__c = led.Account__r.Preferred_Language__c,
                                                                        Retail_Preferred_Contact_Method__c = led.Account__r.Preferred_Contact_Method__c,
                                                                        Retail_Special_Needs_Class__c = led.Account__r.Special_Needs_Class__c, Retail_Allow_Data_Sharing__c = led.Account__r.Allow_Data_Sharing2__c,
                                                                        Retail_Full_Name_Native__c = ((led.Account__r.LastName_Native_1__c != null ? led.Account__r.LastName_Native_1__c: '') + (led.Account__r.FirstName_Native_1__c != null ?led.Account__r.FirstName_Native_1__c :'' )).left(50),
                                                                        Retail_LastName__c = led.Account__r.LastName, Retail_FirstName__c = led.Account__r.FirstName, 
                                                                        Retail_Full_Name_Title__c = ((led.Account__r.LastName!=null ? led.Account__r.LastName : '') + ' ' + (led.Account__r.FirstName != null ? led.Account__r.FirstName : '') + ' ' + (led.Account__r.FirstName!= null ? led.Account__r.FirstName : '')),
                                                                        Retail_LastName_Native__c = led.Account__r.LastName_Native_1__c, Retail_FirstName_Native__c = led.Account__r.FirstName_Native_1__c
                                                                        );
                  }else if(led.Account__r.RecordTypeId == AccountCompanyId){
                acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Company'), Name = led.Account__r.UCID__c, fromRole__c = led.Account__c, toRole__c = led.Supporting_Dealer__c,ContractId__c=led .Id,         
                                                     Retail_Company_Name__c = led.Account__r.Name, Retail_Company_Name_Native1__c = led.Account__r.Company_Name_Native_1__c, 
                                                     Retail_Commercial_Reg_No__c = led.Account__r.Gender__c, Retail_Website__c = led.Account__r.website,Retail_Company_Phone__c = led.Account__r.Individual_Home_Phone__c,
                                                     Retail_Company_Other_Phone__c = led.Account__r.Work_Phone__c);  
                       if(led.Account__r.Foundation_Date__c != null){
                           acclnk.Retail_Foundation_Month__c = String.ValueOf(led.Account__r.Foundation_Date__c.month())+String.valueOf(led.Account__r.Foundation_Date__c.year());
                       }                      
                      
                  }
                  acclnk.Retail_Fax__c = led.Account__r.Fax;
                  acclnk.Retail_Industry__c = led.Account__r.Industry;
                  if(led.MD__c == Label.MarketKR){
                      acclnk.Retail_Country__c = 'Korea';   
                  }
                  else if(led.MD__c == Label.MarketJP){
                      acclnk.Retail_Country__c = 'Japan';
                  }
                  
                  
                  
                  if(led.Account__r.Primary_Address_Reference__c != null){
                     acclnk.Retail_Address_Type__c = led.Account__r.Primary_Address_Reference__r.Address_Type__c;
                     acclnk.Retail_Address_Line_1__c = (led.Account__r.Primary_Address_Reference__r.Address_Line_1__c != null ? led.Account__r.Primary_Address_Reference__r.Address_Line_1__c: '' ).left(17);
                     acclnk.Retail_Address_Line_2__c  = (led.Account__r.Primary_Address_Reference__r.Address_Line_2__c!= null ? led.Account__r.Primary_Address_Reference__r.Address_Line_2__c : '' ).left(17);
                     acclnk.Retail_ZipCode__c= led.Account__r.Primary_Address_Reference__r.ZipCode__c;
                     acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(led.Account__r.Primary_Address_Reference__r.CreatedDate);
                     acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(led.Account__r.Primary_Address_Reference__r.LastModifiedDate);
                     acclnk.Retail_Province__c = led.Account__r.Primary_Address_Reference__r.Province__c;
                     acclnk.Retail_City__c = led.Account__r.Primary_Address_Reference__r.City__c.left(17);
                     acclnk.Retail_Distinct__c = ((led.Account__r.Primary_Address_Reference__r.District__c != null ? led.Account__r.Primary_Address_Reference__r.District__c : '') + ' ' + (led.Account__r.Primary_Address_Reference__r.Block__c != null ? led.Account__r.Primary_Address_Reference__r.Block__c : '' )).left(17);
                    }    
                   accLst.add(acclnk);            
            }
         }  
         if(!accLst.isEmpty()){
            insert accLst;
         }          
    }   
}