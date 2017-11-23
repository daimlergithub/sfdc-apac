/************************************************************************************
* Created By:Sarath M
* Created Date:23-sept-17
* Company:Infosys Ltd
* Description: Controller for the User_Req_Form page.(Which takes the details from the page and creates a record in the registered users Object.)
* ***********************************************************************************/
public class CustomSelfRegController{  
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}   
    public boolean checkDB{get;set;}  
    public Registered_Users__c u {get;set;}
    public string selectedRegion{get;set;}
    public string selectedDepartment{get;set;}
    public List<SelectOption> selectedRegionList{get;set;}
    public List<SelectOption> selectedDepartmentList{get;set;}
    
    public CustomSelfRegController(ApexPages.StandardController controller) {
                u = new Registered_Users__c();
        		// bring in from custom settings label.getPickListValuesRegion
                selectedRegionList=getPickListValues('Registered_Users__c','Region__c');
                selectedDepartmentList=getPickListValues('Registered_Users__c',label.getPickListValuesDepartment);
    }
    
    public void registerUser() {        
        List<Registered_Users__c> userRegisteredList=new List<Registered_Users__c>();
        string searchName=firstName+'.'+lastName;
        string searchString=searchname.toLowerCase();
        String userName = searchString+label.rug_userName_Extension;      
        String squery = 'Select id, UserName__c from Registered_Users__c';
        squery = squery+' where UserName__c like \'%'+ searchString + '%\'' ;
        if (squery != null){
            userRegisteredList = database.query(squery);
        }
        if (userRegisteredList.size()>0){
            Integer userRegisteredListSize = userRegisteredList.size();
            string listsizeString = string.valueof(userRegisteredListSize);           
            userName=searchString+listsizeString+label.rug_userName_Extension;
        }        
        String profileId =[select Id,name from profile where name=:Label.Rug_CommunityuserProfile].id;		   
       
        u.userName__c = userName;
        u.emailId__c = email;
        u.first_Name__c = firstName;
        u.last_Name__c = lastName;
        u.region__c = selectedRegion;       
        u.department__c = selectedDepartment;
        u.request_Status__c='New';
        u.profile__c=profileId;
        try {
            insert u;
            checkDB =true;
        } catch(DMLException ex) {            
            system.debug('<<Exception occured during Insert'+ex);
        } 
    }
    public PageReference navigateurl(){
        PageReference page = new PageReference(label.pageRedirectionAfterReqCreation);
        page.setRedirect(true);
        return page;
    }
    public List<SelectOption> getPickListValues(string sObjectName,string fieldName){          
          List<selectOption> dependentListFinal=new List<selectOption>();
          Schema.SObjectType obJGlobalDescribe = Schema.getGlobalDescribe().get(sObjectName);
          Schema.DescribeSObjectResult sObjDescribe = obJGlobalDescribe.getDescribe();    
          Schema.DescribeFieldResult F = sObjDescribe.fields.getMap().get(fieldName).getDescribe();
          List<Schema.PicklistEntry> P = F.getPicklistValues();
          for(Schema.PicklistEntry e : P)
          {
              dependentListFinal.add(new SelectOption(e.getValue(),e.getLabel()));
          }       
          return dependentListFinal;
   }
}