public class Duplicatecheck_controller {
public Id id;
public Account acc;
public List<DuplicateWrapper> listwrap{get;set;}
    public Duplicatecheck_controller(ApexPages.StandardController controller) {
    id = ApexPages.currentpage().getParameters().get('id');
    listwrap = new List<DuplicateWrapper>();
    if(id!=null){
        acc = [select Id,FirstName,LastName,LastName_Native_1__c,Name ,FirstName_Native_1__c,PersonBirthdate,Loyalty_Card_No__c,Individual_Home_Phone__c,Home_Phone_2__c,Work_Phone__c,Phone,Mobile__c,Mobile2__c ,Email__c,Email2__c,Email3__c ,Salutation from account where id =:id ];
    crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
   DuplicateWrapper dup =  new DuplicateWrapper ();
    dup.acc=acc;
    dup.duplicatecheck=false;
    listwrap.add(dup);
    try{
    system.debug('@@@@::::account:::'+acc);
    if(acc.lastname!=null)
    response =  UtilWebservice.validateCustomerDetails(acc);
    system.debug('@@@Response@@@'+response);
   if(response.CustomerIdentificationResponseMessage!=null)
   {
       for(integer i=0;i<response.CustomerIdentificationResponseMessage.size();i++)
       {
       
       DuplicateWrapper dup1 =  new DuplicateWrapper ();
   
    Account dupAcc =new Account(id=response.CustomerIdentificationResponseMessage[i].Customer.id);
    system.debug('@@@@dupAcc :::'+dupAcc );
    dupAcc.lastname=response.CustomerIdentificationResponseMessage[i].Customer.Lastname;
     dup1.acc=dupAcc;
    dup1.duplicatecheck=True;
    system.debug('dup1:::'+dup1);
    listwrap.add(dup1);
       
       system.debug('listwrap:::'+listwrap);
       }
     
   
   }
    }
    catch(Exception e){
    system.debug(e.getMessage());
    
    }
    
    
    }

    }
    
 Public class DuplicateWrapper{
 public Account acc{get;set;}
 public boolean duplicatecheck{get;set;}
 
     public DuplicateWrapper()
     {
     acc=new Account();
     duplicatecheck=false;
     }
     
 
 } 

}