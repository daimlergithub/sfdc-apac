/**************************************************************************************************************************************************************************** 
* File Name     : LeadDetails
* Description   : This Class is part of the Factory model and is the Interface Class
* Description   : This class uses custom meta data type Factory_Fields__mdt  to retrieve the information for each Market, with the Market being passed from the Lightning Component
* Description   : This class along with LeadDetailsDefault,LeadDetailsFactory are part of the Factory model along with Market specific Classes. 
* Copyright     : Diamler
* @author       : Infosys 
* Author Modification & Ver.Date : Harshit & 31/08/2018
******************************************************************************************************************************************************************/ 
public interface LeadDetails {
    Factory_Fields__mdt getmdRec();
    void setmdRec(Factory_Fields__mdt rec);
    Map<String,Map<String,String>> getFields();
}