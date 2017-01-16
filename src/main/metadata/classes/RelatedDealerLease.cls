public class RelatedDealerLease {
    public List<Retail_Task__c> rettsk{set;get;}
 id recid=ApexPages.CurrentPage().getparameters().get('id');
   public Retail_Task__c retailtask=[select id,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c where id=:recid ];
   public string dealercode=retailtask.Related_Dealer__r.Dealer_GC_Code__c;
   public string supportdealercode=retailtask.Supporting_Dealer__r.Dealer_GC_Code__c;
   public List<Retail_Task__c> lstrettsk=[select id,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode ]; 
    public user currentuser=[select id,name,Dealer_GC_Code__c from user where id=:userinfo.getUserId() AND Market__c=:'JP'];
       Id profileId=userinfo.getProfileId();
      Profile currentuserprofile=[Select Id,Name from Profile where Id=:profileId];
       
    public List<profile> japanprofiles=[select id,UserLicense.Name,name from profile where UserLicense.Name=:'Partner Community'];
    
    public RelatedDealerLease(ApexPages.StandardController controller){
    
     
       Map<string,string> profilemap=new Map<string,string>();
        for(profile p:japanprofiles){
            profilemap.put(p.name,p.name);
        }
            
        if(profilemap.containsKey(currentuserprofile.name)){
            
           
           rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode]; 
        }
        
    Map<string ,string> profilestrmap=new Map<string,string>();
    for(Retail_Task__c r:lstrettsk){
    if(r.Related_Dealer__r.Dealer_GC_Code__c!=null )
       profilestrmap.put(r.Related_Dealer__r.Dealer_GC_Code__c,r.Related_Dealer__r.Dealer_GC_Code__c); 
        
    }
        if(profilestrmap.containsKey(currentuser.Dealer_GC_Code__c))
        {
           
          rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode];
 
       
              
             }
         Map<string ,string> profstrmap=new Map<string,string>();
    for(Retail_Task__c r:lstrettsk){
    if(r.Supporting_Dealer__r.Dealer_GC_Code__c!=null )
    profstrmap.put(r.Supporting_Dealer__r.Dealer_GC_Code__c,r.Supporting_Dealer__r.Dealer_GC_Code__c); 
        
    }   
    
    
    if(profstrmap.containsKey(currentuser.Dealer_GC_Code__c))
            {
                         
       rettsk=[select id,Latest_Sales_Person__c,Contractor_Name__c,Contractor_Name_Native__c,Contractor_ZipCode1__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode AND Supporting_Dealer__r.Dealer_GC_Code__c=:supportdealercode];
               
            } 
            
            
            
        }

        
        
    
}