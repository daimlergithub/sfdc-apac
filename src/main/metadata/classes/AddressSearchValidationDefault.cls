/**************************************************************************************************************************************************************************** 
* File Name     : AddressSearchValidationDefault
* Description   : This Class is part of the Factory model and is the default class which is executed with out any Market specific logic
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with AddressSearchValidation,AddressSearchValidationFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sravani & 22/08/2018
******************************************************************************************************************************************************************/ 
public virtual class AddressSearchValidationDefault implements AddressSearchValidation{
    private Factory_Fields__mdt rec;
    public Factory_Fields__mdt  getmdRec(){
        return this.rec;    
    }
    public void setmdRec(Factory_Fields__mdt fRec){
        this.rec=fRec;
    }
    private Map<String,List<String>> fieldSetMap = new Map<String,List<String>>();
    protected Map<String,List<String>> deduplicationMap = new Map<String,List<String>>();
    protected Map<String,List<String>> saveMap = new Map<String,List<String>>();
    protected String endURL='';
    public Map<String,List<String>> retrieveFieldSet(SObject sObj, String filterName, String recordType,String market){
        try{
            if(rec.Input_Fields__c!=null){
                List<String> compList=rec.Input_Fields__c.split('}');
                for(String str:compList){
                    List<String> titleList=str.split(':');
                    fieldSetMap.put((titleList[0].remove('__c')).toLowerCase()+'InputFields',titleList[1].split(','));
                }
                //fieldSetMap.put('inputFields',rec.Input_Fields__c.split(','));
            }else{
                AuraHandledException auraExceptionObj  = new AuraHandledException('Empty fields in MetaDataRecord');
                auraExceptionObj.setMessage(Label.ErrorCheck_Lightning);
                throw auraExceptionObj;
            }
            if(rec.Buttons__c!=null){
                fieldSetMap.put('buttons',rec.Buttons__c.split(','));
            }
            if (rec.PrePopulated_Values__c != null) {
                fieldSetMap.put('defaults', rec.PrePopulated_Values__c.split(','));
            } else {
                fieldSetMap.put('defaults', ('one||red,two||blue,three||green').split(','));
            }
        } catch(Exception e) {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj; 
        }
        system.debug('fieldSetMap****'+fieldSetMap);
        return fieldSetMap ;
    }
    
    public Map<String,List<String>> onLineDeduplication(List<sObject> sObjList, String filterName){
        try{
            onLineDeduplicationCheck(sObjList,filterName);
            return deduplicationMap;
        }catch(exception e){
            system.debug('entered Exception2');
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;   
        }
        
    }
    
    public String getCDMURL(String Recordtype,Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
        try{
            String url= getCDMURLMarket(Recordtype,objAccount,firstsave,market,AddressObj);
            return url;
        }catch(exception e){
            system.debug('entered Exception2');
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;   
        }
    }
    
    public Map<String,List<String>> submitForm(List<sObject> sObjList, String filterName){
        try{
            saveForm(sObjList,filterName);
            return saveMap;
        }catch(exception e){
            system.debug('entered Exception2');
            AuraHandledException auraExp=new AuraHandledException(e.getMessage());
            auraExp.setMessage(e.getMessage());
            throw auraExp;   
        }
    }
    
    public virtual void onLineDeduplicationCheck(List<sObject> sObjList, String filterName){
        //logic in market specific
    }
    
    public virtual String getCDMURLMarket(String Recordtype,Account objAccount,Boolean firstsave,String market,Address__c AddressObj){
        //logic in market specific
        return null;
    }
    
    public virtual void saveForm(List<sObject> sObjList, String filterName){
        //logic in market specific
    }
}