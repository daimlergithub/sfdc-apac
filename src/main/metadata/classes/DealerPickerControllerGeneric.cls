public with Sharing class DealerPickerControllerGeneric {
    private  String campaignId{set;get;} 
    public List<DealersList> dList{set;get;}
    public static Id dealerAccount = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    public list<Account> dealerList{set;get;}
    List<Retail_Campaign__Share> accessonRetailcamp{Set;get;}
    Retail_campaign__C retcamp=new Retail_Campaign__c();
    public boolean displayPopup{set;get;}
    String market=[Select market__c from User where id=:UserInfo.getUserId()][0].market__c;
    List<campaignShare> campaignToShare=new List<campaignShare>();
    public DealerPickerControllerGeneric(){
    campaignId=ApexPages.currentPage().getParameters().get('CampaignId');//'a160l000000LgYf';//= 
    //system.debug('&&&&&&&'+campaignId);
       dealerList =new List<Account>();
        accessonRetailcamp=new List<Retail_Campaign__Share>();
        dealerList=[select id,Name,Dealer_Nd_code__c,Dealer_Gc_code__C,Dealer_Lead_Gate_Keeper__c,Mobile__c from Account where RecordTypeId=:dealerAccount and MD__c=:market and Dealer_Nd_code__c!=''];
        dList=new List<DealersList>();
        for(Account dealerrec:dealerList){
            dList.add(new DealersList(dealerrec));
        }
    }
    public class DealersList{
        public Account dealerlist{set;get;}
        public Boolean isSelected{set;get;}
        public DealersList(Account acc){
            this.dealerlist=acc;
            this.isSelected=false;
            }
        }
    public PageReference cancel() {
        return new PageReference('/' + campaignId);
        }
    public Retail_Campaign__Share shareRetailcampaignRecords(){
        Retail_Campaign__Share alshare=new Retail_Campaign__Share ();
        alshare.AccessLevel='EDIT';
        alshare.RowCause = Schema.Retail_Campaign__Share.RowCause.Manual;
        alshare.ParentId = campaignID;
        return alshare;  
    }
    public void showPopup() {        
        displayPopup = true;    
    }
    public PageReference SharetoDealers(){
        Retail_Campaign__c camp=new Retail_Campaign__c();
        camp=[select id,Relevant_Central_Campaign__c from Retail_Campaign__c where id=:campaignId limit 1];
        //String market=[Select market__c from User where id=:UserInfo.getUserId()][0].market__c;
        List<Retail_campaign__share> retailcampaignstosharewithdealergroups=new List<Retail_campaign__Share>();
        List<Account> retailcampaingstosharewithdealers=new List<Account>();
        Set<String> dealerndCode=new Set<String>();
        Set<String> dealerndcodetosendEmails=new Set<String>();
        Set<Group> groupName=new Set<Group>();
        Set<Group> actualgrouptoshare=new Set<Group>();
        for(DealersList listdealer:dList){
            if(listdealer.isSelected){
                retailcampaingstosharewithdealers.add(listdealer.dealerlist);
                String grpName=market+listdealer.dealerlist.dealer_nd_code__c;
                dealerndCode.add(grpName);
            } 
        }
        if(dealerndCode.size()>0){
            List<group> gnames=[select Id, Name, Type from Group where Name IN:dealerndCode];
            groupName.addAll(gnames);
            accessonRetailcamp=[select id, Accesslevel, userOrgroupid from Retail_Campaign__Share where parentid=:campaignId];
            Set<Retail_Campaign__Share> accssonRetailcampset=new Set<Retail_campaign__share>();
            accssonRetailcampset.addAll(accessonRetailcamp);
            if(groupName.size()>0&&accssonRetailcampset.size()>0){
                for(Group g:groupName){
                    for(Retail_Campaign__Share retshare:accssonRetailcampset){
                        if(g.id!=retshare.userOrgroupid&&!String.valueof(retshare.UserOrGroupId).Startswith('00G')){
              actualgrouptoshare.add(g);
                            dealerndcodetosendEmails.add(g.name);
                        }
                    }
                }
            }
            else{
                actualgrouptoshare.addAll(groupName);
            }
            
        }
        for(Group gp:actualgrouptoshare ){ 
        
            Retail_campaign__Share sharerec=new Retail_Campaign__Share();
            sharerec=shareRetailcampaignRecords();
            sharerec.UserOrGroupId=gp.id;
            retailcampaignstosharewithdealergroups.add(sharerec);
            //system.debug('@@@@'+retailcampaignstosharewithdealergroups.size());
            if(camp.Relevant_Central_Campaign__c!=null){
            CampaignShare campShare=new CampaignShare();
            campShare.UserOrGroupId=gp.id;
            campShare.CampaignId=camp.Relevant_Central_Campaign__c;
            campShare.CampaignAccessLevel='READ';
            campShare.RowCause=CampaignShare.RowCause.Manual;
            campaignToShare.add(campShare);
            }
        }
        if(retailcampaignstosharewithdealergroups.size()>0){
            try{
                database.insert(retailcampaignstosharewithdealergroups,false);
                if(market=='MY'){
                    sendEmailNotificationtoDealerMY(actualgrouptoshare,dealerndcodetosendEmails);
                }
            }
            Catch(Exception e){
                throw new applicationException(e.getMessage());
            }
        }
        if(campaignToShare.size()>0){
            try{
            database.insert(campaignToShare,false);
            //sendEmailNotificationtoDealer(actualgrouptoshare,dealerndcodetosendEmails);
            }
            Catch(Exception e){
                throw new applicationException(e.getMessage());
            }
        }
        return new PageReference('/' + campaignId);
        
    }
    public void sendEmailNotificationtoDealerMY(Set<Group> groupnames, Set<String> dealerndcode){
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         String commubaseurl='';
         boolean flag;        
         String communityName='Dealer Community MB Malaysia';    //market specific community name
         List<Network>  myNetwork = [SELECT Id,Name FROM Network];
         retcamp=[select name,id,ownerid from Retail_Campaign__C where id =:campaignID];
         for(Network net:myNetwork){
               if(net.name==communityName){
               flag=true;
               commubaseurl=Network.getLoginUrl(net.id)+'/'+campaignId;
               break;
           }
       }
       //MY specific email template
       EmailTemplate temp=(EmailTemplate)[select id,Body,subject from emailtemplate where name=:'MBMY_Retail_Campaign_Planning_And_Design_Notification_to_Dealers' limit 1];
       message.setTemplateid(temp.id);
       message.setTargetObjectId(retcamp.ownerid);
       message.setSaveAsActivity(false);
       string body=temp.Body.replace('{!Retail_Campaign__c.Name}',retcamp.name).replace('{!Retail_Campaign__c.Link} ',commubaseurl);
       message.setPlainTextBody(body);
       List<User> usrlist=new List<User>();
       usrlist=[select id,name,Email from User where dealer_nd_code__C IN:dealerndcode];
       Set<User> userset=new Set<USer>();
       userset.addall(usrlist);
       List<String> ToAdd=new List<String>();
        for(USer usr:userset){
            ToAdd.add(usr.email);
        }
        message.setToAddresses(ToAdd);
        try{
            Messaging.SendEmailResult[] m2=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
        }
        catch(Exception e){
           throw new applicationException(e.getMessage()); 
        }
    }
    public PageReference cancelURLS(){
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/DealerPicker?core.apexpages.request.devconsole=1');
    }
    
}