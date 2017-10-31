public class CompassCase
{
public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
public static Id Case_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S24h - MMC').getRecordTypeId();
set<String> gscode= new set<String>();
Map<String, id> accUserMap = new Map<String, id>();
set<String> newmapid= new set<String>();

  public void updateOwnerwithDealer(List<Case> Cs){   
           
           for(Case c:Cs){
                    if(c.recordtypeid==Case_RecordTypeId)
                    {
                        gscode.add(c.Compass_Dealer_GS_Code__c);    
                    }
             
            }
            List<Account> accList = new List<Account>();
            accList=[Select id,Dealer_GS_Code__c,Dealer_Lead_Gate_Keeper__c from Account where Dealer_GS_Code__c=:gscode];
            if (accList.size()>0){
                for(Account acc:accList){
                    if (acc.Dealer_GS_Code__c!= null){
                        accUserMap.put(acc.Dealer_GS_Code__c,acc.Dealer_Lead_Gate_Keeper__c); 
                    }
                }
            }
            for(Case c1:Cs){
               
                     if(c1.recordtypeid==Case_RecordTypeId)
                     {
                       if(accUserMap.get(c1.Compass_Dealer_GS_Code__c)!=null)
                       {
                            c1.ownerID = accUserMap.get(c1.Compass_Dealer_GS_Code__c); 
                        }   
                  
                }
              
                
                  
            }
            
        }
        
        public void updateOwner(List<Case> Cs)
    { 
        for(Case c:Cs)
        {
            if(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c!=((Case)Trigger.oldMap.get(C.id)).Compass_Dealer_GS_Code__c && c.RecordTypeId==Case_RecordTypeId)
            {
                if(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c!=null)
                {
                    newmapid.add(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c);
                    
                 }
            }
        }         
                    
                   
        if(newmapid.size()>0)
        {
            List<Account> accountList=[select Dealer_GS_Code__c,Dealer_Lead_Gate_Keeper__c from Account where Dealer_GS_Code__c=:newmapid];
            for(Account ac:accountList)
            {
                if(ac.Dealer_GS_Code__c!=null)
                {
                    accUserMap.put(ac.Dealer_GS_Code__c,ac.Dealer_Lead_Gate_Keeper__c);
                }
            }
        }
        for(Case lists:CS)
        {    
            if(accUserMap.get(lists.Compass_Dealer_GS_Code__c) !=null)
            {
                lists.ownerID = accUserMap.get(lists.Compass_Dealer_GS_Code__c); 
            } 
            else
            {
                lists.ownerid=lists.createdbyId;
            }
        }

 
    }
  
}