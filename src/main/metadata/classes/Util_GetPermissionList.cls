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
     
  public class UserPermissionDetails
  { String Uid {get;set;}
    String Umarket {get;set;}
    String  Upersona{get;set;}
    String UFAM{get;set;}
    List<String> UpermissionSetIds{get;set;}
    Set<String> UCustomPermissions{get;set;}
    //User u{get;set;}
  }  
  
   public class MarketPermissionDetails
  { String Mmarket {get;set;}
    String  Mpersona{get;set;}
    String MFAM{get;set;}
    List<String> MpermissionSetIds{get;set;}
    Set<String> MCustomPermissions{get;set;}
    //User u{get;set;}
  }  

    
    //Method to be invoked from other classes to check permisson on user , It will return true for Integration users
    public static Boolean checkAccessOnUser(String permissionToCheck )
    {  if(flag)
       { flag=false;
         u =[Select id, market__c ,Persona_Assigned__c from user where id=:UserInfo.getUserId()] ;
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
    {   
        
        UserPermissionMap=new Map<String,Set<String>>();
     try{
         List<UserPermissionDetails> updetList = new List<UserPermissionDetails>();
         for(User u : ulist)
         {
            if(u.Persona_Assigned__c != null)
            {
              UserPermissionDetails updet= new UserPermissionDetails();
              updet.Uid=u.id;
              updet.Umarket=u.Market__c;  
              updet.Upersona=u.Persona_Assigned__c;    
              updetList.add(updet);  
            }
         }
         if(updetList!= null && updetList.size()>0)
         {   
             Set<String> personaSet = new Set<String>();
             for(UserPermissionDetails upd : updetList)
             {
                 personaSet.add(upd.Upersona);
             }
             List<Persona__c> personaList = new List<Persona__c>();
             personaList=[Select Functionality_Access__c,Functionality_Access__r.PermissionSet_Ids__c,PersonaName__c from Persona__c where PersonaName__c in : personaSet];
             Set<String> PSSet=new Set<String>();
             for(persona__c p: personaList)
             {
                 PSSet.addAll(p.Functionality_Access__r.PermissionSet_Ids__c.split(';'));
             }
            List<SetupEntityAccess> SEList = new list<SetupEntityAccess>();
            SEList=[SELECT SetupEntityId,ParentId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : PSSet]; 
            Set<String> SEIds = new Set<String>();
            for(SetupEntityAccess s : SEList)
            {
                SEIds.add(s.SetupEntityId) ;
                 
            }
            List<CustomPermission> Ucustompermissions=new List<CustomPermission>(); 
            Ucustompermissions=[SELECT  id,DeveloperName FROM CustomPermission where id in : SEIds];
            Map<String, Set<String>> PSCPMap = new Map<String, Set<String>>();
            for(String p : PSSet)
            {   
              Set<String> cps = new Set<String>();  
                for(SetupEntityAccess sea : SEList)
                {
                    if(sea.ParentId == p)
                    {
                       for(CustomPermission cp : Ucustompermissions)
                       {
                        
                        if(cp.id==sea.SetupEntityId)
                        {
                            cps.add(cp.DeveloperName);
                            
                        } 
                       }
                      PSCPMap.put(sea.ParentId,cps);          
                    }
                      
                }
              
            }
             for(UserPermissionDetails upd : updetList)
             {
                 for(persona__c p : personaList) 
                 {
                     if(p.PersonaName__c == upd.Upersona)
                     { 
                         upd.UFAM=p.Functionality_Access__c;
                         upd.UpermissionSetIds= p.Functionality_Access__r.PermissionSet_Ids__c.split(';');
                         upd.UCustomPermissions = new Set<String>();
                         for( String up : upd.UpermissionSetIds)
                         {
                            if(PSCPMap.get(up) != null)
                            upd.UCustomPermissions.addAll(PSCPMap.get(up));    
                         }
                         
                         
                     }
                 }
                
             }
         }
      for(UserPermissionDetails upd : updetList)
             {
                 UserPermissionMap.put(upd.Uid,upd.UCustomPermissions );
                 
             }
                  
        
     //system.debug('++++++++++++'+updetList);    
     }catch(Exception e)
     {
         system.debug(e.getMessage() );
         CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
     }
     
           
        return UserPermissionMap;
    }
    
    //return all custom permissions assigned to market integration persona
    Public static Map<String,Set<String>> getPermissionsForMarket(List<String> MDList)
    {
      MarketPermissionMap=new Map<String,Set<String>>();
      Set<String>MarketPermissions;  
      try{
         List<MarketPermissionDetails> mdetList = new List<MarketPermissionDetails>();
         
             List<Persona__c> personaList = new List<Persona__c>();
             personaList=[Select Functionality_Access__c,Functionality_Access__r.PermissionSet_Ids__c,Market_Access__r.Market_Code__c, PersonaName__c from Persona__c where PersonaName__c like '%Integration%' and Market_Access__r.Market_Code__c in: MDList ];
             
             for(Persona__c p : personaList)
             {
              MarketPermissionDetails mdet= new MarketPermissionDetails();
              mdet.Mmarket=p.Market_Access__r.Market_Code__c;
              mdet.Mpersona=p.PersonaName__c;
              mdet.MFAM=p.Functionality_Access__c;   
              mdet.MpermissionSetIds =p.Functionality_Access__r.PermissionSet_Ids__c.split(';');
              mdetList.add(mdet);  
            }
             Set<String> PSSet=new Set<String>();
             for(persona__c p: personaList)
             {
                 PSSet.addAll(p.Functionality_Access__r.PermissionSet_Ids__c.split(';'));
             }
            List<SetupEntityAccess> SEList = new list<SetupEntityAccess>();
            SEList=[SELECT SetupEntityId,ParentId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : PSSet]; 
            Set<String> SEIds = new Set<String>();
            for(SetupEntityAccess s : SEList)
            {
                SEIds.add(s.SetupEntityId) ;
                 
            } 
          List<CustomPermission> Ucustompermissions=new List<CustomPermission>(); 
          Ucustompermissions=[SELECT  id,DeveloperName FROM CustomPermission where id in : SEIds];
          
          Map<String, Set<String>> PSCPMap = new Map<String, Set<String>>();
            for(String p : PSSet)
            {   
              Set<String> cps = new Set<String>();  
                for(SetupEntityAccess sea : SEList)
                {
                    if(sea.ParentId == p)
                    {
                       for(CustomPermission cp : Ucustompermissions)
                       {
                        
                        if(cp.id==sea.SetupEntityId)
                        {
                            cps.add(cp.DeveloperName);
                            
                        } 
                       }
                      PSCPMap.put(sea.ParentId,cps);          
                    }
                      
                }
            }
          
          for(MarketPermissionDetails mpd : mdetList)
             {
                 for(persona__c p1 : personaList) 
                 {
                     if(p1.PersonaName__c == mpd.Mpersona)
                     { 
                         //system.debug('@@@@@@'+upd.UpermissionSetIds);
                         //system.debug('%%%%%'+PSCPMap);
                         mpd.MCustomPermissions = new Set<String>();
                         for( String up : mpd.MpermissionSetIds)
                         {
                            if(PSCPMap.get(up) != null)
                            mpd.MCustomPermissions.addAll(PSCPMap.get(up));    
                         }
                     }
                 }
             }
      //system.debug(mdetList);   
      for(MarketPermissionDetails mpd : mdetList)
             {
                 MarketPermissionMap.put(mpd.Mmarket ,mpd.MCustomPermissions );
                 
             } 
          
          
      }catch(Exception e)
      {
         // system.debug(e.getMessage() );
         CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
      }
        
        system.debug('HHH*******'+MarketPermissionMap);
        return MarketPermissionMap;
    }
    
}