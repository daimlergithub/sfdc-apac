global class Batch_RefreshButton implements Database.Batchable<sObject>{
    global final String query;
    
    global Batch_RefreshButton(String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id,Name,Address__r.Name,Finance_Address__c,Preferred_Dealer__c,Preferred_Dealer__r.Dealer_GC_Code__c,Campaign_ID__r.Parent.Driven_Type__c,Address__r.Province__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c,Address__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c,Vehicle_Relationship__r.vehicle_address_picklist__c,Vehicle_Relationship__r.Vehicle_Address_Display__c,Campaign_ID__r.Campaign_Type__c,Campaign_ID__r.Segmentation_Base__c,Vehicle_Relationship__r.vehicle_address__c,Vehicle_Relationship__r.vehicle_address__r.District__c,Address__r.Address_Line_1__c,Address__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.District__c,Contract__c,Contact_Id__r.Primary_Address_Reference__c,Contract__r.Contractor_Address1_Native__c , Contract__r.Contractor_Address3_Native__c,Campaign_ID__c,Vehicle_Relationship__r.vehicle_address__r.name,Vehicle_Relationship__r.vehicle_address__r.Province__c,Campaign_ID__r.parent.Campaign_Type__c, Contact_Id__r.Primary_Address_Reference__r.Country__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c,Contract__r.Contractor_Address1__c,Contract__r.Contractor_Address3__c,Contact_Id__r.Primary_Address_Reference__r.Province__c,Address__r.Block__c,Address__r.City__c,Address__r.ZipCode__c,Address__r.Country__c,Vehicle_Relationship__r.vehicle_address__r.Block__c,Vehicle_Relationship__r.vehicle_address__r.ZipCode__c,Vehicle_Relationship__r.vehicle_address__r.City__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.Block__c,Contact_Id__r.Primary_Address_Reference__r.City__c,Vehicle__r.NextInspectionDate__c,Vehicle__r.LastWorkDate__c,Vehicle__r.LastServiceDate__c,Vehicle__r.LastInspectionDate__c,Vehicle__r.NextServiceDate__c,Address__r.District__c,Contact_Id__r.Primary_Address_Reference__r.ZipCode__c from campaign_Member__c WHERE Campaign_ID__c =: query ] );
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Member__C> scope){
    String province;
    String provincecontact;
    String provincevehicle;
      String market = 'JP';
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
      
        UtilAddressTranslation.gettranslatedvalues(market);
        system.debug('++++++++++++++++++++++++'+scope);
        Set<String> Jointvehicle = new set<String>();
        Set<String> contactid = new set<String>();
        Set<String> JointPreferedDealer= new set<String>();
        Set<String> ContactPreferedDealer= new set<String>();
     List<Campaign_Member__c> membertoupdate = new List<Campaign_Member__c>();
        for(campaign_Member__c mem : scope){
            if(mem.Campaign_ID__r.Parent.Driven_Type__c == 'Joint' && mem.Preferred_Dealer__c != null){
                JointPreferedDealer.add(mem.Preferred_Dealer__r.Dealer_GC_Code__c);
                if(mem.Vehicle__c!=null){
                    Jointvehicle.add(mem.Vehicle__c);
                }
                if(mem.Contact_Id__c != null){
                    contactid.add(mem.Contact_Id__c);
                }
            }
            
        }
         
        List<Account_Link__c> acclink = [select Id, Name, NextInspectionDate__c, NextServiceDate__c, LastWorkDate__c,LastInspectionDate__c, LastServiceDate__c, Service_Advisor__c,fromRole__r.Dealer_GC_Code__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Vehicle_External_Link' AND Vehicle__c IN: Jointvehicle AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer order by LastModifiedDate desc LIMIT 1];
        system.debug('acclink $##$Kiran'+acclink );
        List<Account_Link__c> Personacclink = [select Id, Name, Retail_Sales_Consultant__c,Retail_Delete_Flag__c,toRole__c,Retail_Duplicate_Flag__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Retail_Person' AND toRole__c IN: contactid AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer AND Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false  order by LastModifiedDate desc LIMIT 1];
        
        for(campaign_Member__c mem : scope){
        province = addtrmap1.get(mem.Address__r.Province__c);
        provincecontact= addtrmap1.get(mem.Contact_Id__r.Primary_Address_Reference__r.Province__c);
        provincevehicle= addtrmap1.get(mem.Vehicle_Relationship__r.vehicle_address__r.Province__c);
    
        if(mem.Contract__c != null && mem.Campaign_ID__r.parent.Campaign_Type__c == 'Finance' ){
            //if(!String.isBlank(mem.Contract__r.Contractor_Address1_Native__c) && !String.isBlank(mem.Contract__r.Contractor_Address3_Native__c))
                //mem.Finance_Address__c = (mem.Contract__r.Contractor_Address1_Native__c + ',' + mem.Contract__r.Contractor_Address3_Native__c);
            if(!String.isBlank(mem.Contract__r.Contractor_Address3__c))
                mem.Finance_Address__c = mem.Contract__r.Contractor_Address3__c;
            else if(!String.isBlank(mem.Contract__r.Contractor_Address1__c))
                mem.Finance_Address__c = mem.Contract__r.Contractor_Address1__c;
            else
                mem.Finance_Address__c = '';
        }        
        if (mem.Vehicle_Relationship__r.vehicle_address__c == mem.Address__c &&  mem.Vehicle_Relationship__r.vehicle_address__c != null && mem.Address__c != null  && (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales') && mem.Campaign_ID__r.Segmentation_Base__c =='Vehicle'){
        system.debug('----------> in loop');
        mem.Customer_Complete_Address__c = (province + mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100);
        //(mem.Vehicle_Relationship__r.vehicle_address_picklist__c + mem.Vehicle_Relationship__r.Vehicle_Address_Display__c).left(100);
         }
         
         else if(mem.Vehicle_Relationship__r.vehicle_address__c != mem.Address__c &&  mem.Vehicle_Relationship__r.vehicle_address__c != null   && (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales') && mem.Campaign_ID__r.Segmentation_Base__c =='Vehicle'){
             mem.Customer_Complete_Address__c =(provincevehicle + mem.Vehicle_Relationship__r.vehicle_address__r.City__c +mem.Vehicle_Relationship__r.vehicle_address__r.District__c +mem.Vehicle_Relationship__r.vehicle_address__r.Block__c +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c+ '  ' +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c ).left(100);
             mem.Address__c=   mem.Vehicle_Relationship__r.vehicle_address__c;
         } 
         else if(mem.Address__c == mem.Contact_Id__r.Primary_Address_Reference__c && mem.Address__c != null &&  mem.Contact_Id__r.Primary_Address_Reference__c != null && mem.Campaign_ID__r.Segmentation_Base__c == 'Customer' &&  (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales')){
            mem.Customer_Complete_Address__c = (province +mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100);
        }
        else if(mem.Address__c != mem.Contact_Id__r.Primary_Address_Reference__c){  
        //mem.Customer_Complete_Address__c = ''; 
         mem.Customer_Complete_Address__c = (provincecontact +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + '  ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
        mem.Address__c = mem.Contact_Id__r.Primary_Address_Reference__c;
         } 
         else if (mem.Vehicle_Relationship__r.vehicle_address__c == null && (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales') && mem.Campaign_ID__r.Segmentation_Base__c =='Vehicle' ){
                mem.Customer_Complete_Address__c =  (provincecontact +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + '  ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
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
            
            if(mem.Campaign_ID__r.Parent.Driven_Type__c == 'WholeSale' && mem.Vehicle__c != null){
            mem.NextInspectionDate__c = mem.Vehicle__r.NextInspectionDate__c;
            mem.NextServiceDate__c = mem.Vehicle__r.NextServiceDate__c;
            mem.LastInspectionDate__c = mem.Vehicle__r.LastInspectionDate__c;
            mem.LastServiceDate__c = mem.Vehicle__r.LastServiceDate__c;
            mem.LastWorkDate__c = mem.Vehicle__r.LastWorkDate__c;
            
        }
        if(!acclink.isEmpty() && acclink.size()>0){
            mem.NextInspectionDate__c = acclink[0].NextInspectionDate__c;
            mem.NextServiceDate__c = acclink[0].NextServiceDate__c;
            mem.LastInspectionDate__c = acclink[0].LastInspectionDate__c;
            mem.LastServiceDate__c = acclink[0].LastServiceDate__c;
            mem.LastWorkDate__c = acclink[0].LastWorkDate__c;
            mem.Service_Advisor__c = acclink[0].Service_Advisor__c;
            
        }
        
        if(!Personacclink.isempty()&&Personacclink.size()>0){
            mem.Sales_Consultant__c = Personacclink[0].Retail_Sales_Consultant__c;
            
        }
        membertoupdate.add(mem);
        //}
        }
        
        
        update membertoupdate;
    
        
    }
    
    global void finish(Database.BatchableContext BC){
       

}
}