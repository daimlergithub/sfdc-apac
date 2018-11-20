/**************************************************************************************************************************************************************************** 
* File Name     : RetailCopyInfoAUNZ
* Description   : This Class is part of the Factory model and is the Market Specific Class
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with RetailCopyInfoDefault,RetailCopyInfoFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys  
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public class RetailCopyInfoAUNZ extends RetailCopyInfoDefault implements RetailCopyInfo{
    public override String createLinkRecordAdditionalFields(Account retrievepersonAccount,Account_Link__c newAlk,Address__c retrieveSelectedAddress,Id accPerson_RecordTypeId,Id accCompany_RecordTypeId,Boolean hasContactId){
        List<Account_Link__c> InsertAlk=new List<Account_Link__c>();
        String errorMsg='Success';
        try{ 
            if (retrievepersonAccount.RecordtypeId == accPerson_RecordTypeId) {
                sObjectMappingUtility varMapUtil = new sObjectMappingUtility(retrievepersonAccount.Md__c,'Create_RetailCopy_PersonAccount');
                varMapUtil.mapFieldValues(retrievepersonAccount, newAlk);
                if (retrieveSelectedAddress != null){
                    sObjectMappingUtility varAddrMapUtil = new sObjectMappingUtility(retrievepersonAccount.Md__c,'Create_AddressRetailCopy_PersonAccount');
                    varAddrMapUtil.mapFieldValues(retrieveSelectedAddress, newAlk);
                }
            }else if (retrievepersonAccount.RecordtypeId == accCompany_RecordTypeId) {
                sObjectMappingUtility varMapUtil = new sObjectMappingUtility(retrievepersonAccount.Md__c,'Create_RetailCopy_CompanyAccount');
                varMapUtil.mapFieldValues(retrievepersonAccount, newAlk);
                if (retrieveSelectedAddress != null){
                    sObjectMappingUtility varAddrMapUtil = new sObjectMappingUtility(retrievepersonAccount.Md__c,'Create_AddressRetailCopy_CompanyAccount');
                    varAddrMapUtil.mapFieldValues(retrieveSelectedAddress, newAlk);
                }
            }
            if (retrieveSelectedAddress != null){
                newAlk.Retail_Address_Line_1__c = ((retrieveSelectedAddress.Address_Line_1__c)!=null?retrieveSelectedAddress.Address_Line_1__c:'').left(35);
                newAlk.Retail_Address_Line_2__c = ((retrieveSelectedAddress.Address_Line_2__c)!=null?retrieveSelectedAddress.Address_Line_2__c:'').left(35);
                newAlk.Retail_Address_Line_3__c = ((retrieveSelectedAddress.Address_Line_3__c)!=null?retrieveSelectedAddress.Address_Line_3__c:'').left(35);
                newAlk.Retail_Address_CreatedDate__c = Date.ValueOf(retrieveSelectedAddress.CreatedDate);
                newAlk.Retail_Address_LastModifiedDate__c = Date.ValueOf(retrieveSelectedAddress.LastModifiedDate);
            }
            InsertAlk.add(newAlk); 
            if(!InsertAlk.isEmpty()){
                insert InsertAlk;
            }
        }catch(System.DMLException dmlExp){
            String errorMessage = dmlExp.getMessage();
            if(errorMessage.containsignorecase('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                AuraHandledException auraExceptionObj = new AuraHandledException(dmlExp.getDMLMessage(0));
                auraExceptionObj.setMessage(dmlExp.getDMLMessage(0));
                CustomLogUtil.CustomLoggingEntry('Error Occured ' +dmlExp.getMessage()+ dmlExp.getStackTraceString());
                throw auraExceptionObj;
            }
            else
            {
                AuraHandledException auraExceptionObj = new AuraHandledException(dmlExp.getDMLMessage(0));
                auraExceptionObj.setMessage(Label.ErrorCheck_Lightning+ dmlExp.getStackTraceString());
                CustomLogUtil.CustomLoggingEntry('Error Occured ' +dmlExp.getMessage()+ dmlExp.getStackTraceString());
                throw auraExceptionObj;   
            }
        }catch(Exception e){
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(Label.ErrorCheck_Lightning + e.getStackTraceString());
            CustomLogUtil.CustomLoggingEntry('Error Occured ' +e.getMessage()+ e.getStackTraceString());
            throw auraExceptionObj;
        }
        return errorMsg;
    }
}