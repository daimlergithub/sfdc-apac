public with sharing class PrintPDF {
public Lead__c cas{get;set;}
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

   public PrintPDF (ApexPages.StandardController controller) {
      usr = [select id,Market__c from user where id =:userinfo.getUserId()];
      this.cas=(Lead__c)controller.getRecord();  
      cas=[select id,Name,Lead_Type__c,Lead_DataSource__c,Vehicle_Need__c,Is_Assigned__c,Dealer_Lead_Status__c,Lost_Dealer_Date__c,Lead_Possibility__c,Lead_Possibility_text__c,Lost_Situation__c,Purchase_Amount__c,Price_Range_From__c,Price_Range_To__c,Dealer_Audit__c,Dealer_Audit_Result__c,Contact_Failed_For_3_Days_Date__c,Re_visit__c,Team__c,Next_Contact__c,CAC_Lead_Status__c,Lead_Sub_Type__c,Source_Campaign__c,Vehicle_Need_Text__c,CAC_Lost_Reason__c,Dealer_Lost_Reason__c,Lost_Comment__c,Lost_To__c,Lost_CAC_Date_Time__c,Lead_Priority__c,Reserve_Flag__c,Relation_With_The_Leads__c,Qualified_Date_Time__c,Need_Assign_To_Dealer__c,Is_Active__c,Is_Qualify__c,Network_Registration_Date__c,Batch_No__c,Quotation_Date__c,Next_Contact_Customer_Date__c,Case__c  from Lead__c Where id=:ApexPages.currentPage().getParameters().get(System.Label.Id)];     
    }
    
   
}