/*******************************************************************************************
* Class:                            MRC_PermissionHandler
* Description:                      This class is called from user trigger for updating permission sets and profile of user 
                                    on assigning/changing persona of user .
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public with sharing class MRC_PermissionHandler
{

  //public List<User>UserProfileUpdate= new List<User>();
  public class UserDetails
  { String Uid {get;set;}
    String Umarket {get;set;}
    String  Uprofile{get;set;}
    String Upersona{get;set;}
    Set<String> UpermissionSetIds{get;set;}
    //User u{get;set;}
  }  

//this method is invoked from process builder on updating persona of user to update profile 
@InvocableMethod(label='updateProfile' description='This will update profile of user according to persona')
public static void updateProfile(List<ID> ids )
{   
    List<User>userToUpdate = new List<User>();
    List<User> u= [Select id,Persona_Assigned__c,ChangesMadeInAssignedPersona__c from user where id in: ids];
    for(User ud: u){
       
        String uPersona=ud.Persona_Assigned__c;
        List <Persona__c> selectedMaj = new List<Persona__c>();
        selectedMaj=[Select name,id,PersonaName__c,ProfileId__c from Persona__c where PersonaName__c=: uPersona ];
         if(selectedMaj != null && selectedMaj.size() > 0){
      ud.ProfileId=selectedMaj[0].ProfileId__c;       
          userToUpdate.add(ud);
         }
       }
    DMLManagerService.updateAsSystem(userToUpdate);
    //update userToUpdate;
}

//for DML operations(delete existing and update new) on Permission Set Assignment records     
@future
public static void futureMethodsForDMLOperations(Set<Id> userIdSet )
{
   try{
         
  
    //fetch Users updated   
    List<User> c = [SELECT Id,Market__c,ProfileId,Persona_Assigned__c FROM user WHERE id in : userIdSet];
    //fetch existing Permission Sets to the users updated   
    List<PermissionSetAssignment> UsersExistingPermissionSets =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:userIdSet and PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile =false)];
    system.debug('**@@@****'+c.size()+'**@@@****'+UsersExistingPermissionSets.size()); 
    //delete UsersExistingPermissionSets;
    DMLManagerService.deleteAsSystem(UsersExistingPermissionSets);
    List<UserDetails> listUserDetails=new List<UserDetails>();   
    List<PermissionSetAssignment> PSAListToInsert = new List<PermissionSetAssignment>();   
    //fetch PS and assign new PS , according to persona      
    for(User u: c )
    {  
      UserDetails ud = new UserDetails();
      ud.Uid=u.id;
      ud.Umarket=u.Market__c;
      ud.Uprofile=u.ProfileId;
      ud.Upersona=u.Persona_Assigned__c;
      listUserDetails.add(ud);   
    } 
   
    if(listUserDetails.size()>0)
     {
       List<UserDetails>UserwithPermissions= getPermissionsetIdsForUser(listUserDetails);
       //assign the permissionsets
       PSAListToInsert= assignPermissionSetstoUsers(UserwithPermissions);
       DMLManagerService.upsertAsSystem(PSAListToInsert);      
       
     }   
   
   }catch(Exception e)
      {   
          CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
      }
        
   
    
}
    
  //this method to be called from the user trigger handler to assign permission sets to each user
  public void assignMarketBasedPermisionSetsToUsers(List<User> userList)
  {
     Set<ID> userID = new Set<Id>();  
      try{
           for(SObject obj:Trigger.new)
           {   
             User newu=(User)obj;
             User oldu=(User)trigger.oldmap.get(newu.id);
        
        
             //ChangesMadeInAssignedPersona__c=true, when changes made in functionality associated with assigned persona 
             //i.e. persona remains same only its access changes. 
             if(newu.Persona_Assigned__c != oldu.Persona_Assigned__c || newu.ChangesMadeInAssignedPersona__c == True )
             {
               userID.add(newu.id); 
             }  
           }
          if(userID != null && userID.size()>0) futureMethodsForDMLOperations(userID);         
          
        }catch(Exception e)
        {
          CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
        }
  }
    
 //this method to be called from the user trigger handler to assign permission sets to each user created
  public void assignMarketBasedPermisionSetsToUsersCreated(List<User> userList)
  {
     Set<ID> userID = new Set<Id>();  
      try{
           for(SObject obj:Trigger.new)
           { 
             User newu=(User)obj;
             //User oldu=(User)trigger.oldmap.get(newu.id);
                    
             if(newu.Persona_Assigned__c != null && newu.Persona_Assigned__c != '')
             {
               userID.add(newu.id); 
             }  
           }
           if(userID != null && userID.size()>0) futureMethodsForDMLOperations(userID);
        }catch(Exception e)
        {
          CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
        }
  }    
    
  
  //get permissionsets sets from junction object according to persona
  public static List<UserDetails> getPermissionsetIdsForUser(List<UserDetails> listUserDetails )
  { 
        
   List<UserDetails> PermissionsToUser=new List<UserDetails>();
   Set<String> UserPersonas=new Set<String>();
   for(UserDetails udt: listUserDetails )
   {
       UserPersonas.add(udt.Upersona);
   }
   List<Persona__c> listMAJ=[Select id,PersonaName__c,Market_Access__r.Market_Code__c,Functionality_Access__r.PermissionSet_Ids__c,ProfileId__c from Persona__c where Active__c=true and PersonaName__c in : UserPersonas];
  //assign PS acording to new persona selected
   if(listMaj.size()>0)
   {
       for(UserDetails udet: listUserDetails )
     {
        Set<String> setPermissionSetsForUser= new Set<String>();
         for(Persona__c maj: listMAJ )
         {
             if(udet.Upersona!=null && maj.PersonaName__c!= null && maj.PersonaName__c==udet.Upersona )
             {   
                 //udet.u.ProfileId= maj.ProfileId__c;
                 //UserProfileUpdate.add(udet.u);
                 if(maj.Functionality_Access__r.PermissionSet_Ids__c != null)
                 {
                     Set<String> setPermissionSets= new Set<String>(maj.Functionality_Access__r.PermissionSet_Ids__c.split(';'));
                     setPermissionSetsForUser.addAll(setPermissionSets);

                 }
                                  
             }
         }
             
             udet.UpermissionSetIds=setPermissionSetsForUser;
             PermissionsToUser.add(udet); 
      }  
   }
   
     
     return PermissionsToUser;
  }
  //assign a list of permission sets to each user
  public static List<PermissionSetAssignment> assignPermissionSetstoUsers(List<UserDetails> PermissionsToUser)
  {
    List<PermissionSetAssignment> psaList=new List<PermissionSetAssignment>();
    for(UserDetails ptu: PermissionsToUser)
    {
      if(ptu!=null && ptu.UpermissionSetIds!=null)
      {
      for(String psId: ptu.UpermissionSetIds)
        {
          PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = psId, AssigneeId = ptu.uId);
          psaList.add(psa );
        }
      }
    }
    
    return psaList;
  }
  //revoke permission from users; returns OK for success and exception message for error
  public String revokePermissions(Persona__c maj)
  {
     try{
         //List<String> listPermissionSetIds=getPermissionsetIdsForMarketTobeRemoved(maj);
         if(maj.PersonaName__c!= null && maj.Functionality_Access__r.PermissionSet_Ids__c != null)
         {
             List<String> listPermissionSetIds=maj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
             removePermissionSetsfromUsers(maj.PersonaName__c,listPermissionSetIds);
         }
         maj.Active__c=false;
         DMLManagerService.updateAsSystem(maj);
         //update maj;
         return 'OK';
        
     }
     catch(exception ex)
     {
       return ex.getStacktraceString();
     }
     
  }
  //delete permission set assignments from users of the market
  public void removePermissionSetsfromUsers(String personaOfUser,List<String> listPermissionSetIds)
  {
    List<PermissionSetAssignment> PSAtoBeDeleted=new List<PermissionSetAssignment>();
    //select user according to market & profile of functionality  
    List<User> UserListToUpdatePersona=new List<User>();
    List<User> usersTobeRevoked=[Select id,Persona_Assigned__c from User where Persona_Assigned__c =: personaOfUser];
    List<String> userIds=new List<String>();
    if(usersTobeRevoked.size()>0 )
    {
        for(User oUser: usersTobeRevoked)
      { oUser.Persona_Assigned__c=null;
        userIds.add(oUser.id);
       UserListToUpdatePersona.add(oUser);
       }
      DMLManagerService.updateAsSystem(UserListToUpdatePersona);
      //update UserListToUpdatePersona;
    }
    List<PermissionSetAssignment> psaFromQuery=[Select id,PermissionSetId,AssigneeId from PermissionSetAssignment where AssigneeId in :userIds
                                                And PermissionSetId In: listPermissionSetIds];
   DMLManagerService.deleteAsSystem(psaFromQuery);
      //delete psaFromQuery;
  }
  

    

}