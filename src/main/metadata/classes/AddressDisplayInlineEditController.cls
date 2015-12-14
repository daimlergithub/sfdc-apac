/**   
    Purpose:  Innline controller To add, edit and delete related address to an account   
    created by: Srinivas 11/3/2015
    modified by: Sudhir Kumar Acharya 11/30/2015
   
*/
public class AddressDisplayInlineEditController { 

   public List<Address__c> adds {get; set;}
   public Address__c addressobj {get; set;}
   public Boolean ShowpageBlockFlag {get;set;}
   private ApexPages.StandardController stdController;   
   public string addressId {get;set;}
   public string editaddressId {get;set;}  
   public String aid;

    
   public AddressDisplayInlineEditController(ApexPages.StandardController stdController){
           this.stdController = stdController;     
           aid = ApexPages.currentPage().getParameters().get('id');
           system.debug('######'+ aid); 
       
             if(ApexPages.currentPage().getParameters().get('id')!=Null){
                
                adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c, TitleOfHonor__c,Company_Name_Native__c from Address__c where Customer__c =: aid ];        
                system.debug('@Account Information :' +adds);
             }             
     
         /*Intitializing address object*/
         addressobj = new Address__c();
   } 
 
 
    /**    
     * @Description : Cancel functionality 
     * @author      : Srinivas
     * @Date        : 11/3/2015
     * @return      : null
      
    **/  
    public void cancelEdit() {              
        ShowpageBlockFlag = null;
        if(addressobj!=Null)
        {
             addressobj.clear();
             editaddressId=Null;
         }             
    }
    
   
    /**    
     * @Description : saves edited records
     * @author      : Srinivas
     * @Date        : 11/3/2015    
      
    **/  
   public void saveEditedRecords(){
       system.debug('@Changed Address Records :' +adds);
           try{
            update adds;
           }catch (DmlException e) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));
           }
   }
   
   
    /**    
     * @Description : to load updated data after deletion of address
     * @author      : Srinivas
     * @Date        : 11/3/2015     
    **/  
   @TestVisible private void loadData() {
           system.debug('@Loading Addresses...' +aid);
           adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                  Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c  from Address__c where Customer__c =: aid];
   }
   
   
   
    /**    
     * @Description : deletes the address record 
     * @author      : Srinivas
     * @Date        : 11/3/2015    
      
    **/  
   
   public void delAccountAddress(){
       
            system.debug('@addressId :' +addressId);
                    
        // if for any reason we are missing the reference 
          if (addressId == null) {
             return;
          }
      
          // find the address record within the collection
          Address__c tobeDeleted = null;
          for(Address__c a : adds)
           if (a.Id == addressId){
              tobeDeleted = a;
              break;
           }      
      
      
          //if address record found delete it
          if(tobeDeleted != null) {
             system.debug('@Delete DML' +tobeDeleted.id);
             try{
                Delete tobeDeleted;
             }catch (DmlException e) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));
             }
          }
          //refresh the data
          loadData();
      }
      
   public void addEditOptions()
   {    
       Account acc=[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];
       adds= [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                  Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c  from Address__c where Customer__c=:acc.id];
       if(adds.size()>=5)
       {
           ShowpageBlockFlag=false;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,system.label.Account_cannot_have_more_than_5_Address));
       }
       else 
       ShowpageBlockFlag = true;
   }
   
 
 /**    
     * @Description : Edit the address record  
     * @author      : Sudhir
     * @Date        : 11/12/2015    
      
    **/  
    public void EditOptions(){
       Address__c editadds;
       if (editaddressId != null) 
       {
       editadds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
                  Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c,Company_Name_Native__c  from Address__c where Id =: editaddressId];
       // if for any reason we are missing the reference 
          
       }
      
          // find the address record within the collection
          If(editadds!=null)
          {                     
              addressobj.Address_Type__c = editadds.Address_Type__c;
              addressobj.ZipCode__c = editadds.ZipCode__c;
              addressobj.Province__c = editadds.Province__c;
              addressobj.City__c = editadds.City__c;
              addressobj.District__c =editadds.District__c;
              addressobj.Block__c =editadds.Block__c;
              addressobj.Address_Line_1__c =editadds.Address_Line_1__c;
              addressobj.Address_Line_2__c =editadds.Address_Line_2__c;
              addressobj.Company_Name__c =editadds.Company_Name__c;
              addressobj.Company_Name_Native__c = editadds.Company_Name_Native__c;
              addressobj.TitleOfHonor__c =editadds.TitleOfHonor__c;
              addressobj.Status__c =editadds.Status__c;
              addressobj.Preferred__c = editadds.Preferred__c;
               
          }      
        ShowpageBlockFlag = true;
                
   }
    
 /**    
     * @Description : creates new address record  
     * @author      : Srinivas
     * @Date        : 11/3/2015    
      
    **/  
  
  public void saveAddress(){
    
          system.debug('addressobj>>>>>'+addressobj);
          system.debug('@Account Id :' +ApexPages.currentPage().getParameters().get('id'));
  
        if(addressobj != null ){ 
        
            Account acc=[select id,name from Account where id=:ApexPages.currentPage().getParameters().get('id')];
            system.debug('ACCid>>>>>'+acc); 
            if (editaddressId ==null)
            {
                addressobj.Customer__c = acc.id;
            
            try {
                    insert addressobj;                    
                }
            catch (DmlException e) 
                {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));
                }
            }
           else if(editaddressId !=null)
            {
            addressobj.id = editaddressId;
            
            try {
                    update addressobj;  
                }
            catch (DmlException e) 
                {
                     ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getDMLMessage(0)));
                }
            }    
        }               
   } 
}