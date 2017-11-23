/************************************************************************************
* Created By:Sarath M
* Created Date:23-Sept-2017
* Company:Infosys Ltd
* Description: Controller for uploadFileComponent
* **********************************************************************************/
public class uploadFileComponentHelper {
        
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
    
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
            
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion oAttachment = new ContentVersion();
        oAttachment.Title = fileName;
        oAttachment.VersionData = EncodingUtil.base64Decode(base64Data);
        oAttachment.PathOnClient='/' + fileName ;
        insert oAttachment; 
        system.debug('oAttachment.id '+ oAttachment.id);
        oAttachment = [select id, ContentDocumentId from ContentVersion WHERE Id =: oAttachment.Id];
        ContentDocumentLink cl = new ContentDocumentLink();
        cl.ContentDocumentId = oAttachment.ContentDocumentId;
        cl.LinkedEntityId = parentId; 
        cl.ShareType = 'V';
        cl.Visibility = 'AllUsers';
        insert cl;
        system.debug('oAttachment.id');
        return oAttachment.id;
        
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion a = [
            SELECT Id, VersionData
            FROM ContentVersion
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.VersionData);
        
        a.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
}