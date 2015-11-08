/**   
    Purpose:  Innline controller To add, edit and delete related address to an account   
    created by: Srinivas 11/3/2015
    modified by: Sriram Kalluri 11/4/2015
   
*/
public class AddressDisplayInlineEditController { 

   public List<Address__c> adds {get; set;}
   public Address__c addressobj {get; set;}
   public Boolean ShowpageBlockFlag {get;set;}
   private ApexPages.StandardController stdController;   
   public string addressId {get;set;}   
   public String aid; 
   
   
  
   public AddressDisplayInlineEditController(ApexPages.StandardController stdController){
	       this.stdController = stdController;     
	       aid = ApexPages.currentPage().getParameters().get('id');
	       system.debug('######'+ aid);
       
		     if(ApexPages.currentPage().getParameters().get('id')!=Null){
		     	
		        adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
		        Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c, TitleOfHonor__c from Address__c where Customer__c =: aid ];        
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
    public PageReference cancelEdit() {
        ShowpageBlockFlag = null;
        return null;        
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
	       }catch (Exception e) {
	        ApexPages.addMessages(e);
	       }
   }
   
   
    /**    
     * @Description : to load updated data after deletion of address
     * @author      : Srinivas
     * @Date        : 11/3/2015     
    **/	 
   private void loadData() {
	       system.debug('@Loading Addresses...');
	       adds = [Select id,Name, Address_Type__c, Status__c , ZipCode__c,Province__c,Preferred__c,Company_Name__c,
	              Address_Line_2__c ,Address_Line_1__c,District__c,City__c, Block__c,TitleOfHonor__c  from Address__c where Customer__c =: aid];
   }
   
   
   
    /**    
     * @Description : deletes the address record 
     * @author      : Srinivas
     * @Date        : 11/3/2015    
      
    **/	 
   
   public void delAccountAddress(){
	        system.debug('@Entered Delete method...');
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
	         }catch (Exception e) {
	       		 ApexPages.addMessages(e);
	         }
	         system.debug('@Delete Address...');
	      }
	      //refresh the data
	      loadData();
	  }
      
   public void addEditOptions(){
   	
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
	        addressobj.Customer__c = acc.id;
          
        try{
        	upsert addressobj;  
        }catch (Exception e) {
	        ApexPages.addMessages(e);
	       }
	       
      }
  }
  
 
  
}