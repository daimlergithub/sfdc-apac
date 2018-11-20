global class Batch_RefreshButton implements Database.Batchable<sObject>,Database.stateful{
    global final String query;
	 global  Campaign camprec=new  Campaign();
      global Map<Id, String> errorMap {get; set;}
  global Map<Id, String> successMap {get; set;}
   global list<Id> successlist=new list<ID>();
    global set<Id> campid=new set<ID>();
  global Map<Id, SObject> IdToSObjectMap {get; set;}
    global Batch_RefreshButton(String q){
        query = q;
		campid.add(q);
        system.debug('++++++++++++++++++'+query);
		  errorMap = new Map<Id, String>();
successMap= new Map<Id, String>();
IdToSObjectMap = new Map<Id, SObject>();
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id,Name,Vehicle__c ,Postal_OptOut__c,OptOutContact_Reason__c,Retail_Copy__c,Vehicle_ExternalLink__c,Address__r.Name,Finance_Address__c,Preferred_Dealer__c,Preferred_Dealer__r.Dealer_GC_Code__c,Campaign_ID__r.Parent.Driven_Type__c,Address__r.Province__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c,Address__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c,Vehicle_Relationship__r.vehicle_address_picklist__c,Vehicle_Relationship__r.Vehicle_Address_Display__c,Campaign_ID__r.Campaign_Type__c,Campaign_ID__r.Segmentation_Base__c,Vehicle_Relationship__r.vehicle_address__c,Vehicle_Relationship__r.vehicle_address__r.District__c,Address__r.Address_Line_1__c,Address__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.District__c,Contract__c,Contact_Id__r.Primary_Address_Reference__c,Contract__r.Contractor_Address1_Native__c , Contract__r.Contractor_Address3_Native__c,Campaign_ID__c,Vehicle_Relationship__r.vehicle_address__r.name,Vehicle_Relationship__r.vehicle_address__r.Province__c,Campaign_ID__r.parent.Campaign_Type__c, Contact_Id__r.Primary_Address_Reference__r.Country__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c,Contract__r.Contractor_Address1__c,Contract__r.Contractor_Address3__c,Contact_Id__r.Primary_Address_Reference__r.Province__c,Address__r.Block__c,Address__r.City__c,Address__r.ZipCode__c,Address__r.Country__c,Vehicle_Relationship__r.vehicle_address__r.Block__c,Vehicle_Relationship__r.vehicle_address__r.ZipCode__c,Vehicle_Relationship__r.vehicle_address__r.City__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.Block__c,Contact_Id__r.Primary_Address_Reference__r.City__c,Vehicle__r.NextInspectionDate__c,Vehicle__r.LastWorkDate__c,Vehicle__r.LastServiceDate__c,Vehicle__r.LastInspectionDate__c,Vehicle__r.NextServiceDate__c,Address__r.District__c,Contact_Id__r.Primary_Address_Reference__r.ZipCode__c from campaign_Member__c WHERE Campaign_ID__c =: query] );
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
        Map<id,Campaign_Member__c> membertoupdate = new Map<id,Campaign_Member__c>();
     //List<Campaign_Member__c> membertoupdate = new List<Campaign_Member__c>();
        for(campaign_Member__c mem : scope){
            if( mem.Preferred_Dealer__c != null){
                JointPreferedDealer.add(mem.Preferred_Dealer__r.Dealer_GC_Code__c);
                if(mem.Vehicle__c!=null){
                    Jointvehicle.add(mem.Vehicle__c);
                }
                if(mem.Contact_Id__c != null){
                    contactid.add(mem.Contact_Id__c);
                }
            }
            
        }
         
        //List<Account_Link__c> acclink = [select Id, Name, NextInspectionDate__c, NextServiceDate__c, LastWorkDate__c,LastInspectionDate__c, LastServiceDate__c, Service_Advisor__c,fromRole__r.Dealer_GC_Code__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Vehicle_External_Link' AND Vehicle__c IN: Jointvehicle AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer order by LastModifiedDate desc LIMIT 1];
       // system.debug('acclink $##$Kiran'+acclink );
       // List<Account_Link__c> Personacclink = [select Id, Name, Retail_Sales_Consultant__c,Retail_Delete_Flag__c,toRole__c,Retail_Duplicate_Flag__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Retail_Person' AND toRole__c IN: contactid AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer AND Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false  order by LastModifiedDate desc LIMIT 1];
        
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
         membertoupdate.put(mem.id,mem);
        Map<Id,Account_Link__c> mapAccLinks = New Map<Id,Account_Link__c>(); 
        List<Account_Link__c> acclink = [select Id, Name, NextInspectionDate__c,Vehicle__c, NextServiceDate__c, LastWorkDate__c,LastInspectionDate__c, LastServiceDate__c, Service_Advisor__c,fromRole__r.Dealer_GC_Code__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Vehicle_External_Link' AND Vehicle__c IN: Jointvehicle AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer order by LastModifiedDate desc ];
        for(Account_Link__c accMainlink : acclink){
            
            mapAccLinks.put(accMainlink.Vehicle__c,accMainlink);
        }
        
        System.debug('+++++++++acclink++++++++++++'+acclink);
        if(!acclink.isEmpty() && acclink.size()>0){
        for(Campaign_Member__c camp : scope){
          for(Account_Link__c acc : acclink ){
          
          if(camp.Vehicle__c == acc.Vehicle__c && camp.Preferred_Dealer__r.Dealer_GC_Code__c  == acc.fromRole__r.Dealer_GC_Code__c  ){
            camp.NextInspectionDate__c = acc.NextInspectionDate__c;
            camp.NextServiceDate__c = acc.NextServiceDate__c;
            camp.LastInspectionDate__c =acc.LastInspectionDate__c;
            camp.LastServiceDate__c = acc.LastServiceDate__c;
            camp.LastWorkDate__c = acc.LastWorkDate__c;
            camp.Service_Advisor__c = acc.Service_Advisor__c;
            camp.Vehicle_ExternalLink__c = acc.Id;
           // membertoupdate.add(camp);
            membertoupdate.put(camp.id,camp);
            }

            }
            }
            
        }
         Map<Id,Account_Link__c> mapAccSalesLinks = New Map<Id,Account_Link__c>();
          List<Account_Link__c> Personacclink = [select Id,Retail_Email_OptOut__c,Missing_Flag__c, Retail_Postal_OptOut__c,Retail_OptOutContact_Reason__c, Name,Vehicle__c , Retail_Sales_Consultant__c,fromRole__r.Dealer_GC_Code__c,Retail_Delete_Flag__c,toRole__c,Retail_Duplicate_Flag__c,LastModifiedDate  from Account_Link__c WHERE RecordType.Developername = 'Retail_Person' AND toRole__c IN: contactid AND fromRole__r.Dealer_GC_Code__c = :JointPreferedDealer AND Retail_Delete_Flag__c = false AND Retail_Duplicate_Flag__c = false  order by LastModifiedDate desc ];
       
         System.debug('+++++++++Personacclink++++++++++++'+Personacclink );
        if(!Personacclink.isempty()&&Personacclink.size()>0){
        for(Account_Link__c acc :Personacclink){
        
                mapAccSalesLinks.put(acc.toRole__c,acc);
                
            }
            for(Campaign_Member__c retcamp : scope){
            for(Account_Link__c acc : Personacclink  ){
           
            if(retcamp.Contact_Id__c == acc.toRole__c && retcamp .Preferred_Dealer__r.Dealer_GC_Code__c  == acc.fromRole__r.Dealer_GC_Code__c  ){
            retcamp.Sales_Consultant__c = acc.Retail_Sales_Consultant__c;
             retcamp.Retail_Copy__c = acc.Id;
              retcamp.Postal_OptOut__c = acc.Retail_Postal_OptOut__c;
                retcamp.OptOutContact_Reason__c = acc.Retail_OptOutContact_Reason__c;
                retcamp.Email_OptOut__c= acc.Retail_Email_OptOut__c;
                    retcamp.Missing_Flag__c= acc.Missing_Flag__c;
            //membertoupdate.add(retcamp);
            membertoupdate.put(retcamp.id,retcamp);
            }
        }
        }
        
        }
         Map<Id,Account_Link__c> mapmymeid = New Map<Id,Account_Link__c>();
          List<Account_Link__c> acclinkid = [select ID,Name from Account_link__c where RecordType.Developername = 'IndividualExternalLink' and System__c = 'My Mercedes' and Primary__c = True and toRole__c IN: contactid  ];
       
         System.debug('+++++++++acclinkid++++++++++++'+acclinkid );
        if(!acclinkid.isempty()&&acclinkid.size()>0){
        for(Account_Link__c acc :acclinkid){
        
                mapmymeid.put(acc.toRole__c,acc);
                
            }
            for(Campaign_Member__c cmpmembr : scope){
            for(Account_Link__c acc : acclinkid  ){
           
            if(cmpmembr.Contact_Id__c == acc.toRole__c 

			){
            cmpmembr.My_Mercedes_ID__c = acc.name;

            membertoupdate.put(cmpmembr.id,cmpmembr);
            }
        }
        }
        
        }        
        
        //update membertoupdate;
       // database.update(membertoupdate.values(), false);
        //update membertoupdate.values();
        //upsert membertoupdate.values();
    
        
    }
    
    
        if(membertoupdate.size()>0)
    {
        List<Database.SaveResult> dsrs = Database.update(membertoupdate.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: membertoupdate.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, membertoupdate.values());                        
                    }
                    
                }
                index++;
            }
    }
    }
    
    global void finish(Database.BatchableContext BC){
    
   
    
    
         if(!errorMap.isEmpty() || !successlist.isempty())
     {
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        if(campid !=null)
        {
         camprec=[Select id,name from campaign where id=:campid Limit 1];
         }
         String body = 'Your batch job '
             + 'Batch_RefreshButton '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Id, Name, Error \n';
			// String subject = 'Campaign member Insertion for'+camprec.Name+' - Apex Batch Error List';
            String subject = 'Refresh List for'+camprec.Name+' - Apex Batch Error List';
            String attName = 'Refresh List.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                Campaign_Member__c acct = (Campaign_Member__c) IdToSObjectMap.get(id);
                string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                finalstr = finalstr +recordString;
            } 
         // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
 
            // Sets the paramaters of the email
            email.setSubject( subject );
            //email.setToAddresses( new String[] {'dinesh.govindaswamy@nttdata.com'} );
           email.setToAddresses( new String[] {'NTT_Daimler_SO_Team@nttdata.com'} );
            email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
 
     }
       

}
}