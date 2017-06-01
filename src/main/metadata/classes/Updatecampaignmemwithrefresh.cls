/*
 Purpose : Update the Campaign_Member__c Address  using refresh button and concatenate to  Customer complete address field.
 Created : Siivaram A
 Date: 10-02-2017
 */

global class Updatecampaignmemwithrefresh{
 //User usr = [Select id, LanguageLocaleKey,Market__c,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()]; 
    webservice static void Refreshcampaignmember(String camid){
    String province;
    String provincecontact;
    String provincevehicle;
      String market = 'JP';
            
          //market = usr.Market__c;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
      //if(usr.Profile.Name != 'IntegrationAPI')
          // {
        UtilAddressTranslation.gettranslatedvalues(market);
     // }
        system.debug('--------------->'+camid);
        List<campaign_Member__c> cmmeber = [select id,Name,Address__r.Name,Finance_Address__c,Address__r.Province__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c,Address__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c,Vehicle_Relationship__r.vehicle_address_picklist__c,Vehicle_Relationship__r.Vehicle_Address_Display__c,Campaign_ID__r.Campaign_Type__c,Campaign_ID__r.Segmentation_Base__c,Vehicle_Relationship__r.vehicle_address__c,Vehicle_Relationship__r.vehicle_address__r.District__c,Address__r.Address_Line_1__c,Address__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.District__c,Contract__c,Contact_Id__r.Primary_Address_Reference__c,Contract__r.Contractor_Address1_Native__c , Contract__r.Contractor_Address3_Native__c,Campaign_ID__c 
                                            ,Vehicle_Relationship__r.vehicle_address__r.name,Vehicle_Relationship__r.vehicle_address__r.Province__c,Campaign_ID__r.parent.Campaign_Type__c, Contact_Id__r.Primary_Address_Reference__r.Country__c,
                                            Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c,Contract__r.Contractor_Address1__c,Contract__r.Contractor_Address3__c,Contact_Id__r.Primary_Address_Reference__r.Province__c,Address__r.Block__c,Address__r.City__c,Address__r.ZipCode__c,Address__r.Country__c,Vehicle_Relationship__r.vehicle_address__r.Block__c,Vehicle_Relationship__r.vehicle_address__r.ZipCode__c,Vehicle_Relationship__r.vehicle_address__r.City__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.Block__c,Contact_Id__r.Primary_Address_Reference__r.City__c,Address__r.District__c,Contact_Id__r.Primary_Address_Reference__r.ZipCode__c from campaign_Member__c WHERE Campaign_ID__c = : camid];
        List<Campaign_Member__c> membertoupdate = new List<Campaign_Member__c>();
        for(campaign_Member__c mem : cmmeber){
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
        }        
        if (mem.Vehicle_Relationship__r.vehicle_address__c == mem.Address__c && (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales') && mem.Campaign_ID__r.Segmentation_Base__c =='Vehicle'){
        system.debug('----------> in loop');
        mem.Customer_Complete_Address__c = (province + mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100);
        //(mem.Vehicle_Relationship__r.vehicle_address_picklist__c + mem.Vehicle_Relationship__r.Vehicle_Address_Display__c).left(100);
         }
         
         else if(mem.Vehicle_Relationship__r.vehicle_address__c != mem.Address__c && (mem.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || mem.Campaign_ID__r.parent.Campaign_Type__c == 'After Sales') && mem.Campaign_ID__r.Segmentation_Base__c =='Vehicle'){
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
         }
         else {
           mem.Customer_Complete_Address__c = ''; 
            //else mem.Customer_Complete_Address__c = ''; 
           }
            //getSObjectField(mem.Customer_Complete_Address__c);
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null,',' ');
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null',' ');
            membertoupdate.add(mem);
        //}
        }
        update membertoupdate;
    }
    
    webservice static void Refreshretcampaignmember(String retcamid){
    String provinces;
      String market = 'JP';
      String provincecontacts;
    String provincevehicles;

            
          //market = usr.Market__c;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
      //if(!test.isrunningtest() && usr.Profile.Name != 'IntegrationAPI')
          //  {
        UtilAddressTranslation.gettranslatedvalues(market);
     // }
        system.debug('--------------->'+retcamid);
       List<campaign_Member__c> retcmmeber = [select id,Name,Address__r.Name,Finance_Address__c,Address__r.Province__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c,Address__c,Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c,Vehicle_Relationship__r.vehicle_address_picklist__c,Vehicle_Relationship__r.Vehicle_Address_Display__c,Campaign_ID__r.Campaign_Type__c,Campaign_ID__r.Segmentation_Base__c,Vehicle_Relationship__r.vehicle_address__c,Vehicle_Relationship__r.vehicle_address__r.District__c,Address__r.Address_Line_1__c,Address__r.Address_Line_2__c,Contract__c,Contact_Id__r.Primary_Address_Reference__c,Address__r.District__c,Contract__r.Contractor_Address1_Native__c ,Contact_Id__r.Primary_Address_Reference__r.District__c, Contract__r.Contractor_Address3_Native__c,Campaign_ID__c 
                                            ,Vehicle_Relationship__r.vehicle_address__r.name,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c ,Vehicle_Relationship__r.vehicle_address__r.Province__c,Campaign_ID__r.parent.Campaign_Type__c, Contact_Id__r.Primary_Address_Reference__r.Country__c,
                                            Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c,Retail_Campaign_Id__r.Segmentation_Base__c,Contact_Id__r.Primary_Address_Reference__r.Province__c,Address__r.Block__c,Address__r.City__c,Address__r.ZipCode__c,Address__r.Country__c,Vehicle_Relationship__r.vehicle_address__r.Block__c,Vehicle_Relationship__r.vehicle_address__r.ZipCode__c,Vehicle_Relationship__r.vehicle_address__r.City__c,Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c,Contact_Id__r.Primary_Address_Reference__r.Block__c,Contact_Id__r.Primary_Address_Reference__r.City__c,Contact_Id__r.Primary_Address_Reference__r.ZipCode__c  from campaign_Member__c WHERE Retail_Campaign_Id__c = : retcamid];
        List<Campaign_Member__c> membertoupdate = new List<Campaign_Member__c>();
        for(campaign_Member__c mem : retcmmeber){
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
        if (mem.Vehicle_Relationship__r.vehicle_address__c == mem.Address__c && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle'){
        system.debug('----------> in loop');
        mem.Customer_Complete_Address__c = (provinces+mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100);
        //(mem.Vehicle_Relationship__r.vehicle_address_picklist__c + mem.Vehicle_Relationship__r.Vehicle_Address_Display__c).left(100);
         }
         
         else if(mem.Vehicle_Relationship__r.vehicle_address__c != mem.Address__c && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle'){
             mem.Customer_Complete_Address__c =(provincevehicles + mem.Vehicle_Relationship__r.vehicle_address__r.City__c +mem.Vehicle_Relationship__r.vehicle_address__r.District__c +mem.Vehicle_Relationship__r.vehicle_address__r.Block__c +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_1__c+ '  ' +mem.Vehicle_Relationship__r.vehicle_address__r.Address_Line_2__c ).left(100);
             mem.Address__c=   mem.Vehicle_Relationship__r.vehicle_address__c;
         } 
         else if(mem.Address__c == mem.Contact_Id__r.Primary_Address_Reference__c && mem.Address__c != null &&  mem.Contact_Id__r.Primary_Address_Reference__c != null && mem.Retail_Campaign_Id__r.Segmentation_Base__c == 'Customer' &&  mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales'){
            mem.Customer_Complete_Address__c = (provinces+mem.Address__r.City__c + mem.Address__r.District__c +mem.Address__r.Block__c +mem.Address__r.Address_Line_1__c + '  ' + mem.Address__r.Address_Line_2__c ).left(100); 
        }
        else if(mem.Address__c != mem.Contact_Id__r.Primary_Address_Reference__c){  
        //mem.Customer_Complete_Address__c = ''; 
         mem.Customer_Complete_Address__c = (provincecontacts +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + '  ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
        mem.Address__c = mem.Contact_Id__r.Primary_Address_Reference__c;
         } 
         else if (mem.Vehicle_Relationship__r.vehicle_address__c == null && mem.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales' && mem.Retail_Campaign_Id__r.Segmentation_Base__c =='Vehicle' ){
                mem.Customer_Complete_Address__c =  (provincecontacts +mem.Contact_Id__r.Primary_Address_Reference__r.City__c +mem.Contact_Id__r.Primary_Address_Reference__r.District__c +mem.Contact_Id__r.Primary_Address_Reference__r.Block__c +mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_1__c + ' ' + mem.Contact_Id__r.Primary_Address_Reference__r.Address_Line_2__c ).left(100); 
         }
         else {
           mem.Customer_Complete_Address__c = ''; 
            //else mem.Customer_Complete_Address__c = ''; 
           }
            //getSObjectField(mem.Customer_Complete_Address__c);
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null,',' ');
            mem.Customer_Complete_Address__c = mem.Customer_Complete_Address__c.replaceAll('null',' ');
            membertoupdate.add(mem);
        //}
        }
        update membertoupdate;
    }
    /*public static String getSObjectField(String str){
        if (str == null) { 
            //return ''; 
           return str== null ? '' : str ;
        } 

        return str;
    }*/
    }