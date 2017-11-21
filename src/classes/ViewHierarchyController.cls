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
     Public Set<Id> setVehicleIds=new Set<Id>();
     Public Map<Id,List<Retail_Task__c>> mapRetailTask=new Map<Id,List<Retail_Task__c>>();  
     Public Map<Id,List<Vehicle_Relationship__c>> mapVehicleRelship=new Map<Id,List<Vehicle_Relationship__c>>();
     Public String[] ignoredAccounts = new String[]{'ＭＡＹＢＡＣＨ販売店車両%','ＭＢＰＣ販売店車両%','ＳＭＡＲＴ販売店車両%','ＳＬＲ販売店車両%'};
     Public Set<Id> setIgnoredAccounts=new Set<Id>();
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
        IgnoredAccountInProd();
        List<Vehicle_Relationship__c> tempParentvelRel = [Select Id,Name,Vehicle_ID__c,Vehicle_ID__r.Name,Start_Date__c,Car_Relation__c,
                                                Vehicle_ID__r.Brand__c,Vehicle_ID__r.Car_Model__c,Vehicle_ID__r.Class__c,Contact__r.name, 
                                                Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c 
                                                from Vehicle_Relationship__c Where Contact__c=:acount.Id AND Vehicle_ID__c!=Null AND (NOT Contact__c IN : setIgnoredAccounts) LIMIT 50000];
        
        for(Vehicle_Relationship__c vr:tempParentvelRel){
            setVehicleIds.add(vr.Vehicle_ID__c);
        }
        tempRetailTask();  
        tempVelRelation();       
        for (Integer i =0; i<tempParentvelRel.size();i++)
          {         
            hierarchy.add(new cNodes(tempParentvelRel[i],mapVehicleRelship.get(tempParentvelRel[i].Vehicle_ID__c),mapRetailTask.get(tempParentvelRel[i].Vehicle_ID__c)));//tempRetailTask(tempParentvelRel[i].Vehicle_ID__c)));
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
       Public void tempVelRelation(){
       List<Vehicle_Relationship__c> childrenVelRelation = [Select Name,Vehicle_ID__r.Name,Vehicle_ID__c,
                                    Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_ID__r.Brand__c,Vehicle_ID__r.Car_Model__c,
                                    Vehicle_ID__r.Class__c,Car_Relation__c,Contact__r.name,Contact__c from Vehicle_Relationship__c Where Vehicle_ID__c IN:setVehicleIds LIMIT 50000];
                      
        for(Vehicle_Relationship__c vr:childrenVelRelation)
            {
             if(mapVehicleRelship!=Null && mapVehicleRelship.containsKey(vr.Vehicle_ID__c)) {             
               List<Vehicle_Relationship__c> vehicleRelationshipList=mapVehicleRelship.get(vr.Vehicle_ID__c); 
               vehicleRelationshipList.add(vr);                            
               mapVehicleRelship.put(vr.Vehicle_ID__c,vehicleRelationshipList);              
             }
              else {
               mapVehicleRelship.put(vr.Vehicle_ID__c,new List<Vehicle_Relationship__c> {vr});
              }
           } 
        
       }
                
      
     /**  
      * @Description fetch all the Retail task records
      * @author  Sneha chail
      * @Date   12/11/2015(mm/dd/yy)  
      * @Param Vehicle Id  
      * @see   ViewHierarchy(Vf Page)
     **/   
      public Void tempRetailTask(){
         for(Retail_Task__c rt :[select id,Name,Related_Vehicle__c,ContractNumber__c,Status__c,StartDate__c,EndDate__c from Retail_Task__c Where Related_Vehicle__c IN:setVehicleIds LIMIT 50000])
            {
             if(mapRetailTask!=Null && mapRetailTask.containsKey(rt.Related_Vehicle__c)) {             
              List<Retail_Task__c> retailTaskList=mapRetailTask.get(rt.Related_Vehicle__c); 
              retailTaskList.add(rt);                            
              mapRetailTask.put(rt.Related_Vehicle__c,retailTaskList);              
             }
              else {
               mapRetailTask.put(rt.Related_Vehicle__c, new List<Retail_Task__c> {rt});
              }
           } 
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
             IgnoredAccountInProd();
             for(Account_Link__c accLink:[select id,name,toRole__c,toRole__r.FirstName,toRole__r.LastName,Role__c,Role2__c from  Account_Link__c Where toRole__r.Id=:acount.Id AND (NOT toRole__r.Id IN : setIgnoredAccounts) Limit 50000])        
             {
               lstAccountLink.add(accLink);
             }
            return lstAccountLink;
        }  
      
      Public void IgnoredAccountInProd(){
            for(Account acc:[select id from Account Where Name Like :ignoredAccounts]){
                setIgnoredAccounts.add(acc.Id);
            }
      }         
   }