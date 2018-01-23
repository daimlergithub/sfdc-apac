/*******************************************************************************************
* Class:                            MRC_AssignPersonaToUserExt 
* Description:                      This class is used to update persona of user based on the value selected from persona list. 
* ------------------------------------------------------------------------------------------
* Date          Name                   Modification Description
* 20/4/2017     Harshit Kabra           Modified  

===========================================================================================*/
public class MRC_AssignPersonaToUserExt {
    
    public boolean isError{get; set;}
    public String isPersona {get;set;}
    public List<Persona__c> majList{get;set;}
    public id UserId{get;set;}
    public User u{get;set;}
    public ID selMajID{get;set;}
    public Persona__c selectedMaj{get;set;}
    public String assignedMajID{get;set;}
    public Persona__c AssignedMaj{get;set;}
    public MRC_AssignPersonaToUserExt(ApexPages.StandardController controller) 
    {  isError=false;
       UserId=ApexPages.currentPage().getParameters().get('id');
       u= [select Market__c,Persona_Assigned__c,ChangesMadeInAssignedPersona__c from User where id =: UserId]; 
       if(u.Market__c == null)
       {   isError=true;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter user market before assigning Persona'));
          
       }
        else{
            if(u.Persona_Assigned__c != null) AssignedMaj = [Select PersonaName__c,Functionality_Access__r.Module_Name__c from Persona__c where PersonaName__c =: u.Persona_Assigned__c ]; 
            if(AssignedMaj != null) 
             {assignedMajID  = AssignedMaj.id;
              isPersona=assignedMajID ;
             } 
           //assignedMajID = assignedMajID.left(15);
            majList=new List<Persona__c>();
            majList=[Select id,PersonaName__c,Functionality_Access__r.Module_Name__c from Persona__c where Active__c= True and Market__c=:u.Market__c ];
            if(majList != null && majList.size()==0)
            {
                isError=true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Persona is present for the market of user'));
            }
        } 
    }
    
    public List<selectOption> getPersonas(){
         List<SelectOption> options = new List<SelectOption>();
        if(majList != null && majList.size()>0){
          for(Persona__c p: majList)
          {   String s=p.PersonaName__c+'   -   '+p.Functionality_Access__r.Module_Name__c;
              //String s=p.PersonaName__c;
              
              options.add(new SelectOption(p.id,s));
          }
        return options;   
       }
        return null;


        
    }    

    public pagereference selectPersona()
    {
        system.debug('!!!!!@@'+isPersona);
        selectedMaj=[Select name,id,PersonaName__c,ProfileId__c from Persona__c where id=: isPersona];
        u.Persona_Assigned__c=selectedMaj.PersonaName__c;
        u.ProfileId=selectedMaj.ProfileId__c;
        //ChangesMadeInAssignedPersona__c is false:  as we are assigning new persona, not making change in existing.
        u.ChangesMadeInAssignedPersona__c=false;
        DMLManagerService.updateAsSystem(u); 
        return new Pagereference('/'+u.id+'?noredirect=1&isUserEntityOverride=1');
       
    }
    
    public pagereference cancel()
    {
        return new Pagereference('/'+u.id+'?noredirect=1&isUserEntityOverride=1');
    }

    
}