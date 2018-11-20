public class ServiceRetailTaskLTG
{
    public static List<Sobject> getRecords(Id acc,List<String> outputFields) {
        {
            try
            {
                list<Retail_Task__c> retlist; 
                User loggedInUser=[Select id, market__c, contact.account.id from User where id=:UserInfo.getUserId()];
                String query= 'SELECT Id, ' + String.join(outputFields,',') + ' from Retail_Task__c  '+'WHERE ( (Related_Contact__c = \''+acc+'\') OR (Related_Contact2__c = \''+acc+'\') OR (Related_Contact3__c = \''+acc+'\') OR (Related_Contact4__c = \''+acc+'\')) and Recordtype.name = \'Service\' '; 
                if(acc!=null)
                {    
                    // if condition added for Dealer users of MY to have Access to all Retail Task (Service History) records of the Vehicle related to only that dealer
                    if(loggedInUser.market__c==Label.MarketMY && Util_GetPermissionList.checkAccessOnUser(Label.MYDealer)){
                        query = query + ' and Related_Dealer__c = \''+loggedInUser.contact.account.id +'\'  ORDER BY Service_Date__c  DESC';
                    }
                    else{
                        query = query + ' ORDER BY Service_Date__c  DESC';
                    }
                    retlist = Database.query(query);
                }
                return retList;
                
            } catch (QueryException e) {
                //throw new AuraHandledException(e);
                return null;
            }
            
        }
    }
    
    @AuraEnabled
    public static LightningDataTableWrapper.DataTableResponse getResponse(String market, String recordType, String componentName,Id recordId){
        //User user=[select id,Market__c,ContactId from User where id=:UserInfo.getUserId()];
        //market=user.Market__c; 
        ServiceRetailTsk valObj = ServiceRetailTaskFactory.retrieveFieldSetValidate(market, recordType, componentName, new Retail_Task__c() );
        
        Map<String,List<String>> valresult = valObj.retrieveFieldSet(new Retail_Task__c(),componentName,recordType,market);
        LightningDataTableWrapper ldt = new LightningDataTableWrapper();        
        ldt.strObjectName='Retail_Task__c';
        ldt.fieldsToDisplay=valresult.get('outputFields');
        ldt.dataToDisplay=getRecords(recordId,valresult.get('outputFields'));
        ldt.buttonsToDispaly=valresult.get('buttons');
        ldt.ColumnsToDisplay=valresult.get('Table Columns');
        LightningDataTableWrapper.DataTableResponse tableresponse= ldt.getSobjectList();
        return tableresponse;
    }
    
}