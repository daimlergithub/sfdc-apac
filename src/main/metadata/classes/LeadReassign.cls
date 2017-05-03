public without sharing class  LeadReassign{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
    set<id> accId = new set<id>();
    set<id> newmapid= new set<id>();
    
    Map<id, id> accUserMap = new Map<id, id>();
        public void updateOwnerwithDealer(List<lead__c> leads){  
                       
            List<lead__c> leadslist=new List<lead__c>();
            for(Lead__c lead:leads){
               
                    if((lead.RecordTypeId==salesRecordTypeId || lead.RecordTypeId==afterSalesRecordTypeId || lead.RecordTypeId==retailSalesRecordTypeId) && lead.md__c=='TH'){
                        accId.add(lead.assigned_dealer__c);    
                    }
               
            
            }
            List<Account> accList = new List<Account>();
            accList = [Select Dealer_Lead_Gate_Keeper__c from Account where id=:accId ];
            if (accList.size()>0){
                for(Account acc:accList){
                    if (acc.Dealer_Lead_Gate_Keeper__c != null){
                        accUserMap.put(acc.id, acc.Dealer_Lead_Gate_Keeper__c); 
                    }
                }
            }
            for(Lead__c lead:leads){
              
                    if((lead.RecordTypeId==salesRecordTypeId || lead.RecordTypeId==afterSalesRecordTypeId || lead.RecordTypeId==retailSalesRecordTypeId) && lead.md__c=='TH'){
                       if(accUserMap.get(lead.assigned_dealer__c) !=null){
                            lead.ownerID = accUserMap.get(lead.assigned_dealer__c); 
                        }   
                   
                }
              
                
                  
            }
            
        }
        
    
    
    
    public void updateOwner(List<lead__c> leads){  
    
        for(Lead__c l:leads){
        if(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c!=((Lead__c)Trigger.oldMap.get(l.id)).assigned_dealer__c && l.md__c=='TH' &&(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
            if(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c!=null){
            newmapid.add(((Lead__c)Trigger.newMap.get(l.id)).assigned_dealer__c);
            l.Received_Date_Time__c=null;
            l.Assigned_Date_Time__c=null;
            l.Accepted_Date_Time__c=null;
            l.dealer_lead_status__c='';
            }
            else{
           
            l.assigned_dealer__c=null;
            l.ownerId=l.createdbyId;
            
            }
        
        }
         else if(((Lead__c)Trigger.newMap.get(l.id)).ownerid!=((Lead__c)Trigger.oldMap.get(l.id)).ownerid && l.md__c=='TH' &&(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
        l.ownerID=((Lead__c)Trigger.newMap.get(l.id)).ownerid;
        }
        
        else if(l.md__c=='TH'&&(l.RecordTypeId==salesRecordTypeId || l.RecordTypeId==afterSalesRecordTypeId || l.RecordTypeId==retailSalesRecordTypeId)){
                if(l.assigned_dealer__c==null){
                    l.ownerID=l.createdbyId;
                    //l.dealer_lead_status__c='';
                    
                    }
               else{
                    if(l.assigned_dealer__c!=null && l.Received_Date_Time__c!=null&&l.Assigned_Date_Time__c!=null&&l.Accepted_Date_Time__c!=null){
                        if(l.dealer_lead_status__c!='Accepted'){
                               
                               l.ownerID=l.createdbyId;
                               l.assigned_dealer__c=null;
                               
                    }
                    else{
                    //l.ownerId=l.assigned_Dealer__r.Dealer_lead_gatekeeper__c;
                    }
                      
                }
               
            }
        
        
        }
        
       else{
            l.ownerID=l.createdbyId;
        
            }
    
        
        
    
       
      
         

    }
            
   
    if(newmapid.size()>0){
    updateOwnership(newmapid,leads);
    }

    }
    
                public  void leadValidation(List<lead__c> leadlist){
    Id profileId=userinfo.getProfileId();
String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        for(Lead__c listlead:leadlist){
        
                system.debug('validationsTH.leadValidation'+listlead.CAC_Lead_Status__c+listlead.recordtypeid+ listlead.md__c=='TH'+listlead.Purchased_CAC_Date__c);
            if((listlead.recordtypeid==afterSalesRecordTypeId || listlead.recordtypeid==salesRecordTypeId) && listlead.md__c=='TH'&& profileName!='IntegrationAPI'){
                if(listlead.CAC_Lead_Status__c=='Purchased' && listlead.Purchased_CAC_Date__c==null ){
                system.debug('validationsTH.leadValidation');
                listlead.CAC_Lead_Status__c.adderror('SARI changing lead statust ot purchased please enter Purchased CAC Date  Field');
                
                
                }
                if(listlead.recordtypeid==salesRecordTypeId && listlead.CAC_Lead_Status__c=='Purchased' && (listlead.Purchased_CAC_Date__c==null||listlead.Bought_Vehicle_Brand__c==null||listlead.Bought_Vehicle_Class__c==null||listlead.Bought_Vehicle_Model__c==null) ){
                listlead.CAC_Lead_Status__c.adderror('SARI changing lead statust ot “Purchased ”,please enter Purchase Date, Bought Vehicle Brand, Bought Vehicle Class and Bought Vehicle');
                
                }
            
            }
            if((listlead.recordtypeid==retailSalesRecordTypeId||listlead.recordtypeid==afterSalesRecordTypeId || listlead.recordtypeid==salesRecordTypeId) && listlead.md__c=='TH'&& profileName!='IntegrationAPI'){
            if(listlead.Dealer_Lead_Status__c=='Order Placed' && listlead.Order_Placed_Date__c==null&&listlead.recordtypeid!=retailSalesRecordTypeId){
            listlead.Order_Placed_Date__c.adderror('SARI changing lead statust to Order Placed,please enter OrderPlaced Date');
            
            }
             if(listlead.Dealer_Lead_Status__c=='Purchased' && listlead.Purchased_Date__c==null){
            listlead.Dealer_Lead_Status__c.adderror('SARI changing lead statust to "Purchased" please enter Purchase Date');
            
            } 
            }
        
        }
    
}

    
    
 public Static void updateOwnership(set<id> acc,List<Lead__c> leadlist){
Map<id, id> accUserMap = new Map<id, id>();
if(acc.size()>0){

    List<Account> accountList=[select Dealer_Lead_Gate_Keeper__c from Account where id=:acc];
    for(Account ac:accountList){
        if(ac.Dealer_Lead_Gate_Keeper__c!=null){
            accUserMap.put(ac.id,ac.Dealer_Lead_Gate_Keeper__c);
            
          }
    }

    }
    for(Lead__c lists:leadlist){
    
        if(accUserMap.get(lists.assigned_dealer__c) !=null){
                            lists.ownerID = accUserMap.get(lists.assigned_dealer__c); 
                         
                           
                } 
        else{
        lists.ownerid=lists.createdbyId;
        }
    }


}
}