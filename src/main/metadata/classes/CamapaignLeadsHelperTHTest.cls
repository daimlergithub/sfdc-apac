@isTest
public class CamapaignLeadsHelperTHTest {
    public static List<Campaign_Lead__c> testrecords(){
        List<Campaign_Lead__c> cls= new List<Campaign_Lead__c>();
        Account acc = new Account();
        acc.lastname='Testing';
        acc.MBK_Data_Source__c='MB website';
        acc.mobile__c='010-1456-2156';
        insert acc;
        
        Lead__c l = new Lead__c();
        l.Lead_Type__c='New Car';
        l.CAC_Lead_Status__c='New';
        l.Contact__c=acc.Id;
        insert l;
        
        Campaign c= new Campaign();
        c.Name='Testing';
        c.Execution_Type__c='OB Call';
        c.Task_Created_By__c='Contact';
        insert c;
        
        Campaign_Lead__c cl= new Campaign_Lead__c();
        cl.Campaign__c=c.Id;
        cl.Lead__c=l.Id;
        cl.Contact__c=acc.Id;
        insert cl;
        cls.add(cl);
        return cls;
    }
	@isTest
    public static void updateCampaignleadsTest(){
       List<Campaign_Lead__c> cls= testrecords();
        CamapaignLeadsHelperTH clt=new CamapaignLeadsHelperTH();
        clt.updateCampaignleads(cls);
    }
}