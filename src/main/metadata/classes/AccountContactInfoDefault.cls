/**************************************************************************************************************************************************************************** 
* File Name     : AccountDisplayAndValidationDefault
* Description   : This Class is part of the Factory model and is the default class which is executed with out any Market specific logic
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with AccountDisplayAndValidationInterface,AccountDisplayAndValidationFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class AccountContactInfoDefault implements AccountContactInfo {
    Factory_Fields__mdt rec;
    public Factory_Fields__mdt getMetaRec(){return this.rec;}      
    public void setMetaRec (Factory_Fields__mdt fRec){this.rec=fRec;}   
    public AccountContactDetailsDefinition getFields()
    {
        try
        {
            if(rec.Input_Fields__c!=null && rec.Input_Fields__c!='')
            {
                return(processFields(rec.Input_Fields__c, new AccountContactDetailsDefinition()));
            }
            else
            {
                AuraHandledException auraExceptionObj  = new AuraHandledException('Empty fields in MetaDataRecord');
                auraExceptionObj.setMessage(Label.ErrorCheck_Lightning);
                throw auraExceptionObj;
            }
        }
        catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj;  
        }
    }
    @TestVisible
    private AccountContactDetailsDefinition processFields(string fields,AccountContactDetailsDefinition actDataObj){
        Map<string,list<string>> accFieldMap=new Map<string,list<string>>();
        Map<String, String> accFieldLabelMap = UtilLTG.retrieveFieldLables(rec.sObject__c);
        try 
        {            
            for(string ioField : fields.split('}') )
            {
                string tileHeading='';
                
                for (string fname : ioField.split(',') )
                {
                    system.debug('actDataObj.thList' +actDataObj.thList);
                    if(fName.containsIgnoreCase('-'))
                    {
                        list<string> splitR = fName.split('-');
                        if(!actDataObj.apiLabelMap.containsKey(splitR[0]))
                        {
                            actDataObj.apiLabelMap.put(splitR[0],accFieldLabelMap.get(splitR[0]));
                        }
                        if (accFieldMap.containsKey(tileHeading))
                        {
                            list<string> ioFields= new list<string>();
                            ioFields=accFieldMap.get(tileHeading);
                            iofields.add(splitR[0]);
                            accFieldMap.put(tileHeading,iofields);                              
                        }
                        else
                        {
                            accFieldMap.put(tileHeading,new list<string>{splitR[0]});       
                        }
                        if(actDataObj.labelTHMap.containsKey(tileHeading))
                        {
                            list<string> ioLabels= new list<string>();
                            ioLabels=actDataObj.labelTHMap.get(tileHeading);
                            ioLabels.add(accFieldLabelMap.get(splitR[0]));
                            actDataObj.labelTHMap.put(tileHeading,ioLabels);
                        }
                        else
                        {
                            actDataObj.labelTHMap.put(tileHeading,new list<string>{accFieldLabelMap.get(splitR[0])});       
                        }  
                    }
                    else if (fName.containsIgnoreCase(':'))
                    {
                        if(!actDataObj.iconTHMap.containsKey(tileHeading))
                        {
                            actDataObj.iconTHMap.put(tileHeading,fName);  
                        }
                    }
                    else
                    {
                        tileHeading=fName;
                        if(!actDataObj.thList.contains(tileHeading))
                        {
                            actDataObj.thList.add(tileHeading);
                        }   
                        system.debug('tileHeading' +tileHeading);
                    }
                }
            }  
            
            if (actDataObj.inputFieldsMap.isEmpty()){
                actDataObj.inputFieldsMap = accFieldMap;
                processFields(rec.Output_Fields__c,actDataObj) ; // to fetch Output Fields
            }
            else{
                actDataObj.outputFieldsMap = accFieldMap;
            }            
            
            return actDataObj;          
        }
        catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj;  
        } 
    } 
}