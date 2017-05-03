public class CaseHelperJP 
{
    
    public Id caseInquiryRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
    public Id caseMBComplaintRec_Id = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.MB_COMPLAINT);
    public List<Id> tmpCaseIds = new List<Id>();
    public List<Account> updateAccount = new List<Account>();
    public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id S24h_Case_RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('S24h - MMC').getRecordTypeId();
    public List<Account> accUpdLst = new List<Account>();    
	set<String> gscode= new set<String>();
    Map<String, id> accUserMap = new Map<String, id>();
    Map<String,id> accUserMap1 = new Map<String,id>();
    set<String> newmapid= new set<String>();  

        
    public void calculateComplaintAmount(List<Case> cases, Map<Id,SObject> case_Map)
    {
        system.debug('Trigger Old Map...' +case_Map);
        Set<Id> accounts = new Set<Id>();
        Map<Id, List<Integer>> acc_Count = new Map<Id, List<Integer>>();
        List<Id> newAccoutIds = new List<Id>();
        for (Case c : cases)
        {
            if (c.MD__c == 'JP' || c.MD__c == 'KR')
            {

                Case caseRec = (Case)case_Map.get(c.Id);
                if (c.AccountId != caseRec.AccountId)
                {
                    List<Integer> count = acc_Count.get(caseRec.AccountId);
                    if (count == null)
                    {
                        acc_Count.put(caseRec.AccountId, new List<Integer>{1});
                    }
                    else
                    {
                        count[0]++;
                    }
                    accounts.add(caseRec.AccountId);               
                }else{
                    newAccoutIds.add(c.AccountId);
                }
            }
        }
        
        System.debug('Count of the Accounts changed...' +acc_Count);
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                                      Where (AccountId IN :accounts AND RecordTypeId =:caseInquiryRec_Id AND (MD__c = 'JP' OR MD__c = 'KR')
                                      AND Case_Class__c = 'Complaint') OR (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id 
                                      AND Case_Class__c = 'Complaint' and MD__c = 'KR')];  
        

        List<Account> accLst = new List<Account>([select id, Complaint_Amount__c from Account where id in: newAccoutIds]);
        for(Account acc: accLst){
            if(acc.Complaint_Amount__c > 0){
                acc.Complaint_Amount__c = acc.Complaint_Amount__c+1;
            }else{
                acc.Complaint_Amount__c = 1;
            }
                accUpdLst.add(acc);
        }
        if(accUpdLst.size()>0){
            update accUpdLst;
        }

        
        
        for(Case c : case_acc)
        {
            tmpCaseIds = accountCaseMap.get(c.AccountId);
            if (tmpCaseIds == null)
            {
                accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
            }
            else
            {
                tmpCaseIds.add(c.Id);
            }
        }
        
        accounts = new Set<Id>();
        accounts = accountCaseMap.keySet();
        List<Account> accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts];

        for (Account acc : accRecords)
        {
            List<Id> caseIds = accountCaseMap.get(acc.Id);
            List<Integer> caseCount = acc_Count.get(acc.Id);
            acc.Complaint_Amount__c = caseIds.size()-caseCount[0];
            updateAccount.add(acc);
        }
        system.debug('Accounts to be updated...' +updateAccount);
        if(updateAccount.size()>0){
            update updateAccount;
        }
    }
    
    public void calculateComplaintAmount(List<Case> cases)
    {
        system.debug('Incoming Cases...' +cases);
        Set<Id> accounts = new Set<Id>();
        List<Account> accRecords;
        for(Case c : cases)
        {
            if(c.MD__c == 'JP' || c.MD__c == 'KR')
            {
                accounts.add (c.AccountId);
            } 
        }                       
        system.debug('Accounts...' +accounts);
        
        List<Case> case_acc = [Select Id, AccountId From Case 
                               Where (AccountId IN :accounts AND RecordTypeId =:caseInquiryRec_Id AND MD__c = 'JP'
                                      AND Case_Class__c = 'Complaint') OR (AccountId IN :accounts AND RecordTypeId =:caseInquiryRec_Id AND MD__c = 'JP'
                                                                           AND Case_Class__c = 'Claim') OR (AccountId IN :accounts AND RecordTypeId =:caseMBComplaintRec_Id 
                                                                                                            AND Case_Class__c = 'Complaint' and MD__c = 'KR')]; 
        
        system.debug('Case_acc...' +case_acc);
        if (case_acc != null && !case_acc.isEmpty())
        {                                         
            for(Case c : case_acc)
            {
                tmpCaseIds = accountCaseMap.get(c.AccountId);
                if (tmpCaseIds == null)
                {
                    accountCaseMap.put(c.AccountId, new List<Id>{c.Id});
                }
                else
                {
                    tmpCaseIds.add(c.Id);
                }
            }
            
            system.debug('accountCaseMap...' +accountCaseMap);
            accounts = new Set<Id>();
            accounts = accountCaseMap.keySet();
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accounts];
            for (Account acc : accRecords)
            {
                List<Id> caseIds = accountCaseMap.get(acc.Id);
                acc.Complaint_Amount__c = caseIds.size();
                updateAccount.add(acc);
            }
            system.debug('Accounts to be updated...' +updateAccount);
        }
        else
        {
            Set<Id> accountIds = new Set<Id>();
            for (Id accId : accounts)
            {
                accountIds.add(accId);
            }
            accRecords = [Select Id, Complaint_Amount__c From Account Where Id IN:accountIds];
            for (Account acc : accRecords)
            {
                acc.Complaint_Amount__c = 0;
                updateAccount.add(acc);
            } 
        }
        update updateAccount;                                                                                                                 
    }
  
    public static void caseOwner(List<Case> CaseList,Map<Id,Case> Maplist){

 Set<Id> aid = new Set<Id>();   
    
    
    
     for(Case ca :CaseList){
     
     
         
         aid.add(Maplist.get(ca.Id).OwnerId);
     }
      system.debug('+++++++++++++'+aid);
     
     List<Group> usr = [Select Id From Group Where Id =:aid AND Name = 'Supervisor Team B' ];
     
     system.debug('+++++++++++++'+usr);
     
     if(usr.size() >0){
     
     
        
     for(Case ca :CaseList){
       
       ca.Status = 'Waiting for Response approval';
      
     
     }
     
     }
     
     }
    
    public void updateCaseDeadline(List<Case> cases){
        CaseDeadelineCalc__mdt caseDeadline;
        Date todayDate = Date.today();
        Integer days;
        Schema.DescribeSobjectResult results = CaseDeadelineCalc__mdt.getSObjectType().getDescribe();
        system.debug('Custom metadata :' +results.fields.getMap());
        
        Set<String> fields = results.fields.getMap().keySet();
        String fieldsToQuery = '';

        Integer i = 0;
        for (String f : fields){
            system.debug('map values...' +results.fields.getMap().get(f));
            if (i > 0){
                fieldsToQuery = String.ValueOf(fieldsToQuery+ ' ,'+results.fields.getMap().get(f));
                system.debug('fieldsToQuery...1' +fieldsToQuery); 
            }
            else{
                fieldsToQuery = String.ValueOf(results.fields.getMap().get(f));
                system.debug('fieldsToQuery...2' +fieldsToQuery); 
            }
            i++;
            system.debug('fieldsToQuery...3' +fieldsToQuery);  
        }
        
        String queryString = 'Select ' + fieldsToQuery + ' FROM CaseDeadelineCalc__mdt WHERE QualifiedApiName ='  +'\'Japan_Case_Deadlines\'';
        system.debug('Final query string..' +queryString);
        caseDeadline = Database.query(queryString);
        system.debug('Case deadline values...' +caseDeadline);
        
        for (Case c : cases){
            if (c.Case_Class__c == 'Others' && c.MD__c == 'JP' && c.RecordTypeId == caseInquiryRec_Id){
                if(c.Priority == 'A'){
                    system.debug('Case Deadlines...' +caseDeadline);
                    days = (Integer)caseDeadline.CaseDeadelineCalc1__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc2__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc3__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc4__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc5__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Complaint' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc6__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc7__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc8__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc9__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc10__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Claim' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc11__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc12__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc13__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc14__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc15__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Inquiry' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc16__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc17__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc18__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc19__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc20__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Request' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc21__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc22__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc23__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc24__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc25__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Touring Support' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc26__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc27__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc28__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc29__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc30__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
            if (c.Case_Class__c == 'Finance' && c.MD__c == 'JP'){
                if(c.Priority == 'A'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc31__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'B'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc32__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'C'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc33__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'D'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc34__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }else if(c.Priority == 'E'){
                    days = (Integer)caseDeadline.CaseDeadelineCalc35__c;
                    c.DeadLine__c = todayDate.addDays(days);
                }
            }
          if ((c.Priority == 'A' || c.Priority == 'Red >= 4') && c.MD__c == 'KR'){
               c.DeadLine__c=System.Now() + 1;         
            }
          if ((c.Priority == 'B' || c.Priority == 'Yellow = 3') && c.MD__c == 'KR'){
              c.DeadLine__c= System.Now() + 3;
           }
          if ((c.Priority == 'C' || c.Priority == 'Green <= 2') && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 10;          
           }  
        }        
    }
   public void updateCaseDeadline(List<Case> cases, Map<Id,SObject> case_Map){     
         for (Case c : cases){ 
               Case caseRec = (Case)case_Map.get(c.Id);
            if ((c.Priority == 'A' || c.Priority =='Red >= 4') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               
                c.DeadLine__c=System.Now() + 1;         
             }
           if ((c.Priority == 'B' || c.Priority =='Yellow = 3') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 3;
            }
           if ((c.Priority == 'C' || c.Priority =='Green <= 2') && c.Priority!=caseRec.Priority && c.MD__c == 'KR'){
               c.DeadLine__c= System.Now() + 10;          
            } 
          }      
       }  
public  void updateCase (List<case> caseSta) {

map<id, string> accidmap = new map<id, string>();
List<Account> accUpdLst = new List<Account>();
    
        for(case cas: caseSta){
            if (cas.Narrative_of_Type__c == 'Marketing Opt Out'){
                accidmap.put(cas.accountId, 'Marketing Opt Out');
            }
            if (cas.Narrative_of_Type__c == 'Magazine Opt Out'){
                accidmap.put(cas.accountId, 'Magazine Opt Out');
            }
           
        }   
    
    if(accidmap.size() > 0){
        List<Account> accLst = new List<Account>([select id, Opt_In_Contact_Reason__c from account where id in: accidmap.keyset()]);
        for(Account acc: accLst){
            if(accidmap.get(acc.id) == 'Marketing Opt Out'){
                acc.Opt_In_Contact_Reason__c = 'Magazine; Survey; MOT Car inspection; Gift; Campaign (Aftersales);Campaign (Finance);Campaign (New Car);Event (Aftersales);Event (New Car);Product Info (Aftersales);Product Info (Finance);Product Info (New Car);Fair';
            }
           
            if(accidmap.get(acc.id) == 'Magazine Opt Out'){
                acc.Opt_In_Contact_Reason__c = 'Magazine';
            }
            accUpdLst.add(acc);
        }
        if(accUpdLst.size()>0){
            update accUpdLst;
        }
    }
 
}
 
          /*
 Sent email to Dealer Sales/Dealer Service manager profile users if Retail_Case_Notice_Dealer_Flag__c =true in case object.
 */
 public static void SendEmailToNotifyDealer(List<Case> caseList)
    {
    Set<ID> dealerID=new Set<Id>();
    Set<ID> dealerName=new Set<Id>();
    List<User> lstUser=new List<User>();
    
        for(Case cs:caseList)
        {
        dealerID.add(cs.Case_Dealer__c);
        dealerName.add(cs.Case_Dealer__r.name);
        }
        if(dealerID!=null && !dealerID.isempty())
        {
        lstUser=[Select id,profile.name,email,contactId,contact.AccountId from User where contact.AccountId=:dealerID AND ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') ) ];
       System.debug('sent lstUser '+lstUser);
       }
       EmailTemplate et=[Select id,DeveloperName from EmailTemplate where DeveloperName=:'Notify_to_Dealer'];  
       List < Messaging.SingleEmailMessage > mailList = new List < Messaging.SingleEmailMessage > ();
        
             if(lstUser!=null )
             {
             System.debug('sent lstUser  venkyusers '+lstUser);
             for(User u:lstUser)
             {
                 System.debug('user details');
                 if(u.profile.Name=='Japan Dealer Sales Manager' || u.profile.Name=='Japan Dealer Service Manager')
                 {
                 
                 System.debug('sent lstUser  caseList'+caseList);
                     for(Case c:caseList)
                     {
                             if(c.Case_Dealer__c !=null )
                             {
                             System.debug('user email details');
                              if(c.Retail_Case_Notice_Dealer_Flag__c  ==true)
                              {
                               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTargetObjectId(u.id);  
                            mail.setUseSignature(false);  
                            mail.setBccSender(false); 
                            mail.setTemplateId(et.id); 
                            mail.setSaveAsActivity(false); 
                            mail.setWhatID(c.id);
                            mailList.add(mail);
                             
                            }
                             }
                     }
                 }
               }
               if(mailList!=null && !mailList.isempty())
               {
            Messaging.sendEmail(mailList);
            }
            //  Messaging.SendEmailResult [] sentemails = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailList}); 
                             
                    //         System.debug('sent email details'+sentemails ); 
             } 
    }
 /*
 Share case record with Japan Dealer Company Manager,Japan Dealer Sales Manager,Japan Dealer Service Manager,
  if this Case record belongs to the dealer user's company and Dealer_Contact__c value as "Yes" and
  Dealer_GC_Code_c field value of the Account linked to the "Case_Dealer_c" field of target Case match the Dealer_GC_Code__c of the target User
 */
   public static void shareCaseWithDealers(List<Case> shcaseList)
    {
    Id profileId=userinfo.getProfileId();
    if(profileId!=null)
    {
    Profile profileName=[Select Id,Name from Profile where Id=:profileId];
    } 
    
         Set<String> DealerGccode = new Set<String>();
          List<Account> DealeAcc=new List<Account>();  
        Id caseRecId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
        List<CaseShare> CaseSharingRecord = new List<CaseShare>();
        List<Caseshare> shareList = new List<Caseshare>();
        List<Case> caserecList = new List<Case>();
        set<id> shrcaseId = new set<id>();
        set<id> userId = new set<id>();
        set<string> Dealername = new set<string>();
        map<string,id> groupmap = new map<string,id>();
        set<id> shUserId = new set<id>();
        List<Group> partnerUserList = new List<Group>();
        List<Case> caselist = new List<Case>();
        set<id> dealerId = new set<id>();
        List<User> pUser=new List<User>();
        List<User> CaseDealerUser=new List<User>();
        set<id> CaseDealerUserId = new set<id>();
        
        if(shcaseList!=null && !shcaseList.isempty())
        {
        for(Case c : shcaseList)
        {
            if(c.RecordTypeId == caseRecId && c.Dealer_Contact__c == 'Yes' && c.Case_Dealer__c != null)
             {
                shrcaseId.add(c.Id);
                dealerId.add(c.Case_Dealer__c);
            }
           
        }
        }
         if(!shrcaseId.isEmpty() && shrcaseId != null)
            {
                caserecList = [select id,Case_Dealer__c,Case_Dealer_User__c,Case_Dealer__r.Name,Case_Dealer_User__r.Dealer_GC_Code__c,Case_Dealer__r.Dealer_GC_Code__c from Case where ID =:shrcaseId];                
            }
            if(!caserecList.isEmpty() && caserecList != null)
            {
                for(Case listca:caserecList)
                    {
                        Dealername.add(listca.Case_Dealer__r.Name);
                        userId.add(listca.Case_Dealer__c);  
                        CaseDealerUserId.add(listca.Case_Dealer_User__c); 
                        if(listca.Case_Dealer_User__r.Dealer_GC_Code__c !=null)
                        {
                        DealerGccode.add(listca.Case_Dealer_User__r.Dealer_GC_Code__c);
                        }                       
                        if(listca.Case_Dealer__r.Dealer_GC_Code__c!=null)
                        {
                        DealerGccode.add(listca.Case_Dealer__r.Dealer_GC_Code__c); 
                        }              
                    }
            }
            if(DealerGccode!=null)
            {
        DealeAcc=[Select id,Dealer_GC_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and Dealer_GC_Code__c=:DealerGccode];
           
           }
           if(DealeAcc!=null)
            for(Account dealerac:DealeAcc)
            {
            userId.add(dealerac.ID);
            }     
      System.debug('@@@@@@ userId venky'+userId);
      if(userId!=null)
      {
      pUser=[Select Id,Name,Dealer_GC_Code__c,contactId,isactive,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from user where Contact.AccountId=:userId and isactive=true and (profile.Name='Japan Dealer Company Manager' or profile.Name='Japan Dealer Sales Manager' OR profile.Name='Japan Dealer Service Manager')];
      } 
        if(!Dealername.isempty() && Dealername != null)
        {
            partnerUserList = [select id,name,developername from group where name =:Dealername];
        }
        for(Group g : partnerUserList)
        {
            groupmap.put(g.name,g.id);
        }
        if(!caserecList.isEmpty() && caserecList != null)
        { 
          for(User us:pUser)
          {
            for(Case shrcs : caserecList)
            {
            
               // if(!groupmap.isEmpty() && groupmap.get(shrcs.Case_Dealer__r.Name) != null && ((us.profile.Name=='Japan Dealer Sales Representative') || (us.profile.Name=='Japan Dealer Service Advisor') ))
                
                if(us.Contact.Accountid !=null && shrcs.Case_Dealer__c!=null)
                {
                    CaseShare shrcase = new CaseShare();
                    shrcase.CaseId = shrcs.id;
                    shrcase.CaseAccessLevel = 'edit';
                    shrcase.UserOrGroupId = us.id;
                    CaseSharingRecord.add(shrcase);
                }
            }
           } 
        }
        //Apex share number AS-017,JIRA ticket SFDCJP-655
        if(CaseDealerUserId!=null)
        {
          CaseDealerUser=[Select Id,Name,Dealer_GC_Code__c,contactId,isactive,Contact.AccountId,Contact.Account.Name,Profile.Name,Profile.userlicense.name from user where Contact.AccountId=:userId and isactive=true and (profile.Name='Japan Dealer Service Advisor' or profile.Name='Japan Dealer Sales Representative')];
        }
        
         if(!caserecList.isEmpty() && caserecList != null && CaseDealerUser!=null)
        { 
         
          for(User us:CaseDealerUser)
          {
            for(Case shrcs : caserecList)
            {
            
               // if(!groupmap.isEmpty() && groupmap.get(shrcs.Case_Dealer__r.Name) != null && ((us.profile.Name=='Japan Dealer Sales Representative') || (us.profile.Name=='Japan Dealer Service Advisor') ))
                
                if(us.id !=null && shrcs.Case_Dealer_User__c!=null )
                {
                    CaseShare shrcase = new CaseShare();
                    shrcase.CaseId = shrcs.id;
                    shrcase.CaseAccessLevel = 'edit';
                    shrcase.UserOrGroupId = us.id;
                    CaseSharingRecord.add(shrcase);
                }
            }
           } 
        }
        
         // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(CaseSharingRecord,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
         if(sr.isSuccess())
         {
         system.debug('###### %^%^%^%^%^%^%^%^'+sr);
         }
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(CaseSharingRecord[i].CaseId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }
        System.debug('$%$%$%$%$%$% CaseSharingRecord'+CaseSharingRecord);
        
    }
    

    
      public static void countchildcase(List<Case> cases,List<case> oldcases)
      {
         
         
          Id caseinquiryrt= Schema.SObjectType.case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
          Id dealeracctrt= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
          Id companyacctrt= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
          string dealercode;
          List<Account> accdealer = new List<Account>();
          set<case > newcaseids=new set<case >();
          Set<id> casedealeraccids=new Set<Id>();
          Set<id> delaccidcase=new Set<Id>();
          Set<id> delcasedealer=new Set<Id>();
          List<Account_Link__c> relatedacctlnkList = new List<Account_Link__c>();
          set<id> accdealerids=new set<id>();
          for(case ca:cases) 
              {
                  if(ca.RecordTypeId == caseinquiryrt && (ca.Case_Class__c =='Complaint' || ca.Case_Class__c == 'Claim'))
                  {
                      newcaseids.add(ca);
                      casedealeraccids.add(ca.Case_Dealer__c);
                  }
              }          
              
              // fetch all the account records which are related with case and have same dealer GC Code value.
              String dealerGCcode;
          if(!casedealeraccids.isEmpty() && casedealeraccids != null)
          {
              accdealer =[select id,name, Dealer_GC_Code__c ,(select id,Retail_Complaint_Amount__c,Last_Service_Dealer__c,fromRole__c,toRole__c from Account_Links1__r),(select id, Case_Dealer__c,accountId from Dealer__r) from Account where id=:casedealeraccids  AND RecordTypeId=:dealeracctrt ];
          }
              for(Account ac:accdealer)
              {
                  dealerGCcode=ac.Dealer_GC_Code__c; 
              }
              List<Account> sameaccdealer=[select id,name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c=:dealerGCcode AND RecordTypeId=:dealeracctrt];
              
              
              for(Account adeal: sameaccdealer)
              {
                  
                  accdealerids.add(adeal.id);
              } 
              Map<id,id> mapofcasefromids=new Map<id,id>(); 
              Map<id,id> mapofcasetoids=new Map<id,id>();
              List<case> casedealercount=new List<case>(); 
              set<id> caseaccountid=new set<id>(); 
              set<id> casedealeraccid=new set<id>(); 
              // fetch all the case records related to Accounts having same dealer GC code
              List<case> caselst= [select id,accountId ,Case_Dealer__r.Dealer_GC_Code__c,Case_Dealer__c from case where Case_Dealer__c=:accdealerids AND  RecordTypeId=:caseinquiryrt LIMIT 5000];
              
              for(case cs:caselst)
              {
                  caseaccountid.add(cs.accountId);
                  casedealeraccid.add(cs.Case_Dealer__c );
                  casedealercount.add(cs);
                  mapofcasefromids.put(cs.accountId, cs.accountId );
                  
                  mapofcasetoids.put(cs.Case_Dealer__c , cs.Case_Dealer__c );
                  
              }   
              
              //fetch all  the account link record which is related with case
              List<Account_Link__c> relatedacctlnk=[select id,Retail_Complaint_Amount__c,Last_Service_Dealer__c,fromRole__c,toRole__c from Account_Link__c where fromRole__c=:casedealeraccid AND toRole__c=:caseaccountid LIMIT 5000 ];
              
              system.debug('relatedacctlnk>>>>>>' + relatedacctlnk);
              // for insert and update trigger 
              for(Account_Link__c al :relatedacctlnk)
              {  
                  if(mapofcasetoids.containsKey(al.fromRole__c) &&  mapofcasefromids.containsKey(al.toRole__c ) )
                      if((mapofcasetoids.get(al.fromRole__c)==al.fromRole__c) &&( mapofcasefromids.get(al.toRole__c )==al.toRole__c) )
                  {
                      al.Retail_Complaint_Amount__c=casedealercount.size();
                      relatedacctlnkList.add(al);
                  }
              }
          system.debug('relatedacctlnkList>>>>' + relatedacctlnkList);
              update relatedacctlnkList; 
          
          
          
          
          // for delete trigger
          List<case> deletedcasedealer=new List<case>();
          Map<Id,Id> MapOfaccountId =new Map<Id,Id>();
          Map<Id,Id> MapOfdealerId=new Map<Id,Id>();
          set<case > oldcaseids=new Set<case >();
          
          
          if(trigger.isDelete)
          {
              
              for(case c:oldcases)
              {
                  delaccidcase.add(c.accountId);
                  delcasedealer.add(c.Case_Dealer__c);
                  deletedcasedealer.add(c);
                  MapOfaccountId.put(c.accountId,c.accountId);
                  MapOfdealerId.put(c.Case_Dealer__c,c.Case_Dealer__c);
              }
              
              //fetch all the account link records whose Account1 and Account2 are related with case record which we are trying to delete
              system.debug('+++++++++++++'+delcasedealer );
              system.debug('+++++++++++++'+delaccidcase );
              List<Account_Link__c> relatedacclnk=[select id,Retail_Complaint_Amount__c,Last_Service_Dealer__c,fromRole__c,toRole__c from Account_Link__c where fromRole__c IN :delcasedealer  AND toRole__c  IN:delaccidcase LIMIT 5000 ];
              system.debug('+++++++++++++'+relatedacclnk );
              for(Account_Link__c al :relatedacclnk)
              {  
                  if((MapOfdealerId.get(al.fromRole__c)==al.fromRole__c) && (MapOfaccountId.get(al.toRole__c)==al.toRole__c))
                  {
                      al.Retail_Complaint_Amount__c=al.Retail_Complaint_Amount__c-deletedcasedealer.size();
                  } 
              }  
              update relatedacclnk;
          } 
             
      }


    public void updateGateKeaperforApprovedProcess(List<Case> LstnewCase, Map<Id,Case> oldValcase, string action){
       List<Id> caseIds = new List<Id>();
         if(action == 'isUpdate'){
           for(case cs: LstnewCase){
               if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.Case_Dealer__c != null && cs.Case_Dealer__c != oldValcase.get(cs.id).Case_Dealer__c ){
                   caseIds.add(cs.id);                
                }
           }        
       }
        if(action == 'isInsert'){
           for(case cs: LstnewCase){
               if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.Case_Dealer__c != null){
                   caseIds.add(cs.id);                
                }
           }        
       }       
       
       if(caseIds.size()>0){
           
           shareAccountRecord.shareAccountRecordNow(caseIds);
       }
    }
	
    public void updateCaseDealer(List<case> dealerCaseList)
    {
        List<User> userList = new List<User>();
        set<id> userid = new set<id>();
        userList = [select id,Market__c,Profile.UserLicense.Name,ContactId,Contact.Accountid from User where id =:Userinfo.getUserId()];
        
        for(Case delcase: dealerCaseList)
        {
            if(!userList.isEmpty() && userList != null)
            {
                for(User u : userList)
                {
                    if(u.Market__c == 'KR' && u.Profile.UserLicense.Name == 'Partner Community')
                    {
                        delcase.Case_Dealer__c = u.Contact.AccountId;
                    }
                }
            }
        }
    }
	
	public void updateOwnerAsGateKeeperS24HNew(List<Case> Cs)
	{   
	   
	   for(Case c:Cs){
				if(c.recordtypeid==S24h_Case_RecordTypeId)
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
					accUserMap1.put(acc.Dealer_GS_Code__c,acc.id); 
				}
			}
		}
		for(Case c1:Cs){
		   
				 if(c1.recordtypeid==S24h_Case_RecordTypeId)
				 {
				   if(accUserMap.get(c1.Compass_Dealer_GS_Code__c)!=null)
				   {
						c1.ownerID = accUserMap.get(c1.Compass_Dealer_GS_Code__c); 
						
				   }
				   if(accUserMap1.get(c1.Compass_Dealer_GS_Code__c)!=null)
				   {
					 c1.case_dealer__c=accUserMap1.get(c1.Compass_Dealer_GS_Code__c);
				   }   
			  
			}
		  
			
			  
		}
		
	}
        
    public void updateOwnerAsGateKeeperS24HModify(List<Case> Cs)
    { 
        for(Case c:Cs)
        {
            if(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c!=((Case)Trigger.oldMap.get(C.id)).Compass_Dealer_GS_Code__c && c.RecordTypeId==S24h_Case_RecordTypeId)
            {
                if(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c!=null)
                {
                    newmapid.add(((Case)Trigger.newMap.get(c.id)).Compass_Dealer_GS_Code__c);
                    
                 }
            }
        }         
                    
                   
        if(newmapid.size()>0)
        {
            List<Account> accountList=[select id,Dealer_GS_Code__c,Dealer_Lead_Gate_Keeper__c from Account where Dealer_GS_Code__c=:newmapid];
            for(Account ac:accountList)
            {
                if(ac.Dealer_GS_Code__c!=null)
                {
                    accUserMap.put(ac.Dealer_GS_Code__c,ac.Dealer_Lead_Gate_Keeper__c);
                    accUserMap1.put(ac.Dealer_GS_Code__c,ac.id); 
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
            
            if(accUserMap1.get(lists.Compass_Dealer_GS_Code__c)!=null)
               {
                  lists.case_dealer__c=accUserMap1.get(lists.Compass_Dealer_GS_Code__c);
               }  
            else
            {
                lists.case_dealer__c=null;
            }     
        
        }

 
    }
	
 }