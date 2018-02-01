global class Batch_RefreshButtonRetail implements Database.Batchable<sObject>{
    global final String query;
    
    global Batch_RefreshButtonRetail (String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator([select id,Name,Retail_Copy__c,Vehicle_ExternalLink__c,Address__r.Name,Vehicle__c,Contact_Id__c,Finance_Address__c,Address__r.Province__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c,Address__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c,Vehicle_Relationship__r.vehicle_address_picklist__c,Vehicle_Relationship__r.Vehicle_Address_Display__c,Campaign_ID__r.Campaign_Type__c,Campaign_ID__r.Segmentation_Base__c,Vehicle_Relationship__r.vehicle_address__c,Vehicle_Relationship__r.vehicle_address__r.District__c,Address__r.Address_Line_1__c,Address__r.Address_Line_2__c,Contract__c,Contact_Id__r.Primary_Address_Reference__c,Address__r.District__c,Contract__r.Contractor_Address1_Native__c ,Contact_Id__r.Primary_Address_Reference__r.District__c, Contract__r.Contractor_Address3_Native__c,Campaign_ID__c ,Vehicle_Relationship__r.vehicle_address__r.name,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c ,Vehicle_Relationship__r.vehicle_address__r.Province__c,Campaign_ID__r.parent.Campaign_Type__c, Contact_Id__r.Primary_Address_Reference__r.Country__c,NextInspectionDate__c,NextServiceDate__c,LastInspectionDate__c,LastServiceDate__c,LastWorkDate__c,Service_Advisor__c,Sales_Consultant__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c,Retail_Campaign_Id__r.Segmentation_Base__c,Contact_Id__r.Primary_Address_Reference__r.Province__c,Address__r.Block__c,Address__r.City__c,Address__r.ZipCode__c,Address__r.Country__c,Vehicle_Relationship__r.vehicle_address__r.Block__c,Vehicle_Relationship__r.vehicle_address__r.ZipCode__c,Vehicle_Relationship__r.vehicle_address__r.City__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.Block__c,Contact_Id__r.Primary_Address_Reference__r.City__c,Contact_Id__r.Primary_Address_Reference__r.ZipCode__c  from campaign_Member__c WHERE Retail_Campaign_Id__c =: query]);
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Member__C> scope){
    String provinces;
      String market = 'JP';
      String provincecontacts;
    String provincevehicles;
    User usr = [Select id, LanguageLocaleKey,Dealer_GC_Code__c,Market__c,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()]; 

         set<String> vehicleid = new set<String>();
         set<string> contactid = new set<string>();
          //market = usr.Market__c;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
      
        UtilAddressTranslation.gettranslatedvalues(market);
        Map<id,Campaign_Member__c> membertoupdate = new Map<id,Campaign_Member__c>();
        for(campaign_Member__c mem : scope){
            if(mem.Vehicle__c != null){
                vehicleid.add(mem.Vehicle__c);
            }
            if(mem.Contact_Id__c != null){
                contactid.add(mem.Contact_Id__c);
            }
        provinces = addtrmap1.get(mem.Address__r.Province__c);
        provincecontacts=addtrmap1.get(mem.Contact_Id__r.Primary_Address_Reference__r.Province__c);
        provincevehicles=addtrmap1.get(mem.Vehicle_Relationship__r.vehicle_address__r.Province__c);
        if(mem.Contract__c != null && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Finance' ){
            if(!String.isBlank(mem.Contract__r.Contractor_Address1_Native__c) && !String.isBlank(mem.Contract__r.Contractor_Address3_Native__c))
                mem.Finance_Address__c = (mem.Contract__r.Contractor_Address1_Native__c + ',' + mem.Contract__r.Contractor_Address3_Native__c);
            else if(!String.isBlank(mem.Contract__r.Contractor_Address1_Native__c))
                mem.Finance_Address__c = mem.Contract__r.Contractor_Address1_Native__c;
            else if(!String.isBlank(mem.Contract__r.Contractor_Address3_Native__c))
                mem.Finance_Address__c = mem.Contract__r.Contractor_Address3_Native__c;
        }        
        if (mem.Vehicle_Relationship__r.vehicle_address__c == mem.Address__c &&  mem.Vehicle_Relationship__r.vehicle_address__c != null && mem.Address__c != null && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle'){
        system.debug('----------> in loop');
        system.debug('+++++1st condtion+++++++');
        mem.Customer_Complete_Address__c = (provinces+mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100);
        //(mem.Vehicle_Relationship__r.vehicle_address_picklist__c + mem.Vehicle_Relationship__r.Vehicle_Address_Display__c).left(100);
         }
         
         else if(mem.Vehicle_Relationship__r.vehicle_address__c != mem.Address__c &&  mem.Vehicle_Relationship__r.vehicle_address__c != null && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle'){
             mem.Customer_Complete_Address__c =(provincevehicles + mem.Vehicle_Relationship__r.vehicle_address__r.City__c +mem.Vehicle_Relationship__r.vehicle_address__r.District__c +mem.Vehicle_Relationship__r.vehicle_address__r.Block__c +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c+ '  ' +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c ).left(100);
             mem.Address__c=   mem.Vehicle_Relationship__r.vehicle_address__c;
             system.debug('+++++2nd condtion+++++++');
         } 
         else if(mem.Address__c == mem.Contact_Id__r.Primary_Address_Reference__c && mem.Address__c != null &&  mem.Contact_Id__r.Primary_Address_Reference__c != null && mem.Retail_Campaign_Id__r.Segmentation_Base__c == 'Customer' &&  mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales'){
            mem.Customer_Complete_Address__c = (provinces+mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100); 
        }
        else if(mem.Address__c != mem.Contact_Id__r.Primary_Address_Reference__c){  
        //mem.Customer_Complete_Address__c = ''; 
         mem.Customer_Complete_Address__c = (provincecontacts +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + '  ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
        mem.Address__c = mem.Contact_Id__r.Primary_Address_Reference__c;
        system.debug('+++++3rd condtion+++++++');
         } 
         else if (mem.Vehicle_Relationship__r.vehicle_address__c == null && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle' ){
                mem.Customer_Complete_Address__c =  (provincecontacts +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + ' ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
              if(mem.Contact_Id__r.Primary_Address_Reference__c != null){
                mem.Address__c = mem.Contact_Id__r.Primary_Address_Reference__c;
                } 
        
         }
         else {
           mem.Customer_Complete_Address__c = ''; 
            //else mem.Customer_Complete_Address__c = ''; 
           }
            //getSObjectField(mem.Customer_Complete_Address__c);
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null,',' ');
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null',' ');
            membertoupdate.put(mem.id,mem);
        
        }
        Map<Id,Account_Link__c> mapAccLinks = New Map<Id,Account_Link__c>(); 
        List<Account_Link__c> acclink = [select Id, Name,Vehicle__c, NextInspectionDate__c, NextServiceDate__c, LastWorkDate__c,LastInspectionDate__c, LastServiceDate__c, Service_Advisor__c,fromRole__r.Dealer_GC_Code__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Vehicle_External_Link' AND Vehicle__c IN: vehicleid AND fromRole__r.Dealer_GC_Code__c = :usr.Dealer_GC_Code__c order by LastModifiedDate desc];
        for(Account_Link__c accMainlink : acclink){
            
            mapAccLinks.put(accMainlink.Vehicle__c,accMainlink);
        }
        if(!acclink.isempty() && acclink.size()>0){
        for(Campaign_Member__c camp : scope){
            camp.NextInspectionDate__c = mapAccLinks.get(camp.Vehicle__c).NextInspectionDate__c;
            camp.NextServiceDate__c = mapAccLinks.get(camp.Vehicle__c).NextServiceDate__c;
            camp.LastInspectionDate__c = mapAccLinks.get(camp.Vehicle__c).LastInspectionDate__c;
            camp.LastServiceDate__c = mapAccLinks.get(camp.Vehicle__c).LastServiceDate__c;
            camp.LastWorkDate__c = mapAccLinks.get(camp.Vehicle__c).LastWorkDate__c;
            camp.Service_Advisor__c = mapAccLinks.get(camp.Vehicle__c).Service_Advisor__c;
            camp.Vehicle_ExternalLink__c = mapAccLinks.get(camp.Vehicle__c).Id;
            membertoupdate.put(camp.id,camp);
        }
        }
        Map<Id,Account_Link__c> mapAccSalesLinks = New Map<Id,Account_Link__c>();
        List<Account_Link__c> Personacclink = [select Id, Name, Retail_Sales_Consultant__c,Retail_Delete_Flag__c,toRole__c,Retail_Duplicate_Flag__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Retail_Person' AND toRole__c IN: contactid AND fromRole__r.Dealer_GC_Code__c = :usr.Dealer_GC_Code__c AND Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false  order by LastModifiedDate desc];
        if(!Personacclink.isempty() && Personacclink.size()>0){
            for(Account_Link__c acc :Personacclink){
                mapAccSalesLinks.put(acc.toRole__c,acc);
                
            }
        for(Campaign_Member__c retcamp : scope){
            retcamp.Sales_Consultant__c = mapAccSalesLinks.get(retcamp.Contact_Id__c).Retail_Sales_Consultant__c;
            membertoupdate.put(retcamp.id,retcamp);
            if(retcamp.Contact_Id__c !=null)
            {
             retcamp.Retail_Copy__c = mapAccSalesLinks.get(retcamp.Contact_Id__c).Id;
            }
           
        }
        }
        update membertoupdate.values();
    }
    
     
    
        
    
    
    global void finish(Database.BatchableContext BC){
       

}
}