global class LeadUpdateToLostJPBatch implements Database.batchable<sObject>{
global Date daysBack30 = System.today().addDays(-30);
global Date daysBack60 = System.today().addDays(-60);
global Date daysBack90 = System.today().addDays(-90);
 /*   global Date daysBack90 = System.today().addDays(-10);
    global Date daysBack60 = System.today().addDays(-6);
    global Date daysBack30 = System.today().addDays(-30);*/

// global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c from Lead__c';
    global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c from Lead__c  where MD__c=\'JP\' AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND Assigned_Dealer__r.Data_Source__c =\'Dealer\' AND ((Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND ((RecordType.Name =\'Sales Leads\' AND (Lead_Latest_Phase__c = \'Quotation\' OR Lead_Latest_Phase__c = \'CA Submission\' OR Lead_Latest_Phase__c = \'Finance Quotation\') AND LastModifiedDate  <= :daysBack90 ) OR  (RecordType.Name =\'Sales Leads\' AND Lead_Latest_Phase__c =\'Order Placed\' AND LastModifiedDate  <= :daysBack60 ) OR  (RecordType.Name =\'Aftersales Leads\' AND Appointment_DateTime__c != null AND Appointment_DateTime__c <= :daysBack30)) )';
 
  /*  //Scenario 1: Days Back 90 ,Quotation/CA Submission/Finance Quotation
    //    global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c from Lead__c  where Market__c=\'JP\' AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND (Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND (RecordType.Name =\'Sales Leads\' AND (Lead_Latest_Phase__c = \'Quotation\' OR Lead_Latest_Phase__c = \'CA Submission\' OR Lead_Latest_Phase__c = \'Finance Quotation\') AND LastModifiedDate  <= :daysBack90) limit 5';
 //Scenario 2: Days Back 60 , Order Placed
          global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c from Lead__c  where Market__c=\'JP\' AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND (Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND (RecordType.Name =\'Sales Leads\' AND Lead_Latest_Phase__c =\'Order Placed\' AND LastModifiedDate  <= :daysBack60)';
//Scenario 3: Days Back 30 , After Sales ,Appointment Date Time__c
        //  global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c from Lead__c  where Market__c=\'JP\' AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND RecordType.Name =\'Aftersales Leads\' AND Appointment_DateTime__c != null AND Appointment_DateTime__c <= :daysBack30';
*/    
global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('@@Start'+ query);
      return Database.getQueryLocator(query);
   }

global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Lead__c> leadLIst= new List<Lead__c>();
       List<Lead__c> leadLIstTemp= new List<Lead__c>();
       leadLIst = (List<Lead__c>)scope;
       for(Lead__c lead :leadLIst){
          if(lead.RecordType.Name == 'Sales Leads'){
               if(lead.Lead_Latest_Phase__c == 'Quotation' || lead.Lead_Latest_Phase__c == 'CA Submission' || lead.Lead_Latest_Phase__c == 'Finance Quotation'){
                if(lead.LastModifiedDate <= daysBack90){
                 // lead.Lead_Latest_Phase__c ='Lost'; 
                    lead.Dealer_Lead_Status__c='Lost';
                    lead.Dealer_Lost_Reason__c='Other reasons';
                    lead.Lost_Situation__c='Others';
                  leadLIstTemp.add(lead);
                }
                 }
               else if(lead.Lead_Latest_Phase__c == 'Order Placed'){
               if(lead.LastModifiedDate <= daysBack60){
                //  lead.Lead_Latest_Phase__c ='Lost'; 
                    lead.Dealer_Lead_Status__c='Lost';
                    lead.Dealer_Lost_Reason__c='Other reasons';
                    lead.Lost_Situation__c='Others';
                  leadLIstTemp.add(lead);
                }
                   }
            }
         else if(lead.RecordType.Name == 'Aftersales Leads'){
            if(lead.Appointment_DateTime__c  != null){               
               if(lead.Appointment_DateTime__c <= daysBack30){
                 // lead.Lead_Latest_Phase__c ='Lost'; 
                 //  lead.CAC_Lead_Status__c ='Lost(CAC)';
                 lead.Dealer_Lead_Status__c='Lost';
                    lead.Dealer_Lost_Reason__c='Other reasons';
                    lead.Lost_Situation__c='Others';
                  leadLIstTemp.add(lead);
                }
             }
          }
          
       }
       if(leadLIstTemp.size() >0)
       {
             update leadLIstTemp;
             for(Lead__c l:leadLIstTemp)
                 System.debug('@@@@@Lead : '+'--'+l.id+'--'+l.Lead_Latest_Phase__c+'--'+l.Assigned_Dealer__c+'--'+l.RecordType.Name+'--'+l.Appointment_DateTime__c+'--'+l.LastModifiedDate+'--'+l.Dealer_Lead_Status__c+'--'+l.Dealer_Lost_Reason__c+'--'+l.Lost_Situation__c);
       } 
    System.debug('@@@@@leadLIstTemp '+leadLIstTemp.size());
    }

global void finish(Database.BatchableContext BC){
       System.debug('Records Updated');
   }

}