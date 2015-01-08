/*
    Type:       Extension for CarModelComparison Visualforce page 
    Purpose:    Compare the attributes of the chosen three cars
    User Story: US-Knowledge-003
    Used By:    CarModelComparison.page
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-03-07
*/
public with sharing class CarModelComparisonController {
    public Map<String, List<String>> typeWithNamesMap   {get; set;}
    public List<Integer> proxySequences                 {get; set;}
    public List<Car_Model_Attribute__c> proxies         {get; set;}
    public List<Integer> chosenProxySequences           {get; set;}
    public List<Car_Model_Attribute__c> chosenProxies   {get; set;}
    public Map<Id, Car_Model__c> carModelsMap           {get; set;}
    
    // Used to display Car Model Picture in related Attachment
    public Map<Id, String> modelId2AttachmentIdMap      {get; set;}
    
    // Attribute Type + Attr Name + Car Model Id => Car Model Attribute Value
    public Map<String, String> combineMap               {get; set;}
    
    // If no Car Model Attributes, don not display campare section
    public Boolean hasCarModelAttributes                {get; set;}
    
    // Define Picture Attachment File Extension
    private final Set<String> PICTURE_EXTENSIONS = 
        new Set<String> {
            '.BMP', '.JPG', 
            '.JPEG', '.PNG',
            '.GIF'
    };

    // Numbers of Car Models to compare
    // You can change it to more than 3 cars
    private final Integer NUM_OF_CAR_MODELS = 3;

    public CarModelComparisonController() {
        // Initiate cars
        proxySequences = new List<Integer>();
        proxies = new List<Car_Model_Attribute__c>();
        for (Integer i = 0; i < this.NUM_OF_CAR_MODELS; i++) {
            proxySequences.add(i);
            proxies.add(new Car_Model_Attribute__c());
        }
        
        // proxies[0].Car_Model__c = 'a13N0000002NV1z';
        // proxies[1].Car_Model__c = 'a13N0000001XwGR';
        // proxies[2].Car_Model__c = 'a13N0000002NV25';
        //proxies[3].Car_Model__c = 'a13N0000001XwWK';
        //proxies[4].Car_Model__c = 'a13N0000001GtDC';
        
        // Initiate chosenProxies, chosenProxies and combineMap
        typeWithNamesMap = new Map<String, List<String>>();
        combineMap = new Map<String, String>();
        chosenProxies = new List<Car_Model_Attribute__c>();
        
        this.pouplateCompareResult();
    }

    public void pouplateCompareResult() {
        // Populate chosenProxies
        chosenProxies.clear();
        for (Car_Model_Attribute__c proxy : proxies) {
            if (proxy.Car_Model__c != null) {
                chosenProxies.add(proxy);
            }
        }
        
        if (chosenProxies.size() == 0) {
            return;
        }
        
        System.debug('chosenProxies=>' + chosenProxies);
        chosenProxySequences = new List<Integer>();
        for (Integer i = 0; i< chosenProxies.size(); i++) {
            chosenProxySequences.add(i);
        }
        
        // Get the Car Model Ids from proxies
        Set<Id> carModelIds = new Set<Id>();
        for (Car_Model_Attribute__c proxy : proxies) {
            carModelIds.add(proxy.Car_Model__c);
        }
        
        // Populate carModelsMap
        carModelsMap = this.getCarModelMap(carModelIds);

        // Populate combineMap and typeWithNamesMap
        Set<String> allAttributeTypes = new Set<String>();
        Set<String> allAttributeNames = new Set<String>();
        for (Car_Model__c car : carModelsMap.values()) {
            for (Car_Model_Attribute__c attr : car.Car_Model_Attribute__r) {
                allAttributeTypes.add(attr.Attribute_Type__c);
                allAttributeNames.add(attr.Attribute__r.Name);
            }     
        }

        // Popualte combineMap
        for (String attributeType : allAttributeTypes) {
            Set<String> attributeNames = new Set<String>();
            for (Car_Model__c car : carModelsMap.values()) {
                for (Car_Model_Attribute__c attr : car.Car_Model_Attribute__r) {
                    // Populate value in typeWithNamesMap by key
                    if (attributeType == attr.Attribute_Type__c) {
                        attributeNames.add(attr.Attribute__r.Name);
                    }
                    
                    // Populate combineMap
                    if (attr.Value__c != null) {
                        combineMap.put(attributeType + attr.Attribute__r.Name + 
                            attr.Car_Model__c, attr.Value__c);
                    }
                    else {
                        combineMap.put(attributeType + attr.Attribute__r.Name + 
                            attr.Car_Model__c, '');
                    }
                }
            }
            
            // Populate typeWithNamesMap
            typeWithNamesMap.put(attributeType, new List<String>(attributeNames));
        }

        hasCarModelAttributes = combineMap.size() > 0;
        if (!hasCarModelAttributes) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 
                'The choosen car models has no attribute'));
            return;
        }

        // Prevent Map key <key> not found in map
        // http://salesforce.stackexchange.com/questions/5190/how-to-handle-maps-with-no-key-match
        // Populate the value that is null with blank.
        for (String type : allAttributeTypes) {
            for (String name : allAttributeNames) {
                for (Id carModelId : carModelsMap.keySet()) {
                    String key = type + name + carModelId;
                    if (!combineMap.containsKey(key)) {
                        combineMap.put(key, '');
                    }
                }
            }
        }
        
        System.debug(combineMap);

        // Populate modelId2AttachmentIdMap
        modelId2AttachmentIdMap = new Map<Id, String>();
        for (Car_Model__c model : carModelsMap.values()) {
            Attachment pictureAtt;
            for (Attachment att : model.Attachments) {
                String extensionName = att.Name.subString(att.Name.lastIndexOf('.'),  
                    att.Name.length());

                if (PICTURE_EXTENSIONS.contains(extensionName.toUpperCase())) {
                    pictureAtt = att;
                    break;
                }
            }

            modelId2AttachmentIdMap.put(model.Id, 
                pictureAtt == null ? 'empty' : pictureAtt.Id);
        }

    }
    
    public Map<Id, Car_Model__c> getCarModelMap(Set<Id> carModelIds) {
        return new Map<Id, Car_Model__c>(
            [SELECT Id, Name, Brand__c, Series__c,
                Model__c, Description__c, 

                (SELECT Id, Attribute_Type__c, 
                        Attribute_Category__c,
                        Attribute__r.Name, Model__c, 
                        Value__c, Car_Model__c 
                 FROM Car_Model_Attribute__r
                 ORDER BY Attribute_Type__c, Attribute__r.Name),

                (SELECT Id, Name FROM Attachments)
            FROM Car_Model__c
            WHERE Id IN :carModelIds]);
    }
    
    public void compare() {
        this.pouplateCompareResult();
    }
    
    public String getValueByParam(String param) {
        String value = ApexPages.currentPage().getParameters().get(param);
        return value;
    }
    
    public PageReference cancel() {
        String retURL = this.getValueByParam('retURL');
        return new PageReference(retURL);
    }
}