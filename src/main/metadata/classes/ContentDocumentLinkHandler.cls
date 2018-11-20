/************************************************************************************
* Created By:Kavya Bondada
* Project: RCP INDONESIA
* Modified Date:5-sep-2018
* Company:Infosys Ltd
* Description: Trigger call on ContentDocumentLink to provide/restrict file access access on News Object based on document status .			   
* **********************************************************************************/

public class ContentDocumentLinkHandler {
    
    public void onBeforeInsert(List<ContentDocumentLink> contDocLinkList){
        //getting News Prefix
        Schema.DescribeSObjectResult r = News__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        Set<id> refIds=new Set<id>();
        //get all reference Ids of Files
        for(ContentDocumentLink cdl:contDocLinkList){
            refIds.add(cdl.LinkedEntityId);
        }
        system.debug(refIds);
        //get all existing News records based on :reference Ids
        List<News__c> allNews=[select  Id,Document_Status__c,DocStatus_FileUpload__c from News__c where Id in :refIds];
        system.debug(allNews);
        //restricting File access based on its reference News details on Document Status
        for(ContentDocumentLink cdl:contDocLinkList){
            if((String.valueOf(cdl.LinkedEntityId)).startsWith(keyPrefix)){
                for(News__c n:allNews){
                    if(cdl.LinkedEntityId==n.Id && (n.Document_Status__c=='Published'||n.Document_Status__c=='Expired'||n.Document_Status__c=='Pending for Approval' )){
                        cdl.addError('You do not have permission to upload a file to this News');
                    }
                    else if(cdl.LinkedEntityId==n.Id && n.Document_Status__c=='Ready to Publish' && n.DocStatus_FileUpload__c != true ){
                        cdl.addError('You do not have permission to upload a file to this News');
                    }
                    else{
                        cdl.ShareType = 'I';
                        cdl.Visibility = 'AllUsers';
                    }
                }
            } 
        }
        
    }

}