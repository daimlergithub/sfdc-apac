public class cSendVehicleInformationtoSPOJP {

public String recordTypeId2 { get; set; }
    public String recordTypeId1 { get; set; }
    Public list<Vehicle_Relationship__c> vehRec {get;set;}
    public string VehId {get; set;}
    public integer RecordSize{get; set;}
    public string Param1 {get; set;}
    public List<Account_Link__c> newRec {get; set;}
    public set<ID> addID {get; set;}
    public set<ID> accID {get; set;}
    public List<Account> newacc {get; set;}
    public Id aeeId {get; set;}
   //public string SelectedType {get; set;}
    
    public cSendVehicleInformationtoSPOJP(ApexPages.StandardController controller) {
    
        VehId=ApexPages.currentPage().getParameters().get('id');
         //SelectedType = '2';
         checkSelectedValue();
         
    }

        public string SelectedType {
            get{if(SelectedType == null) SelectedType = '2'; return SelectedType;}
            set;}

           

        public void checkSelectedValue()
        {
            newRec = New List<Account_Link__c>();
            newacc = New List<Account>();
            addID  = New Set<ID>();
            accID  = New Set<ID>();
            
        if(SelectedType== '2')
                {
                    
     
                     
                    vehRec = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name,Car_Relation__c ,End_Date__c 
                                    FROM Vehicle_Relationship__c
                                     WHERE Vehicle_ID__c =:VehId AND Car_Relation__c = 'Purchaser' AND End_Date__c = null ];
                                     
                                     
                     for( Vehicle_Relationship__c acc : vehRec ){
                     
                        addId.add(acc.Contact__c);
                        
                        system.debug('++++++++++++++++++++'+addId);
                        }
                    newRec = [Select RecordType.Name,fromRole__c, toRole__c ,toRole__r.Recordtype.name ,fromRole__r.Recordtype.name From Account_Link__c where (fromRole__c=:addId OR toRole__c =:addId)  AND RecordType.Name IN('Contact2Contact') ];
                    
                    system.debug('++++++++++++++++++++'+newRec);
                    for( Account_Link__c alc : newRec ){
                        if(alc.toRole__r.Recordtype.name == 'Company'){
                            accID.add(alc.toRole__c) ;
                            system.debug('++++++++++++++++++++'+accID);
                        }
                        else if (alc.fromRole__r.Recordtype.name == 'Company'){
                             accID.add(alc.fromRole__c) ;
                            system.debug('++++++++++++++++++++'+accID);
                        }
                   }
                    
                    system.debug('++++++++++++++++++++'+newRec);
                    newacc = [Select id ,Name ,IsPersonAccount,RecordType.Name From Account where id=: accId AND RecordType.Name IN('Company') ];
                    system.debug('++++++++++++++++++++'+newacc);         
                                
                    RecordSize=vehRec.size();
                                
                  }
                  else if(SelectedType== '1')
                    {
                      vehRec = [SELECT Id,Name,OwnerId,Vehicle_ID__c, Contact__c,Contact__r.Id, Contact__r.Name
                                    FROM Vehicle_Relationship__c
                                     WHERE Vehicle_ID__c =:VehId AND Car_Relation__c = 'Purchaser' ];
                                     
                                     
                     for( Vehicle_Relationship__c acc : vehRec ){
                     
                        addId.add(acc.Contact__c);
                        
                        system.debug('++++++++++++++++++++'+addId);
                        }
                    newRec = [Select fromRole__c, toRole__c ,toRole__r.Recordtype.name ,fromRole__r.Recordtype.name From Account_Link__c where (fromRole__c=:addId OR toRole__c =:addId) AND RecordType.Name IN('Contact2Contact') ];
                    
                    system.debug('++++++++++++++++++++'+newRec);
                       for( Account_Link__c alc : newRec ){
                    if(alc.toRole__r.Recordtype.name == 'Company'){
                        accID.add(alc.toRole__c) ;
                        system.debug('++++++++++++++++++++'+accID);
                    }
                    else if (alc.fromRole__r.Recordtype.name == 'Company'){
                         accID.add(alc.fromRole__c) ;
                    system.debug('++++++++++++++++++++'+accID);
                    }
                   }
                    
                    system.debug('++++++++++++++++++++'+newRec);
                    newacc = [Select id ,Name ,IsPersonAccount, RecordType.Name From Account where id=: accId AND RecordType.Name IN('Company')];
                    system.debug('++++++++++++++++++++'+newacc);         
                                
                    RecordSize=vehRec.size();
                      
                      
                      
                                
                    }
                
                                   
                }
                
                
                public pagereference getSelected(){
                
              
          aeeId =ApexPages.currentPage().getParameters().get('idselected');            
        
           system.debug('+++++++++ aeeId '+ aeeId ); 
     
    
      return null;
      
                
                
                }
                
            public pagereference Navigate()
            {
            
             Pagereference pg = new Pagereference('/apex/SendVehicletoSPOConfirmationJP?id=');
             
              if(SelectedType != null && SelectedType== '2' ){           
              system.debug('selected type 2 ######');
              pg.getParameters().put('accountId',aeeId );
              pg.getParameters().put('vehicleid',VehId);
              pg.setRedirect(true);
              system.debug('+++++++++ aeeId '+ aeeId ); 
            
              }else if(SelectedType != null && SelectedType== '1'){
           
               system.debug('selected type 1 ######');
              //Pagereference pg = new Pagereference('/apex/SendVehicletoSPOConfirmationJP?id=');
             //pg.getParameters().put('accountid',aeeId );
              pg.getParameters().put('vehicleid',VehId);
              pg.setRedirect(true);
             
              
              
              }
              return pg;
               
            }
            
          public pagereference cancel () {
          
          Pagereference pr = new Pagereference('/');
            pr.getParameters().put('id',VehId);
            pr.setRedirect(true);
            return pr ;
          
          
          
          } 
        
}