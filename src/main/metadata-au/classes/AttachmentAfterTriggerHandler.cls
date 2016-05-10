/*
    Type:       Trigger
    Purpose:    1. As the case team member, when a  team member  add  a Attachment
                   on MB Complaint , and the “Urgent” field of the case is ticked, an notify email will be
                   sent to other case team members.
    User Story:
    Used By:
    ---------------------------------------------------------------
    History:

    5-Dec-2013 Bing (NTTData)  Created
    21-Apr-2015 Gerhard Henning (NTTData)  Moved to AttachmentAfterTriggerHandler
*/
public class AttachmentAfterTriggerHandler 
    implements TriggerHandlerIf
{
    public void handleTrigger()
    {
        
        If(trigger.isInsert && trigger.isAfter){
        List<id> caseIds = new List<id>();
    
        for(Attachment a : (List<Attachment>)trigger.new){
            // for purpose No.1
            String parentIdString = String.valueof(a.parentId);
            if(trigger.isInsert && parentIdString.startsWith('500')){
                caseIds.add(a.parentId);
            }
        }
    
        // for purpose No.1
        if (caseIds.size()>0) {
            ComplaintDesHelper.sendMailToCaseMember(caseIds);
        }
        }
        
        
        If(trigger.isInsert && trigger.isAfter){
            set<id> leadSet = new set<id>();
            list<lead__c> leadList = new list<lead__c>();
            list<Lead_Product__c> leadProductlst = new list<Lead_Product__c>();
            
            for(Attachment a : (List<Attachment>)trigger.new){                
                String parentIdString = String.valueof(a.parentId);
                //if(parentIdString.startsWith('a0s')){
                   leadSet.add(a.ParentId);
              // }
              }
                
                for(lead__c lead:[select id,Attachment_Flag__c from lead__c where id IN:leadSet]){
                    lead.Attachment_Flag__c= true;
                    leadList.add(lead);
                }
                
                if(leadList!= null && !leadList.isEmpty()){
                    try{
                    update leadList;
                    }catch(Exception e){

                    }
                }
                 for(Lead_Product__c leadProductObj :[select id,Attachment_Flag__c from Lead_Product__c where id IN:leadSet]){
                    leadProductObj.Attachment_Flag__c= true;
                    leadProductlst.add(leadProductObj);
                }
                
                if(leadProductlst!= null && !leadProductlst.isEmpty()){
                    try{
                    update leadProductlst ;
                    }catch(Exception e){

                    }
                }


                
                
        }  
            
            
        
        
        if(trigger.isDelete && trigger.isAfter){
            set<id> leadSet = new set<id>();
            list<lead__c> leadList = new list<lead__c>();
            
            
            for(Attachment a : (list<Attachment>)trigger.oldMap.Values()){                
                    String parentIdString = String.valueof(a.parentId);
                    leadSet.add(a.ParentId);
                  
              }
                
             for(lead__c lead:[select id,Attachment_Flag__c,(SELECT Id,Name FROM Attachments) from lead__c where id IN:leadSet]){
                    system.debug('Attachments'+lead.Attachments);
                    if(lead.Attachments.isEmpty()){
                        system.debug('test1111111111111');
                        lead.Attachment_Flag__c= false;
                        leadList.add(lead);
                    }
                }
                
                if(leadList!= null && !leadList.isEmpty()){
                   
                    update leadList;
                }
             system.debug('@@@Laed Product11111@@'+leadSet);
             List<Lead_Product__c> leadProductlist = new List<Lead_Product__c>();
             system.debug('@@@Laed Product@@'+leadSet);
             for(Lead_Product__c leadProductObj :[select id,Attachment_Flag__c,(SELECT Id,Name FROM Attachments) from Lead_Product__c where id IN:leadSet]){ 
                 if(leadProductObj.Attachments.isEmpty()){
                        system.debug('Lead Product:::');
                        leadProductObj .Attachment_Flag__c= false;
                        leadProductlist.add(leadProductObj );
                  }
             }   
             
             if(leadProductlist != null && leadProductlist.size() >0 ){
                 update leadProductlist ;
             }
                
            
            
            
        }
        
    }
}