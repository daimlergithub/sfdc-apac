global class LeadUpdateToLostJPBatch implements Database.batchable<sObject>{
  
global string query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c,Contact__r.Data_Source__c,Lead_DataSource__c from Lead__c  where (MD__c=\'JP\' OR Market__c=\'JP\') AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND Lead_DataSource__c =\'Dealer Outlet\' AND ((Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND ((RecordType.Name =\'Sales Leads\' AND (Lead_Latest_Phase__c = \'Quotation\' OR Lead_Latest_Phase__c = \'CA Submission\' OR Lead_Latest_Phase__c = \'Finance Quotation\') AND LastModifiedDate  <= :daysBack90 ) OR  (RecordType.Name =\'Sales Leads\' AND Lead_Latest_Phase__c =\'Order Placed\' AND LastModifiedDate  <= :daysBack60) OR  (RecordType.Name =\'Aftersales Leads\' AND Appointment_DateTime__c != null AND Appointment_DateTime__c <=  :daysBack30)) )';
 
global Database.QueryLocator start(Database.BatchableContext BC){ 
    Date daysBack30 =  System.today().addDays(Integer.valueof(Label.Days30));
    Date daysBack60 = System.today().addDays(Integer.valueof(Label.Days60));
    Date daysBack90 = System.today().addDays(Integer.valueof(Label.Days90));  
    if(Test.isRunningTest()){
       daysBack30 = System.today();
	   daysBack60 = System.today();
 	   daysBack90 = System.today();
       query='Select id,Lead_Latest_Phase__c,Assigned_Dealer__c,RecordType.Name,Appointment_DateTime__c,LastModifiedDate,Dealer_Lead_Status__c,Dealer_Lost_Reason__c,Lost_Situation__c,Contact__r.Data_Source__c,Lead_DataSource__c from Lead__c  where (MD__c=\'JP\' OR Market__c=\'JP\') AND CAC_Lead_Status__c=\'Allocated\' AND Assigned_Dealer__r.Dealer_ND_Code__c !=\'\' AND Assigned_Dealer__r.Dealer_Group__c =\'Yanase\' AND Lead_DataSource__c =\'Dealer Outlet\' AND ((Dealer_Lead_Status__c != \'Order Placed\' OR Dealer_Lead_Status__c != \'Lost\' OR Dealer_Lead_Status__c != \'Purchased(Only Non BDC)\') AND ((RecordType.Name =\'Sales Leads\' AND (Lead_Latest_Phase__c = \'Quotation\' OR Lead_Latest_Phase__c = \'CA Submission\' OR Lead_Latest_Phase__c = \'Finance Quotation\') AND LastModifiedDate  <= :daysBack90 ) OR  (RecordType.Name =\'Sales Leads\' AND Lead_Latest_Phase__c =\'Order Placed\' AND LastModifiedDate  <= :daysBack60) OR  (RecordType.Name =\'Aftersales Leads\' AND Appointment_DateTime__c != null AND Appointment_DateTime__c <=  :daysBack30)) )';
    }
        System.debug('@@Start'+ query);
      return Database.getQueryLocator(query);
   }

global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Lead__c> leadLIst= new List<Lead__c>();
       List<Lead__c> leadLIstTemp= new List<Lead__c>();
       leadLIst = (List<Lead__c>)scope;
    	system.debug('leadLIst.size()'+leadLIst.size());
       for(Lead__c lead :leadLIst){
	        if(lead.Dealer_Lead_Status__c != 'Purchased(Only Non BDC)' && lead.Dealer_Lead_Status__c != 'Lost'){
               lead.Dealer_Lead_Status__c='Lost';
                    lead.Dealer_Lost_Reason__c='Other reasons';
                    lead.Lost_Situation__c='Others';
					lead.Lost_Comment__c ='YA自動失注処理';
				    lead.Automatic_Lost_date__c = System.today();
					lead.YA_Lead_Lost_Date__c =System.today();
					lead.Auto_lost_trigger__c='Yanase';
                  leadLIstTemp.add(lead); 
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