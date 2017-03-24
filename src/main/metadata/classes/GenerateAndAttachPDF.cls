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
   public String CustomerStatement{get;set;}
   public String PRCommentForDealer {get;set;}

   /**
    * Escape <br/> tag
    */
   private static final String BR_TG_ESCAPE = '%%br%%';
   /**
    * Regular expresssion for the tag
    */
   private static final String REGEX_TAG = '<.+?>';
   /**
    * <br> tag
    */
   public static final String BR_TG = '<br>';
   /**
    * <br/> tag
    */
   public static final String BR_SLASH_TG = '\n';
   /**
    * Define empty
    */
   public static final String STRING_NONE = '';
   /**
    * Define \n (line break)
    */
   public static final String NEW_LINE_CHARACTER = '\n';
   /**
    * Define "$"
    */
   public static final String DOLLAR_CHARACTER = '$';

   /**
    * Define number of characters per line
    */
   public static final Integer LINE_LENGTH = 57;
    public user usr{get;set;}

   public GenerateAndAttachPDF(ApexPages.StandardController controller) 
   {
       usr = [select id,Market__c from user where id =:userinfo.getUserId()];
       this.cas=(Case)controller.getRecord();  
       cas=[select id,Vehicle__c,CaseNumber,AccountId,Account.FirstName_Native_1__c,Account.LastName_Native_1__c,Customer_Statement__c,PR_Comment_for_Dealer__c from case Where id=:ApexPages.currentPage().getParameters().get(System.Label.Id)];         	
       system.debug('Entered>>>');
       system.debug('First Name Native>>>>>' + cas.Account.FirstName_Native_1__c + 'Last name Native' + cas.Account.LastName_Native_1__c);
       if(cas.Vehicle__c!=Null && cas.AccountId!=Null)
       {
           List<Vehicle_Relationship__c> lstVehicleRelationship=[Select id,Vehicle_ID__c,Contact__c,Selling_Dealer__c,Selling_Dealer__r.Name,Last_Service_Dealer__c,Last_Service_Dealer__r.Name,toLabel(Finance_Method__c),Registration_Date__c,Registration_Number__c
                                                                 from Vehicle_Relationship__c Where Vehicle_ID__c=:cas.Vehicle__c  AND Contact__c=:cas.AccountId limit 1];
           system.debug('lstVehicleRelationship>>>>>>' + lstVehicleRelationship);
           system.debug('lstVehicleRelationship>>>>>>' + lstVehicleRelationship[0]);
           if(lstVehicleRelationship!=null && !lstVehicleRelationship.isEmpty())
           {                                
               VehicleRelationshipList=lstVehicleRelationship[0];               
           }
       }   
   }

    /**     
     * @Description Get the current record Id.  
     * @author  Sneha chail
     * @Date 11/06/2015(mm/dd/yy)   
     * @return Current record Id of a case.
     */ 
   public String recordId 
   {
    get 
	{
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
   public PageReference GenerateAndAttachPDF() 
   {
          
       CustomerStatement= cas.Customer_Statement__c;
       PRCommentForDealer = cas.PR_Comment_for_Dealer__c;
       system.debug('CustomerStatement>>>>'+CustomerStatement);
       CustomerStatement = convertString(CustomerStatement, LINE_LENGTH);
       PRCommentForDealer = convertString(PRCommentForDealer, LINE_LENGTH);
       system.debug('CustomerStatement>>>>'+CustomerStatement);       
       if(String.isBlank(ApexPages.currentPage().getParameters().get(System.Label.displayOnly))) {       
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
      
      /** 
     * @Description Adding line break to the given value 
     * @author  Sergio Kobayashi
     * @Date 03/07/2016(mm/dd/yy)  
     * @Param Value to be added line break and the line length
     * @return value with the line break added
     */
    public static String convertString(final String targetString, final Integer maxByte) {

        // Store the converted strings
        String convertStr = STRING_NONE;

        if (targetString != null) {

            // Replace all <br>
            String targetStr = targetString.replaceAll(BR_TG, BR_TG_ESCAPE);
            targetStr = targetStr.replaceAll(BR_SLASH_TG, BR_TG_ESCAPE);
            // Replace all tags
            targetStr = targetStr.replaceAll(REGEX_TAG, STRING_NONE);
            // Convert line breaks to <br/>
            targetStr = targetStr.replaceAll(
                NEW_LINE_CHARACTER,
                BR_SLASH_TG
            );

            // Convert replaced <br> to <br/>
            targetStr = targetStr.replaceAll(BR_TG_ESCAPE, BR_SLASH_TG);
            // Split at each <br/>
            String[] strList = targetStr.split(BR_SLASH_TG);

            // Line length
            Integer lineLen = 0;

            // Per <br/> is one line
            for (String line : strList) {

                // Total number of bytes in the line
                Integer sum = 0;
                // Index variable
                Integer index = 0;
                // Get the length of the line
                lineLen = line.length();

                // Check number of bytes for each character
                for (Integer i = 0; i < lineLen; i++) {

                    // Get one character
                    String one = line.substring(i, (i + 1));
                    // Calculate number of characters instead of bytes since English and Japanese mixed woulc cause issue.
                    //Integer oneSize = getBytes(one);
                    Integer oneSize = 1;
                    // Total number of bytes
                    sum += oneSize;

                    // If exceeded the maximum number of bytes per line
                    if (sum > maxByte) {
                        // Clear the variables
                        sum = 0;
                        // Add line break
                        convertStr += line.substring(index, (i + 1)) + BR_SLASH_TG;
                        index = i + 1;
                    }
                }
                // Add line break
                convertStr += line.substring(index, (line.length())) + BR_SLASH_TG;
            }
        }

        // Remove br at the end
        convertStr = convertStr.replaceAll(BR_SLASH_TG + DOLLAR_CHARACTER, STRING_NONE);

        return convertStr;
    }
}