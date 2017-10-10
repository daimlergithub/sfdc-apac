public class RetailCampaignHelperTH{
    public Static boolean booleanCampaignUpdate=true;
    public static Id executionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id planningRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    Set<ID> retailExecutionid=new Set<ID>();
    Set<ID> retailplanningId=new Set<ID>();
    public static Map<id,string> retailcampaign= new Map<id,string>();
    public static List<Retail_Campaign__c> updateRetailCampaign=new List<Retail_Campaign__c>();
    public static void RevokeRecordaccesstoDealers(List<Retail_Campaign__C> newacclinkmap,Map<Id, Retail_Campaign__C> oldacclinkmap,List<Retail_Campaign__C> oldrec){
        List<Retail_Campaign__C> retcampdelete=new List<Retail_Campaign__C>();
        List<Retail_Campaign__share> recordstodelete=new List<Retail_Campaign__share>(); 
        for(Retail_Campaign__C ret:oldrec){
            if(((Retail_Campaign__C)Trigger.newMap.get(ret.id)).Dealer_Code__c==null&&((Retail_Campaign__C)Trigger.newMap.get(ret.id)).Dealer_Code__c!=((Retail_Campaign__C)Trigger.OldMap.get(ret.id)).Dealer_Code__c){
        		retcampdelete.add(ret);
            }
            else if(((Retail_Campaign__C)Trigger.newMap.get(ret.id)).Dealer_Code__c!=((Retail_Campaign__C)Trigger.OldMap.get(ret.id)).Dealer_Code__c){
        		retcampdelete.add(ret);
    		}
        }
      recordstodelete=[select id from Retail_Campaign__share where parentid IN:retcampdelete];
      if(recordstodelete.size()>0){
      	database.delete(recordstodelete,false);
        sharerecordswithDealers(newacclinkmap);
        }
    }
    
  	public static void sharerecordswithDealers(List<Retail_Campaign__C> retailcamplst){
         List<String> dealerndcode=new List<String>();
         List<retail_Campaign__share> retshare=new List<retail_Campaign__share>();
         LIST<Retail_Campaign__C> retcampaign=[select id,Dealer_Code__c from Retail_Campaign__C where id in:retailcamplst and Dealer_Name__c!=null];
         for(Retail_Campaign__C retcam:retcampaign ){
           dealerndcode.add(retcam.Dealer_Code__c);  
       		}
        List<User> usrlist=[select id,username from User where dealer_nd_code__C IN : dealerndcode];
    	for(Retail_Campaign__c rc:retcampaign){
        	for(user us:usrlist){
            	Retail_Campaign__share ret=new Retail_Campaign__share();
            	ret.AccessLevel='EDIT';
                ret.RowCause = Schema.Retail_Campaign__share.RowCause.Manual;
                ret.ParentId = rc.id;
                ret.UserOrGroupId=us.id;
                retshare.add(ret);
        	} 
    	}
    	if(retshare.size()>0){
            Database.insert(retshare, false);
        }    
    }
    
    public static void UpdateDealerEmail(List<Retail_Campaign__c> dmr){
        LIST<ID> acclist=new List<ID>();
        List<Retail_Campaign__c> filterlst=new List<Retail_Campaign__c>();
        Map<id,String> accwithndcode=new Map<id,String>();
        MAp<String,String> idwithemail=new Map<string,string>();
        for(Retail_Campaign__c dm:dmr){
            if(dm.Dealer_Name__c!=null){
                filterlst.add(dm);
                acclist.add(dm.Dealer_Name__c);
            }
        }
        for(Account acc:[select id,dealer_nd_code__C from Account where id IN:acclist])
        {
            accwithndcode.put(acc.id,acc.dealer_nd_code__C);
        }
        for(USER usr:[select id,email,dealer_nd_code__C from user where dealer_nd_code__C IN : accwithndcode.values()]){
            idwithemail.put(usr.dealer_nd_code__C,usr.email);
        }
    	for(Retail_Campaign__c dmre:filterlst){
        	for(String str:idwithemail.keyset()){
            	if(accwithndcode.get(dmre.Dealer_Name__c)==str){
                	dmre.Dealer_Email__c=idwithemail.get(str);    
            	}
            	else{
                dmre.Dealer_Email__c='';
            	}            
        	}   
    	}	
    }
    public static void parentCampaingStatusChange(List<Retail_Campaign__c> retailcamp){     
     List<Retail_Campaign__c> records=[Select id,Close_Date__c,RecordTypeId,Child_Campaign_Status__c,Parent_Campaign1__r.id,Parent_Campaign1__r.status__c from Retail_Campaign__c where id IN:retailcamp];
        for(Retail_Campaign__c re:records){
            if(re.RecordTypeId==executionRecordId && re.Parent_Campaign1__c!=null){               
               retailcampaign.put(re.Parent_Campaign1__r.id,re.Parent_Campaign1__r.status__c);            
            } 
        }
        for(Retail_Campaign__c re:records){
           if(re.Child_Campaign_Status__c == 'Planning'){
                 retailcampaign.put(re.Parent_Campaign1__r.id,'Draft');
             }
             else if(re.Child_Campaign_Status__c == 'Completed'&&   re.Close_Date__c>System.today()){
             retailcampaign.put(re.Parent_Campaign1__r.id,'Completed');
             }
             else{
             retailcampaign.put(re.Parent_Campaign1__r.id,'Ongoing');
             }
        }       
        for(id idset : retailcampaign.keySet()){
            Retail_Campaign__c reCamp=new Retail_Campaign__c();
            if(idset!=null){
            reCamp.id=idset;
            reCamp.status__c=retailcampaign.get(idset);
            updateRetailCampaign.add(reCamp);
            }
        }
        
       if(updateRetailCampaign.size()>0){
           update updateRetailCampaign;
        }
    }
}