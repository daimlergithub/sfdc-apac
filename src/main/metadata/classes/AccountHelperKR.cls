/**
* Utility for Trigger on Account for KR(Korea)
* Author: Chethan A
* Created Date : 2016-08-05
*/

public class AccountHelperKR{

    /**
    * Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are inserted. 
    */
    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert){   
        AccountHelperJP.updateAccountFieldsBeforeInsert(Trigger.new,Trigger.isInsert);
    }
    
    /**
    * Update custom last modified date field(s) associated with each contact information field, when any contact information field(s) are updated. 
    */    
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperJP.updateAccountFieldsBeforeUpdate(Trigger.new,(Map<Id,Account>)Trigger.OldMap,trigger.isUpdate);
    }
    
    /**
    * Update primary address details from the associated preferred address records.
    */
/*   
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate){
        //AccountHelperJP.updatePrimaryAddressdisplay(Trigger.new,Trigger.isUpdate);
        Map<Id,Address__c> addr;
        If(!listNewAccounts.isEmpty() && listNewAccounts != Null)
        {
            string regexForNullValue ='null';
            string nullValue ='';
            set<id> addressid = new set<id>();                  
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            UtilAddressTranslation.gettranslatedvalues('KR');
            For(Account a:listNewAccounts)
            {      
                if(a.MD__c == 'KR')
                {                    
                    addressid.add(a.Primary_Address_Reference__c);
                }
            }
            If(!addressid.isEmpty())
            {   
                addr = new map<id,Address__c>([select Customer__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c from Address__c where id In : addressid]);            
            }
            For(Account acc:listNewAccounts)
            {      
                if(acc.MD__c == 'KR')
                {   
                    If(acc.Primary_Address_Reference__c !=Null  && addr!=Null && addr.get(acc.Primary_Address_Reference__c) != Null)
                    {              
                        Address__c add = addr.get(acc.Primary_Address_Reference__c);
                        if(addtrmap1.containsKey(add.Province__c))
                        {
                            province = addtrmap1.get(add.Province__c);
                        }
                        acc.Primary_Address_Display__c = province+ add.City__c + add.District__c +add.Block__c+ add.Address_Line_1__c + add.Address_Line_2__c ;
                        acc.Primary_Address_Display__c=acc.Primary_Address_Display__c.replaceAll(regexForNullValue,nullValue);
                        system.debug(')&)^%$%&&*(**^^^^'+acc.Primary_Address_Display__c);
                    }
                    else if(acc.Primary_Address_Reference__c ==Null)
                    {
                        acc.Primary_Address_Display__c ='';
                    }
                    
                }
            }     
                 
        }            
    }
*/
    /**
    * Implement Do Not Call(PersonDoNotCall) to automate opt-out for all channels which means that selecting this flag opts out the customer from 
    *  being contacted via all Phone numbers (Ex: Home Phone, Mobile, Work Phone).   
    */
    public static void updateOnDoNotCall(list<Account> listNewAccounts){
        // Opt_In_Home_Phone__c , Opt_In_Home_Phone2__c , Opt_In_Work_Phone__c , Opt_In_Work_Phone2__c
        
        for(Account acc : listNewAccounts){
           if(acc.MD__c == 'KR'){
               if(acc.PersonDoNotCall){
                   if(acc.Opt_In_Home_Phone__c){ acc.Opt_In_Home_Phone__c = FALSE;}
                   if(acc.Opt_In_Home_Phone2__c){ acc.Opt_In_Home_Phone2__c = FALSE;}
                   if(acc.Opt_In_Work_Phone__c ){ acc.Opt_In_Work_Phone__c = FALSE;}
                   if(acc.Opt_In_Work_Phone2__c){ acc.Opt_In_Work_Phone2__c = FALSE;}
                   if(acc.Preferred_Mobile_1__c){ acc.Preferred_Mobile_1__c = FALSE;}
                   if(acc.Preferred_Mobile_2__c){ acc.Preferred_Mobile_2__c = FALSE;}
               }
           } 
        }
    }
    
    /*
    * Implement Postal_Opt_Out__c to automate opt-out for all addresses which means that selecting this flag opts out the customer from being contacted 
    *   via Addresses (Ex: Home Address, Office Address, etc.).
    */
     public static void updateOnPostalOptout(list<Account> listNewAccounts){
      system.debug('@@@@@@ listNewAccounts'+listNewAccounts);
    List<Address__c> addressupdatelst = new list<Address__c>();
    List<Address__c> addressList = new list<Address__c>();
  Set<Id> Accid=new Set<Id>();
  Set<Id> Addd=new Set<Id>();
        for(Account acc: listNewAccounts){
        Accid.add(acc.id);
        Addd.add(acc.Primary_Address_Reference__c);
             
    
    // NEED INPUTS FOR IMPLEMENTATION
    }
    system.debug('@@@@@@ Addd'+Addd);
    addressList =[select id,Opt_In_Hardcopy__c from Address__c where id=:Addd];
    for(Account acc: listNewAccounts)
    {
    for(Address__c add: addressList)
    if(acc.MD__c == 'KR'){
               if(acc.Postal_Opt_Out__c){
                   if(add.Opt_In_Hardcopy__c== true){ 
                        add.Opt_In_Hardcopy__c = false;
                        addressupdatelst.add(add);
                    }
                } 
                } 
                }
    
    update addressupdatelst;
    system.debug('@@@@@@ addressupdatelst'+addressupdatelst);
    }
    
   
    /**
    * Use Email Opt Out (PersonHasOptedOutOfEmail) to automate opt-out from email options.
    */
    public static void updateOnEmailOptout(list<Account> listNewAccounts){
        // PersonHasOptedOutOfEmail  , Opt_In_Email__c , Opt_In_Email2__c   , Opt_In_Email3__c
        for(Account acc: listNewAccounts){
            if(acc.MD__c == 'KR'){
                if(acc.PersonHasOptedOutOfEmail){
                    if(acc.Opt_In_Email__c){ acc.Opt_In_Email__c = FALSE;}
                    if(acc.Opt_In_Email2__c){ acc.Opt_In_Email2__c = FALSE;}
                    if(acc.Opt_In_Email3__c){ acc.Opt_In_Email3__c = FALSE;}
                }
            }
        }
    }
    
    /**
    * Calculate “Age Range” based on birthdate.
    */
    public static void updateAgeRange(list<Account> listNewAccounts){
     // PersonBirthdate
        for(Account acc:  listNewAccounts){
            if(acc.PersonBirthdate != NULL){
                if(acc.MD__c == 'KR'){
                   Integer ageInt = (Integer.valueOf(System.today().year())-Integer.valueof(acc.PersonBirthdate.year()) );
                   acc.Age_Range__c = AccountHelperKR.calculateAgeRange(ageInt); 
                }
            }
        }
    }
    
    public static String calculateAgeRange(Integer ageInt){
      if(17 <= ageInt && ageInt <= 25){
          return '17-25';   
      }else if(26 <= ageInt && ageInt <= 35){
          return '26-35';
      }else if( 36 <= ageInt && ageInt <= 45){
          return '36-45';
      }else if( 46 <= ageInt && ageInt <= 55){
          return '46-55';
      }else if(56 <= ageInt && ageInt <= 65){
          return '56-65';
      }else if( 65 < ageInt){
          return '65+';
      }else {
          return 'Unknown';
      }
    }
       

    
}