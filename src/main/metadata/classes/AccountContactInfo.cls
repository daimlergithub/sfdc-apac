/**************************************************************************************************************************************************************************** 
* File Name     : AccountContactInfo
* Description   : This Class is part of the Factory model and is the Interface Class
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with AccountContactInfoDefault,AccountContactInfoFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Sarath & 22/08/2018
******************************************************************************************************************************************************************/ 
public interface AccountContactInfo {
    AccountContactDetailsDefinition getFields();
    void setMetaRec (Factory_Fields__mdt fRec);   
    Factory_Fields__mdt getMetaRec();   
}