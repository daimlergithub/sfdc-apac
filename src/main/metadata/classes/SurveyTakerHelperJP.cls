public class SurveyTakerHelperJP {
    
    
    public static Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id rca=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Company').getRecordTypeId();
    public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id rp=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id rc=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Company').getRecordTypeId();
    
    public static void afterInsertEvent(List<SurveyTaker__c> surTakList)
    {
        set<id> percomAccoID = new set<id>();
        set<id> dealerID = new set<id>();
        set<id> accntId = new set<id>();
        set<String> GCCode = new set<String>();
        List<SurveyTaker__c> surveyTakerList = new List<SurveyTaker__c>();
        set<string>vnames = new set<string>();
        List<Account> dAccountList = new List<Account>();
        List<Account_Link__c>accountLinkList=new List<Account_Link__c>();
        list<account> alist=new list<account>();
        list<account> newacntlist=new list<account>();
        list<group> assignGroupList=new list<group>();
        map<string,id> assgroupMap = new map<string,id>();
        list<string>assignlist=new list<string>();
        list<String> AccountNAme = new List<String>();
        List<SurveyTaker__share> surveyTkrShareList = new List<SurveyTaker__share>();
        List<Survey__share> surveyShareList = new List<Survey__share>();
        
        for(SurveyTaker__c sur : surTakList)
        {
            
            if(sur.Dealer_Account__c != null && sur.View_By_All__c == false)
            {
                dealerID.add(sur.Dealer_Account__c);
            }
            else if(sur.Account__c != null && sur.Dealer_Account__c == null && sur.View_By_All__c == false)
            {
                percomAccoID.add(sur.Account__c);
                
            }
        }
        system.debug('percomAccoID>>>>' + percomAccoID);
        system.debug('dealerID>>>>' + dealerID);
        
        
        if(!percomAccoID.isEmpty() && percomAccoID != null)
        {
            accountLinkList=[select id,fromrole__c,torole__c from Account_link__c where torole__c=:percomAccoID AND (RecordtypeId =:rp OR RecordtypeId =:rc)];
        }
        if(accountLinkList!=null)
        {
            for(account_link__c acs:accountLinkList)
            { 
                system.debug('accountLinkList>>>>'+accountLinkList);
                dealerID.add(acs.fromrole__c);
            }
        }
        if(dealerID != null)
        {
            alist=[select id,name,Dealer_GC_Code__c from account where id IN:dealerID];  
        }
        if(alist!=null)
        {
            for(account a:alist)
            { 
                System.debug('DGCCode>>>>>'+a.Dealer_GC_Code__c);
                GCCode.add(a.Dealer_GC_Code__c);
                // assignlist.add(a.name);
            }
        }
        if(GCCode!=null)
        {
            newacntlist=[select id,recordtypeid,name,Dealer_GC_Code__c from account where Dealer_GC_Code__c IN:GCCode and recordtypeid=:da ];
            
        }    
        if(newacntlist!=null)
        {
            for(account a:newacntlist)
            {
                System.debug('a.name>>>>>>>>'+a.name);
                AccountNAme.add(a.name);
                
            }
        }        
        
        list<Group>grplist=new list<Group>([select id ,Name ,Type from Group where  Name IN: AccountNAme]);
        for(Group assg:grplist)
        {
            system.debug('grplist>>>>>>>>'+grplist);
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);
            
        }
        
        List<Account>aclist = [select id,name,recordtypeid,MD__c from account where  recordtypeid=:da and MD__c ='JP'];
        for(account a:aclist)
        {
            vnames.add(a.name);
        }
        list<Group>grouplist=new list<Group>([select id ,Name ,Type from Group where Name IN:vnames]);
        
        for(SurveyTaker__c surtak : surTakList)
        {
            if(surtak.view_by_all__c == false)
            {
                for(id m:assgroupMap.values())
                {
                    SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                    sharestaker.ParentId = surtak.Id;
                    sharestaker.UserOrGroupId = m;
                    sharestaker.AccessLevel = 'Edit';
                    sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    surveyTkrShareList.add(sharestaker);
                    
                    if(surtak.Survey__c != null)
                    {
                        Survey__Share surShare=new Survey__Share();
                        surShare.ParentId = surtak.survey__c;
                        System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                        surShare.UserOrGroupId = m;
                        surShare.AccessLevel = 'Read';
                        surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                        surveyShareList.add(surShare);
                    }
                }
                system.debug('surveyTkrShareList>>>>' + surveyTkrShareList);
            }
            else if(surtak.view_by_all__c == true)
            {
                for(group g:grouplist)
                {
                    SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                    sharestaker.ParentId = surtak.Id;
                    sharestaker.UserOrGroupId = g.id;
                    sharestaker.AccessLevel = 'Edit';
                    sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    surveyTkrShareList.add(sharestaker);
                    
                    if(surtak.survey__c != null)
                    {
                        Survey__Share surShare=new Survey__Share();
                        surShare.ParentId = surtak.survey__c;
                        System.debug('survey>>>>>>>>>>>>'+surtak.survey__c);
                        surShare.UserOrGroupId = g.id;
                        surShare.AccessLevel = 'Read';
                        surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                        surveyShareList.add(surShare);
                    }
                }
                system.debug('surveyTkrShareList>>>>' + surveyTkrShareList);
            }
            
            if(!surveyShareList.isEmpty() && surveyShareList != null)
            {
                Database.insert (surveyShareList);
            }
            
            if(!surveyTkrShareList.isEmpty() && surveyTkrShareList != null)
            {
                system.debug('surveyTkrShareList>>>>' + surveyTkrShareList);
                insert surveyTkrShareList;
            }
        }
    }
    public static void afterUpdateEvent(List<SurveyTaker__c> newList, Map<Id, SurveyTaker__c> oldMap){
        
        Map<Id, List<Id>> mapSurvery = new Map<Id, List<Id>>();
        Map<Id, List<Id>> mapCheckingType = new Map<Id, List<Id>>();
        List<SurveyTaker__Share> list_SharingRecord = new List<SurveyTaker__Share>();
        Set<Id> currentVrId=new Set<Id>();
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        //List<User> list_User = new List<User>();
        List<String> accNames=new List<String>();
        List<String> GcNames=new List<String>();
        set<string> vnames = new set<string>();
        Set<Id> set_AccountId = new Set<Id>();
        Set<Id> set_LinkId = new Set<Id>();
        Set<Id> set_CustomerId = new Set<Id>();
        List<Id> list_SurveyTakerId = new List<Id>();
        List<Id> list_SSurveyTakerId = new List<Id>();
        List<SurveyTaker__Share> sharesToDelete = new List<SurveyTaker__Share>();
        List<SurveyTaker__Share> surveyTkrShareList = new List<SurveyTaker__Share>();
        List<Survey__Share> surveyShareList = new List<Survey__Share>();
        
        
        for(SurveyTaker__c vc : newList){
            if(vc.account__c != null  &&  vc.account__c != oldMap.get(vc.Id).account__c && vc.View_By_All__c == false && vc.Dealer_Account__c == null){
                if(!mapCheckingType.containsKey(vc.account__c)){
                    mapCheckingType.put(vc.account__c, new List<Id>());
                }
                mapCheckingType.get(vc.account__c).add(vc.Id);
                currentVrId.add(vc.Id);
                if(vc.account__c != oldMap.get(vc.Id).account__c){
                    System.debug('set_CustomerId>>>>>>>'+set_CustomerId);
                    set_CustomerId.add(oldMap.get(vc.Id).account__c);
                }
                /*  if(vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c  && vc.View_By_All__c == false)
{
System.debug('inser>>>');
list_SurveyTakerId.add(vc.Id);

}*/
                if(vc.Dealer_Account__c == null && oldMap.get(vc.Id).Dealer_Account__c != null)
                { 
                    System.debug('set_AccountId>>>>>>>'+set_AccountId);
                    set_AccountId.add(oldMap.get(vc.Id).Dealer_Account__c);
                }
                
                list_SurveyTakerId.add(vc.Id);
                
                
            }
            // if(vc.View_By_All__c == false && vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c){list_SurveyTakerId.add(vc.Id);}
            
            if(vc.Dealer_Account__c != null && vc.Dealer_Account__c != oldMap.get(vc.Id).Dealer_Account__c && vc.View_By_All__c == false ){
                if(!mapSurvery.containsKey(vc.Dealer_Account__c)){
                    mapSurvery.put(vc.Dealer_Account__c, new List<Id>());
                }
                mapSurvery.get(vc.Dealer_Account__c).add(vc.Id);
                currentVrId.add(vc.Id);
                if(vc.Dealer_Account__c != oldMap.get(vc.Id).Dealer_Account__c){
                    set_AccountId.add(oldMap.get(vc.Id).Dealer_Account__c);
                }
                if(vc.Dealer_Account__c != null && oldMap.get(vc.Id).Dealer_Account__c == null){set_CustomerId.add(vc.account__c);}
                /*   if(vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c  && vc.View_By_All__c == false){

// set_CustomerId.add(vc.account__c);



}*/
                System.debug('inser1>>>');
                list_SurveyTakerId.add(vc.Id);  
            }
            if(vc.View_By_All__c == true && vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c)
            {
                list_SurveyTakerId.add(vc.Id);  
                List<Account>aclist = [select id,name,recordtypeid,MD__c from account where  recordtypeid=:da and MD__c ='JP'];
                for(account a:aclist)
                {
                    vnames.add(a.name);
                }
                list<Group>grouplist=new list<Group>([select id ,Name ,Type from Group where Name IN:vnames]);
                for(group g:grouplist)
                {
                    SurveyTaker__Share sharestaker = new SurveyTaker__Share();
                    sharestaker.ParentId = vc.Id;
                    sharestaker.UserOrGroupId = g.id;
                    sharestaker.AccessLevel = 'Edit';
                    sharestaker.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                    surveyTkrShareList.add(sharestaker);
                    if(vc.survey__c != null)
                    {
                        Survey__Share surShare=new Survey__Share();
                        surShare.ParentId = vc.survey__c;
                        System.debug('survey>>>>>>>>>>>>'+vc.survey__c);
                        surShare.UserOrGroupId = g.id;
                        surShare.AccessLevel = 'Read';
                        surShare.RowCause = Schema.Survey__Share.RowCause.Manual;
                        surveyShareList.add(surShare);
                    }
                }  
            }
            if(vc.View_By_All__c == false && vc.View_By_All__c != oldMap.get(vc.Id).View_By_All__c)
            {
                System.debug('Inserting>>>>>');
                list_SSurveyTakerId.add(vc.Id);
                
            }
            
        }  
        if(!surveyTkrShareList.isEmpty() && surveyTkrShareList != null)
        {
            if(!surveyShareList.isEmpty() && surveyShareList != null)
            {
                insert surveyShareList;
            }
            system.debug('surveyTkrShareList>>>>' + surveyTkrShareList);
            insert surveyTkrShareList;
        }
        system.debug('++++++++++++++++'+mapSurvery );
        system.debug('++++++++++++++++'+ mapCheckingType );
        system.debug('++++++++++++++'+set_AccountId);
        system.debug('++++++++++++++'+set_CustomerId);
        
        if(set_AccountId.size() > 0){
            List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_AccountId];
            for(Account acc : accName){
                //accNames.add(acc.Name);
                GcNames.add(acc.Dealer_GC_Code__c );
                system.debug('++++++++++++++'+'True');
                
                
            } 
            List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
            for(Account accs : accGCode ){
                accNames.add(accs.Name);  
                
            }
        }  if(set_CustomerId.size() >0){
            system.debug('++++++++++++++'+set_CustomerId);
            system.debug('++++++++++++++rpa'+rpa);
            system.debug('++++++++++++++rca'+rca);
            
            ListAlk=[select id,fromRole__c,toRole__c,RecordtypeId from Account_Link__c where toRole__c=:set_CustomerId AND (RecordtypeId=:rp OR RecordtypeId=:rc)];
            System.debug('++++++++'+ListAlk);
            
            if(ListAlk.size() > 0){
                System.debug('inserting>>>>>'+ListAlk.size());
                for(Account_Link__c  alk:ListAlk)
                {
                    if(alk.fromRole__c!=null && alk.toRole__c!=null)
                    {
                        System.debug('inserting1>>>>>');
                        set_LinkId.add(alk.fromRole__c);
                    } }
                List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_LinkId];
                for(Account acc : accName){
                    // accNames.add(acc.Name);
                    System.debug('dgccode>>>>>>'+acc.Dealer_GC_Code__c);
                    GcNames.add(acc.Dealer_GC_Code__c );
                    
                }
                List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                for(Account accs : accGCode ){
                    System.debug('anames>>>>>>'+accs.Name);
                    accNames.add(accs.Name); 
                    
                    
                }
                
            } }
        
        system.debug('++++++++++++++'+accNames);
        System.debug('lstlist>>>>'+list_SurveyTakerId );
        //  System.debug('ullist>>>>'+list_User);
        List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
        system.debug('+++++++++++'+list_User);
        List<SurveyTaker__Share> list_SharingDele = new List<SurveyTaker__Share>([SELECT Id,ParentId FROM SurveyTaker__Share 
                                                                                  WHERE (ParentId IN:list_SurveyTakerId AND RowCause ='Manual') AND UserOrGroupId IN :list_User]);
        
        if(list_SharingDele.size() > 0){
            for(SurveyTaker__Share s:list_SharingDele){system.debug('parentIds>>>>>>>>'+s.parentid);}
            delete list_SharingDele;
            system.debug('+++++++++++SD'+list_SharingDele);
        } 
        if(list_SSurveyTakerId.size()>0 ){
            System.debug('Delet5ecopy>>>>>>>>>');
            List<SurveyTaker__Share> list_SharingDeele = new List<SurveyTaker__Share>([SELECT Id,ParentId FROM SurveyTaker__Share 
                                                                                       WHERE ParentId IN:list_SSurveyTakerId AND RowCause ='Manual']);
            delete list_SharingDeele;
            System.debug('Delet5ecopy@@>>>>>>>>>');
            
        }  
        
        if(mapSurvery.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(mapSurvery));
        }
        
        if(mapCheckingType.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(mapCheckingType,currentVrId));
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        system.debug('++++++++++++++'+list_SharingRecord);
    }
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    // Get all the Dealer Account with Same GC Code -
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
        
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordTypeId =: Dealer_RecordTypeId ];
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
        }
        
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                            AND RecordTypeId =: Dealer_RecordTypeId ];
            
            system.debug('+++++++++++++++++++'+similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
    
    
    private static List<SurveyTaker__Share> createDealerAccountSharing(Map<Id, List<Id>> mapSurvery){
        // START: Adding Similar GC Code related Account To Map which is sharing already.
        Set<Id> dealerAccIdSet = new Set<Id>();
        for(Id dealerAccId : mapSurvery.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
        
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(mapSurvery.containsKey(dealerId)) {
                List<Id> vrIdList = mapSurvery.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    mapSurvery.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: mapSurvery.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
        // END: Adding Similar GC Code related Account To Map which is sharing already.
        List<SurveyTaker__Share> list_SharingRecord = new List<SurveyTaker__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && mapSurvery.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id acId : mapSurvery.get(accNameToAccIdMap.get(groupRec.Name))){
                    SurveyTaker__Share surveyTakerShare = new SurveyTaker__Share();
                    surveyTakerShare.AccessLevel = 'Edit';
                    surveyTakerShare.UserOrGroupId = groupRec.Id;
                    surveyTakerShare.ParentId = acId;
                    surveyTakerShare.RowCause = Schema.SurveyTaker__Share.RowCause.Manual;
                    list_SharingRecord.add(surveyTakerShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    
    private static List<SurveyTaker__Share> createPersonOrCompanyAccountSharing(Map<Id, List<Id>> mapCheckingType,Set<Id> currentVrId){
        List<Account_Link__c> ListAlk1=new List<Account_Link__c>();
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> VrID=new Set<Id>();
        
        ListAlk1 = [select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:mapCheckingType.keySet() ];
        for(Account_Link__c alk:ListAlk1) {
            DealerAccId.add(alk.fromRole__c);
        }
        DealerAccId.remove(null);
        
        // Start: Share with all Dealer Account with same GC Code
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(DealerAccId);
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                DealerAccId.add(similarGCCodeDealerId);
            }
        }
        // Finish: Share with all Dealer Account with same GC Code
        
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: DealerAccId];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
        
        System.debug('DealerAccId  newList'+DealerAccId);
        
        List<SurveyTaker__Share> list_SharingRecord = new List<SurveyTaker__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(currentVrId != null){
                for(Id ids:currentVrId){
                    SurveyTaker__Share surveyTakerShare = new SurveyTaker__Share();
                    surveyTakerShare.AccessLevel = 'Edit';
                    surveyTakerShare.UserOrGroupId = groupRec.Id;
                    surveyTakerShare.ParentId = ids;
                    surveyTakerShare.RowCause = Schema.SurveyTaker__Share.RowCause.Manual;
                    list_SharingRecord.add(surveyTakerShare);
                }
            }
        }
        return list_SharingRecord;
        
        
    }
}