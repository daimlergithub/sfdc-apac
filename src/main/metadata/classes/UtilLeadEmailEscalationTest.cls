@isTest

public class UtilLeadEmailEscalationTest {

public static testMethod void testUtilLeadEmailEscalation() 
{
Account customer1 = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy1',
                                    Province__c = 'Shanghai',
                                    ZipCode__c='000000',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce'); 
                                    insert customer1;

                     List<Account> listacc = new List<Account>();
for (Integer i=0;i<1;i++) {
 Account customer3 = new Account(name='test',Status__c='Other',City__c='Beijing',Phone = '80801010',Area_code__c = '010',ZipCode__c='000000');
                listacc.add(customer3);                    
                                    }
                                    insert listacc;
UtilLeadEmailEscalation u=new UtilLeadEmailEscalation();

UtilLeadEmailEscalation.getSeparateAccountsBySubRegion(listacc);
UtilLeadEmailEscalation.getWeeklyEmailBodyByDealer(customer1);
UtilLeadEmailEscalation.getMonthlyEmailBodyByRegion(listacc);
UtilLeadEmailEscalation.getWeeklyEmailBodyByRegion(listacc);
UtilLeadEmailEscalation.checkFollowupRate(customer1);
 UtilLeadEmailEscalation.getMonthlyEmailBodyByDealer(customer1);
     
    UtilLeadEmailEscalation.getConversionRateEmailBodyByRegion(listacc);
    UtilLeadEmailEscalation.getConversionRateRowValue(listacc);
   UtilLeadEmailEscalation.getDealerToAddresses(customer1);
        UtilLeadEmailEscalation.getDealerCcAddresses(customer1);
}
}