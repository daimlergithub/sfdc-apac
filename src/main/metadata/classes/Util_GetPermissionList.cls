public class Util_GetPermissionList {

    public static Map<String,List<String>> UserPermissionMap;
    public static Map<String,List<String>> MarketPermissionMap;
    
    Public static Map<String,List<String>> getUserPermissions(List<User> ulist)
    {   UserPermissionMap=new Map<String,List<String>>();
     try{
         for(User u : ulist) 
        {  List<String>MarketPermissionList=new List<String>();
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
           //system.debug(maj);    
           List<String> UpermissionSetIDs= new List<String>();
           if(maj.Functionality_Access__r.PermissionSet_Ids__c != null)
           {
            UpermissionSetIDs=maj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
            List<CustomPermission> Ucustompermissions=new List<CustomPermission>();
            Ucustompermissions=[SELECT  DeveloperName FROM CustomPermission where id IN (SELECT SetupEntityId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : UpermissionSetIDs ) ];
            system.debug(Ucustompermissions);
               for(CustomPermission cp:Ucustompermissions)
            {
                MarketPermissionList.add(cp.DeveloperName);
            }
          }
        }
         if(MarketPermissionList.size()>0) UserPermissionMap.put(u.id, MarketPermissionList);
      }
     }
     }catch(Exception e)
     {
         System.debug(e.getMessage()+e.getLineNumber() );
     }
     
           
        return UserPermissionMap;
    }
    
    Public static Map<String,List<String>> getPermissionsForMarket(List<String> MDList)
    {
      UserPermissionMap=new Map<String,List<String>>();
      List<String>MarketPermissionList;  
      for(String MD:MDList)
      {
       MarketPermissionList = new List<String>();    
       String recmkt=MD;
       List<Persona__c> personaList = new LIst<Persona__c>();
       //fetch details from  Integration persona of record's market  
       personaList=[Select Functionality_Access__c,Functionality_Access__r.PermissionSet_Ids__c, PersonaName__c from Persona__c where PersonaName__c like '%Integration%' and Market_Access__r.Market_Code__c =: recmkt ];
       if(personaList.size()>0)
       {
          Persona__c maj=personaList[0];
          //system.debug('hk'+ maj);
          List<String> UpermissionSetIDs= new List<String>();
          if(maj.Functionality_Access__r.PermissionSet_Ids__c != null)
           {
            UpermissionSetIDs=maj.Functionality_Access__r.PermissionSet_Ids__c.split(';');
            List<CustomPermission> Ucustompermissions=new List<CustomPermission>();
            Ucustompermissions=[SELECT  DeveloperName FROM CustomPermission where id IN (SELECT SetupEntityId from SetupEntityAccess WHERE SetupEntityType='CustomPermission' AND ParentId In : UpermissionSetIDs ) ];
            for(CustomPermission cp:Ucustompermissions)
            {
                MarketPermissionList.add(cp.DeveloperName);
            }
          }
        }
       if(MarketPermissionList.size()>0) UserPermissionMap.put(MD, MarketPermissionList);
      }
      
        return UserPermissionMap;
    }
    
}