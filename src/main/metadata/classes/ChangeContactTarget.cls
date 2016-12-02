public class ChangeContactTarget {

private static final String VehicleExternalLinkRT = Schema.sObjectType.account_link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
   
       Public vehicledataWrpper vehiclewrpper {Set;get;}
      
       public static Id vehicleId;
       public Vehicle__c vehicle {set;get;}
       
    public ChangeContactTarget(ApexPages.StandardController controller) {
     
        
            this.vehicle= (Vehicle__c)controller.getRecord();
            vehiclewrpper = new vehicledataWrpper();
          
             vehicleId= ApexPages.currentPage().getParameters().get('id');
         
          
            vehicle =[SELECT id,Name,UsVIN__c,Brand__c,Class__c,Model__c,(SELECT id,Name,Car_Relation__c,Owner_relation__c,Contact__r.Name, Contact__c FROM Vehicle_Relationships__r),(SELECT id,toRole__c,fromRole__c,Retail_sales_consultant__c,Retail_Sales_Consultant__r.name, recordtypeid,Service_Dealer__c,Service_Dealer__r.name,Selling_Dealer__c,Service_Advisor__r.name, Service_Advisor__c,Selling_Dealer__r.Name FROM Account_Links__r) FROM Vehicle__c Where id =:vehicleId LIMIT 1];
            
            for(Vehicle_relationship__c vr: vehicle .Vehicle_Relationships__r)
            {
            
                if (vr.car_relation__c =='Purchaser' ) 
                {
                    vehiclewrpper.purchaservr= vr;
                }
                else if (vr.car_relation__c=='Sales Contact Target')
                {
                    vehiclewrpper.salescontactvr=vr;
                }
                else if (vr.car_relation__c=='Aftersales Contact Target 1')
                {
                    vehiclewrpper.aftersalescontactvr=vr;
                }
     
            }
     
            for(account_link__c acclink: vehicle .Account_Links__r)
            {
      
                if (acclink.recordtypeid == VehicleExternalLinkRT)
                {
            
                    vehiclewrpper.userdealeracclink = acclink;
                }

                else if (acclink.recordtypeid != VehicleExternalLinkRT)
                {

                    if (acclink.fromrole__c == vehiclewrpper.purchaservr.contact__c)
                    {

                        vehiclewrpper.purchaseracclink = acclink;
                    }
                    else if(acclink.fromrole__c == vehiclewrpper .salescontactvr .contact__c)
                    {
                        vehiclewrpper.salescontactacclink = acclink;

                    }
                    else if(acclink.fromrole__c == vehiclewrpper.aftersalescontactvr .contact__c)
                    {
                        vehiclewrpper.salescontactacclink = acclink;

                    }
                }
            }
    }
    
 
    
    public pagereference updateit()
    {
       
       list<vehicle_relationship__c> vrlist= new list<vehicle_relationship__c>();
       list<account_link__c> acclinklist= new list<account_link__c>();
       
        
            if (vehiclewrpper.purchaservr.id!=null)
            {
                vrlist.add(vehiclewrpper.purchaservr);
        
            }
            
            if (vehiclewrpper.salescontactvr.id!=null)
            {
            System.debug('Sales Contact VR >>>>>>>>'  + vehiclewrpper.salescontactvr.contact__c);
             System.debug('Sales Contact VR >>>>>>>>'  + vehiclewrpper.salescontactvr);
                vrlist.add(vehiclewrpper.salescontactvr);
            }
            if (vehiclewrpper.aftersalescontactvr.id!=null){
            vrlist.add(vehiclewrpper.aftersalescontactvr);
        
        
            }
            update vrlist;
            if(vehiclewrpper.userdealeracclink.id!=null)
            {
            acclinklist.add(vehiclewrpper.userdealeracclink);
            }
            if(vehiclewrpper.purchaseracclink.id!=null){
            acclinklist.add(vehiclewrpper.purchaseracclink);
            }
        
            if(vehiclewrpper.salescontactacclink.id!=null){
            acclinklist.add(vehiclewrpper.salescontactacclink);
            }
        
            if(vehiclewrpper.aftersalescontactacclink.id!=null){
            acclinklist.add(vehiclewrpper.aftersalescontactacclink);
            }
        
        update acclinklist;
        String str = ApexPages.currentPage().getParameters().get('id');
        PageReference pageref = new pageReference ('/'+str);
       //PageReference pageref=  ApexPages.currentPage();
        //pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
    //pageref.setRedirect(true);

        return pageref;
    }
    
    public class vehicledataWrpper
    {
       public Vehicle_relationship__c purchaservr{get;set;}
       public Vehicle_relationship__c salescontactvr{get;set;}
       public Vehicle_relationship__c aftersalescontactvr{get;set;}
       public Account_link__c userdealeracclink{get;set;}
       public Account_link__c purchaseracclink{get;set;}
       public Account_link__c salescontactacclink{get;set;}
       public Account_link__c aftersalescontactacclink{get;set;}
       
       public vehicledataWrpper(){
       
       purchaservr= new Vehicle_relationship__c();
       salescontactvr= new Vehicle_relationship__c();
       aftersalescontactvr= new Vehicle_relationship__c();
       userdealeracclink = new Account_link__c();
       purchaseracclink= new Account_link__c();
       salescontactacclink= new Account_link__c();
       aftersalescontactacclink= new Account_link__c();
       
       }
        
    }
    
}