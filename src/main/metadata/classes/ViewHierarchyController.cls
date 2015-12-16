/**
** Display "Tree Hierarchy" of Account to Vehicle Relationship --> Vehicle Relationship to Vehicle -->  to Vehicle Relationship and Retail Tasks.
** Also Display "Tree Hierarchy" of Account to Account Link
** Created By: Sneha Chail
** Date: 2015-12-11(yyyy-mm-dd)
**/
  Public class ViewHierarchyController{ 
     //Variable Declaration
     List<Account_Link__c> lstAccountLink=new List<Account_Link__c>();
     Public Vehicle_Relationship__c velRel{get;set;}
     Public Account acount{get;set;}
     Public List<cNodes> hierarchy;
 
    /**  
     * @Description Contructor is getting called and fatching current account record details 
     * @author  Sneha chail
     * @Date   12/11/2015(mm/dd/yy)  
     * @return current page record Id
     * @see   ViewHierarchy(Vf Page)    */    
   
     Public ViewHierarchyController(ApexPages.StandardController controller) {        
             acount= new Account();
             if(!test.isRunningTest()){  
               controller.addFields(new List<String> {'lastName','FirstName','UCID__c'});
                 
                } 
             this.acount= (Account)controller.getRecord();        
        }
      
    /**  
     * @DescriptionWrapper class to contain the nodes and their children
     * @author  Sneha chail
     * @Date   12/11/2015(mm/dd/yy)  
     * @Param  Current account's VehicleRelationship
     * @Param  List of Vehicle Relationship which are associated with vehicles 
     * @Param  Current account's Retail Task
     * @see   ViewHierarchy(Vf Page)
    */ 

    public class cNodes
    {
    
     public List<Vehicle_Relationship__c> parentVehRelation {get; set;}
     Public Vehicle_Relationship__c gparentVehRelation {get;set;}
     Public List<Retail_Task__c> retailtask{get;set;}
    
     public cNodes(Vehicle_Relationship__c gparent, List<Vehicle_Relationship__c> parentVelRel,List<retail_Task__c> retailTsk)
       {
         parentVehRelation = parentVelRel;
         gparentVehRelation = gparent;
         retailtask=retailTsk;
      }
     }
    /* end of Wrapper class */ 
      
     /**  
      * @Description fetching all the data associated with VehicleRelationship to Vehicle then Vehicle to Vehicle Relationship
      * @author  Sneha chail
      * @Date   12/11/2015(mm/dd/yy)  
      * @return List of Current account-->Vehicle Relationshio-->Vehicle-->Vehicle Relationship
      * @return List of current account's Retail Tasks
      * @see   ViewHierarchy(Vf Page)
     **/ 

     Public List<cNodes> getmainnodes()
      {
        hierarchy = new List<cNodes>();
        List<Vehicle_Relationship__c> tempParentvelRel = [Select Id,Name,Vehicle_ID__c,Vehicle_ID__r.Name,Start_Date__c,Car_Relation__c,
                                                Vehicle_ID__r.Brand__c,Vehicle_ID__r.Car_Model__c,Vehicle_ID__r.Class__c,Contact__r.name 
                                                from Vehicle_Relationship__c Where Contact__c=:acount.Id AND Vehicle_ID__c!=Null];
        for (Integer i =0; i< tempParentvelRel.size() ; i++)
        {
           hierarchy.add(new cNodes(tempParentvelRel[i],tempVelRelation(tempParentvelRel[i].Vehicle_ID__c,tempParentvelRel[i].Id),tempRetailTask(tempParentvelRel[i].Vehicle_ID__c)));
         }   
        return hierarchy;
      } 
  
     /**  
      * @Description fetch all the vehicle relationship records
      * @author  Sneha chail
      * @Date   12/11/2015(mm/dd/yy)  
      * @Param Vehicle Id and associated vehicle Relationship Id   
      * @see   ViewHierarchy(Vf Page)
     **/   
      
      Public list<Vehicle_Relationship__c> tempVelRelation(Id VehicleID,Id Ids){
       List<Vehicle_Relationship__c> childrenVelRelation = [Select Name,Vehicle_ID__r.Name,Vehicle_ID__c,
                                    Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_ID__r.Brand__c,Vehicle_ID__r.Car_Model__c,
                                    Vehicle_ID__r.Class__c,Car_Relation__c,Contact__r.name,Contact__c from Vehicle_Relationship__c 
                                    where Vehicle_ID__c = :VehicleID AND Id!=:Ids];
        return childrenVelRelation;
       }
       
     /**  
      * @Description fetch all the Retail task records
      * @author  Sneha chail
      * @Date   12/11/2015(mm/dd/yy)  
      * @Param Vehicle Id  
      * @see   ViewHierarchy(Vf Page)
     **/   
   
       public list<Retail_Task__c> tempRetailTask(Id VehicleID){
         List<Retail_Task__c> retailTask=new List<Retail_Task__c>();
         for(Retail_Task__c rst:[select id,Name,Related_Vehicle__c,ContractNumber__c,Status__c,StartDate__c,EndDate__c from Retail_Task__c Where Related_Vehicle__c=:VehicleID])
            {
              retailTask.add(rst);
            }
          return retailTask;
       }
   
     /**  
      * @Description fetch all the Account Link records
      * @author  Sneha chail
      * @Date   12/11/2015(mm/dd/yy)  
      * @Param Vehicle Id and associated vehicle Relationship Id   
      * @see   ViewHierarchy(Vf Page)
     **/ 
        
      public List<Account_Link__c> getAccountRelation(){  
             List<Account_Link__c> lstAccountLink=New List<Account_Link__c>();
             for(Account_Link__c accLink:[select id,name,toRole__c,toRole__r.FirstName,toRole__r.LastName,Role__c,Role2__c from  Account_Link__c Where toRole__r.Id=:acount.Id])        
             {
               lstAccountLink.add(accLink);
             }
            return lstAccountLink;
        }           
   }