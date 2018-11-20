/* File Name   : createRetailCopyLCController -->
<!-- Description : createRetailCopyLCController apex class supported for createRetailCopyLC -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 18-June-2018  */
public class createRetailCopyLCController {
    @AuraEnabled     
    public static RetailCopyInfoDefinition fetchCardFields (String recordId,String componentName)
    {      
        RetailCopyInfoDefinition resultFields=new RetailCopyInfoDefinition();
        if((recordId!=null && recordId!='') && (componentName!=null && recordId!=''))
        {    
            try
            {	   
                system.debug('recordId' +recordId);   
                User user=UtilLTG.getUserRec(userInfo.getuserId());   
                RetailCopyInfo valObj = RetailCopyInfoFactory.fetchInstance(componentName,user.market__c);
                resultFields = valObj.fetchCardTableFields(recordId,user);   
            }
            catch(Exception e){
                AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            	auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getMessage());
            	throw auraExceptionObj;
            }   
        }
        return resultFields;  
    }
    
    @AuraEnabled
    public static LightningDataTableWrapper.DataTableResponse  fetchLDTFields (String recordId,String componentName)
    {  
        LightningDataTableWrapper.DataTableResponse resultFields = new LightningDataTableWrapper.DataTableResponse();
        if((recordId!=null && recordId!='') && (componentName!=null && recordId!=''))
        {
            try{
                
                User user=UtilLTG.getUserRec(userInfo.getuserId());
                RetailCopyInfo valObj = RetailCopyInfoFactory.fetchInstance(componentName,user.market__c); 
                resultFields = valObj.fetchDataTableFields(recordId,user);
                system.debug('resultFields' +resultFields);
                
            }catch(Exception e){
                AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            	auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getMessage());
            	throw auraExceptionObj;
            }
        }
        return resultFields;
    }
    
/* @AuraEnabled
public static List<String> getCustomPermissions(){
List<String> permissionList = new List<String>();
permissionList = Util_getPermissions.getCustomPermissions(UserInfo.getUserId());
system.debug('<<permissionList'+permissionList);
return permissionList;
}*/
    @AuraEnabled
    public static String createRetailCopyRecord(Id accountId,Address__c selectedAdd, Id dealerId,String componentName){
        try{
            User user=UtilLTG.getUserRec(userInfo.getuserId());
            RetailCopyInfo valObj = RetailCopyInfoFactory.fetchInstance(componentName,user.market__c); 
            String resultFields = valObj.createLinkRecord(accountId,selectedAdd,user,dealerId);
            system.debug('resultFields' +resultFields);
            return resultFields; 
        }catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getMessage());
            throw auraExceptionObj; 
        }
    }
}