/**
** Generate pdf file for a case and file should be attached in Attachment object.
** Audit Trail should be generated on downloading the pdf file.
** Created By: Sneha 
** Date: 11/06/2015(mm/dd/yy)    
**/  
public with sharing class GenerateAndAttachPDF {
   public Case cas{get;set;}
   public String attachmentName;
   public Vehicle_Relationship__c VehicleRelationshipList{get;set;}
  
   public GenerateAndAttachPDF(ApexPages.StandardController controller) {
      this.cas=(Case)controller.getRecord(); 
      
    }
    /**     
     * @Description Get the Vehicle_relationship records having same Account and vehicle as case .  
     * @author  Sneha chail
     * @Date 1/27/2016(mm/dd/yy)   
     * @return records of vehicle Relationship 
     */  
    public Vehicle_Relationship__c  getvehicleRelation(){
       VehicleRelationshipList=[Select id,Vehicle_ID__c,Contact__c,Selling_Dealer__c,Last_Service_Dealer__c,Registration_Date__c,Registration_Number__c 
                                    from Vehicle_Relationship__c Where Vehicle_ID__c=:cas.Vehicle__c  AND Contact__c=:cas.AccountId limit 1];
        if(VehicleRelationshipList!=Null){
          return VehicleRelationshipList;
        }
        else{
         return null;
        }        
    }
    /**     
     * @Description Get the current record Id.  
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)   
     * @return Current record Id of a case.
     */ 
   public String recordId {
    get {
      return ApexPages.currentPage().getParameters().get(System.Label.Id);
    }
  }
    /** 
     * @Description pdf should be generated for the associated case.  
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)   
     * @return generated pdf file
     * @see GeneratePDF Page
     */
   public PageReference GenerateAndAttachPDF() {
     if (String.isBlank(ApexPages.currentPage().getParameters().get(System.Label.displayOnly))) {
       Id attachmentId = savePDF();
       generateAuditTrail();
       return openPDF(attachmentId);
     } else {
      return null;
     }
   }
    /** 
     * @Description Creating attachement record  for the current case.  
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)  
     * @return Id of an attachment record
     */
     public Id savePDF() {
        Attachment attachment = new Attachment();
        attachment.ParentId = recordId;
        attachment.name =System.Label.Case+''+cas.CaseNumber+':'+String.valueof(Datetime.now())+'.pdf';
        PageReference pdf = Page.GeneratePDF;
        pdf.getParameters().put('Id', recordId);
        pdf.getParameters().put(System.Label.displayOnly,'1');
        pdf.setRedirect(true);
        try {
          attachment.Body = pdf.getContent();
        }
        catch (VisualForceException e) {
          attachment.Body = Blob.valueof(System.Label.AttachedPdfError);
        } 
        attachment.ContentType = System.Label.applicationpdf;
        insert attachment;
        attachmentName=attachment.Name;
        return attachment.Id;
      }
      /** 
     * @Description Inserting Audit Trail only on generation of a pdf file. 
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)  
     */
      public void generateAuditTrail(){
         Audit_Trail__c auditTrail=new Audit_Trail__c();
         auditTrail.User__c=userInfo.getuserId();
         auditTrail.Date_of_Change__c=system.now();
         auditTrail.Name__c=recordId;//CaseNumber;
         auditTrail.Action__C=System.Label.Downloadedfile+attachmentName;
         insert auditTrail;
      } 
      /** 
     * @Description Generating pdf file.  
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)  
     * @Param paasing attachment's Id.
     * @return generated pdf file
     */
      public PageReference openPDF(Id attachmentId) {
        PageReference ret = new PageReference(system.Label.servletfile+attachmentId);
        ret.setRedirect(true);
        return ret;
      }
  }