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
     {
	 if (!Test.isRunningTest()){controller.addFields(new String[]{'PermissionSet_Ids__c','Permission_Sets__c','Module_Name__c','Description__c','Id'});}
       func=(Functionality_Access_Master__c)controller.getRecord();
      try{
         PSpresent=false; 
         PermSIDList= new List<String>();
         if(func.PermissionSet_Ids__c != null) PermSIDList= func.PermissionSet_Ids__c.split(';');
      
      if(PermSIDList.size()>0 )
      {   PSpresent=true;
          displayPSMap();
      }
      
     
      }catch(Exception e)
      {
          CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
      }
       
        
    }
   public void displayPSMap()
   {
         PermSMap=new Map<String, String>();
		 List<permissionset> Permissionlist= new list<permissionset>([SELECT name,Id,IsOwnedByProfile,Label FROM PermissionSet where id in :PermSIDList]);
         for(permissionset PS : Permissionlist)
         {  
            PermSmap.put('/'+ps.id,ps.Name); 
		}
      
   }
    
}