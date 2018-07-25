public class SalesLeadUtility {    
    
    private static List<Car_Model__c> lstSelectedCarModel;
    private static List<String> carSearchFormat = ((String)System.label.CarSearchFormatCriteria).split(',');
    public static void createLeadDetails(Opportunity Opp, List<SelectOption> lstSelectedOptions, Map<Id,Car_Model__c> mapCarModel)
    {
        Set<Lead_Details__c> lstLeadDetails = new Set<Lead_Details__c>();       
        List<Lead_Details__c> lstlead = new List<Lead_Details__c>();
        lstSelectedCarModel = selectedCarModelList(mapCarModel,lstSelectedOptions);
        lstLeadDetails.addAll(CarModelMappingUtility.createLeadDetails(Opp, lstSelectedCarModel, 
                UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type)));
        lstLead.addAll(lstLeadDetails);        
        if(lstLeadDetails.size()>0)
          upsert lstLead;
    }
    public static List<Car_Model__c> selectedCarModelList( Map<Id,Car_Model__c> mapCarModel, List<SelectOption> lstSelectedOptions)
    {
         lstSelectedCarModel = new List<Car_Model__c>();
         for(SelectOption tempSelOption : lstSelectedOptions)
        	lstSelectedCarModel.add(mapCarModel.get(tempSelOption.getValue()));  
        
        return lstSelectedCarModel;
    }   
    public static void updateSelectedCarModel(Opportunity Opp, Map<Id,Car_Model__c> mapCarModel, 
                                              List<SelectOption> lstSelectedOptions)
    {
        String carModelcriteria;
        Car_Model__C tempCarModel;
        lstSelectedCarModel = new List<Car_Model__c>();       
        List<String> carSearchFormat = ((String)System.label.CarSearchFormatCriteria).split(',');
        
        for(SelectOption tempSelOption : lstSelectedOptions)
        {        
			tempCarModel = mapCarModel.get(tempSelOption.getValue())  ;           
            lstSelectedCarModel.add(tempCarModel);
            carModelcriteria= '';
            for(String tempField : carSearchFormat)
           		carModelcriteria += tempCarModel.get(tempField) + ',';
                    
           	if(!(Opp!= null && Opp.Selected_Car_Model__c != null && Opp.Selected_Car_Model__c!= '' 
                 && Opp.Selected_Car_Model__c.contains(carModelcriteria)))
            	opp.Selected_Car_Model__c = carModelcriteria + ';';
           	
        }
    }
    public static void deleteSelectedLeadDetails(Opportunity opp)
    {
    	List<Lead_Details__c> lstLeadDetails = new List<Lead_Details__c>();        
        String query = 'Select id from lead_details__C where Related_Lead__c = \''+opp.Id+'\'';
        lstLeadDetails = Database.query(query);
        if(lstLeadDetails.size()>0)
        delete lstLeadDetails;
    }
    public static List<SelectOption> populateOptions(Map<Id, Car_Model__c> mapCarModels, List<Lead_Details__c> lstLeadDetails, Boolean populateAll)
    {
        Car_Model__c selectedModel;
        List<SelectOption> lstOption = new List<SelectOption>();
        if(populateAll)
        {
            for(Car_model__c tempSelectedModel: mapCarModels.values())
        	  lstOption.add(generateOption(tempSelectedModel));
        }
        else
        {           
            for(Lead_Details__c templead : lstLeadDetails)
        	{
                selectedModel = mapCarModels.get(templead.Car_Model__c);
                if(selectedModel != null)
 					lstOption.add(generateOption(selectedModel));
            }
        }
        return lstOption;
    }
    public static Map<Id,Car_Model__c> populateCarModel(Opportunity Opp)
    {
        return new Map<Id,Car_Model__c>(
            [SELECT Id, Name,Marketing_Class__c, Marketing_Body_Type__c, Variant__c, Fuel_Type__c 
             FROM Car_model__c where DFE_MARKER__c = 'Y' AND Marketing_Class__c != null AND 
             marketing_body_type__c != null AND Market__c = :Opp.Market__c AND Status__c = 'Own Sellable' ]);
    }
    private static SelectOption generateOption(Car_Model__c selectedModel) 
    {
       	String name= '';
	    for(String tempField : carSearchFormat)
    	 	name += selectedModel.get(tempField) + ' ';                        
        name += ';'+String.valueOf(selectedModel.Name);
		name = name.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\\'"]', ' ');
         return (new SelectOption(selectedModel.Id, name));
    }
}