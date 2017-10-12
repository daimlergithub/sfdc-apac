/*******************************************************************************************
* Class:                            MRC_MAJNewEditExt 
* Description:                      This class is used for associating the functionality/module record , market and a base profile  
*                                   to a newly created/updated persona record.
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public class MRC_MAJNewEditExt {

    public Persona__c maj{get;set;}
    public List<SelectOption> availableProfiles{get;set;}
    public String selectedProfile { get; set; }
    
//method to query all profile available in system
   public void fetchProfiles()
   {
      List<Profile> profileList=[SELECT Id,name FROM Profile];
      if(profileList!=null && profileList.size()>0 )
      {
        availableProfiles = new List<SelectOption>();
        //to display default value of profile picklist as none
        availableProfiles.add(new SelectOption('','-None-'));
        for(Profile oProfile : profileList)
        {
         availableProfiles.add(new SelectOption(oProfile.id,oProfile.name));
        }
      }
      
   }
    
    public MRC_MAJNewEditExt(ApexPages.StandardController controller) 
    {
       maj=(Persona__c)controller.getRecord();
       fetchProfiles();
       if(maj!=null && maj.id!=null)
      {
        maj=[Select id,PersonaName__c,Active__c,Market_Access__r.Market_Code__c,ProfileId__c,Functionality_Access__r.PermissionSet_Ids__c from Persona__c where id=:maj.id];
        if(maj!=null && maj.ProfileId__c!=null)
        {
        String savedProfile=maj.ProfileId__c;
        List<Profile> profileList=[SELECT Id,name from Profile where id =:savedProfile];
        if(profileList!= null && profileList.size()>0)
        {
            for(Profile oprofile: profileList)
          {
           // selectedProfile=new SelectOption(oprofile.id,oprofile.name);
           selectedProfile=(String)oprofile.id;
          }
        }
       }
      }
    }
    
   public PageReference saveRecord()
    {
      try{
        boolean first= true;
        maj.ProfileId__c=selectedProfile;
        List<Profile> profileList1=[SELECT Id,name from Profile where id =:selectedProfile];
        for(Profile oprofile: profileList1)
        {
           maj.Profiles__c=(String)oprofile.name;
        }
        //upsert maj;
        DMLManagerService.upsertAsSystem(maj);
         
        return new Pagereference('/'+maj.id);
           }
           catch(Exception ex)
           {
              
             if(ex.getMessage().contains('DUPLICATE_VALUE'))
             {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Value of Persona and combination of functionality-market should be unique');
                 ApexPages.addMessage(myMsg);
                 CustomLogUtil.CustomLoggingEntry('Error Occured' + ex.getmessage() +'-- '+ex.getlinenumber());
             }
               else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+ex.getMessage());
             ApexPages.addMessage(myMsg);
             CustomLogUtil.CustomLoggingEntry('Error Occured' + ex.getmessage() +'-- '+ex.getlinenumber());
              }  
             
               return null;
           }
          
           
           
    }
    
//method to invoke MRC_PermissionHandler.revokePermissions method to revoke access from all users who are assigned this persona    
    public pagereference revokeAccess()
    {
       
       MRC_PermissionHandler mph=new MRC_PermissionHandler();
       String message=mph.revokePermissions(maj);
       if(message.equals('OK'))
       {
          return new PageReference('/'+maj.id);
       }
       else
       {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+message);
             ApexPages.addMessage(myMsg);
             return null;
          
       }
    }

}