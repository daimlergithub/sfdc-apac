/*
    Type:      class
    Purpose:   1.Update the Lookup relation based on the record Id
    
*/
public without sharing class InsightResponseHelperBase {
  private static final String alkCompanyRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    private static final String alkpersonRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    Public  static MAP<String,Account_link__c> AcclinkMap = new MAP<String, Account_link__c>();
  Public  static List<Insights_Response__Share> IRshareList =new List<Insights_Response__Share>();
  

    // @Description: Update the Customer Id / VR Id .
    public static void UpdateRelation(list<Insights_Response__c> listNewResponse){
        
        
        for (Insights_Response__c Resp : listNewResponse){
            system.debug('Rescord Id Value' + Resp.RecordId__c);
            if (string.isnotblank(Resp.RecordId__c)){
                
                Id myid = Resp.RecordId__c;
                String sObjectType = ((Id)myid).getSobjectType().getDescribe().getName();
                system.debug('object type ' + sObjectType);
                
                if (sObjectType == 'Account')
                {   Resp.Customer__c =myid;
                     Resp.Vehicle_Relationship_ID__c = null;
                }
                else if (sObjectType == 'Vehicle_Relationship__c')
                {   Resp.Vehicle_Relationship_ID__c = myid;
                    Resp.Customer__c = null;
                }

               
            }
        }

    }

//share the Records with Dealers with Edit access

 public static void afterInsertEventShareInsightResponse(list<Insights_Response__c> listNewResponse){
        
        set < Id > CustomerId = new set < Id > ();
        
        //Get the list of Customer id
     for (Insights_Response__c Resp : listNewResponse){
                if (string.isnotblank(Resp.RecordId__c)){
                  Id myid = Resp.RecordId__c;
                    String sObjectType = ((Id)myid).getSobjectType().getDescribe().getName();
                    if (sObjectType == 'Account')
                    {  
                            CustomerId.add(myid);
                    }
                 }
                 else if (string.isnotblank(Resp.Customer__c )){
                         CustomerId.add(Resp.Customer__c);
                 }
                 
        }
         
             
        //Get the Dealer Details 
         List < Account_Link__c > dealercount = new List<Account_link__c>();
        dealerCount=[select id,fromRole__c,toRole__c,fromRole__r.Dealer_ND_Code__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.MD__c from Account_Link__c WHERE toRole__c IN: CustomerId  AND (RecordTypeId =: alkCompanyRecordTypeId OR RecordTypeId =: alkpersonRecordTypeId) AND(Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false)];

        //Get Group Name 
         for(Account_link__c acclinkrec:dealerCount){
            if(acclinkrec.fromRole__r.Dealer_GC_Code__c !=null){
                string grpName= acclinkrec.fromRole__r.MD__c+acclinkrec.fromRole__r.Dealer_nd_Code__c;
                AcclinkMap.put(grpName,acclinkrec);
            }
         }
        
    //share all records with group      
        if(AcclinkMap.size()>0){
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: AcclinkMap.keySet()]){
            for (Insights_Response__c Resp : listNewResponse){
                //compare the Id of Insight response record and map to perticular group 
                if( (string.isnotblank(Resp.RecordId__c) || string.isnotblank(Resp.Customer__c )) && ( Resp.RecordId__c == AcclinkMap.get(groupRec.Name).toRole__c  || Resp.Customer__c == AcclinkMap.get(groupRec.Name).toRole__c   ) ) {
                    Insights_Response__Share IRshare=new Insights_Response__Share ();
                    IRshare.AccessLevel='EDIT';
                    IRshare.RowCause = Schema.Insights_Response__Share.RowCause.Manual;
                    IRshare.ParentId = Resp.id;
                    IRshare.UserOrGroupId=groupRec.id;
                    IRshareList.add(IRshare);        
                }
            }
         }    
        }
        if(IRshareList.size()>0){
            Database.insert(IRshareList, false);
        }
        
        
    }
 
}