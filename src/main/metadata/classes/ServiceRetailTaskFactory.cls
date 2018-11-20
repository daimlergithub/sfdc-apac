public class ServiceRetailTaskFactory{
    private static ServiceRetailTsk retInstance{get;set;}
    private static Factory_Fields__mdt metaRec {get;set;}
    public static ServiceRetailTsk retrieveFieldSetValidate(String market,String recordType, String componentName,SObject sObj) {
        String objName=String.valueOf(sObj.getSObjectType()); 
        metaRec=FactoryHelper.getMetaDataRec(objName,market,recordType,componentName);
        if (metaRec.Class_Name__c != null && metaRec.Class_Name__c != ''){
            retInstance = (ServiceRetailTsk)Type.forName(metaRec.Class_Name__c).newInstance();    
        } else {
            retInstance = new ServiceRetailTskDefault();
        }
        retInstance.setmdRec(metaRec);
        return retInstance;   
	}
    
    
}