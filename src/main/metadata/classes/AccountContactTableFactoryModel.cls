/* File Name   : AccountContactTableFactoryModel -->
<!-- Description : AccountContactTableFactoryModel -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 26-July-2018  */
public class AccountContactTableFactoryModel {
    
    public class fieldsAvailabilityWrapper{
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String fieldLabel{get;set;}
        @AuraEnabled public Boolean apiname{get;set;}
        @AuraEnabled public Boolean isInPutField{get;set;}
        @AuraEnabled public Boolean isRequired{get;set;}
        @AuraEnabled public String availableForMarket{get;set;}
        @AuraEnabled public String availableForWhatPage{get;set;} // if more than one page then add the page with semicolor as a seperator
    	
       
        public fieldsAvailabilityWrapper(String market, String page, String label, String apiname, Boolean output, Boolean input, Boolean required){
        	this.availableForMarket =  market;
            this.availableForWhatPage =  page;
            this.fieldLabel =  label;
            this.fieldApiName =  apiname;
            this.apiname =  output;
            this.isInPutField =  input;
            this.isRequired =  required;
        }
    }
    
    public static List<fieldsAvailabilityWrapper> commonFields(){
        List<fieldsAvailabilityWrapper> fieldWrapperList =  new List<fieldsAvailabilityWrapper>();
        String allMarkets = getAllMarkets();
        fieldsAvailabilityWrapper faw1 =  new fieldsAvailabilityWrapper(allMarkets, 'ContactTable' , '', 'Individual_Home_Phone__c',false, true, false);       
        fieldWrapperList.add(faw1);
        fieldsAvailabilityWrapper faw2 =  new fieldsAvailabilityWrapper(allMarkets, 'ContactTable' , '', 'Individual_Home_Phone_Status__c',false, true, false);       
        fieldWrapperList.add(faw2);
        fieldsAvailabilityWrapper faw3 =  new fieldsAvailabilityWrapper(allMarkets, 'ContactTable' , '', 'Home_Phone_Last_Modified_By__c',true, false, false);       
        fieldWrapperList.add(faw3);
        return fieldWrapperList;
    }
    
    public static List<fieldsAvailabilityWrapper> japanMarketFields(){
        List<fieldsAvailabilityWrapper> fieldWrapperListJP =  new List<fieldsAvailabilityWrapper>();
        	fieldWrapperListJP = commonFields();
        
        return fieldWrapperListJP;
    }
    
    public static String getAllMarkets(){
        String allMarkets='';
        Schema.sObjectType objType = User.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get('Market__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            if(allMarkets==''){
                allMarkets = a.getValue();
            }else{
                allMarkets = allMarkets + ';' +a.getValue();
            }
            
        }
        system.debug('<<allMarkets'+allMarkets);
        return allMarkets;
    }
}