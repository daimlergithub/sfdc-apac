/*******************************************************************************************
* Class:                            Util_GetPermissionList
* Description:                      This class is invoked to check , if a user/market has permission to execute a apex method 
                                    according to assigned custom permissions/persona of user/market .
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 25/9/2017     Harshit Kabra           Created  

===========================================================================================*/
public without sharing class Util_GetPermissionList {

    public static Map<String,Set<String>> UserPermissionMap;
    public static Map<String,Set<String>> MarketPermissionMap;
    public static Map<String,Set<String>> UserPermissionMapFinal;
    public static Map<String,Set<String>> MarketPermissionMapFinal;
    public static User u;
    public static String RecordMarket;
    public static boolean flag;
    public static boolean flag1;
    public static String profileName;
   
    static{ 
             UserPermissionMap = new Map<String, Set<String>>();
             MarketPermissionMap = new Map<String, Set<String>>();
             UserPermissionMapFinal = new Map<String, Set<String>>();
             MarketPermissionMapFinal = new Map<String, Set<String>>();
             flag=true ;
             flag1=true;
             profileName=[Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
          }
    
    
    //Method to be invoked from other classes to check permisson on user , It will return true for Integration users
    public static Boolean checkAccessOnUser(String permissionToCheck )
    {  if(flag)
       { flag=false;
         u =[Select id, market__c from user where id=:UserInfo.getUserId()] ;
         UserPermissionMapFinal=Util_GetPermissionList.getUserPermissions(new List<User>{u});
         
       }
     
     if((UserPermissionMapFinal!= null && UserPermissionMapFinal.size()>0 &&  UserPermissionMapFinal.get(u.id).contains(permissionToCheck)) || profileName.equals('IntegrationAPI') ) return true;
     return false;
    }
    
    // set record market before invoking this method
    public static Boolean checkAccessForMarket( String RecordMarket, String permissionsToCheck)
    {
      if(flag1)
      {flag1=false;
       if(RecordMarket!= null) MarketPermissionMapFinal=Util_GetPermissionList.getPermissionsForMarket(new List<String>{RecordMarket}); 
       
      }
      if(MarketPermissionMapFinal!=null && MarketPermissionMapFinal.size()>0 &&  MarketPermissionMapFinal.get(RecordMarket).contains(permissionsToCheck)) return true;
      return false;
    }
    
    //get all custompermissions assigned to user
    Public static Map<String,Set<String>> getUserPermissions(List<User> ulist)
    {   UserPermissionMap=new Map<String,Set<String>>();
     try{
         for(User u : ulist) 
        {  Set<String>UserPermissions=new Set<String>();
           User u1= [Select Persona_Assigned__c from User where id=:u.id ];
           String personaAssigned=u1.Persona_Assigned__c;
         
           if(personaAssigned != null )
           {
            List<Persona__c> personaList = new List<Persona__c>();
            //fetch details from persona assigned to User 
            personaList=[Select Functionality_Access__c,Functionality_Access__r.PermissionSet_Ids__c, PersonaName__c from Persona__c where PersonaName__c =: personaAssigned ];
            if(personaList.size()>0)
           {
           Persona__c maj=personaList[0];
              
           List<String> UpermissionSetIDs= new List<String>();
           if(maj.Functionality_Access__r.PermissionSet_Ids__c != null)
           {
            UpermissionSetIDs=maj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
            List<CustomPermission> Ucustompermissions=new List<CustomPermission>();
            Ucustompermissions=[SELECT  DeveloperName FROM CustomPermission where id IN (SELECT SetupEntityId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : UpermissionSetIDs ) ];
            if(Ucustompermissions.size()>0)
            {
                for(CustomPermission cp:Ucustompermissions)
              {
                UserPermissions.add(cp.DeveloperName);
              } 
            }    
          }
        }
         if(UserPermissions.size()>0) UserPermissionMap.put(u.id, UserPermissions);
      }
     }
     }catch(Exception e)
     {
         CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
     }
     
           
        return UserPermissionMap;
    }
    
    //return all custom permissions assigned to market integration persona
    Public static Map<String,Set<String>> getPermissionsForMarket(List<String> MDList)
    {
      MarketPermissionMap=new Map<String,Set<String>>();
      Set<String>MarketPermissions;  
      for(String MD:MDList)
      {
       MarketPermissions = new Set<String>();    
       String recmkt=MD;
       List<Persona__c> personaList = new LIst<Persona__c>();
       //fetch details from  Integration persona of record's market  
       personaList=[Select Functionality_Access__c,Functionality_Access__r.PermissionSet_Ids__c, PersonaName__c from Persona__c where PersonaName__c like '%Integration%' and Market_Access__r.Market_Code__c =: recmkt ];
       if(personaList.size()>0)
       {
          Persona__c maj=personaList[0];
         
          List<String> UpermissionSetIDs= new List<String>();
          if(maj.Functionality_Access__r.PermissionSet_Ids__c != null)
           {
            UpermissionSetIDs=maj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
            List<CustomPermission> Ucustompermissions=new List<CustomPermission>();
            Ucustompermissions=[SELECT  DeveloperName FROM CustomPermission where id IN (SELECT SetupEntityId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : UpermissionSetIDs ) ];
            if(Ucustompermissions.size()>0)
            {
                 for(CustomPermission cp:Ucustompermissions)
               {
                MarketPermissions.add(cp.DeveloperName);
               }
            }
              
          }
        }
       if(MarketPermissions.size()>0) MarketPermissionMap.put(MD, MarketPermissions);
      }
      
        return MarketPermissionMap;
    }
    
}