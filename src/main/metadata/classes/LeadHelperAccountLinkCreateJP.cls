/*
  1.New Account Link record will create when assigned dealer is populated.
  Created By: Kiran
  Date: 2016-9-23
*/
public class LeadHelperAccountLinkCreateJP {

    public static void leadAccountDetails(list<Lead__c> leadlst, map<id,Lead__c> leadOldMap, boolean isInsert, boolean isUpdate){
        
        set<String> contactId = new set<String>();
        
        for(Lead__c le : leadlst){
            if(le.Assigned_Dealer__c != null && le.CAC_Lead_Status__c == 'Approved' && (le.MD__c == label.MarketJP)){
                if(isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)){
                    System.debug('Is Insert OR Update called -----:::::');
                    contactId.add(le.id);
                }
            } else if(le.Assigned_Dealer__c != null && le.CAC_Lead_Status__c == 'Qualified' && le.MD__c == Label.MarketKR){
                if(isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c)){
                    System.debug('Is Insert OR Update called -----:::::');
                    contactId.add(le.id);
                }
            }
            
        }
        
        if(! contactId.isEmpty() ){
            createAccountLinkRecord(contactId);
        }
        
    }
    
    public static void createAccountLinkRecord(set<String> contactId){
        set<String> dealerId = new set<String>();
        List<Lead__c> leadLst = [select Id, Company_Account__c,Contact__c, Assigned_Dealer__c, Contact__r.LastName, Contact__r.FirstName,Contact__r.LastName_Native_1__c, 
                                 Contact__r.FirstName_Native_1__c, Contact__r.PersonBirthdate, Contact__r.Special_Care__c, Contact__r.Individual_Home_Phone__c, Contact__r.Work_Phone__c,
                                 Contact__r.Mobile__c, Contact__r.Fax, Contact__r.Email__c, Contact__r.Primary_Address_Reference__r.City__c, Contact__r.Primary_Address_Reference__r.District__c,
                                 Contact__r.Primary_Address_Reference__r.Block__c, Contact__r.Primary_Address_Reference__r.Address_Line_1__c,
                                 Contact__r.Primary_Address_Reference__r.Address_Line_2__c, Contact__r.Primary_Address_Reference__r.ZipCode__c,
                                 Contact__r.Primary_Address_Reference__r.CreatedDate, Contact__r.Primary_Address_Reference__r.LastModifiedDate,
                                 Contact__r.gender__c, contact__r.Occupation__c, Contact__r.Industry,Contact__r.Preferred_Language__c,
                                 Contact__r.Special_Needs_Class__c, Contact__r.Allow_Data_Sharing2__c, Contact__r.Primary_Address_Reference__r.Address_Type__c, 
                                 Contact__r.Primary_Address_Reference__r.Province__c, Contact__r.Preferred_Contact_Method__c,MD__c,
                                 Contact__r.UCID__c, Contact__r.RecordtypeId, Contact__r.Name, Contact__r.Company_Name_Native_1__c,Contact__r.Foundation_Date__c,
                                 Contact__r.Website,Contact__r.Vat_No__c                                                 
                                 from Lead__c WHERE id IN : contactId
                                ];
         List<Account_Link__c> accLst = new List<Account_Link__c>();
         //List<Lead__c> leadListupdate = new List<Lead__c>();    
         Map<String,Id> recordTypes = new Map<String,Id>();
         for(RecordType rt : [select id,DeveloperName from RecordType WHERE DeveloperName IN ( 'ContactSector' ,'Retail_Company', 'Retail_Person' ) ] ){
             recordTypes.put(rt.DeveloperName,rt.Id) ;
         }
         Id PersonRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
         Id AccountCompanyId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
         for(Lead__c dealerLead : leadLst){
            dealerId.add(dealerLead.Assigned_Dealer__c);
         }
         Integer dealercount = [select count() from Account_Link__c WHERE toRole__c IN : dealerId AND (RecordTypeId = :recordTypes.get('Retail_Company') OR RecordTypeId = :recordTypes.get('Retail_Person'))];
         system.debug('########'+dealercount);
         for(Lead__c led : leadlst){            
            if(led.Assigned_Dealer__c != null && dealercount == 0){
                 Account_Link__c acclnk = new Account_Link__c(RecordTypeId = recordTypes.get('ContactSector'), Name = led.Contact__r.UCID__c, fromRole__c = led.Contact__c, toRole__c = led.Assigned_Dealer__c);
                 accLst.add(acclnk);
                 if(led.Contact__r.RecordTypeId == PersonRecordTypeId){
                 acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Person'), Name = led.Contact__r.UCID__c, fromRole__c = led.Contact__c, toRole__c = led.Assigned_Dealer__c, 
                                                                        //Retail_CreatedDate__c =  led.Contact__r.Retail_CreatedDate__c, Retail_LastModifiedDate__c = led.Contact__r.Retail_LastModifiedDate__c,
                                                                        Retail_Full_Name__c = ((led.Contact__r.LastName!=null ? led.Contact__r.LastName : '') + ' ' + (led.Contact__r.FirstName != null ? led.Contact__r.FirstName : '')).left(25) , //Retail_Full_Name_Native__c = (led.Contact__r.LastName_Native_1__c + ' ' + led.Contact__r.FirstName_Native_1__c).left(50),
                                                                        Retail_PersonBirthdate__c = led.Contact__r.PersonBirthdate, Retail_Special_Care__c = led.Contact__r.Special_Care__c, Retail_Individual_Home_Phone__c = led.Contact__r.Individual_Home_Phone__c,
                                                                        Retail_Work_Phone__c = led.Contact__r.Work_Phone__c, Retail_Mobile__c = led.Contact__r.Mobile__c, Retail_Email__c = led.Contact__r.Email__c,
                                                                        //Retail_City__c = led.Contact__r.Primary_Address_Reference__r.City__c, Retail_Distinct__c = ((led.Contact__r.Primary_Address_Reference__r.District__c != null ? led.Contact__r.Primary_Address_Reference__r.District__c : '') + ' ' + (led.Contact__r.Primary_Address_Reference__r.Block__c != null ? led.Contact__r.Primary_Address_Reference__r.Block__c : '' )).left(35),
                                                                        Retail_Gender__c = led.Contact__r.Gender__c, Retail_Occupation__c = led.Contact__r.Occupation__c,
                                                                        Retail_Preferred_Language__c = led.Contact__r.Preferred_Language__c,
                                                                        Retail_Preferred_Contact_Method__c = led.contact__r.Preferred_Contact_Method__c,
                                                                        Retail_Special_Needs_Class__c = led.Contact__r.Special_Needs_Class__c, Retail_Allow_Data_Sharing__c = led.contact__r.Allow_Data_Sharing2__c,
                                                                        Retail_Full_Name_Native__c = ((led.Contact__r.LastName_Native_1__c != null ? led.Contact__r.LastName_Native_1__c: '') + (led.Contact__r.FirstName_Native_1__c != null ?led.Contact__r.FirstName_Native_1__c :'' )).left(50),
                                                                        //Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c,                                                              
                                                                        //Retail_Country__c = 'Japan'
                                                                        Retail_LastName__c = led.Contact__r.LastName, Retail_FirstName__c = led.Contact__r.FirstName, 
                                                                        Retail_Full_Name_Title__c = ((led.Contact__r.LastName!=null ? led.Contact__r.LastName : '') + ' ' + (led.Contact__r.FirstName != null ? led.Contact__r.FirstName : '') + ' ' + (led.Contact__r.FirstName!= null ? led.Contact__r.FirstName : '')),
                                                                        Retail_LastName_Native__c = led.Contact__r.LastName_Native_1__c, Retail_FirstName_Native__c = led.Contact__r.FirstName_Native_1__c
                                                                        );
                  }else if(led.Contact__r.RecordTypeId == AccountCompanyId){
                      acclnk = new Account_Link__c(  RecordTypeId = recordTypes.get('Retail_Company'), Name = led.Contact__r.UCID__c, fromRole__c = led.Contact__c, toRole__c = led.Assigned_Dealer__c,         
                                                     Retail_Company_Name__c = led.Contact__r.Name, Retail_Company_Name_Native1__c = led.Contact__r.Company_Name_Native_1__c, 
                                                     Retail_Commercial_Reg_No__c = led.Contact__r.Commercial_Reg_No__c, Retail_Website__c = led.Contact__r.website,Retail_Company_Phone__c = led.Contact__r.Individual_Home_Phone__c,
                                                     Retail_Company_Other_Phone__c = led.Contact__r.Work_Phone__c, Retail_Vat_No__c = led.Contact__r.Vat_No__c); 
                       if(led.Contact__r.Foundation_Date__c != null){
                           acclnk.Retail_Foundation_Month__c = String.ValueOf(led.Contact__r.Foundation_Date__c.month())+String.valueOf(led.Contact__r.Foundation_Date__c.year());
                       }
                      //Date foundationDate = led.Contact__r.Foundation_Date__c;
                      
                  }
                  acclnk.Retail_Fax__c = led.Contact__r.Fax;
                  acclnk.Retail_Industry__c = led.contact__r.Industry;
                  if(led.MD__c == Label.MarketKR){
                      acclnk.Retail_Country__c = 'Korea';   
                  }
                  else if(led.MD__c == Label.MarketJP){
                      acclnk.Retail_Country__c = 'Japan';
                  }
                  
                  
                  
                  if(led.Contact__r.Primary_Address_Reference__c != null){
                     acclnk.Retail_Address_Type__c = led.Contact__r.Primary_Address_Reference__r.Address_Type__c;
                     acclnk.Retail_Address_Line_1__c = (led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c != null ? led.Contact__r.Primary_Address_Reference__r.Address_Line_1__c: '' ).left(17);
                     acclnk.Retail_Address_Line_2__c  = (led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c!= null ? led.Contact__r.Primary_Address_Reference__r.Address_Line_2__c : '' ).left(17);
                     acclnk.Retail_ZipCode__c= led.Contact__r.Primary_Address_Reference__r.ZipCode__c;
                     acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(led.Contact__r.Primary_Address_Reference__r.CreatedDate);
                     acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(led.Contact__r.Primary_Address_Reference__r.LastModifiedDate);
                     acclnk.Retail_Province__c = led.Contact__r.Primary_Address_Reference__r.Province__c;
                     acclnk.Retail_City__c = led.Contact__r.Primary_Address_Reference__r.City__c.left(17);
                     acclnk.Retail_Distinct__c = ((led.Contact__r.Primary_Address_Reference__r.District__c != null ? led.Contact__r.Primary_Address_Reference__r.District__c : '') + ' ' + (led.Contact__r.Primary_Address_Reference__r.Block__c != null ? led.Contact__r.Primary_Address_Reference__r.Block__c : '' )).left(17);
                     //acclnk.
                   }    
                   accLst.add(acclnk);
            
                    //Lead__c ledrecupdate = new Lead__c(id = led.id, IsRetailrecordCreated__c = true);
                    //leadListupdate.add(ledrecupdate);
            }
         }  
         if(!accLst.isEmpty()){
            insert accLst;
         } 
         //if(!leadListupdate.isEmpty()){
             //update leadListupdate;
         //}
    }   
}