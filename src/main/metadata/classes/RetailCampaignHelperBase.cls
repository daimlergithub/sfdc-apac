/**************************************************************************************************************************************************
* Class:                            RetailCampaignHelperBase
* Description:                      This class will handles the Retail Campaign helper functionalities
@ deleteParentCampaignsandRelatedChildcampaigns() this method will delete the child and its parent campaigs once its parent campaign status is Draft.
* --------------------------------------------------------------------------------------------------------------------------------------------------
=====================================================================================================================================================*/
public class RetailCampaignHelperBase{
    //public Static boolean booleanCampaignUpdate=true;
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
        }
    }
    }

    //Will Updates the dealer email.This Email is going to be used in Email notifications
    public static void UpdateDealerEmail(List<Retail_Campaign__c> dmr, String commURLMY){
        LIST<ID> acclist=new List<ID>();
        List<Retail_Campaign__c> filterlst=new List<Retail_Campaign__c>();
        Map<id,String> accwithndcode=new Map<id,String>();
        MAp<String,String> idwithemail=new Map<string,string>();
        for(Retail_Campaign__c retcamp:dmr){
            retcamp.CommunityURL__c=commURLMY;
        }
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
        Map<id,String>  idwithndcode=new Map<id,String>();
        List<Retail_Campaign__share> retcampshare=new List<Retail_Campaign__share>();   
        for(Retail_Campaign__c re:[Select id,Close_Date__c,createdby.dealer_nd_code__C,RecordTypeId,Child_Campaign_Status__c,Parent_Campaign1__r.id,Parent_Campaign1__r.Close_Date__c,Parent_Campaign1__r.status__c from Retail_Campaign__c where id IN:retailcamp]){
           if(re.Child_Campaign_Status__c == 'Planning'){
                 retailcampaign.put(re.Parent_Campaign1__r.id,'Draft');
             }
             else if(re.Child_Campaign_Status__c == 'Completed'&&   re.Parent_Campaign1__r.Close_Date__c<System.today()){
             retailcampaign.put(re.Parent_Campaign1__r.id,'Completed');
             }
             else if(re.Child_Campaign_Status__c =='Segmentation'||re.Child_Campaign_Status__c =='Execution'||re.Child_Campaign_Status__c =='Response collection'){
             retailcampaign.put(re.Parent_Campaign1__r.id,'Ongoing');
             }
            if(isinsertflag&&Userinfo.getUserType()=='PowerPartner' && (re.RecordTypeId==planningRecordId || re.RecordTypeId==executionRecordId) && re.createdby.dealer_nd_code__C!=null){
                idwithndcode.put(re.id,re.createdby.dealer_nd_code__C);
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
        for(Group g:[select Name from group where name IN : idwithndcode.values() ]){
           for(Id id:idwithndcode.keyset()){
               if(idwithndcode.get(id)==g.name){
                   retcampshare.add(new Retail_Campaign__share(ParentId=id,AccessLevel='EDIT',RowCause=Schema.Retail_Campaign__share.RowCause.Manual,UserOrGroupId=g.id));
               }    
           } 
        }
        
       if(updateRetailCampaign.size()>0){
           DMLManagerService.updateAsSystem(updateRetailCampaign);
        }
        if(retcampshare.size()>0){
            DMLManagerService.insertAsSystem(retcampshare);
        }
    }
}