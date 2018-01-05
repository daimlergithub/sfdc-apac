public class UserHelperTH{
    public static Id dealerAccount = RecordTypeAccessService.getRecordTypeId('Account','Dealer');
    public static List<id> userlisttosharewhileupdating=new List<id>();
    public static List<id> AccessneedstoRevokefromuser=new List<id>();
    public static MAP<id,String> dealeruser=new Map<Id,String>();
    public static void AfterInsertANDUpdateMethod(list<User> usersList,boolean isInsert,boolean isUpdate)
    {    List<id> listOfUsers=new List<id>();
         List<id> accesstorevoke=new List<id>();
         List<id> accid=new List<ID>();
         Map<ID,set<ID>> accwithsetofUsers=new Map<ID,set<id>>();
        if(isInsert){
            System.debug('***usersList'+usersList+'--'+usersList[0].contact.AccountId);
            for(integer i=0;i<usersList.size()&&usersList[i].AccountId!=null&&usersList[i].market__C=='TH';i++){
                listOfUsers.add(usersList[i].id);
                accid.add(usersList[i].accountid);
            } 
        }
        
        //Update Operation will be perform once the requirement got from Market
        /*else if(isUpdate){
        for(integer i=0;i<usersList.size()&&(((User)Trigger.newmap.get(usersList[i].id)).contact.account.md__c=='TH'&&((User)Trigger.newmap.get(usersList[i].id)).contact.accountid!=((User)Trigger.oldmap.get(usersList[i].id)).contact.accountid)||(((User)Trigger.newmap.get(usersList[i].id)).market__c=='TH'&&((User)Trigger.oldmap.get(usersList[i].id)).market__c!='TH'&&((User)Trigger.newmap.get(usersList[i].id)).contact.accountid!=null&&((User)Trigger.newmap.get(usersList[i].id)).contact.account.md__c=='TH');i++){
                listOfUsers.add(usersList[i].id);
                accid.add(usersList[i].accountid);
                accesstorevoke.add(((User)Trigger.oldmap.get(usersList[i].id)).id);
            }
        }*/
        
        if(listOfUsers.size()>0){
        //will provides the existing users under particular Account.As community users creating manually taking only one account in consideration.
         Set<Id> existUserIds = new Set<Id>();
        for(User existUser : [select Id from User where AccountId = :accid[0] and isActive = true]) {
            existUserIds.add(existUser.Id);
        }

        if (existUserIds.size() == 0) {
            return;
        }
            
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Account',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Lead',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Vehicle',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'VehicleRelation',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Case',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'RetailCampaign',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'CampaignMemberCustom',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Campaign',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Accountlink',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'User',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'CarModel',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'SurveyTaken',true)));
        FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatchTH(listOfUsers[0],existUserIds,'Survey',true)));
        
        

           
           /* for(User usr:[select id,contact.accountid from User where contact.accountid IN : accid and market__c=:'TH']){
                 if(!accwithsetofUsers.keyset().contains(usr.contact.accountid)){
                        accwithsetofUsers.put(usr.contact.accountid,new set<ID>());
                    }
                accwithsetofUsers.get(usr.contact.accountid).add(usr.id);
            }*/
        }
            
        if(accesstorevoke.size()>0){
        //needs to revoke the access once users account or market got changed
                 
                 
        //database.ExecuteBatch(new RevokeALLRecordsToNewUserBatchTH(accesstorevoke[0],'Account'));
        
        }
          
        
        }
    
    
    public static void ShareUsersToDealersAfterInsertAndUpdate(List<User> userlist,boolean flag, List<User> oldusrlst){
       //this will work at the time of update trigger on user records
        if(flag){
            //if Old map market discriminator != newmap marketdiscriminator and new map marketdiscriminator is "TH" then sharing records with Dealers
            for(user u:userlist){
                if(((user)trigger.newmap.get(u.id)).market__c!=((user)trigger.oldMap.get(u.id)).market__c && ((user)trigger.newMap.get(u.id)).market__c=='TH' ){
                    
                    userlisttosharewhileupdating.add(u.id);
                }
                //If oldmap market Discriminator is "TH" and NewMap MarketDiscr is not equal to "TH" then revoke access from the Dealer
                else if(((user)trigger.oldMap.get(u.id)).market__c=='TH'&&((user)trigger.newMap.get(u.id)).market__c!='TH'){
                    AccessneedstoRevokefromuser.add(u.id);
                    
                }
                
            }
        }
        else{
            for(User u:userlist){
                //if the contact id is null and MD__c='TH' then he is not Thailand dealer user so share this User with All the Thailand Dealers
               if(u.Market__c=='TH'){
                    if(u.contactid==null){
                        userlisttosharewhileupdating.add(u.id);
                        }
                        // if contact id is there then he is the dealer user so share the Dealer User to Specific set of users 
                    else if(u.Dealer_nd_code__c!=null){
                        dealeruser.put(u.id,u.Dealer_nd_code__c);
                    }
              }
            }
        }
        if(userlisttosharewhileupdating.size()>0||AccessneedstoRevokefromuser.size()>0||dealeruser.size()>0){
            sharerecordswithdealersasfuture(userlisttosharewhileupdating,AccessneedstoRevokefromuser,dealeruser);
        }
    }
    @future
    public static void sharerecordswithdealersasfuture(List<id> accesstoshare,List<id> accesstorevoke,Map<id,String> dealeridandndcode){
        List<Group> gplst=getListofThailandDealerUsers();
        List<Usershare> usertoshare=new List<Usershare>();
         for(Group gp:gplst){
            for(ID usr:accesstoshare){
                    usertoshare.add(new UserShare(UserId=usr,UserAccessLevel ='READ',UserOrGroupId =gp.id,RowCause=Schema.UserShare.RowCause.Manual));
            } //the follwoing for will share the records only with specific dealers
            for(ID usr1:dealeridandndcode.keyset()){
                if(gp.name==dealeridandndcode.get(usr1)){
                    usertoshare.add(new UserShare(UserId=usr1,UserAccessLevel ='READ',UserOrGroupId =gp.id,RowCause=Schema.UserShare.RowCause.Manual));
                }
                
            }
        }
        if(usertoshare.size()>0){
        insert usertoshare;
        }
        if(accesstorevoke.size()>0){
            list<usershare> usrtodelete=[select id from Usershare where Userid IN : accesstorevoke and UserOrGroupId IN :gplst];
            if(usrtodelete.size()>0){
                delete usrtodelete;
            }
        }
    }
    //If no group is there with dealer nd code then it will create group and adds it to the group
    public static void createGroup(List<User> newUserList)
    {
       set<id> userid = new set<id>();
        set<id> newuserid = new set<id>();
        set<string> dealerndcode= new set<string>();
        List<Group> listgp=new List<Group>();
        List<Group> insertlistgp=new List<Group>();
        List<GroupMember> listGroupMember =new List<GroupMember>();
        for(integer i=0;i<newUserList.size()&&newUserList[i].ContactId !=null;i++){
            userid.add(newUserList[i].id);
        }
        List<User> users=[Select Id,Name,contactId,Contact.AccountId,Contact.Account.Dealer_Nd_code__c,Profile.userlicense.name from user where Id =:userid and market__c=:'TH' limit 50000];
        for(integer i=0;i<users.size()&&users[i].profile.userlicense.name=='Partner Community'&&users[i].contact.Account.Dealer_Nd_code__c!=null;i++)
        {         
                dealerndcode.add(users[i].contact.Account.Dealer_Nd_code__c);
        }
        listgp=[select id,Name ,Developername from group where Name =:dealerndcode];
        if(listgp.size()>0 && listgp!=null)
        {
            for(User Us:users)
            {
                for(integer i=0;i<listgp.size()&&Us.Contact.Account.Dealer_Nd_code__c ==listgp[i].name;i++)
                {
                       listGroupMember.add(new GroupMember(GroupId=listgp[i].id,UserOrGroupId = Us.id));
                }
            }       
            if(listGroupMember.size()>0){
                DMLManagerService.insertassystem(listGroupMember);
            }
        }
        else
        {
            for(integer i=0;i<users.size()&&dealerndcode.contains(users[i].contact.account.Dealer_Nd_code__c);i++)
            {
                Group g  = new group();
                newuserid.add(users[i].Id);
                g.name=users[i].Contact.Account.Dealer_Nd_code__c;
                insertlistgp.add(g);
            }
          if(insertlistgp.size()>0){
            DMLManagerService.insertassystem(insertlistgp);
              addGroupmembers(insertlistgp,newuserid);
         }
        }
    }
    //it will add Dealer Users to the group
    public static void addGroupmembers(List<Group> listGroup,Set<Id> UsersID)
    {
        List<GroupMember> listGroupMember =new List<GroupMember>();
        List<User> partUserList = new List<User>();
        partUserList=[Select id from User where id=:UsersID];
        for(Group g:listGroup)
        {
            for(User u:partUserList)
            {
              listGroupMember.add(new GroupMember(GroupId=g.id,UserOrGroupId = U.id)); 
            }    
        }
       if(listGroupMember.size()>0){
           DMLManagerService.insertassystem(listGroupMember);
       }
    }
    //Will fetch and returns all the Thailand User groups depends on Dealer nd code fields
    public Static List<Group> getListofThailandDealerUsers(){
        list<Account> dealerList=new list<Account>();
        Set<String> dealerndcode=new Set<String>();
        Set<Group> grp=new Set<Group>();
        //dealerList=[select id,Dealer_Nd_code__c from Account where RecordTypeId=:dealerAccount and MD__c='TH' and Dealer_Nd_code__c!=''];
        for(Account acc:[select id,Dealer_Nd_code__c from Account where RecordTypeId=:dealerAccount and MD__c='TH' and Dealer_Nd_code__c!='' limit 50000]){
            dealerndcode.add(acc.dealer_Nd_code__c);
        }
        return [select id,name from group where name IN : dealerndcode];
        }

}