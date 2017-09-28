/*******************************************************************************************
* Class:                            MRC_AccessPSFromFunctionalityExt 
* Description:                      This class is used to display links for permission sets detail page over functionality page. 
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public class MRC_AccessPSFromFunctionalityExt {
      
     public Functionality_Access_Master__c func{get;set;}
     public List<String>PermSIDList{get;set;}
     public Map<String, String>PermSMap{get;set;}
     public Boolean PSpresent{get;set;}
     public MRC_AccessPSFromFunctionalityExt(ApexPages.StandardController controller) 
     {if (!Test.isRunningTest()){controller.addFields(new String[]{'PermissionSet_Ids__c','Permission_Sets__c','Module_Name__c','Description__c','Id'});}
       func=(Functionality_Access_Master__c)controller.getRecord();
      try{
         PSpresent=false; 
         PermSIDList= new List<String>();
         if(func.PermissionSet_Ids__c != null) PermSIDList= func.PermissionSet_Ids__c.split(';');
      //PermSList.add(func.Permission_Sets__c.split(';') );
      system.debug('list'+PermSIDList);
      if(PermSIDList.size()>0 )
      {   PSpresent=true;
          displayPSMap();
      }
      /*else{
          system.debug('empty');
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO ,'No Permissions sets are attached with functionality.');
          //ApexPages.addMessage(myMsg);
      }*/
      }catch(Exception e)
      {
          system.debug(e.getMessage()+e.getStackTraceString());
      }
       
        
    }
   public void displayPSMap()
   {
         PermSMap=new Map<String, String>();
         for(String PS : PermSIDList)
         {  System.debug(PS);
            PermissionSet pset=[SELECT name,Id,IsOwnedByProfile,Label FROM PermissionSet where id=: PS];
            PermSmap.put('/'+pset.id,pset.Name); 
}
       system.debug('map'+ PermSmap);
   }
    
}