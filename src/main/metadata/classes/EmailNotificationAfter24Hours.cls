/**
** This class is created as part of lead Escalation after 24 hours if dealer  is not contatcted the lead

** Created By: Dhanamjaya .
** Date:  3/3/2017
**/
public class EmailNotificationAfter24Hours{
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    private static final String retailSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.RETAIL_SALES_LEADS).getRecordTypeId();
    public static String sub=UtilConstant.EMAILSUB;
   @InvocableMethod
    public static void SendEmails(List<String> ListID){ 
        List<String> ToAdd=new List<String>();
        List<String> cCAdd=new List<String>();
        List<String> desiredService=new List<String>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        EmailTemplate temp=(EmailTemplate)[select id,Body,subject from emailtemplate where name=:'Email to Sales & Service Manager & CCC Manager if dealer is untouched for 24 hrs' limit 1];
        message.setTemplateId(temp.id);
        String rectype;
        String afterSalesmanagermail;
        String salesManagermail;
        Id leadOwnerIDs;
        String communityName='Daimler Community Thailand';
        boolean flag1=false;
        String commubaseurl;
        List<Lead__c> leadList=[select id,RecordTypeID,assigned_dealer__r.name,lead_desired_service__c,Contact__r.name,name,Dealer_DMS_Comments__c,createddate,createdbyid,assigned_dealer__r.Dealer_Aftersales_Manager_Email__c,assigned_dealer__r.Dealer_Sales_Manager_Email__c,ownerId from Lead__c where id=:ListId ];
       List<Network>  myNetwork = [SELECT Id,Name FROM Network];
       for(Network net:myNetwork){
           if(net.name==communityName){
           flag1=true;
           commubaseurl=Network.getLoginUrl(net.id)+'/';
           break;
           }
       }
       String commurl;
       if(flag1){
       commurl=commubaseurl+''+leadList[0].id;
       }
       else{
       commurl='No Thailand community Exists';
       }
        message.setTargetObjectId(leadList[0].ownerid);
        message.setSaveAsActivity(false);
        String name=leadlist[0].name;
        String leadContact=(!String.isBlank(leadlist[0].contact__c)?leadlist[0].contact__r.name:'not selected');
        String leadCreateddate=leadlist[0].createddate+'';
        String dealercomm=leadlist[0].Dealer_DMS_Comments__c;
        String leadassigndealer=leadlist[0].assigned_dealer__r.name;
        String leadurl=URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadList[0].id;
         string body=temp.Body.replace('{Lead__c.Assigned_Dealer__c}',leadassigndealer).replace('{Lead__c.Name}',Name).replace('{Lead__c.CreatedDate}',leadCreateddate).replace('{Lead__c.Dealer_DMS_Comments__c}',!String.isBlank(dealercomm)?dealercomm:'not selected').replace('{Lead__c.Contact__c}',leadContact).replace('{Lead__c.Link}',leadurl).replace('{Lead__c.Link1}',commurl);  
        message.setSubject(sub); 
        message.setPlainTextBody(body);
        
        //it will call from Process Builder so at any time one record will come to the method.so i am assigning afterSalesmanagermail..values in for loop
        for(Lead__c l:leadList){
             afterSalesmanagermail=l.assigned_dealer__r.Dealer_Aftersales_Manager_Email__c;
             salesManagermail=l.assigned_dealer__r.Dealer_Sales_Manager_Email__c;
             leadOwnerIDs=l.createdbyid;
             rectype =l.RecordTypeID;                
             if(l.lead_desired_service__c!=null){
                 desiredService.addAll(l.lead_desired_service__c.split(';'));
              }
             }
        if(rectype==salesRecordTypeId){
             if(leadOwnerIDs!=null){
                    User managersEmail=[select name,email,manager.email from user where id=:leadOwnerIDs limit 1];
                    ToAdd.add(managersEmail.email);
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
                            User managersEmail=[select name,email,manager.email from user where id=:leadOwnerIDs limit 1];
                            ToAdd.add(managersEmail.email);
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