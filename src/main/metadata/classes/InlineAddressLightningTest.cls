@isTest
public class InlineAddressLightningTest 
{
    static User objUser;
    static Account objAccount;
  
    
    static testMethod void testInitializeObjAddressInfo() 
    {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];                                        
        User objUser = new User(
                Alias = 'testu',
                Email = 'test@unitingambition.com', 
                EmailEncodingKey = 'UTF-8',
                LastName = 'Test',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey='America/Los_Angeles',
                ProfileId = p.Id,
                UserName='test@unitingamb2.com'+String.valueof(DateTime.now().getTime()),
                Market__c='AU'
         );
        insert objUser;
        
            insert new Trigger__c(          before__c           = true,
                                            insert__c           = true,
                                            update__c           = true,
                                            Trigger_Name__c     = 'TriggerAddress',
                                            name                = 'TriggerAddressAU',
                                            Trigger_Handler__c  = 'TriggerAddressTriggerHandlerAU',
                                            Market__c           = 'AU'
                                        );

        
       System.runAs(objUser) 
       {
            Account objAccount = new Account(name= 'Test',market__c='AU');
            insert objAccount;
             List<Address__c> lstAddress = new List<Address__c>();
             Address__c objAddress;
            
            for(Integer i =1; i<=3 ;i++)
            {
                objAddress = new Address__c(            market__c = 'AU',
                                                        Address_Line_1__c ='Test'+i,
                                                        Address_Type__c = 'Home',
                                                        Country__c = 'Australia',
                                                        State_City__c = 'SA',
                                                        ZipCode__c = '4323',
                                                        preferred__c=false,
                                                        Customer__c = objAccount.Id
                                            );
                lstAddress.add(objAddress);
            }
            
            insert lstAddress;
        
        
            Test.startTest();  
                try
                {
                    AddressInfoDefinition returnedResponse = InlineAddressLightning.getFactoryFields(objAccount.Id,'InlineAddressLightning',null); 
                    System.assertNotEquals(null,returnedResponse.factoryFieldsMap.get('inputFields'));
                    System.assertNotEquals(null,returnedResponse.factoryFieldsMap.get('outputFields'));
                    System.assertNotEquals(null,returnedResponse.factoryFieldsMap.get('outputSideBarFields'));
                    System.assertEquals(3,returnedResponse.addressList.size());
                
                
                    Address__c objAddr = [SELECT preferred__c FROM Address__c where Address_Line_1__c = 'Test1' LIMIT 1];
                    objAddr.preferred__c = true;
                    update objAddr;
                    
                    objAddr = [SELECT preferred__c FROM Address__c where Address_Line_1__c = 'Test2' LIMIT 1];
                    objAddr.preferred__c = true;
                    update objAddr;
                    
                    objAddr = new Address__c(           market__c = 'AU',
                                                        Address_Line_1__c ='NewTest',
                                                        Address_Type__c = 'Bussiness',
                                                        Country__c = 'Australia',
                                                        State_City__c = 'SA',
                                                        ZipCode__c = '4323',
                                                        preferred__c=true,
                                                        Customer__c = objAccount.Id
                                            );
                    insert objAddr;
                    
                    InlineAddressLightning.deleteRecordDB(objAddr.Id);
                }
                catch(Exception e)
                {
                    System.debug(e.getMessage());
                }

            Test.stopTest();
       }
       
    }

}