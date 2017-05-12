/**
* Utility for Trigger on DM Request for TH(Thailand)
* Author: Bhushan K
* Created Date : 2017-03-08
*/
public with sharing class  DMRequestHelperTH {
    
     
    
    public static void UpdateDMRequest(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isUpdate){
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
        Map<String, String> addtrmapUpdate = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('TH');
                 //get the accountIds 
                for(DM_Request__c lstDMR:triggerNew){
                    CustomerId.add(lstDMR.Customer_Name__c);
                }  
              
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
                {
                    admap.put(addrlst.Address_Type__c, addrlst);
                    addressMap.put(addrlst.Customer__c, admap);
                } 
            
            for(DM_Request__c lstDMR:triggerNew){          
               
               if((lstDMR.Sending_Address__c!=null)&&(lstDMR.Sending_Address__c!='Temporary'))
               {
                   if(lstDMR.Sending_Address__c!=oldMap.get(lstDMR.id).Sending_Address__c)
                   {
                        if((addressMap.containsKey(lstDMR.Customer_Name__c))&&(addressMap.get(lstDMR.Customer_Name__c).containsKey(lstDMR.Sending_Address__c)))
                        {
                                if(addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c).Address_Type__c==lstDMR.Sending_Address__c){                                                                       
                                    Address__c address = addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c);
                                    lstDMR.Zip_Code__c=address.ZipCode__c;
                                    lstDMR.Address__c=address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c;
                                    lstDMR.Additional_Address__c=address.Address_Line_2__c;
                                    lstDMR.Attention__c=address.Company_Name__c;
                                    lstDMR.TitleOfHonor__c=address.TitleOfHonor__c;
                                    if(addtrmapUpdate.containsKey(address.Province__c))
                                    {
                                       province = addtrmapUpdate.get(address.Province__c);
                                    }
                                    lstDMR.Province__c = province;
                                }
                                else{
                                    lstDMR.adderror(Label.DMRequest_validation_error);
                                }
                                lstDMR.Address__c=lstDMR.Address__c.replaceAll(regexForNullValue,nullValue);
                        }
                        else{
                                lstDMR.adderror(Label.DMRequest_validation_error);
                            }
                    
                  }
               }
                
            }  
        
    }
    
    
    public static void InsertDMRequest(List<DM_Request__c> triggerNew,boolean isInsert)
    {
        set<id> CustomerId = new set<id>();  
        Map<id,map<string,Address__c>> addressMap =new Map<id,map<string,Address__c>>();
        map<string,Address__c> admap =new map<string,Address__c>();
        map<string,Address__c> promap = new map<string,Address__c>();
        string regexForNullValue ='null';
        string nullValue ='';
        String province;
        Map<String, String> addtrmapInsert = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues('JP');
                 //get the accountIds 
                for(DM_Request__c lstDMR:triggerNew){
                    CustomerId.add(lstDMR.Customer_Name__c);
                }  
              
                //query for arelated addresses and create a nested map
                for(Address__c addrlst:[select Customer__c,Address_Type__c,ZipCode__c,Province__c,City__c,District__c,Block__c,Address_Line_1__c,Address_Line_2__c,Company_Name__c,TitleOfHonor__c from Address__c where Customer__c IN:CustomerId])
                {
                    admap.put(addrlst.Address_Type__c, addrlst);
                    addressMap.put(addrlst.Customer__c, admap);
                } 
            
            for(DM_Request__c lstDMR:triggerNew){          
                
               if((lstDMR.Sending_Address__c!=null)&&(lstDMR.Sending_Address__c!='Temporary'))
               {                   
                   if((addressMap.containsKey(lstDMR.Customer_Name__c))&&(addressMap.get(lstDMR.Customer_Name__c).containsKey(lstDMR.Sending_Address__c)))
                        {
                                if(addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c).Address_Type__c==lstDMR.Sending_Address__c){                                                                                                           
                                    Address__c address = addressMap.get(lstDMR.Customer_Name__c).get(lstDMR.Sending_Address__c);
                                    lstDMR.Zip_Code__c=address.ZipCode__c;
                                    lstDMR.Address__c=address.City__c+address.District__c+address.Block__c+address.Address_Line_1__c;
                                    lstDMR.Additional_Address__c=address.Address_Line_2__c;
                                    lstDMR.Attention__c=address.Company_Name__c;
                                    lstDMR.TitleOfHonor__c=address.TitleOfHonor__c;
                                    if(addtrmapInsert.containsKey(address.Province__c))
                                    {
                                       province = addtrmapInsert.get(address.Province__c);
                                    }
                                    lstDMR.Province__c = province;
                                }
                                else{
                                    lstDMR.adderror(Label.DMRequest_validation_error);
                                }
                                lstDMR.Address__c=lstDMR.Address__c.replaceAll(regexForNullValue,nullValue);
                        }
                        else{
                                lstDMR.adderror(Label.DMRequest_validation_error);
                            }                    
                  
               }
                
            }  
        
    }
  
     
        
    public static void updateStatus(List<DM_Request__c> triggerNew,Map<ID,DM_Request__c> oldMap,boolean isInsert,boolean isUpdate)
    {
            set<id> CustomerId = new set<id>(); 
            list<DM_Request__c> DMList =new  list<DM_Request__c>();
            User Usr = new User();
            Usr = [SELECT Market__C,Id FROM User WHERE Id = : UserInfo.getUserId()];
            Map<Id,DM_Request__c> mapDMRequest=new Map<Id,DM_Request__c>();
            //get the accountIds 
                for(DM_Request__c lstDMR:triggerNew){
                    CustomerId.add(lstDMR.Customer_Name__c);
                }  
              
        //query for DM_Request__c 
               
                  If(Usr.Market__C=='TH'){
                    DMList=[select Id,Customer_Name__c,Expected_DM_Material1__c,Expected_DM_Material2__c,Expected_DM_Material3__c from DM_Request__c where Customer_Name__c IN:CustomerId and Sent_Date__c <= LAST_N_DAYS:90 and (Status1__c='Success' OR Status2__c='Success' OR Status3__c='Success')];
                }  
             for(DM_Request__c lstDMR:DMList){
                  mapDMRequest.put(lstDMR.Customer_Name__c,lstDMR);
              }     
            for(DM_Request__c lstDMR:triggerNew)
            {
                if(isUpdate){
             
                   if((lstDMR.Status__c=='to be sent')&&((lstDMR.Status1__c=='to be sent')||(lstDMR.Status2__c=='to be sent')||(lstDMR.Status3__c=='to be sent'))
                     &&((lstDMR.Expected_DM_Material1__c!=oldMap.get(lstDMR.id).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c!=oldMap.get(lstDMR.id).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c!=oldMap.get(lstDMR.id).Expected_DM_Material3__c)
                     ||(lstDMR.Status__c!=oldMap.get(lstDMR.id).Status__c)||(lstDMR.Status1__c!=oldMap.get(lstDMR.id).Status1__c)||(lstDMR.Status2__c!=oldMap.get(lstDMR.id).Status2__c)||(lstDMR.Status3__c!=oldMap.get(lstDMR.id).Status3__c))){
                    
                         if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c==lstDMR.Customer_Name__c){
                                If(Usr.Market__C=='TH'){
                                     lstDMR.Status__c='Duplicate';
                                   }                     
                                 if((lstDMR.Expected_DM_Material1__c!=null)&&((lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                     lstDMR.Status1__c='Duplicate';
                                     
                                 }
                                  if((lstDMR.Expected_DM_Material2__c!=null)&&((lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                    
                                     lstDMR.Status2__c='Duplicate';
                                     
                                 }
                                 if((lstDMR.Expected_DM_Material3__c!=null)&&((lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                     
                                     lstDMR.Status3__c='Duplicate';
                                 }
                         }
                                   
               }
                   
           }
                if(isInsert){
                     if((lstDMR.Status__c=='to be sent')&&((lstDMR.Status1__c=='to be sent')||(lstDMR.Status2__c=='to be sent')||(lstDMR.Status3__c=='to be sent'))
                     &&((lstDMR.Expected_DM_Material1__c!=NULL)||(lstDMR.Expected_DM_Material2__c!=NULL)||(lstDMR.Expected_DM_Material3__c!=NULL)
                     ||(lstDMR.Status__c!=NULL)||(lstDMR.Status1__c!=NULL)||(lstDMR.Status2__c!=NULL)||(lstDMR.Status3__c!=NULL))){
                    
                      if(mapDMRequest.get(lstDMR.Customer_Name__c).Customer_Name__c==lstDMR.Customer_Name__c){
                                If(Usr.Market__C=='TH'){
                                     lstDMR.Status__c='Duplicate';
                                   }                      
                                 if((lstDMR.Expected_DM_Material1__c!=null)&&((lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material1__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                     lstDMR.Status1__c='Duplicate';                                    
                                 }
                                  if((lstDMR.Expected_DM_Material2__c!=null) && ((lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material2__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                    
                                     lstDMR.Status2__c='Duplicate';                                    
                                 }
                                 if((lstDMR.Expected_DM_Material3__c!=null) && ((lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material1__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material2__c)||(lstDMR.Expected_DM_Material3__c==mapDMRequest.get(lstDMR.Customer_Name__c).Expected_DM_Material3__c))){
                                     lstDMR.Status3__c='Duplicate';
                                 }
                          }
                }
           }
        }
    
     }
  }