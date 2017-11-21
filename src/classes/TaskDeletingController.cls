/*
    Type:       Page Controller
    Purpose:    Prevent someone from removing tasks.
    User Story: 
    Used By:    Task Deleting page.
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2013-09-04
*/
public class TaskDeletingController {

    private Set<String> profiles = new Set<String>();
    private Task task;
    
    /**
  *@Description : Constructor
  *@Date : 4/11/2015
  *@param: ApexPages.StandardController(Task)
  *@return:This mehtod does not return any value.

  */
    public TaskDeletingController(ApexPages.StandardController controller) {
        task = (Task)controller.getRecord();
        isAllowedDelete = false;
        profiles.add('Central CRM Manager');
        profiles.add('Central AS Marketing Manager');
        profiles.add('Central AS Marketing Staff');
        profiles.add('CAC IT Manager');
    }
    
    public Boolean isAllowedDelete { get; set; }
   /**
  *@Description : Deletes the Selected Task.
  *@Date : 4/11/2015
  *@param: None
  *@return: PageReference.

  */ 
    public PageReference removeTask(){
        User user = [select Profile.Name from User where Id = :Userinfo.getUserId()];
        if(profiles.contains(user.Profile.Name)){
            try{
                delete task;
                isAllowedDelete = true;
                return new PageReference('/007?isdtp=it');
            }
            catch(DMLException ex){
                ApexPages.addMessages(ex);
            }
        }
        return null;
    }
}