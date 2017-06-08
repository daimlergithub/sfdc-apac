/*
  1.Trigger to update Leads' "Lead Latest Phase" field according to the Conditions
  Created By: Venkataramana Cheedara
  Date: 2016-11-03
*/
public class LeadLatestPhaseUpdateJP {
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();

    public static void LeadLatestPhaseUpdate(list<Lead__c> rtlst, boolean isInsert, boolean isUpdate){
    
        for(Lead__c led: rtlst){
            if(led.MD__c == 'JP'){
              system.debug('>>>>>>>>'+led.Invoice_Date__c);
              system.debug('>>>>>>>>'+led.Recordtype.name);
              
                if(led.Handover_Date__c != Null && led.Lead_Latest_Phase__c != 'Handover' && led.Invoice_Date__c== null && led.Job_Card_Date__c == null && led.Quotation_Date__c == null && led.Network_Registration_Date__c == null && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Handover';
                }                  
                else if(led.Invoice_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced') && led.RecordtypeId == salesRecordTypeId && led.Job_Card_Date__c == null && led.Quotation_Date__c == null && led.Network_Registration_Date__c == null && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                      system.debug('>>>>>>>>1'+led.Invoice_Date__c);
                    led.Lead_Latest_Phase__c = 'Invoiced';
                }
                else if(led.Invoice_Date__c != Null && led.Lead_Latest_Phase__c != 'Invoiced' && led.RecordtypeId == afterSalesRecordTypeId && led.Job_Card_Date__c == null && led.Quotation_Date__c == null && led.Network_Registration_Date__c == null && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Invoiced';
                }
                else if(led.Job_Card_Date__c != Null && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue') && led.Quotation_Date__c == null && led.Network_Registration_Date__c == null && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Job Card Issue';
                }
                else if(led.Quotation_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation') && led.Network_Registration_Date__c == null && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Estimation';
                }
                else if(led.Network_Registration_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration') && led.Order_Confirmation_Date__c==null && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Vehicle Registration';
                }
                else if(led.Order_Confirmation_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed') && led.Order_Placed_Date__c == null && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Order Confirmed';
                }
                else if(led.Order_Placed_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' 
                                                                || led.Lead_Latest_Phase__c != 'Order Placed') && led.CA_Updated_Date__c==null && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Order Placed';
                }
                else if(led.Quotation_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' 
                                                                                                    || led.Lead_Latest_Phase__c != 'Order Placed' || led.Lead_Latest_Phase__c != 'Quotation') && led.CA_Updated_Date__c==null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Quotation';
                }
                else if(led.CA_Updated_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                            || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission') && led.Finance_Quotation_Date__c== null && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'CA Submission';
                }
                else if(led.Finance_Quotation_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                    || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation') && led.Trade_in_Date__c == null && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Finance Quotation';
                }
                else if(led.Trade_in_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                            || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in') && led.Test_Drive_Date__c == null && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Trade-in';
                }
                else if(led.Test_Drive_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                            || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive') && led.Simple_Estimation_Date__c == null && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Test Drive';
                }
                else if(led.Simple_Estimation_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                    || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation') 
                                                                    && led.ServiceProgram_Proposal_Date__c == null && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Simple Estimation';
                }
                else if(led.ServiceProgram_Proposal_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                                                                || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' 
                                                                                                                || led.Lead_Latest_Phase__c != 'Simple Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal') && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Service Program Proposal';
                }
                else if(led.ServiceProgram_Proposal_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal') && led.Insurance_Proposal_Date__c==null && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Service Program Proposal';
                }
                else if(led.Insurance_Proposal_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed'
                                                                                                            || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' 
                                                                                                            || led.Lead_Latest_Phase__c != 'Simple Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal') && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Insurance Proposal';
                }
                else if(led.Insurance_Proposal_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal')  && led.Finance_Proposal_Date__c ==null && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Insurance Proposal';
                }
                else if(led.Finance_Proposal_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation' 
                                                                || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Finance Proposal') && led.Product_Proposal_Date__c == null && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Finance Proposal';
                }
                else if(led.Product_Proposal_Date__c != Null && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation' 
                                                                || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Finance Proposal' || led.Lead_Latest_Phase__c != 'Product Proposal') && led.Needs_Check_Date__c == null && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Product Proposal';
                }
                else if(led.Needs_Check_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' 
                                                                                                    || led.Lead_Latest_Phase__c != 'Order Placed' || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' 
                                                                                                    || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Finance Proposal' 
                                                                                                    || led.Lead_Latest_Phase__c != 'Product Proposal' || led.Lead_Latest_Phase__c != 'Needs Check') && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null ){
                    led.Lead_Latest_Phase__c = 'Needs Check';
                }
                else if(led.Needs_Check_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal' 
                                                                                                            || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Needs Check') && led.Visited_Showroom_Date__c == null && led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Needs Check';
                }
                else if(led.Visited_Showroom_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                                                        || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation' 
                                                                                                        || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Finance Proposal' || led.Lead_Latest_Phase__c != 'Product Proposal' 
                                                                                                        || led.Lead_Latest_Phase__c != 'Needs Check' || led.Lead_Latest_Phase__c != 'Visited')&& led.Contact_Date__c == null ){
                    led.Lead_Latest_Phase__c = 'Visited';
                }
                else if(led.Visited_Showroom_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation' 
                                                                                                                || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Needs Check' || led.Lead_Latest_Phase__c != 'Visited')&& led.Contact_Date__c == null){
                    led.Lead_Latest_Phase__c = 'Visited';
                }
                else if(led.Contact_Date__c != Null && led.RecordtypeId == salesRecordTypeId && (led.Lead_Latest_Phase__c != 'Handover' || led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Vehicle Registration' || led.Lead_Latest_Phase__c != 'Order Confirmed' || led.Lead_Latest_Phase__c != 'Order Placed' 
                                                                                                || led.Lead_Latest_Phase__c != 'Quotation' || led.Lead_Latest_Phase__c != 'CA Submission' || led.Lead_Latest_Phase__c != 'Finance Quotation' || led.Lead_Latest_Phase__c != 'Trade-in' || led.Lead_Latest_Phase__c != 'Test Drive' || led.Lead_Latest_Phase__c != 'Simple Estimation' 
                                                                                                || led.Lead_Latest_Phase__c != 'Service Program Proposal' || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Finance Proposal' || led.Lead_Latest_Phase__c != 'Product Proposal' || led.Lead_Latest_Phase__c != 'Needs Check' 
                                                                                                || led.Lead_Latest_Phase__c != 'Visited' || led.Lead_Latest_Phase__c == 'Contact')){
                    led.Lead_Latest_Phase__c = 'Contact';
                }
                else if(led.Contact_Date__c != Null && led.RecordtypeId == afterSalesRecordTypeId && (led.Lead_Latest_Phase__c != 'Invoiced' || led.Lead_Latest_Phase__c != 'Job Card Issue' || led.Lead_Latest_Phase__c != 'Estimation' || led.Lead_Latest_Phase__c != 'Service Program Proposal' 
                                                                                                        || led.Lead_Latest_Phase__c != 'Insurance Proposal' || led.Lead_Latest_Phase__c != 'Needs Check' || led.Lead_Latest_Phase__c != 'Visited' || led.Lead_Latest_Phase__c == 'Contact')){
                    led.Lead_Latest_Phase__c = 'Contact';
                }
              
            } 
            
        }     
         
    }
}