public class createRetailCopy {
 
public Account account{get;set;}
public Account abc {get;set;}
public Id addId{get;set;}
//public string accId{get;set;}
public List<Address__c> sample {set;get;}
public List<Address__c> ress   {set;get;}
public List<Address__c> sample1{set;get;}
public List<Address__c> din  {set;get;}
public List<Account> accc {set;get;}

 
    public createRetailCopy(ApexPages.StandardController controller) {
    
                  account = (Account)controller.getRecord();

   
    sample = [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where  Customer__c =: account.Id];
     
      system.debug('+++++++++'+sample );
      
    
     
   
    }
   
        public pageReference  getSelected (){ 
    
           addId =ApexPages.currentPage().getParameters().get('idselected');  
           
           system.debug('+++++++++'+ addId );
     
     
    
      return null;
      
    }
         
           
       public void  getAccount (){ 
    
          
     accc =[Select id,name,( Select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c from Addresses__r LIMIT 1) from Account where id =:account.Company__c];
     
          system.debug('+++++++++++'+accc);
     
    
      
      
    }
     public void Save()
    {
    
         List<Address__c> button    = New List<Address__c>();
        
        
        
        sample1  = [select id,Name,Customer__c,Address_Type__c,ZipCode__c,Province__c ,Province_Native__c ,City_Native__c,District__c,District_Native__c ,Block__c ,Block_Native__c ,Address_Line_1__c,Address_Line_1_Native__c , Address_Line_2__c ,Address_Line_2_Native__c  ,Company_Name__c ,Company_Name_Native__c ,TitleOfHonor__c , Status__c ,Temp_ZipCode__c ,Temp_Address__c  FROM  Address__c where id =:addId  Limit 1];
        
        system.debug('+++++++++++++++++++++'+sample1);
        //accc = New list<account>();
        for(Account abc : accc)
        {
        
        
       for(Address__c ress : abc.Addresses__r)
       {
       
          for(Address__c cdf : sample1   ){
        if(ress.Address_Type__c != cdf.Address_Type__c){
        ress.Address_Type__c = cdf.Address_Type__c ;
        } else{
           
        }
        ress.ZipCode__c = cdf.ZipCode__c ;  
      ress.Province__c=cdf.Province__c;
        ress.Province_Native__c=cdf.Province_Native__c;
        ress.City_Native__c=cdf.City_Native__c;
        ress.District__c=cdf.District__c;
        ress.District_Native__c=cdf.District_Native__c;
        ress.Block__c=cdf.Block__c;
        ress.Block_Native__c=cdf.Block_Native__c;
        ress.Address_Line_1__c=cdf.Address_Line_1__c;
        ress.Address_Line_1_Native__c=cdf.Address_Line_1_Native__c;
        ress.Address_Line_2__c=cdf.Address_Line_2__c;
        ress.Address_Line_2_Native__c=cdf.Address_Line_2_Native__c;
        ress.Company_Name__c=cdf.Company_Name__c;
        ress.Company_Name_Native__c=cdf.Company_Name_Native__c;
        ress.TitleOfHonor__c =cdf.TitleOfHonor__c;
        ress.Status__c =cdf.Status__c;
        ress.Temp_ZipCode__c =cdf.Temp_ZipCode__c;
        ress.Temp_Address__c =cdf.Temp_Address__c;
        ress.Customer__c = abc.Id;
        button.add(ress);
       } 
       
       update button;
       
     }
       
      
       list<Account> accList = [SELECT Primary_Address_Reference__c,(select id from Addresses__r ORDER BY LastModifiedDate desc limit 1 )FROM Account where Id =:account.Company__c]; 
       
       for(Account aont : accList){
       
           for(Address__c aress : aont.Addresses__r){
           
           
           aont.Primary_Address_Reference__c = aress.id;
           
           
           
           }
           
           update aont;
           }
     
     /*Database.SaveResult[] srList = Database.Update(button, false) ;
      integer i=0;
      system.debug('+++++++++++++++++++'+button);
     system.debug('+++++++++++++++++++++'+srList);
     for(Database.SaveResult sr :srList ){
       
       accc[i].Primary_Address_Reference__c = sr.getId();
       
       system.debug('+++++++++++++'+sr.getId());
      i++;
    
    integer k=0;
for(Account acco : accc){

acco.Primary_Address_Reference__c=accc[k].Primary_Address_Reference__c;

k++; */

}
    }
    
    
    public PageReference Cancel()
        {
                PageReference page = new PageReference('https://daimlerasia--asiadev9--c.cs5.visual.force.com/apex/RetailCopyButton');
                page.setRedirect(true);
                return page;
           }
 
}