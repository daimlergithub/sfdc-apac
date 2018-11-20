/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:25-Oct-2018
* Company:Infosys Ltd
* Description:Class to send email alerts to subscribed users related to recent published News.
* **********************************************************************************/
global class batchClassForNewsSubscribers Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        sendmail();
    }
    public void sendmail()
    {
        List<News__c> newsList = new List<News__c>();
        List<News__c> cnewsList = new List<News__c>();
        newsList = [select id,name,Title__c,Mail_Sent__c from News__c WHERE Document_Status__c = 'Published' and Start_Date__c =:Date.today() and Mail_Sent__c =:false ORDER BY Start_Date__c DESC NULLS FIRST LIMIT 5];
        cnewsList = [select id,name,Title__c,Mail_Sent__c from News__c WHERE Document_Status__c = 'Published' and Start_Date__c =:Date.today() and Mail_Sent__c =:false ORDER BY Start_Date__c DESC NULLS FIRST];        
        if(newsList != null && newsList.size() > 0){    
            List<User> newsSubscribedUsers = new List<User>();
            newsSubscribedUsers = [select id,Email from user where isActive = true and Subscribe__c = true];
            if(newsSubscribedUsers != null && newsSubscribedUsers.size() > 0){
                List<String> emailList = new List<String>();
                for(User usr : newsSubscribedUsers){
                    emailList.add(usr.Email);                                                                            
                } 
                System.debug('emailList'+emailList);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
                mail.setToAddresses(emailList);             
                mail.setSubject('Latest published news on Daimler South East Asia Pte Ltd - Asia org');                
                string body = 'Below are the latest news published in our RCP<br/><br/><table style="border:1px solid black;border-collapse:collapse;"><tr><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Bulletin#</th><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Title</th><th style="border:1px solid black;border-collapse:collapse;text-align:center;">Link</th></tr>';                
                for(News__c news : newsList){
                    body = body + '<tr><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;">'+news.Name+'</td><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;">'+news.Title__c+'</td><td style="border:1px solid black;border-collapse:collapse;text-align:left;padding: 5px;"><a href="'+Label.Indonesia_Community_URL_RCP+news.Id+'">Click here</a></td></tr>';
                }
                //String sObjName = getSObjectType().getDescribe().
                
                if(cnewsList.size() > 5){
                    body = body+'</table><br/><br/>For more news items please click here <a href="'+Label.Indonesia_Community_News_URL+'">Click here</a><br/><br/>Regards,<br/>DCP';
                }
                else
                    body = body+'</table><br/><br/>Regards,<br/>DCP';              
                mail.setHtmlBody(body);
                System.debug('body '+body);            
                List<Messaging.SendEmailResult> mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                List<News__c> updateNewsList = new List<News__c>();
                for(News__c news : cnewsList){
                    news.Mail_Sent__c = true;
                    updateNewsList.add(news);
                }
                update updateNewsList;
            }
        }
    }
}