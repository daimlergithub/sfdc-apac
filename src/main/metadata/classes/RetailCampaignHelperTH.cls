/**
* Helper for Trigger on Retail_campaign__c for TH(Thailand)
*It will handle the Retail Campaign Functionalities
* Author: Dhanamjaya
* Created Date : 2017-10-10
*/
public class RetailCampaignHelperTH{
    public Static boolean booleanCampaignUpdate=true;
    public static Id planningRecordId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Planning & Design Campaign');
    public static Id executionRecordId = RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    Set<ID> retailExecutionid=new Set<ID>();
    Set<ID> retailplanningId=new Set<ID>();
    public static Map<id,string> retailcampaign= new Map<id,string>();
    public static List<Retail_Campaign__c> updateRetailCampaign=new List<Retail_Campaign__c>();
    //will deletes the parent campaigns and its associated child campaigns
    public static void deleteParentCampaignsandRelatedChildcampaigns(List<Retail_campaign__c> delcamp){
        List<Retail_campaign__C> parentRecordsToDelete=new List<Retail_Campaign__c>();
         List<Retail_campaign__C> childsToDelete=new List<Retail_Campaign__c>();
        List<Retail_campaign__C> childRecordstoDelete=new List<Retail_Campaign__c>();
        for(Retail_Campaign__c retcamprec:delcamp){
        if(retcamprec.Recordtypeid==executionRecordId ){
            if(retcamprec.child_campaign_status__c!='Planning'){
            retcamprec.addError('You Can\'t delete a child campaign with the status other than planning');
            }
            else{
            childsToDelete.add(retcamprec);
            }
        }else{
            if(retcamprec.Recordtypeid==planningRecordId && retcamprec.status__c=='Draft'){
                parentRecordsToDelete.add(retcamprec);
            }
            else{
                retcamprec.addError('The child Records are still running so you can not delete the Campaign');
            }
            childstodelete.addall([select id from Retail_campaign__c where Parent_Campaign1__c IN:parentRecordsToDelete]);
            DMLManagerService.deleteAsUser(childstodelete);
            //DMLManagerService.deleteAsUser(parentRecordsToDelete);
            //delete childstodelete;
            //delete parentRecordstoDelete;
        }
    }
    }
    public static void ShareChildRecordswithDealers(List<Retail_Campaign__C> retcamptoshare){
        
    }
    /*public static void beforeinsertORUpdateRetailCampaign(List<Retail_campaign__c> campnew){
    Map<id,Retail_campaign__c> retailcampaigs=new Map<id,Retail_campaign__c>();
        for(Retail_campaign__c retcamp:campnew){
            if(retcamp.recordtypeid==executionRecordId &&retcamp.Parent_Campaign1__c!=null){
            //retailcampaigs.put(retcamp.id,retcamp.)
            }
        
        }
    }*/
    //Will perform after insert operations.will be continued in the part of Dealer communities
   /* public static void afterInsertRetailCampaignSharing(List<Retail_Campaign__c> newList){
        Set<Id> recordIds = New Set<id>();
        Map<Id,String> UserMap = New Map<Id,String>();
        Set<String> dealerCode = New Set<String>();
        Set<String> accountName = New Set<String>();
        List<Retail_Campaign__Share> RetailCampaignShare = New List<Retail_Campaign__Share>();    
        For(Retail_Campaign__c RetMem : newList){
            If( RetMem.MD__c == 'TH'){
                 recordIds.add(RetMem.Id);
                 }
             }

        List<User> UserList =[select id,Contact.Id,Dealer_GC_Code__c From User Where Id =: UserInfo.getUserId()];
        For(User u : UserList){
            If(u.ContactId != null){    
                UserMap.put(u.id,u.Dealer_GC_Code__c);  
                dealerCode.add(u.Dealer_GC_Code__c);
            }   
        }
    List<Account> dealerAccList = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c =:dealerCode];
    For(Account acc :dealerAccList){
        accountName.add(acc.Name);
    }
    List<Group>groupList = [select Id, Name, Type from Group where Name =: accountName];
    if(recordIds.size()>0 && accountName != null){
       For(Retail_Campaign__c RetMem : newList){
  
           for(Group groupRec : groupList){
                    Retail_Campaign__Share RetShare = new Retail_Campaign__Share();
                    RetShare.AccessLevel = 'Edit';
                    RetShare.UserOrGroupId = groupRec.Id;
                    RetShare.ParentId = RetMem.Id;
                    RetShare.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
                    RetailCampaignShare.add(RetShare);
                } 
        }
    }
    If(RetailCampaignShare.size()>0){
        //insert RetailCampaignShare;
        database.insert(RetailCampaignShare);
    }
    }
    //Will Revoke the Reatil Campaign Access from the dealers.will continue in Dealer Communities
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
    }*/
    //Will Share the Retail Campaigns to Dealers.will continue as part of Dealer Communites
    /*public static void sharerecordswithDealers(List<Retail_Campaign__C> retailcamplst){
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
    }*/
    //Will Updates the dealer email.This Email is going to be used in Email notifications
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
    //Will change the parent campaigns status depends on the Child campaign status
    public static void parentCampaingStatusChange(List<Retail_Campaign__c> retailcamp, boolean isinsertflag){     
        String usrtype=Userinfo.getUserType();
        Map<id,String>  idwithndcode=new Map<id,String>();
        List<Retail_Campaign__share> retcampshare=new List<Retail_Campaign__share>();
     List<Retail_Campaign__c> records=[Select id,Close_Date__c,createdby.dealer_nd_code__C,RecordTypeId,Child_Campaign_Status__c,Parent_Campaign1__r.id,Parent_Campaign1__r.Close_Date__c,Parent_Campaign1__r.status__c from Retail_Campaign__c where id IN:retailcamp];
        for(Retail_Campaign__c re:records){
            if(re.RecordTypeId==executionRecordId && re.Parent_Campaign1__c!=null){               
               retailcampaign.put(re.Parent_Campaign1__r.id,re.Parent_Campaign1__r.status__c);            
            } 
            if(isinsertflag&&usrtype=='PowerPartner' && (re.RecordTypeId==planningRecordId || re.RecordTypeId==executionRecordId) && re.createdby.dealer_nd_code__C!=null){
                idwithndcode.put(re.id,re.createdby.dealer_nd_code__C);
            }
        }
        for(Group g:[select Name from group where name IN : idwithndcode.values() ]){
           for(Id id:idwithndcode.keyset()){
               if(idwithndcode.get(id)==g.name){
                   Retail_Campaign__share retca=new Retail_Campaign__share();
                   retca.ParentId=id;
                   retca.AccessLevel='EDIT';
                   retca.RowCause=Schema.Retail_Campaign__share.RowCause.Manual;
                   retca.UserOrGroupId=g.id;
                   retcampshare.add(retca);
                   
               }
               
               
           } 
        
        }
        for(Retail_Campaign__c re:records){
           if(re.Child_Campaign_Status__c == 'Planning'){
                 retailcampaign.put(re.Parent_Campaign1__r.id,'Draft');
             }
             else if(re.Child_Campaign_Status__c == 'Completed'&&   re.Parent_Campaign1__r.Close_Date__c<System.today()){
             retailcampaign.put(re.Parent_Campaign1__r.id,'Completed');
             }
             else if(re.Child_Campaign_Status__c =='Segmentation'||re.Child_Campaign_Status__c =='Execution'||re.Child_Campaign_Status__c =='Response collection'){
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
           
           //update updateRetailCampaign;
           DMLManagerService.updateAsSystem(updateRetailCampaign);
        }
        if(retcampshare.size()>0){
            DMLManagerService.insertAsSystem(retcampshare);
        }
    }
}