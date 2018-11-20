public class CaseCommentCustomController {
    public String comment {get;set;}
    public Case caseObj {get;set;} 
    public String fileName {get;set;}
    public static boolean IsTriggerRunRequired;
    public Case_Comment__c caseCommentobj{get;set;}
    public transient Blob fileBody {get;set;}
    
    public CaseCommentCustomController(ApexPages.StandardController controller) { 
        String caseId = controller.getId();
        caseCommentobj = new Case_Comment__c();
        caseObj=[select Id,CaseNumber,Subject from Case where Id=:caseId];
    }   
    
    // creates a new case comment record
    public Database.SaveResult saveCustomCaseComment() {
        caseCommentobj.Case__c = caseObj.Id; 
        return Database.insert(caseCommentobj);
    }
    
    // create an actual file record with attachment
    public void saveFile() {

        //When a case comment is inserted with an attachment
        if(this.fileBody!=null && this.fileName!=null && this.fileName!='')
        {
            IsTriggerRunRequired=false;
            Database.SaveResult customCaseCommentResult = saveCustomCaseComment();
        
            if (customCaseCommentResult == null || !customCaseCommentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                  'Could not save case Comment.'));
                return;
            }
            Case_Comment__c caseCommentObj=[select id,Attachment__c,Subject__C from Case_Comment__c where Id=:customCaseCommentResult.getId()];
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
			
			ContentDistribution cd=new ContentDistribution();
            cd.ContentVersionId=cv.Id;
            cd.Name=this.fileName;
            insert cd;
            
            IsTriggerRunRequired=true;
            
            ContentDistribution contentDistObj=[select DistributionPublicUrl from ContentDistribution where contentDocumentId=:contentVersionObj.contentDocumentId];
            caseCommentObj.Attachment__c=contentDistObj.DistributionPublicUrl;
            update caseCommentObj;
            
            // reset the file for the view state
            fileBody = Blob.valueOf(' ');
           
        }
        else//When case comment is added without the attachment
        {
            IsTriggerRunRequired=true;
            Database.SaveResult customCaseCommentResult = saveCustomCaseComment();
        
            if (customCaseCommentResult == null || !customCaseCommentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                  'Could not save case Comment.'));
                return;
            }
        }
        
    }
    
    /**
    * Upload process is:
    *  1. Insert new Case_Comment__c record
    *  2. Insert new Attachment in Document Object.
    *  3. Update the Case_Comment__c record with the URL of the Document.
    **/
    public PageReference saveCaseCommentWithAttachment() {
        try {
        
            saveFile();
        
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