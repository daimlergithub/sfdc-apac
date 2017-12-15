/************************************************************************************
* Created By:Sarath M
* Created Date:21-sept-17
* Company:Infosys Ltd
* Description: 
1. Submit the request to approval process when the request status is 'New'.
2. Create community user when the request status is 'Approved'.
* ***********************************************************************************/
public class RegisteredUsersTriggerHelper{
    public static void submitforApproval(List<Registered_Users__c> Reqlist){        
        for(Registered_Users__c userReq:Reqlist){        
            if(userReq.Request_Status__c=='new'){
                Approval.ProcessSubmitRequest req=new Approval.ProcessSubmitRequest();
                req.setObjectId(userReq.Id);        
				//Approval.ProcessResult result = Approval.process(req);  
				try{
                    Approval.ProcessResult result = Approval.process(req); 
                }catch(Exception e){}  
            } 
        }   
    }   
    public static void communityUserCreation(Registered_Users__c userReq){
        string searchString;
        list<User> userList=new list<user>();   
        List<String> usernameString=new List<String>();
        List<User> duplicateUserList=new List<User>();
        String rugProfileId =[select Id,name from profile where name=:label.Rug_CommunityuserProfile].id;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:label.assignRugPermissionSet];
        
        if (userReq.Request_Status__c=='Approved'){
            searchString = userReq.UserName__c.substringBefore('@');     
        }
        String squery = 'Select id, username from User';
        squery = squery+' where username like \'%'+ searchString + '%\'' ;
        if (squery != null){
            duplicateUserList = database.query(squery);
        }
        User rugUser=new User();
        if(userReq.Request_Status__c=='Approved'){
            rugUser.Email=userReq.EmailId__c;
            String regUserName =userReq.UserName__c.toLowerCase();
            
            if (duplicateUserList.size()>0){
                Integer listSize = duplicateUserList.size();
                string listsizeString = string.valueof(listSize); 
                rugUser.userName=regUserName.substringBefore('@')+listsizeString+label.rug_userName_Extension;
            }
            else{                   
                rugUser.Username=userReq.UserName__c;    
            }
            rugUser.ProfileId=rugProfileId;                    
            rugUser.FirstName=userReq.First_Name__c;
            rugUser.LastName=userReq.Last_Name__c;
            rugUser.communityNickname = string.valueof(userReq.Last_Name__c +Math.random()).substring(0,12);
            rugUser.alias = string.valueof(userReq.First_Name__c.substring(0,1) + 
                                           userReq.Last_Name__c.substring(0,1) + Math.random()).substring(0,5);
            rugUser.emailencodingkey='UTF-8';
            rugUser.languagelocalekey='en_US';
            rugUser.localesidkey='en_US'; 
            rugUser.timezonesidkey='America/Los_Angeles'; 
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = true;
            Database.insert(rugUser, dmo);
            assignPermissionSet(rugUser.id);              
   		}             
    }
    @future
    public static void assignPermissionSet(Id userId){
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:label.assignRugPermissionSet];
        PermissionSetAssignment  psa = new PermissionSetAssignment(PermissionSetId =ps.id, AssigneeId =userId);
        insert psa;
    }
}