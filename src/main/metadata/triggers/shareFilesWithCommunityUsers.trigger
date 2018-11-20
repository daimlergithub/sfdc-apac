/************************************************************************************
* Created By:Kavya Bondada
* Project: RCP INDONESIA
* Modified Date:5-sep-2018
* Company:Infosys Ltd
* Description: Trigger on ContentDocumentLink to provide/restrict file access access on News Object .			   
* **********************************************************************************/

trigger shareFilesWithCommunityUsers on ContentDocumentLink (before insert) {
 
    if(trigger.isbefore){
        if( trigger.isInsert){
            ContentDocumentLinkHandler CDH = new ContentDocumentLinkHandler();
            CDH.onBeforeInsert(Trigger.new);
        }
    }
}