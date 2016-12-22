public class RelatedDealerLease {

 

   public List<Retail_Task__c>   rettsk{set;get;} 
 public List<Retail_Task__c> retailtask=[select id,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c ];
    public user currentuser=[select id,name,Dealer_GC_Code__c from user where id=:userinfo.getUserId()];
       Id profileId=userinfo.getProfileId();
      Profile currentuserprofile=[Select Id,Name from Profile where Id=:profileId];
       
    public List<profile> japanprofiles=[select id,name from profile where name like 'Japan%'];
    
    public RelatedDealerLease(ApexPages.StandardController controller){
    
     
        for(profile p:japanprofiles){
        if(currentuserprofile.name==p.name){
            
           
           rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c  ]; 
        }
        }
        for(Retail_Task__c rt:retailtask){
        if(currentuser.Dealer_GC_Code__c==rt.Related_Dealer__r.Dealer_GC_Code__c)
        {
           
          rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c ];
 
       
              
             }
            else if(currentuser.Dealer_GC_Code__c==rt.Supporting_Dealer__r.Dealer_GC_Code__c )
            {
                         
       rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c ];
                } 
            
            
            
        }
        
        
    }
}