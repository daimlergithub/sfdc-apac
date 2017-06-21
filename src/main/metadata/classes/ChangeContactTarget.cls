public class ChangeContactTarget {

private static final String VehicleExternalLinkRT = Schema.sObjectType.account_link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
private static final String RetailPerson = Schema.sObjectType.account_link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
private static final String RetailCompany = Schema.sObjectType.account_link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
       Public vehicledataWrpper vehiclewrpper {Set;get;}
      
       public static Id vehicleId;
       public Vehicle__c vehicle {set;get;}       
       public string salescontacttargetId = '';
       public string purchaseContactId = '';
       public string aftersalescontacttargetId = '';
       public string salescontacttargetrecordId = '';
       public string aftersalescontacttargetrecordId = '';
       public list<vehicle_relationship__c> oldsalesconractVRlist = new list<vehicle_relationship__c>();
       public list<vehicle_relationship__c> oldaftersalescontractVRlist = new list<vehicle_relationship__c>();
       public String salesOwnerRelation = '';
       public String SalesConsultant = '';       
       public String afterOwnerRelation = '';
       public String afterSalesConsultant = '';
    public ChangeContactTarget(ApexPages.StandardController controller) {
            this.vehicle= (Vehicle__c)controller.getRecord();
            vehiclewrpper = new vehicledataWrpper();          
             vehicleId= ApexPages.currentPage().getParameters().get('id');
            vehicle =[SELECT id,Name,UsVIN__c,Brand__c,Class__c,Model__c,(SELECT id,Name,Car_Relation__c,Owner_relation__c,Contact__r.Name,End_Date__c,Contact__c FROM Vehicle_Relationships__r) FROM Vehicle__c Where id =:vehicleId LIMIT 1];
            for(Vehicle_relationship__c vr: vehicle .Vehicle_Relationships__r)
            {
                 if(vr.End_Date__c == null){
                if (vr.car_relation__c =='Purchaser' ) 
                {
                    vehiclewrpper.purchaservr= vr;
                    purchaseContactId = vr.Contact__c;
                }
                else if (vr.car_relation__c=='Sales Contact Target')
                {    
                    salescontacttargetId = vr.Contact__c;
                    
                    vehiclewrpper.salescontactvr=vr;
                    oldsalesconractVRlist.add(vehiclewrpper.salescontactvr);
                    salescontacttargetrecordId = vr.id;
                    system.debug('Loding #### oldsalesconractVRlist'+oldsalesconractVRlist);
                    system.debug('Loding 222222 #### oldsalesconVR'+vr);
                    //contactId = vr.Contact__c;
                    salesOwnerRelation = vr.Owner_Relation__c;
                    //SalesConsultant = vr.Retail_Sales_Consultant__c ;
                }
                if (vr.car_relation__c=='Aftersales Contact Target 1')
                {
                    aftersalescontacttargetrecordId = vr.id;
                    aftersalescontacttargetId = vr.Contact__c;
                    afterOwnerRelation = vr.Owner_Relation__c;
                    vehiclewrpper.aftersalescontactvr=vr;
                    oldaftersalescontractVRlist.add(vehiclewrpper.aftersalescontactvr);
                    //afterSalesConsultant = vr.Retail_Sales_Consultant__c;
                }
            }
            }
            if(salescontacttargetId != '' || aftersalescontacttargetId != '' || purchaseContactId != ''){
             List<Account_Link__c> accountlink = [select id,toRole__c,fromrole__c,Retail_Sales_Consultant__c,Retail_Sales_Consultant__r.Name,Selling_Dealer__c,Service_Dealer__c,Service_Advisor__c,Selling_Dealer__r.Name,Service_Dealer__r.Name,Service_Advisor__r.Name,Recordtype.DeveloperName from Account_Link__c WHERE (toRole__c =  :salescontacttargetId OR toRole__c = :aftersalescontacttargetId OR toRole__c = :purchaseContactId  OR Vehicle__c = : ApexPages.currentPage().getParameters().get('id')) AND (RecordTypeID= :RetailPerson OR RecordTypeID= :RetailCompany OR RecordTypeId = :VehicleExternalLinkRT)];
            //for(account_link__c acclink: vehicle .Account_Links__r)
            for(account_link__c acclink: accountlink )
            {   
                if (acclink.recordtypeid == VehicleExternalLinkRT)
                {
                    vehiclewrpper.userdealeracclink = acclink;  
                }

                else if (acclink.recordtypeid != VehicleExternalLinkRT)
                {
                    if (acclink.torole__c == vehiclewrpper.purchaservr.contact__c)
                    {
                        vehiclewrpper.purchaseracclink = acclink;   
                    }
                    else if(acclink.torole__c == vehiclewrpper .salescontactvr .contact__c)
                    {
                        vehiclewrpper.salescontactacclink = acclink;
                    }
                    else if(acclink.torole__c == vehiclewrpper.aftersalescontactvr .contact__c)
                    {
                        vehiclewrpper.aftersalescontactacclink= acclink;
                    }
                }
            }
            }
    }
    public PageReference updateit()
    {
        boolean issalescontactchanged = false;
        boolean isaftersalescontactchnged = false;
        set<String> VRid = new set<String>();
       list<vehicle_relationship__c> vrlist= new list<vehicle_relationship__c>();
       list<account_link__c> acclinklist= new list<account_link__c>();
       list<vehicle_relationship__c> newsalescontractvrlist= new list<vehicle_relationship__c>();
       list<vehicle_relationship__c> newaftersalescontractvrlist= new list<vehicle_relationship__c>();
            if (vehiclewrpper.purchaservr.id!=null)
            {
                //vrlist.add(vehiclewrpper.purchaservr);
                //VRid.add(vehiclewrpper.purchaservr.id);
            }
            
            if (vehiclewrpper.salescontactvr.id!=null)
            {
            System.debug('Sales Contact VR >>>>>>>>'  + vehiclewrpper.salescontactvr.contact__c);
             System.debug('Sales Contact VR >>>>>>>>'  + vehiclewrpper.salescontactvr);
                if(vehiclewrpper.salescontactvr.contact__c != salescontacttargetId ){
                    vehiclewrpper.salescontactvr.Start_Date__c = Date.today();
                    //vehiclewrpper.salescontactvr.id = null;
                    vrlist.add(vehiclewrpper.salescontactvr);
                    issalescontactchanged = true;
                    //system.debug('Salescontracttarget Record---->'+newsalescontractvrlist);
                    //system.debug('Salescontracttarget Record---->'+oldsalesconractVRlist);
                    //newsalescontractvrlist=oldsalesconractVRlist.deepclone(true,true,true);
                }
                /*if(vehiclewrpper.salescontactvr.contact__c != salescontacttargetId ){
                    VRid.add(vehiclewrpper.salescontactvr.id);  
                }*/
            }
            if (vehiclewrpper.aftersalescontactvr.id!=null){
            if(vehiclewrpper.aftersalescontactvr.contact__c != aftersalescontacttargetId ){
                vehiclewrpper.aftersalescontactvr.Start_Date__c = date.today();
                //vehiclewrpper.aftersalescontactvr.id = null;
                vrlist.add(vehiclewrpper.aftersalescontactvr);
                isaftersalescontactchnged = true;
                //newaftersalescontractvrlist = oldaftersalescontractVRlist.deepclone(true,true,true);
            }
            /*if(vehiclewrpper.aftersalescontactvr != aftersalescontacttargetId ){
                VRid.add(vehiclewrpper.aftersalescontactvr.id);    
            }*/
        
            }
            List<vehicle_relationship__c> vrlisttoUpdate = new List<vehicle_relationship__c>(); 
            if(!vrlist.isEmpty()){
                list<Vehicle_Relationship__c> VRlst = vrlist.deepClone(false,false,false);
                insert VRlst;
                if(issalescontactchanged){
                    for(vehicle_relationship__c salesvr: oldsalesconractVRlist){
                        //aftersalesvr
                        system.debug('Update method oldsalesconractVRlist'+oldsalesconractVRlist);
                        //salesvr.id = salescontacttargetrecordId;
                        salesvr.Contact__c=salescontacttargetId;
                        salesvr.Owner_Relation__c = salesOwnerRelation;
                        //salesvr.Retail_Sales_Consultant__c = SalesConsultant;
                         salesvr.End_Date__c = date.today();
                         salesvr.End_Reason__c = 'Updated EndDate';
                         salesvr.Start_Date__c = null; 
                         vrlisttoUpdate.add(salesvr); 
                    }
                }
                if(isaftersalescontactchnged){
                    for(vehicle_relationship__c aftersalesvr: oldaftersalescontractVRlist ){ 
                        //aftersalesvr.id = aftersalescontacttargetrecordId;
                        aftersalesvr.Contact__c = aftersalescontacttargetId;
                        aftersalesvr.Owner_Relation__c = afterOwnerRelation;
                        //aftersalesvr.Retail_Sales_Consultant__c = afterSalesConsultant;                     
                        aftersalesvr.End_Date__c = date.today(); 
                        aftersalesvr.End_Reason__c = 'Updated EndDate';
                        aftersalesvr.Start_Date__c = null;
                        vrlisttoUpdate.add(aftersalesvr);
                             
                    }   
                }
                update vrlisttoUpdate; 
                   
            }
            //update vrlist;
            
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
         LeadUtil.isAcctrigger = False;
        update acclinklist;
        
        /*if(!VRid.isEmpty()){
            CreateVehicleRecord(VRid);
        }*/
        String str = ApexPages.currentPage().getParameters().get('id');
        PageReference pageref = new pageReference ('/'+str);
       //PageReference pageref=  ApexPages.currentPage();
        //pageref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
    pageref.setRedirect(true);

        return pageref;
    }
    
    /*
        Description : Added new Method to Create new Vehicle Relationship records.
        Author : Kiran
        JIRA : SFDCJP-1709
    */
   /* public void CreateVehicleRecord(set<String> VehicleRelationID){
        User usr = [Select id, LanguageLocaleKey,Market__c,ContactId,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
        List<Vehicle_Relationship__c> VRUpdate = new List<Vehicle_Relationship__c>();
        if(usr.ContactId != null){
        for(Vehicle_Relationship__c VR : [select Id, Name,Vehicle_ID__c,End_Date__c from Vehicle_Relationship__c WHERE Vehicle_ID__c =: apexpages.currentpage().getparameters().get('id') AND End_Date__c = null]){
            VR.End_Date__c = date.today(); 
            VR.End_Reason__c = 'Updated EndDate';
            VRUpdate.add(VR);
      
        } 
        update VRUpdate; 
        String selects = '';
        list<string> selectFields = new list<string>();
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get('Vehicle_Relationship__c'.toLowerCase()).getDescribe().Fields.getMap();   
        system.debug('$$$$$$$$$$$$'+fMap);
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                //if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                //}
            }
        }
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
                
            }
            system.debug('%%%%%%%%%'+selects);
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
            system.debug('%%%%%333333333%%%%'+selects);
             
        }
        string abc = 'Vehicle_Relationship__c';
        String extension = ':VehicleRelationID LIMIT 1';
        String Soql =  'SELECT ' + selects + ' FROM ' + abc + ' WHERE ' + 'ID IN'+extension  ;
        Vehicle_Relationship__c  l = Database.query(soql);
        Vehicle_Relationship__c  l2 = l.clone(false, true);
        l2.Start_Date__c = Date.today();
        l2.End_Date__c = null;
        insert l2;
     }   
    }
    */
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