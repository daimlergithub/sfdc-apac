/**
* Utility for Trigger on Case for TH(Thailand)
* Author:Dhanamjaya D
* Created Date : 5-april-2017
* this class will count the case complaint amount for thailand market if the record type is MB complaint 
*/

public class CaseHelperTH {
    Date myDate =date.newinstance(1900, 1, 7);
    public static boolean booleanCampaignUpdate=true;
    public Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    Map<Id, List<Id>> parentIdChildIds = new Map<Id, List<Id>>();
    Set<Id> parenthasParents = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    public static final String NOT_PRIMARY_REMINDER = 'This Complaint is not a primary complaint, please find the primary complaint.';
    public void updateCaseDeadLineAmount(List<case> caselist){
        for(Case caserec:Caselist){
            if(caserec.md__c=='TH'){
            Integer i=0;
            Boolean flag;
            if(caserec.RecordTypeId==caseMBComplaintRec_Id){
            //if(caserec.MBTH_Priority__c=='Red'){
                 string dayOfWeek = System.now().format('E');
                     if(dayOfWeek == 'Sat'||dayOfWeek == 'Fri'){
                            caserec.DeadLine__c=System.Now()+3;
                       }
                     else if(dayOfWeek == 'Sun'){
                        caserec.DeadLine__c=System.Now()+2;
                        
                        }
                     /*else if(dayOfWeek == 'Fri'){
                        caserec.DeadLine__c=System.Now()+3;
                        }*/
                     else{
                        caserec.DeadLine__c=System.Now()+1;
                        }
            //}
            /*else if(caserec.MBTH_Priority__c=='Yellow'){
            updatedeadine(caserec,72);
            }
            else if(caserec.MBTH_Priority__c=='Green' ){
            updatedeadine(caserec,192);
            }*/
            }
 
            else if(caserec.RecordTypeId==caseINquiryId){
                caserec.DeadLine__c=System.Now().addhours(3);
                /*if(caserec.priority=='C'){
                    updatedeadine(caserec,120);
                }
                else if(caserec.priority=='D'){
                    updatedeadine(caserec,240);
                }
                else if(caserec.priority=='E'){
                    updatedeadine(caserec,360);
                }*/
        }    
    }
        }
    }
    public static String getCommunityURL(){
        String communityName='Dealer Community Thailand';
         String commubaseurl='';
         boolean flag1;
    List<Network>  myNetwork = [SELECT Id,Name FROM Network];
       for(Network net:myNetwork){
           if(net.name==communityName){
           flag1=true;
           commubaseurl=Network.getLoginUrl(net.id);
          
           break;
           
           }
       }
       return commubaseurl.replace('login','');
    }
public  void updatecommunityurl(List<Case> caselist){
    String commURLTH=getCommunityURL();
    for(Case cas:caselist){
        cas.Others__c = commURLTH;
    }
    
}
    public void updateCaseOwnerDependsonPrimaryCaseDealer(List<Case> caselist,boolean isInsertFlag){
        set<Id> accset=new set<ID>();
        
        if(isInsertFlag){
        for(Case cas:caselist){
            if(cas.Case_Dealer__c!=null){
                accset.add(cas.Case_Dealer__c);
                
            }
        }

        }
        
        else{
            for(Case cas:caselist){
             if(((Case)trigger.newmap.get(cas.id)).ownerId!=((case)trigger.oldmap.get(cas.id)).ownerId){
               //c.ownerid=dealerndcode.get(c.Case_Dealer__c).Dealer_Lead_Gate_Keeper__c;
            }else if(cas.Case_Dealer__c!=null&&((Case)trigger.newmap.get(cas.id)).case_Dealer__c!=((case)trigger.oldmap.get(cas.id)).Case_Dealer__c){
                accset.add(cas.Case_Dealer__c);
            }
        }
       
    }
           Map<id,Account> dealerndcode=new Map<id,Account>([select id,Dealer_Lead_Gate_Keeper__c from Account where id IN:accset and Dealer_Lead_Gate_Keeper__c!=null]);
       if(dealerndcode.size()>0){
       for(Case c:caselist){
           if(c.Case_Dealer__c!=null){
               c.ownerid=dealerndcode.get(c.Case_Dealer__c).Dealer_Lead_Gate_Keeper__c;
           }
       }
    }
    }
    public void updatedeadine(case Caserec,Integer hours){
    Integer daystoadd=0;
    DateTime dt=System.now();
    
    
    Integer hourscount=0;
    While(hourscount<hours){
    string dayOfWeek = dt.format('E');
    
        if(dayOfWeek =='Sat'||dayOfWeek =='Sun'){
            //hourscount=hourscount+24;
        }
        else{
        
        hourscount=hourscount+24;
        }
        dt=dt+1;
    daystoadd=daystoadd+1;
    }
    
    if(caserec.deadline__c==null){
    caserec.deadline__c=System.now()+daystoadd;
    }
    }
    
