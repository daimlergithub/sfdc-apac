@istest
public class ManageTasksTest{
 public static Task objTask;
 public static Task testTask;
 public static string oldstatus;
static testmethod void testgetoldstatuses(){
        objTask=new Task();
        //objTask1=new Task();
        testTask = new Task();
        //testTask.Name='test' ;
        insert testTask;
        
        ApexPages.StandardController objSc = new ApexPages.StandardController(testTask);
        ManageTasks KRcontroller= new ManageTasks(objSc);
       
         Campaign a = new Campaign(Name = 'TestCampaign');
        insert a;
        ManageTasks.TaskInfo ti=new ManageTasks.TaskInfo(objTask);
         //ti.add(objTask);
         //ti.add(testTask);
         ManageTasks.TaskInfo ti1=new ManageTasks.TaskInfo(testTask);
        /* for(ManageTasks.TaskInfo accRec : ti){
           accRec.isSelected = true;
       //ti1.add(accRec);
}*/

 
        PageReference pRef = Page.ManageTasks;
        pRef.getParameters().put('id', a.Id);
         KRcontroller.dropDown();
        KRcontroller.getoldstatuses();
        
         KRcontroller.dropDown();
        KRcontroller.getChangingstatus();
        KRcontroller.Changestatus();
         ApexPages.StandardController objSc1 = new ApexPages.StandardController(testTask);
        ManageTasks KRcontroller1= new ManageTasks(objSc1);
        
        KRcontroller1.Changestatus();
        
        
        KRcontroller.getstatusval();
      
}
static testmethod void testdropDown(){
/*objTask=new Task();
 ApexPages.StandardController objSc = new ApexPages.StandardController(objTask);
        ManageTasks KRcontroller= new ManageTasks(objSc);
        Campaign a = new Campaign(Name = 'TestAccount');
        insert a;
        
        PageReference pRef = Page.ManageTasks;
        pRef.getParameters().put('id', a.Id);
    
        KRcontroller.dropDown();*/

}


}