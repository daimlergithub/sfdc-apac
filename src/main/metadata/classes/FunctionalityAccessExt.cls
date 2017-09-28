/*******************************************************************************************
* Class:                            FunctionalityAccessExt
* Description:                      This class is used for associating the permissions sets  
*                                   to a newly created/updated  functionality record.
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 5/5/2017     Harshit Kabra           Modified  

===========================================================================================*/
public with sharing class FunctionalityAccessExt {

    public FunctionalityAccessExt(ApexPages.StandardController controller) 
    {
     if (!Test.isRunningTest()) {controller.addFields(new String[]{'PermissionSet_Ids__c','Permission_Sets__c','Module_Name__c','Description__c','Id'});}
     // controller.addFields(new String[]{'PermissionSet_Ids__c','Permission_Sets__c','Module_Name__c','Description__c','Id'});
      oFAM=(Functionality_Access_Master__c )controller.getRecord();
      selectedPermissionSets = new List<SelectOption>();
      List<String> savedPermissionSetIds=new List<String>();
        
      if(oFAM.id!=null)
      {
        if(oFAM.PermissionSet_Ids__c != null)
         {
               savedPermissionSetIds=oFAM.PermissionSet_Ids__c.split(';');
         }
        List<PermissionSet> psList=new LIst<PermissionSet>();
        psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet where id in :savedPermissionSetIds];
        if(psList!= null && psList.size()>0)
        {
          for(PermissionSet ps: psList)
         {
          selectedPermissionSets.add(new SelectOption(ps.id,ps.label));
         }  
        }   
      }
     fetchPermissionSets(savedPermissionSetIds);
    }
    
    public List<SelectOption> availablePermissionSets{get;set;}
    public List<SelectOption> selectedPermissionSets { get; set; }
    public Functionality_Access_Master__c oFAM {get;set;}
    
    //method to get permission sets other then already selected
    public void fetchPermissionSets(List<String> savedPDIds )
    {
      List<PermissionSet> psList=[SELECT Id,IsOwnedByProfile,Label FROM PermissionSet where IsOwnedByProfile=false and Id Not in :savedPDIds];
      
      availablePermissionSets = new List<SelectOption>();
      if(psList!= null && psList.size()>0)
     {
      for(PermissionSet ps : psList)
      {
        availablePermissionSets .add(new SelectOption(ps.id,ps.label));
      }
     }
      
    }
    
    public PageReference saveRecord()
    {
      try{
          Boolean first=true;
          for(SelectOption selectedPS : selectedPermissionSets )
              {
                if(first!=true)
               {
                  oFAM.PermissionSet_Ids__c=oFAM.PermissionSet_Ids__c+';'+selectedPS.getValue();
                  oFAM.Permission_Sets__c=oFAM.Permission_Sets__c+';'+selectedPS.getLabel();
                }
                else
                {
                  oFAM.PermissionSet_Ids__c=selectedPS.getValue();
                  oFAM.Permission_Sets__c=selectedPS.getLabel();
                  first=false;
                }
              }
         
              upsert oFAM;
              return new Pagereference('/'+oFAM.id);
           }
           catch(Exception ex)
           {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:'+ex.getStacktraceString());
             ApexPages.addMessage(myMsg);
             return null;
           }
      }
}