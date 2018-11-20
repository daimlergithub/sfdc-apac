/**************************************************************************************************************************************************************************** 
* File Name     : LeadDetailsDefault
* Description   : This Class is part of the Factory model and is the default class which is executed with out any Market specific logic
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with LeadDetails,LeadDetailsFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************/ 
public virtual class LeadDetailsDefault implements LeadDetails{
    
    private static final String WHAEVER_DELIMITER = '@!';
    
    private Map<String,List<String>> FieldMap{get;set;}
    private Factory_Fields__mdt rec{get;set;}
    public Factory_Fields__mdt  getmdRec()
    {
        return this.rec;    
    }
    public void setmdRec(Factory_Fields__mdt fRec)
    {
        this.rec=fRec;
    }
    public Map<String,List<String>> getFieldMap()
    {
        return this.FieldMap;   
    }
    public void setFieldMap(Map<String,List<String>> fMap)
    {
        this.FieldMap=fMap;
    }
    public Map<String,Map<String,String>> getFields()
    {FieldMap= new Map<String,List<String>>();
     Map<String,Map<String,String>> NormailsedMap = new Map<String,Map<String,String>>();
     system.debug('@@@@'+rec.Output_Fields__c);
     FieldMap=processFields(rec.Output_Fields__c);
     NormailsedMap=getPrepopulatedFields(FieldMap,rec.PrePopulated_Values__c);
     system.debug('FInal Map !!!!!'+NormailsedMap);
     system.debug('final!!!'+FieldMap);     
     //return FieldMap;
     return NormailsedMap;
    }
    private Map<String,Map<String,String>> getPrepopulatedFields(Map<String,List<String>> finalMap, String populatedFields)
    {   
        Map<String,String> FieldValueMap = new Map<String, string>();
        Map<String,Map<String,String>> NormailsedMap= new Map<String,Map<String,String>>();
        if(populatedFields != null)
        {
        system.debug(populatedFields.split(','));
        for(String s : populatedFields.split(','))
        {   if(s.contains('||'))
           {
              FieldValueMap.put(s.substringBefore('||'),s.substringAfter('||')); 
           }
        } }
        system.debug('@@@@'+FieldValueMap);
        for(String s : finalMap.keySet())
        {
          Map<String,String> TempMap = new Map<String,String>();  
            for(String field : finalMap.get(s))
            {
                if(FieldValueMap.containsKey(field))
                {
                    TempMap.put(field,FieldValueMap.get(field));
                }
                else
                {
                    TempMap.put(field,'null');
                }
            }
         NormailsedMap.put(s,TempMap); 
         }
       return NormailsedMap;
    }
    private Map<String,List<String>> processFields(String fields)
    {   Map<String,List<String>> finalMap = new Map<String,List<String>>();
     Map<String,List<String>> FieldSetMap= new Map<String,List<String>>(); 
     Map<String,String> FSSecMap = new Map<String,String>(); 
     List<String> metaList = new List<String>();
     List<String> FieldSetNames = new List<String>();
     try{
         
         metaList = fields.replaceAll('\n','').split(','); //Elemenating all carraige returns for perfecting Admins
         for(String s : metaList) {
             String[] step1 = s.split('Name:');
             String key = step1[0];
             String val =step1[1];
             if(key.endsWith('Fieldset')){
                 // FieldSetNames.add(value);
                 finalMap.put(key,retrieveFieldsFromFieldSetsController.getOneFieldSetValue(val,'Opportunity'));
             } else if (key.endsWith('Component')){
                 finalMap.put(key,val.split('-'));  
             }
         }

         return finalMap;
     }catch(Exception e)
     {
         system.debug(e.getMessage()+e.getStackTraceString());
         return null;
         
     }
     
     
    }
}