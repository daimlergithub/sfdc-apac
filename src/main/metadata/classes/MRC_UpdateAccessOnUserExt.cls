/*******************************************************************************************
* Class:                            MRC_UpdateAccessOnUserExt 
* Description:                      This class is used to update the permission set assignment for user assigned a particular persona. 
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/

public class MRC_UpdateAccessOnUserExt {
    
    public Functionality_Access_Master__c func{get;set;}
    public List<User>UListToUpdate{get;set;}

    public MRC_UpdateAccessOnUserExt(ApexPages.StandardController controller) 
     {   if (!Test.isRunningTest()){controller.addFields(new String[]{'PermissionSet_Ids__c','Permission_Sets__c','Module_Name__c','Description__c','Id'});}
       func=(Functionality_Access_Master__c)controller.getRecord();
      UListToUpdate=new List<User>();
      try{
        List<User>uList=new List<User>();
        List<String>PersonaUsingFunc=new List<String>();
        List<Persona__c>majList=new List<Persona__c>();
             
        majList=[Select id, PersonaName__c from Persona__c where Functionality_Access__c = : func.id];
        for(Persona__c maj: majList)
        {
            PersonaUsingFunc.add(maj.PersonaName__c);
        }
        uList=[Select id,ChangesMadeInAssignedPersona__c,Persona_Assigned__c from user where Persona_Assigned__c in: PersonaUsingFunc];
        for(User us: uList)
        {
            us.ChangesMadeInAssignedPersona__c=True;
            UListToUpdate.add(us);
        }
     
    
	 CustomLogUtil.CustomLoggingEntry('Error Occured' + UListToUpdate);
    
           
     }catch(Exception e)
     {
         CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
     }
    
    }
      
    public void updateUser(List<User> Ulist)
    {
        try{
            update Ulist ;
        }catch(Exception e)
        {
           CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() +'-- '+e.getlinenumber());
        }
        
    }
    public pagereference redirect()
    {   system.debug('inside redirect');
        if(UListToUpdate.size()>0) update UListToUpdate;
        system.debug('before return');
        return new Pagereference('/'+func.id);
    
    }
      
  
}