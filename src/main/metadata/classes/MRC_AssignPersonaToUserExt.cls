/*******************************************************************************************
* Class:                            MRC_AssignPersonaToUserExt 
* Description:                      This class is used to update persona of user based on the value selected from persona list. 
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public class MRC_AssignPersonaToUserExt {

    public List<Persona__c> majList{get;set;}
    public id UserId{get;set;}
    public User u{get;set;}
    public ID selMajID{get;set;}
    public Persona__c selectedMaj{get;set;}
    public MRC_AssignPersonaToUserExt(ApexPages.StandardController controller) 
    {  
       UserId=ApexPages.currentPage().getParameters().get('id');
       u= [select Market__c,Persona_Assigned__c,ChangesMadeInAssignedPersona__c from User where id =: UserId]; 
       majList=new List<Persona__c>();
       majList=[Select PersonaName__c,Functionality_Access__r.Module_Name__c from Persona__c where Active__c= True ];
      }
    public pagereference selectPersona()
    {
        
        selectedMaj=[Select name,id,PersonaName__c,ProfileId__c from Persona__c where id=: selMajID];
        u.Persona_Assigned__c=selectedMaj.PersonaName__c;
        u.ProfileId=selectedMaj.ProfileId__c;
        //ChangesMadeInAssignedPersona__c is false:  as we are assigning new persona, not making change in existing.
        u.ChangesMadeInAssignedPersona__c=false;
        DMLManagerService.updateAsSystem(u); 
        return new Pagereference('/'+u.id+'?noredirect=1&isUserEntityOverride=1');
       
    }

    
}