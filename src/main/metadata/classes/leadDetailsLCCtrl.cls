/**************************************************************************************************************************************************************************** 
* File Name     : leadDetailsCtrl
* Description   : This Class is server side controller for LeadDetail cmp to fetch fields to display as per market & recordType of user.  
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************************/ 
public class leadDetailsLCCtrl {
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        try{Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
            return recid;}
        catch(Exception e)
        { CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
          return null;
        }
    }  
    
    @AuraEnabled
    public static String getRecTypeName(String recordId){
        try{Opportunity Opp= [Select recordtypeid from Opportunity where id =: recordId];
        String recTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(Opp.RecordTypeId).getname();        
        return recTypeName;
        }
        catch(Exception e)
        { CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
          return null;
        }
    }  
    @AuraEnabled
    public static Object getFIeldSetForMkt(String recordId, String recordTypeName){
        try{
        Details det = new Details();
        User u= [Select market__c from user where id = : userInfo.getUserId()];
        String market = u.Market__c;
        det.UMarket=market;
            String componentName = 'LeadDetails';
        // for existing record      
        if(recordId!=null && recordId!='')
        {
         Opportunity Opp= [Select recordtypeid from Opportunity where id =: recordId];
         recordTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(Opp.RecordTypeId).getname();
         det.RecTypeName= recordTypeName;  
         det.RecTypeid= Opp.RecordTypeId;  
                componentName = 'LeadDetailsEdit';
        }
        Map<String, Map<String,String>> FSMap= new Map<String, Map<String,String>>(); 
        //Fetch field sets from Factor Class**************
            LeadDetails LD = LeadDetailsFactory.fetchInstance('Opportunity',market,recordTypeName,componentName);
        FSMap=LD.getFields();    
        system.debug('!!!!!Map from factory & metadata'+FSMap);      
        //Factory Invocation above***************************
        List<FSwrapper> FSwrapList = new List<FSwrapper>();
        for(String s : FSMap.keyset())
        {
         FSwrapper FSw= new FSwrapper();
         FSw.sectionName= s;
         FSw.FieldMap= FSMap.get(s); 
         FSwrapList.add(FSw);   
         system.debug('@@@'+Fsw);   
        }
        det.wrapList=FSwrapList;
        system.debug('DET+++'+det);    
        return det;
     }catch(Exception e)
     {       
          CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
          return null;
     }
    } 
   public class FSwrapper{
        @AuraEnabled public Map<String,String> FieldMap{get;set;}
        @AuraEnabled public List<String> FIeldList{get;set;}
        @AuraEnabled public String sectionName {get;set;}
    } 
   public class Details{
        @AuraEnabled public List<FSwrapper> wrapList{get;set;}
        @AuraEnabled public String Umarket {get;set;}
        @AuraEnabled public String recTypeName {get;set;}
        @AuraEnabled public id RecTypeid {get;set;}
    } 
}