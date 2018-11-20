/**************************************************************************************************************************************************************************** 
* File Name     : RetailCopyInfo
* Description   : This Class is part of the Factory model and is the Interface Class
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with RetailCopyInfoDefault,RetailCopyInfoFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public interface RetailCopyInfo {
    RetailCopyInfoDefinition fetchCardTableFields(String recordId,User user);
    LightningDataTableWrapper.DataTableResponse fetchDataTableFields(String recordId,User user);
    String createLinkRecord(Id accountId,Address__c selectedAdd,User user,Id dealerId);  
	void setMetaRec (Factory_Fields__mdt fRec);   
    Factory_Fields__mdt getMetaRec(); 
     
}