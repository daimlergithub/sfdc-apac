public class EmailNotificationAfter24Hours{

    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();

    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();

    private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
    
 

        @InvocableMethod

        public static void SendEmails(List<String> ListID){ 
            List<String> ToAdd=new List<String>();
            List<String> cCAdd=new List<String>();
            List<String> desiredService=new List<String>();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            EmailTemplate temp=(EmailTemplate)[select id from emailtemplate where name=:'EmailNotification to Wholesale manager' limit 1];
          message.setTemplateId(temp.id);
            String rectype;
            String afterSalesmanagermail;
            String salesManagermail;
            Id leadOwnerIDs;
            List<Lead__c> leadList=[select id,RecordTypeID,lead_desired_service__c,name,createdbyid,assigned_dealer__r.Dealer_Aftersales_Manager_Email__c,assigned_dealer__r.Dealer_Sales_Manager_Email__c,ownerId from Lead__c where id=:ListId ];
         message.setTargetObjectId(leadList[0].ownerid);
         message.setSaveAsActivity(false);
        for(Lead__c l:leadList){

             afterSalesmanagermail=l.assigned_dealer__r.Dealer_Aftersales_Manager_Email__c;
             salesManagermail=l.assigned_dealer__r.Dealer_Sales_Manager_Email__c;
             //ownerIDs=l.ownerId;
            leadOwnerIDs=l.createdbyid;
             rectype =l.RecordTypeID;                
             if(l.lead_desired_service__c!=null){
                desiredService.addAll(l.lead_desired_service__c.split(';'));
              }
                
              
                

             }
        if(rectype==salesRecordTypeId){
        //Toadd.add('dhanamjaya44@gmail.com');
             
             if(leadOwnerIDs!=null){
                    User managersEmail=[select name,manager.email from user where id=:leadOwnerIDs limit 1];
                    if(managersEmail.manager.email!=null){
                    system.debug('hi dhanamjaya');
                        cCAdd.add(managersEmail.manager.email);
                    }
                }
                     
             if(afterSalesmanagermail!=null){
                    ToAdd.add(afterSalesmanagermail);
                }
         
             if(salesManagermail!=null){
                 ToAdd.add(salesManagermail);
                }
             if(ToAdd.size()>0){
                     message.setToAddresses(ToAdd);
                     if(cCAdd.size()>0){
                         
                         message.setccAddresses(cCAdd);
                        }
                        system.debug('the email id are'+ToAdd);
                     Messaging.SendEmailResult[] m2=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
                     
                     }
             }
        else if(rectype==afterSalesRecordTypeId){
                 boolean flag=true;
                     for(string str1:desiredService){
             
                         if(str1.toUpperCase().equals('SERVICE BOOKING')){
                             flag=false;
                             
                             break;
                                 }
                             }
                 if(flag){
             
                    if(leadOwnerIDs!=null){
                        User managersEmail=[select name,manager.email from user where id=:leadOwnerIDs limit 1];
                            if(managersEmail.manager.email!=null){
                                cCAdd.add(managersEmail.manager.email);
                            }
                    }
                     
                    if(afterSalesmanagermail!=null){
                        ToAdd.add(afterSalesmanagermail);
                    }
         
                    if(salesManagermail!=null){
                        ToAdd.add(salesManagermail);
                    }
                    if(ToAdd.size()>0){
                        message.setToAddresses(ToAdd);
                        if(cCAdd.size()>0){
                            
                            message.setccAddresses(cCAdd);
                        }
                        Messaging.SendEmailResult[] m2=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
                        
                     }
             
                 }
                 else{
                
                     if(afterSalesmanagermail!=null){
                        ToAdd.add(afterSalesmanagermail);
                    }

                         message.setToAddresses(ToAdd);
                         
                         
                         Messaging.SendEmailResult[] m2=Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});

                         
             
                 
                 }
                 
                 
             }
        }
}