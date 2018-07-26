public class CaseCommentCustomController {
    public String comment {get;set;}
    public Case caseObj {get;set;} 
    public String fileName {get;set;}
    public Case_Comment__c caseCommentobj{get;set;}
    public transient Blob fileBody {get;set;}
    
    public CaseCommentCustomController(ApexPages.StandardController controller) { 
        String caseId = controller.getId();
        caseCommentobj = new Case_Comment__c();
        caseObj=[select Id,CaseNumber,Subject from Case where Id=:caseId];
    }   
    
    // creates a new case comment record
    private Database.SaveResult saveCustomCaseComment() {
        caseCommentobj.Case__c = caseObj.Id; 
        //caseCommentobj.comment__c = comment;
        return Database.insert(caseCommentobj);
    }
    
    // create an actual Document record
    private Database.SaveResult saveStandardDocument(Id parentId) {
        
        //Folder folderObj=[select id from folder where DeveloperName='COS_attachments'];
        Case_Comment__c caseCommentObj=[select id,Attachment__c,Subject__C from Case_Comment__c where Id=:parentId];
        //Organization orgDetails = [SELECT Id FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        Database.SaveResult result;
        if(this.fileBody!=null && this.fileName!=null && this.fileName!='')
        {
            /*Document documentObj = new Document();
            documentObj.body = this.fileBody;
            documentObj.Name = this.fileName;
            documentObj.IsPublic=true;
            documentObj.FolderId=folderObj.Id;
            // insert the attahcment
            result = Database.insert(documentObj);*/
            //String base64Data = EncodingUtil.urlDecode(this.fileBody, 'UTF-8');
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.ContentDocumentId = null;
            cv.VersionData = this.fileBody;
            cv.Title = this.fileName;
            cv.PathOnClient = filename;
            insert cv;
            
            ContentVersion contentVersionObj=[select Id,ContentDocumentId from contentVersion where Id=:cv.Id];
            
            ContentDocumentLink cntDocLinkObj=new ContentDocumentLink();
            cntDocLinkObj.ContentDocumentId=contentVersionObj.ContentDocumentId;
            cntDocLinkObj.LinkedEntityId=caseCommentObj.Id;
            cntDocLinkObj.ShareType='I';
            insert cntDocLinkObj;
            
            //contentDistribution object created to get DistributionPublic URL.
            ContentDistribution cd=new ContentDistribution();
            cd.ContentVersionId=cv.Id;
            cd.Name=this.fileName;
            insert cd;
            
            ContentDistribution contentDistObj=[select DistributionPublicUrl from ContentDistribution where contentDocumentId=:contentVersionObj.contentDocumentId];
            caseCommentObj.Attachment__c=contentDistObj.DistributionPublicUrl;
            update caseCommentObj;
            
            //caseCommentObj.Attachment__c=System.URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+result.getId()+'&oid='+orgDetails.Id;
            //update caseCommentObj;
            // reset the file for the view state
            fileBody = Blob.valueOf(' ');
            return result;
        }
        return null;
    }
    
    /**
    * Upload process is:
    *  1. Insert new Case_Comment__c record
    *  2. Insert new Attachment in Document Object.
    *  3. Update the Case_Comment__c record with the URL of the Document.
    **/
    public PageReference saveCaseCommentWithAttachment() {
        try {
            Database.SaveResult customCaseCommentResult = saveCustomCaseComment();
        
            if (customCaseCommentResult == null || !customCaseCommentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                  'Could not save case Comment.'));
                return null;
            }
        
            Database.SaveResult documentResult = saveStandardDocument(customCaseCommentResult.getId());
        
        } catch (Exception e) {
            ApexPages.AddMessages(e);
            return null;
        }
        
        return new PageReference('/'+caseObj.Id);
    }
    
    public PageReference back() {
        return new PageReference('/'+caseObj.Id);
    }     

}