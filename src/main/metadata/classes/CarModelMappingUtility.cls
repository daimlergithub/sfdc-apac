public class CarModelMappingUtility {
    
    public static Map<Id, Opportunity> mapIdOpportunity{get;set;} 
    private static String query;
    private static List<Lead_Details__c>  lstLeadDetails;
    private static List<String> stringArgs;
    private static List<Car_Model__c> lstcarModel;
    private static List<String> lstArgs;
    private static List<String> lstMandatoryArgs;
    private static String Type = 'Interested'; 
    private static String leadDetails = 'Lead_Details__c';
    private static String queryPrefix = 'SELECT Id from Car_Model__c where';
    private static String queryClause = ' {0} = \'\'{1}\'\'';
    private static String queryLogic = ' AND ';
    private static String carModellimit = ' '+System.label.CarModelSelectionLimit+' ';  
    private static User varUser =[SELECT Id,Market__c,ContactId  FROM User WHERE Id=:UserInfo.getUserId()];

    public static void mapCarModelOpportunity()
    {
        
        lstArgs = new List<String>();
        lstMandatoryArgs = new List<String>();
        lstLeadDetails = new List<Lead_Details__c>();
        lstArgs = ((String)System.label.CarModelArgs).split(',');
        lstMandatoryArgs = ((String)System.label.CarModelMandatoryArgs).split(',');
        String recordTypeId = UtilRecordType.getRecordTypeIdByName(leadDetails, System.Label.Lead_Detail_Interested_Record_Type);
      
        for(Opportunity tempOpp : mapIdOpportunity.values())
        {           
            if(tempOpp.Selected_Car_Model__c != null && tempOpp.Selected_Car_Model__c != '')
            {
                getCarModels(tempOpp);    
            	lstLeadDetails.addAll(createLeadDetails(tempOpp,lstcarModel,recordTypeId));
            }
        }
        if(lstLeadDetails != null && lstLeadDetails.size()>0)
        {
            try
            {
            	Database.insert(lstLeadDetails);
            }
            catch(Exception e)
            {
            }
        }
    }    
    
    private static void getCarModels(Opportunity selectedOpportunity)
    {        
        List<String> carModelAttrib;
  		List<String> carModelType = new List<String>();
        lstcarModel = new List<Car_Model__c>();        
        carModelType = selectedOpportunity.Selected_Car_Model__c.split(';');
        for(String tempCarModelType : carModelType)
        {
            query = queryPrefix;
            carModelAttrib = new List<String>();
            carModelAttrib = tempCarModelType.split(',');  
            if(carModelAttrib.size()<lstArgs.size())
            {
            	while(carModelAttrib.size()<lstArgs.size())
                	carModelAttrib.add(' ');
            }
			 //Sada 2018/June/5 changed as per DF-180. 
            //carModelAttrib.add(varUser.Market__c);
			carModelAttrib.add(selectedOpportunity.Market__c);
            carModelAttrib.add('Y'); 
            lstArgs.addAll(lstMandatoryArgs);
          	createStringArgs(lstArgs,carModelAttrib);
            try
            {
                lstcarModel.addAll((list<Car_model__c>)Database.query(query));
            }
            catch(Exception e)
            {
                selectedOpportunity.addError('Something has gone Wrong. Please contact Administrator for assistance');
            }
        }
    }   
    public static Set<Lead_Details__c> createLeadDetails (Opportunity varOpportunity, List<Car_Model__c> lstCarModel, Id recordTypeId)
    {
        Lead_Details__c varLeadDetails;
        List<String> lstCarModelRelatedLeadId = new List<String>();
        Set<Lead_Details__c> lstLeadDetail = new Set<Lead_Details__c>();
        try
        {
        	lstLeadDetail.addAll([Select id,Car_model__c,Related_Lead__c from lead_Details__c where Market__c = :varOpportunity.market__c 
                              AND Type__c = 'Interested' AND Related_lead__c = :varOpportunity.Id]);
        }
        catch(Exception ex)
        {
            
        }
        for(Lead_Details__c tempDet : lstLeadDetail)
        	lstCarModelRelatedLeadId.add(tempDet.Car_model__c+';'+ tempDet.Related_Lead__c);        
        
        if(lstCarModel != null && lstCarModel.size()>0)
        {
        	for(Car_Model__c tempCarModel : lstcarModel)
            {                
                if(!lstCarModelRelatedLeadId.contains(tempCarModel.Id+';'+varOpportunity.Id))
                {
                    varLeadDetails = new Lead_Details__c();
                    varLeadDetails.Car_Model__c = tempCarModel.Id;
                    varLeadDetails.Related_Lead__c = varOpportunity.Id;
                    varLeadDetails.Market__c = varOpportunity.Market__c;
                    varLeadDetails.RecordTypeId = recordTypeId;
                    varLeadDetails.Type__c = Type;               
                    lstLeadDetail.add(varLeadDetails);
                }
            }  
    	}        
        return lstLeadDetail;
    }
    private static void createStringArgs(List<String> APIName, List<String> values)
    {        
        for(integer i=0;i<APIName.size();i++)
        {
            stringArgs = new List<String>();
            if(values[i] != null && values[i].trim() != '')
            {
                stringArgs.add(APIName[i]);         	
            	stringArgs.add(values[i]);
                query += String.format(queryClause,stringArgs);
                if(i < APIName.size()-1)
               	 query += queryLogic;
            }     
        }
        query += carModellimit;
        System.debug('Value of Query' + query);
    }
}