    //Update Case Creator field with the CreatedBy value
    public void updateCaseCreator(List<Case> lst_Cases){
        If(!lst_Cases.isEmpty() && lst_Cases != Null){
            for(Case newCase: lst_Cases){
                newCase.Case_Creator__c = UserInfo.getUserId();
            }
        }
    }
    
    //Calculate total number of repeated MB complaints per account
    public void calculateComplaintAmount(List<Case> cases){
      
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases){
            if(c.MD__C == System.Label.MarketTH)
                accounts.add (c.AccountId);   
        }                       
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                      Where (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id and MD__c =: System.Label.MarketTH) LIMIT 50000]; 
        if (case_acc != null && !case_acc.isEmpty()){                                         
            for(Case c : case_acc){
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null){
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }
                else{
                    tmpCaseIds.add(c.Id);
                }
            }
            
            accounts = new Set<Id>();
            accounts = accountCaseMap.keySet();
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts LIMIT 50000];
            for (Account acc : accRecords){
               List<Id> caseIds = accountCaseMap.get(acc.Id);
               acc.Complaint_Amount__c = caseIds.size();
               updateAccount.add(acc);
            }
          
        }else{
            Set<Id> accountIds = new Set<Id>();
            for (Id accId : accounts){
                accountIds.add(accId);
            }
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accountIds];
            for (Account acc : accRecords){
               acc.Complaint_Amount__c = 0;
               updateAccount.add(acc);
            } 
        }
        update updateAccount;                                                                                                                 
    }
    
    //Calculate the number of Repeated Case for an account 
    public  void countRepeatComplaintCase (List<case> cases,boolean isInsert) {
        for(Case caseNew : cases) {
            if (isInsert){
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId && caseNew.md__c == System.Label.MarketTH && caseNew.ParentId != null){    
                    parentIds.add(caseNew.ParentId);   
                }
            }
        }
        if (parentIds.size()>0){
            for(Case ca :[select Id, ParentId from Case where ParentId in :parentIds] ) {
                if(!parentIdChildIds.containsKey(ca.ParentId)) {
                    parentIdChildIds.put(ca.ParentId, new List<Id>());
                }
                parentIdChildIds.get(ca.ParentId).add(ca.Id);
            }

            for(Case ca :[select Id, ParentId from Case where Id in :parentIds] ) {
                if(ca.ParentId != null) {
                    parenthasParents.add(ca.Id);
                }
            }
        }

        for(Case caseNew : cases) {
            if(isInsert) {
                if (caseMBComplaintRec_Id == caseNew.RecordTypeId &&caseNew.MD__c == System.Label.MarketTH){
                    caseNew.Repeat_Complaint_Times__c = 0;

             
                    if (caseNew.ParentId != null){
                        if(parenthasParents.contains(caseNew.ParentId)) {
                            caseNew.addError(NOT_PRIMARY_REMINDER );
                        }
                        else
                        {
                            if(parentIdChildIds.containsKey(caseNew.ParentId))
                                caseNew.Repeat_Complaint_Times__c = parentIdChildIds.get(caseNew.ParentId).size() + 1;
                            else
                                caseNew.Repeat_Complaint_Times__c = 1;
                        }
                    }
                }
        
            }
        }
    }

    public Static void ShareRecordswithDealers(List<Case> caselist,Boolean flag){
     Set<String> dealerndcodeset=new Set<String>();
     set<Case> lstcase=new set<Case>();
     set<caseShare> caseshare=new set<caseShare>();
     set<id> casesharingtorevoke=new set<id>();
     set<String> sharingrevokefromgroups=new set<String>();
     List<Case> caselisttoiterat=[select id,createdby.usertype,createdby.Dealer_nd_code__c,Case_Dealer__c,Case_Dealer__r.Dealer_nd_code__c,ownerId from Case where id IN : caselist];
        Set<id> idset=new Set<id>();
        for(Case c:caselisttoiterat){
            idset.add(c.ownerid);
        }
        Map<id,User> usr=new map<id,User>([select id,name,Dealer_nd_code__c,usertype from user where id  IN :idset]);
        //below if part will work at the time of insert
     for(Case casesrec:caselisttoiterat){
         if(!flag){
             
             //if created by is Dealer then share those records with under that Dealer depends on dealer nd code
             if(casesrec.createdby.usertype=='PowerPartner'&& casesrec.createdby.Dealer_nd_code__c!=null){
                    String grpName='TH'+casesrec.createdby.Dealer_nd_code__c;
                 	dealerndcodeset.add(grpName);
                    lstcase.add(casesrec);
             }
             else if(casesrec.Case_Dealer__c!=null && casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
                 String grpName='TH'+casesrec.Case_Dealer__r.Dealer_nd_code__c;
                 dealerndcodeset.add(grpName);
                 lstcase.add(casesrec);
            }
        }
        else{
             
         //if trigger new map value is filled and  oldmap assigned dealer is null then share records with new assigned value
            //system.debug(((Case)trigger.oldmap.get(casesrec.id)).owner!=((Case)trigger.newmap.get(casesrec.id)).owner);
            system.debug(((Case)trigger.oldmap.get(casesrec.id)).ownerId+'  '+((Case)trigger.newmap.get(casesrec.id)).ownerId);
         if(((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=null  && ((Case)trigger.oldMap.get(casesrec.id)).Case_Dealer__c==null&&casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
             String grpName='TH'+casesrec.Case_Dealer__r.Dealer_nd_code__c;
             dealerndcodeset.add(grpName);
             lstcase.add(casesrec);
         }
         //if trigger old is not equal to trigger new  then give access to new dealer and then revoke access from old dealer
         else if(((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=null  && ((Case)trigger.oldMap.get(casesrec.id)).Case_Dealer__c!=null&&((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c!=((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__c&&casesrec.Case_Dealer__r.Dealer_nd_code__c!=null){
            String grpName='TH'+casesrec.Case_Dealer__r.Dealer_nd_code__c;
            dealerndcodeset.add(grpName);
            lstcase.add(casesrec);
          //will revoke record access depends on dealer nd code  if we change the assigned dealer
             if (((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c!=null){
                 sharingrevokefromgroups.add(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
                casesharingtorevoke.add(((Case)trigger.oldmap.get(casesrec.id)).id);
            }
         }
         //if trigger old value is filled and new value did not filled then revoke access from old Dealer
         else if(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__c!=null && ((Case)trigger.newmap.get(casesrec.id)).Case_Dealer__c==null){
             sharingrevokefromgroups.add(((Case)trigger.oldmap.get(casesrec.id)).Case_Dealer__r.Dealer_nd_code__c);
             casesharingtorevoke.add(((Case)trigger.oldmap.get(casesrec.id)).id);
         }
         else if(((Case)trigger.oldmap.get(casesrec.id)).ownerId!=((Case)trigger.newmap.get(casesrec.id)).ownerId){
             String grpName='TH'+usr.get(casesrec.ownerid).dealer_nd_code__c;
             dealerndcodeset.add(grpName);
              lstcase.add(casesrec);
         }
     }
     }
     for(Group gp:[select id,name from Group where name IN :dealerndcodeset]){
        for(Case caseid:lstcase){
            //this if part will applicable for Salesforce users
            String grpName='TH'+caseid.Case_Dealer__r.Dealer_nd_code__c;
            String createdGrpName='TH'+caseid.createdby.Dealer_nd_code__c;
            if(gp.name==grpName){
            caseshare.add(new caseShare(CaseId=caseid.id,UserOrGroupId=gp.id,RowCause=Schema.caseShare.Rowcause.manual,CaseAccessLevel='EDIT'));
            }//this else part will applicable for Dealer users
            else if(gp.name==createdGrpName&&caseid.createdby.Usertype=='PowerPartner'){
                caseshare.add(new caseShare(CaseId=caseid.id,UserOrGroupId=gp.id,RowCause=Schema.caseShare.Rowcause.manual,CaseAccessLevel='EDIT'));
            }
         }
     }
     
     //else part will work at the time of Update
     
     if(caseshare.size()>0){
         List<caseShare> caseshareList=new List<caseShare>();
         caseshareList.addall(caseshare);
         Database.insert(caseshareList);
         if(casesharingtorevoke.size()>0){
             database.delete([select id from caseShare where Id IN :casesharingtorevoke and UserOrGroupId IN :sharingrevokefromgroups]);
         }
     }
     
 }
 
 //after checking the checkbox field '1st reminder','2nd reminder' and 'escalated to MBTH', send email to gatekeeper(case owner)
   public static void sendReminderEmail(Map<Id,sObject> newCaseMap,Map<Id,sObject> oldCaseMap)
   {
       List<Case> caseId1stRemLst=new List<Case>();
       List<Case> caseId2ndRemLst=new List<Case>();
       List<Case> caseIdEscltnLst=new List<Case>();
       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      
           for(Id caseId:newCaseMap.keySet())
           {
               Case newCaseObj=(Case)newCaseMap.get(caseId);
               Case oldCaseObj=(Case)oldCaseMap.get(caseId);
               if(newCaseObj.MBTH_1st_Reminder__c && newCaseObj.MBTH_1st_Reminder__c!=oldCaseObj.MBTH_1st_Reminder__c)
               {
                   caseId1stRemLst.add(newCaseObj);
               }
               if(newCaseObj.MBTH_2nd_Reminder__c && newCaseObj.MBTH_2nd_Reminder__c!=oldCaseObj.MBTH_2nd_Reminder__c)
               {
                   caseId2ndRemLst.add(newCaseObj);
               }
               if(newCaseObj.MBTH_Escalated_to_MBTH__c && newCaseObj.MBTH_Escalated_to_MBTH__c!=oldCaseObj.MBTH_Escalated_to_MBTH__c)
               {
                  
                   caseIdEscltnLst.add(newCaseObj);
               }
           }
      
       if(caseId1stRemLst.size()>0 ||caseId2ndRemLst.size()>0 || caseIdEscltnLst.size()>0)
       {
		   //send 1st reminder email to gatekeeper(case owner)
           if(caseId1stRemLst.size()>0)
            {
                Id templateId=[select Id from EmailTemplate where developerName = 'Case_1st_Reminder_Notification'].Id;
                for(Case caseObj:caseId1stRemLst)
                {
                    mails.add(EmailMessage.createSingleEmailMessage(caseObj.OwnerId,templateId,caseObj.Id));
                }
                
            }
           //send 2nd reminder email to gatekeeper(case owner)
           if(caseId2ndRemLst.size()>0)
           {
               Id templateId=[select Id from EmailTemplate where developerName = 'Case_2nd_Reminder_Notification'].Id;
                for(Case caseObj:caseId2ndRemLst)
                {
                    mails.add(EmailMessage.createSingleEmailMessage(caseObj.OwnerId,templateId,caseObj.Id));
                }
           }
            //send escalation email to gatekeeper(case owner)
           if(caseIdEscltnLst.size()>0)
           {
               Id templateId=[select Id from EmailTemplate where developerName = 'Case_escalated_to_MBTH_Notification'].Id;
                for(Case caseObj:caseIdEscltnLst)
                {
                    mails.add(EmailMessage.createSingleEmailMessage(caseObj.OwnerId,templateId,caseObj.Id));
                }
           }
           if(mails!=null && mails.size()>0)
           		Messaging.sendEmail(mails);
       }
   }	
	
}