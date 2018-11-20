/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:02-Aug-2018
* Company:Infosys Ltd
* Description:Class to check file is uploaded related to Community File.
* **********************************************************************************/
public with sharing class FileUploadController {
    @AuraEnabled
    public List<String> userList;
    @AuraEnabled
    public List<string>  AllPublicGroups;
    @AuraEnabled
    public List<string> selectedUsers;
    @AuraEnabled
    public List<string>  selectedGroups;
    @AuraEnabled
    public static boolean getrelatedFileStatus(Id fId){
        ContentDocumentLink c = new ContentDocumentLink();
        List<ContentDocumentLink> CDLlist = new  List<ContentDocumentLink>();
        CDLlist = [select Id,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: fId];
        if(CDLlist != null && CDLlist.size()>0)
            return true;
        
        else
            return false;
    }
    @AuraEnabled
    public static boolean getFileStatus(Id fId){        
        Community_Files__c cf = [select id,OwnerId from Community_Files__c where Id=:fId];        
        if(cf.OwnerId == UserInfo.getUserId()){           
            return false;
        }
        return true;        
    }    
    //Added :By kavya 
    //Used to retrieve file details when editing File record
    @AuraEnabled
    public static Community_Files__c getFileDetails(Id fileId){
        Community_Files__c file = new Community_Files__c();
        file = [SELECT Name, Expiration_Date__c,Sharing_Level__c,SelectedUsers__c,SelectedGroups__c
                from Community_Files__c
                WHERE Id=:fileId];
        return file;
    }
    
}