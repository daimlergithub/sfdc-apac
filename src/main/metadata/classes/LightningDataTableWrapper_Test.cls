@istest
public class LightningDataTableWrapper_Test {
    
    @isTest
    static void testFactEcpetion2(){
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        Account acc= new Account(Name='Test',Corporate_Category__c='Rental',Mobile__c='12345',Dealer_Lead_Gate_Keeper__c=u.id);
        insert acc;
            String myString = acc.Name;
        	ID usrid=u.id;
            test.startTest();
            LightningDataTableWrapper LDTWarp = new LightningDataTableWrapper(); 
            LDTWarp.strObjectName='Account' ;
            LDTWarp.fieldsToDisplay = new List<String>{'Name','AccountNumber','AnnualRevenue','Dealer_Lead_Gate_Keeper__c'}; 
            LDTWarp.buttonsToDispaly = new List<String>{'Edit','Delete','List'};
            LDTWarp.columnsToDisplay = new List<String>{'Corporate_Group__c','Company__c'};
            LDTWarp.dataToDisplay = Database.query('SELECT name,AccountNumber,AnnualRevenue,Dealer_Lead_Gate_Keeper__c,Corporate_Group__c,Company__c FROM Account where name=: myString and Dealer_Lead_Gate_Keeper__c=: usrid LIMIT 1'); 
            LDTWarp.getSobjectList();
            test.stopTest();
        
    }
    
}