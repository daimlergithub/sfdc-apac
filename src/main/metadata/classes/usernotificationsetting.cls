public class usernotificationsetting
{
    public List<selectOption> leftacc{set;get;}
    public List<selectOption> leftacctwo{set;get;}
    public List<selectOption> leftaccthree{set;get;}
    public List<selectOption> rightacc{set;get;}
    public List<selectOption> rightacctwo{set;get;}
    public List<selectOption> rightaccthree{set;get;}
    public List<String> Selected{set;get;}
    public List<String> Selected1{set;get;}
    public List<String> Selected2{set;get;}
    public id uid{get;set;}
    public user usertoupdate{set;get;}
    
    public string strname{set;get;}
    public  List<Account> acclst{set;get;}
    public List<string> accstr{set;get;}
    
    public usernotificationsetting(ApexPages.StandardController controller)
    {
        set<string> user1 = new set<string>();
        uid = apexpages.currentpage().getparameters().get('id');
        Id dealeracctrt= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Selected=new List<string>();
        Selected1=new List<string>();
        Selected2=new List<string>();
        usertoupdate=[select id,name,Dealer_GC_Code__c ,contactid,Notification_Lead_Dealer_Assignment__c,Notification_Lead_Not_Assigned__c,Notification_Lead_No_Update__c from user where id=:uid]; 
        leftacc=new List<selectOption>(); 
        rightacc=new List<selectOption>();
        leftacctwo=new List<selectOption>(); 
        leftaccthree=new List<selectOption>();
        rightacctwo=new List<selectOption>();
        rightaccthree=new List<selectOption>();        
        strname=usertoupdate.Dealer_GC_Code__c;
        accstr=new List<string>();
        acclst=[select Id,Name,Dealer_GC_Code__c,Dealer_ND_Code__c from Account where  Dealer_GC_Code__c =:strname AND recordtypeId=:dealeracctrt ];
        
        for(Account a:acclst )
        {
            if(a.Dealer_ND_Code__c!=null)
            {
                selectOption s=new selectOption(a.Dealer_ND_Code__c,a.Name); 
                
                leftacc.add(s);
                leftacctwo.add(s);
                leftaccthree.add(s);
            }   
        }
    }
    public void addit()
    {
        if(Selected.size() >0)
        {
            for(String s1:Selected)
            {
                system.debug('##s1'+s1);
                SelectOption sp=new SelectOption(s1,s1);
                rightacc.add(sp);
            }
        }
    }
    public void addit1()
    {        
        if(Selected1.size() >0)
        {
            for(String s1:Selected1)
            {
                SelectOption sp1=new SelectOption(s1,s1);
                rightacctwo.add(sp1); 
            }
        }                  
    }
    
    public void addit2()
    {        
        if(Selected2.size() >0)
        {
            for(String s2:Selected2)
            {
                SelectOption sp2=new SelectOption(s2,s2);
                rightaccthree.add(sp2); 
            }
        } 
    }
    
    public void updateit()
    {
        
        usertoupdate.Notification_Lead_Dealer_Assignment__c=JSON.serializePretty(Selected);
        usertoupdate.Notification_Lead_Not_Assigned__c=JSON.serializePretty(Selected1);            
        usertoupdate.Notification_Lead_No_Update__c=JSON.serializePretty(Selected2);          
        update usertoupdate;        
        System.Debug('++++++++'+usertoupdate);
        
        EmailTemplate e =  [select id,name from EmailTemplate WHERE Name = 'Lead assignment to dealer outlet' limit 1];  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(usertoupdate.Id);
        mail.setTemplateID(e.Id);
        mail.setSaveAsActivity(false);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.Debug('++++++++'+mail);
        
    }
    
    /*public PageReference cancelit(){
PageReference p=new pagereference('/'+usertoupdate.id );
p.setRedirect(true);
return p;
}*/
    
    
    
}


