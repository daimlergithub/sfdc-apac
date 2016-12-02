public class cSendVehicleInformationtoSPOJP {

    public String recordTypeId2 { get; set; }
    public String recordTypeId1 { get; set; }
    Public list<Vehicle_Relationship__c> vehRec {get;set;}
    public string VehId {get; set;}
    public integer RecordSize{get; set;}
    public string Param1 {get; set;}

    public cSendVehicleInformationtoSPOJP(ApexPages.StandardController controller) {
    
        VehId=ApexPages.currentPage().getParameters().get('id');

         checkSelectedValue();

    }

        /*public cSendVehicleInformationtoSPOJP(){

            VehId=ApexPages.currentPage().getParameters().get('id');

            checkSelectedValue();

        }*/
        
           public string SelectedType {
            get{if(SelectedType == null) SelectedType = '2'; return SelectedType;}
            set;}

        public void checkSelectedValue()
        {
        
        
        if(SelectedType== '2')
                {
                    recordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
                    
                    vehRec = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name
                                    FROM Vehicle_Relationship__c
                                     WHERE Vehicle_ID__c =:VehId AND
                                        Contact__r.RecordTypeId =:recordTypeId2];
                                
                    RecordSize=vehRec.size();
                                
                  }
                  else if(SelectedType== '1')
                    {
                        recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                        
                        vehRec = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name
                                    FROM Vehicle_Relationship__c
                                     WHERE Vehicle_ID__c =:VehId AND
                                        Contact__r.RecordTypeId =:recordTypeId1];
                       RecordSize=vehRec.size();
                                
                    }
                   
                                   
                }
                
            public pagereference Navigate()
            {
              //system.debug('This is param value '+ Param1);
             
             /*user usr = [select id,Dealer_ND_Code__c from user where id =:userinfo.getuserid() ];
              list<Vehicle_Relationship__c> VehRelUpdated = new list<Vehicle_Relationship__c>();
              list<Vehicle_Relationship__c> VehRellist = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name,MD__c,Contractor__c,New_Used__c,Warranty_Apply_Status__c,UsedWarranty_Apply_Status__c,UsedWarranty_Apply_Date__c,UsedWarranty_Apply_User__c FROM Vehicle_Relationship__c where Vehicle_ID__c =:Param1];
              system.debug('&&'+VehRellist );
              if(!VehRellist.isEmpty() && VehRellist != null)
              for(Vehicle_Relationship__c VehRel: VehRellist ){
                  
                  If(VehRel.Contact__c!= null)
             VehRel.Contractor__c = VehRel.Contact__c;
         if(VehRel.New_Used__c == 'New'){
         VehRel.UsedWarranty_Apply_NDCode__c = usr.Dealer_ND_Code__c;
         VehRel.Warranty_Apply_NDCode__c = usr.Dealer_ND_Code__c;
         VehRel.Warranty_Apply_Status__c = 'To be Sent';
         VehRel.UsedWarranty_Apply_Date__c = system.Today();
         VehRel.UsedWarranty_Apply_User__c = usr.Id;
         VehRel.Warranty_Apply_Date__c = system.Today();
         VehRel.Warranty_Apply_User__c = usr.Id;
         }
         if(VehRel.New_Used__c == 'Used'){
             VehRel.UsedWarranty_Apply_NDCode__c = usr.Dealer_ND_Code__c;
             VehRel.Warranty_Apply_Status__c = 'To be Sent';
             VehRel.UsedWarranty_Apply_Status__c = 'To be Sent';
             VehRel.UsedWarranty_Apply_Date__c = system.Today();
             VehRel.UsedWarranty_Apply_User__c = usr.Id;
             
         }
              VehRelUpdated.add(VehRel);
              }
              if(!VehRelUpdated.isEmpty() && VehRelUpdated != null)
              update VehRelUpdated;
              system.debug('**'+VehRelUpdated);*/
              Pagereference pg = new Pagereference('/apex/SendVehicletoSPOConfirmationJP?id='+Param1);
              return pg;
            }
        
}