/**
* @author- Infosys
* @date 12/06/2018
* @description batch class for Opportunity SLA Escalation Alerts
*/

global class OppSLAescalation implements Schedulable,Database.Batchable<sObject>{
    global boolean delShare;
	global List<Database.SaveResult> sr;
	global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //fetch oppty where dealer is assigned , first level contact not made and both SLA remainders not send yet...
        
        String query = 'Select Id,Name,Owner.Manager.Email,Account.Name,StageName,owner.name,Sent_to_DMS__c,SLA_Status__c,Number_of_SLA_remainders_sent__c,Opp_SLA_Time__c,Assigned_Dealer__c,Assigned_Dealer__r.Name,Assigned_Dealer__r.Dealer_Email__c,Assigned_Date_Time__c,Lead_Temperature__c from Opportunity where Market__c=\'TR\' and StageName in (\'New\' ,\'Assigned\') and Assigned_Dealer__c != null and Opp_SLA_Time__c!=null ' ;
        return Database.getQueryLocator(query);     
    }    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){        
        delShare=false;
		system.debug('<<<scope'+scope);
        system.debug('<<<<scopeSize'+scope.size());
        Opp_Escalation__mdt customDate = [Select Id,SentReminder1__c,SLAExpiryState__c,SLA_Expiry_after_2hrs__c,Reassign_Leadowner__c,Leadownerreassign__c from Opp_Escalation__mdt where market__c=:label.TR];
        Integer SentReminder=integer.valueOf(customDate.SentReminder1__c);
        Integer SLAExpiry=integer.valueOf(customDate.SLAExpiryState__c);
        Integer SLAafterExpiry=integer.valueOf(customDate.SLA_Expiry_after_2hrs__c);
        String orgURL = System.URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('org Url ---> '+orgURL);
        
                //getkeepers and emails
        set<ID> dealers=new set<ID>();
       
        Map<Id,String> dealerEmails=new Map<ID,String>();
        for(Opportunity op: scope){dealers.add(op.Assigned_Dealer__c);}
        if(!dealers.isEmpty())dealerEmails=OppHelperTR.findGatekeepers(dealers);
        
        
        List<Opportunity> OpptyForSLA = new List<Opportunity>();
        List<Opportunity> OpptyToUpdate = new List<Opportunity>() ;
        List<Opportunity> OpptyTosendRem1 = new List<Opportunity>();
        List<Opportunity> OpptyTosendRem2 = new List<Opportunity>(); 
		List<OpportunityShare> opShare=new List<OpportunityShare>();
		        
        Datetime cDT =  DateTime.now(); 
        Integer NoOfRem=0;
        if(scope.size()>0 && scope !=null){
            for(Opportunity opp : scope){
                OpptyForSLA.add(opp);
                system.debug('Opp ID--'+opp.id); 
                NoOfRem=(Integer)opp.Number_of_SLA_remainders_sent__c;
                system.debug('<<<NoOfRem'+NoOfRem);
                //calculate diff in mins-------- : 
                system.debug('@@@'+cDT);
                system.debug('###'+opp.Opp_SLA_Time__c );
                decimal decHours;
                
              
                
                if(opp.Opp_SLA_Time__c!=null) decHours = ((opp.Opp_SLA_Time__c.getTime())/1000/60) - ((cDT.getTime())/1000/60); 
                
                system.debug('#############'+decHours);
                system.debug('#############'+SLAafterExpiry);
                decimal decHours1= -1 * decHours ;
                
                //add oppty to appropriate rem list---- :
                if(decHours>=0 && decHours <= SentReminder && opp.SLA_Status__c == null)
                {   
                    system.debug('<<<Entered the SLAReminder');
                    NoOfRem=NoOfRem+1;
                    OpptyTosendRem1.add(opp);
                    opp.SLA_Status__c='SLA Reminder 1';
                    opp.Number_of_SLA_remainders_sent__c=NoOfRem;
                    OpptyToUpdate.add(opp);              
                }
                else if (decHours <= SLAExpiry && opp.SLA_Status__c == 'SLA Reminder 1')  
                { 
                    system.debug('<<<Entered the SLAReminder2');
                    NoOfRem=NoOfRem+1;
                    OpptyTosendRem2.add(opp);
                    if(NoOfRem>=2){
                        opp.SLA_Status__c ='SLA Expired';                       
                    }
		    if(opp.SLA_Expired_Count__c == null)
                        opp.SLA_Expired_Count__c = NoOfRem/2;
                    else
                        opp.SLA_Expired_Count__c += NoOfRem/2;
                    opp.Number_of_SLA_remainders_sent__c=NoOfRem;
                    OpptyToUpdate.add(opp);                    
                }
                
                //else if(decHours<=0 && SLAafterExpiry <= decHours1 && opp.Sent_to_DMS__c == false && opp.SLA_Status__c=='SLA Expired'){
				else if(decHours<=0 && SLAafterExpiry <= decHours1 && opp.SLA_Status__c=='SLA Expired'){
                   system.debug('<<<Entered 3rd loooppppp-------------------->>>>>');
                
                    opp.SLA_Status__c='';
                    system.debug('<<<SLA Status');
                    opp.Assigned_Dealer__c=null;
                    system.debug('<<<Assigned Dealer Null');
                    opp.Number_of_SLA_remainders_sent__c=0;
                    opp.opp_sla_time__c = null;
                    // opp.OwnerId='005280000065yg8AAA'; //queue is not possible--only user,partneruser is availble.
                    opp.Assigned_Date_Time__c = null;
                    opp.OwnerId = customDate.Leadownerreassign__c;
					opp.stageName='New';
                    System.debug('---------ownerid----------'+opp.OwnerId);
                    OpptyToUpdate.add(opp);
					delShare=true;
                
               }
              }
                
            }
        
            //update Opportunities        
           if(OpptyToUpdate!= null && OpptyToUpdate.size()>0){ 
                sr=Database.update(OpptyToUpdate,false);
                system.debug('errors is '+sr);
                 String BatchLevel3Id = Schema.SObjectType.Custom_Debug_Info__c.getRecordTypeInfosByName().get('Batch Level 3').getRecordtypeID();
            list<Custom_Debug_Info__c> debugtoInsert = new list<Custom_Debug_Info__c>();
            system.debug('errors is '+sr);
            if(sr != null){
            for(Database.SaveResult srr : sr){
                if(!srr.isSuccess()){
                for(Database.Error err : srr.getErrors()) {
                    Custom_Debug_Info__c cdiNew = new Custom_Debug_Info__c();
                    cdiNew.RecordID__c = srr.getId();
                    cdiNew.isSuccess__c = false;
                    cdiNew.Logging_Date_Time__c = System.now();
                    cdiNew.Error_Logged_By__c = 'SLA Batch';
                    cdiNew.market__c=Label.TR;
                    cdiNew.Error_Description__c = 'The following error has occurred. '+err.getStatusCode() +' : '+err.getMessage()+'Fields affected are '+err.getFields();
                    debugtoInsert.add(cdiNew);
                    //System.debug('The following error has occurred.');                    
                    //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    //System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
            }
            }
            if(!debugtoInsert.isEmpty())
                insert debugtoInsert;
                if(delShare==true){
                opShare=[SELECT Id,OpportunityId,RowCause,UserOrGroupId FROM OpportunityShare where RowCause='Manual'  
                and OpportunityId in :OpptyToUpdate];
                if(opshare.size()>0)delete opshare; }
            }               
        
        
        
        //send appropriate emails to OpptyTosendRem1 and OpptyTosendRem2 ----: 
        try{
		
			//Send email from Org wide default user MB Turkey if country is Turkey 
            //expand this to work generically later to work specific to markets.
            OrgWideEmailAddress[] defaultEmail = [select Id from OrgWideEmailAddress where address= :Label.TROrgWiseAddress];
            
            system.debug('Oppty to send remainder'+OpptyTosendRem1);
            EmailTemplate emailTemp = [select Id, subject, Body  from EmailTemplate where DeveloperName = 'OpptySLARemainder1'];
            List<Messaging.SingleEmailMessage> email_sendList=new List<Messaging.SingleEmailMessage>();
            
            for(Opportunity op : OpptyTosendRem1){
                Messaging.SingleEmailMessage email_send = new  Messaging.SingleEmailMessage();
				 //Pavan Start
                if (defaultEmail.size() > 0 ) {
                email_send.setOrgWideEmailAddressId(defaultEmail.get(0).Id);
                }
                //Pavan End
                //email_send.setToAddresses(new String[] {Op.Assigned_Dealer__r.Dealer_Email__c });
                email_send.setToAddresses(new String[] {dealerEmails.get(op.Assigned_dealer__c) });
                string subject=emailTemp.subject.replace('{!Opportunity.Name}', op.Name).replace('{!Opportunity.Account}',op.Account.Name);
                string body=emailTemp.Body.replace('{!Opportunity.Account}',op.Account.Name).replace('{!Opportunity.Owner }',op.owner.name).replace('{!Opportunity.Assigned_Dealer__c}',op.Assigned_Dealer__r.Name).replace('{!Opportunity.Link}',orgURL+'/'+op.id);  
                email_send.setPlainTextBody(body); 
                email_send.setSubject(subject);           
                email_send.setTemplateId(emailTemp.Id);
                email_send.setSaveAsActivity(false);            
                email_sendList.add(email_send);
            }  
            Messaging.sendEmail(email_sendList);
            
            system.debug('Oppty to send remainder2'+OpptyTosendRem2);
            EmailTemplate emailTemp2 = [select Id, subject, Body  from EmailTemplate where DeveloperName = 'OpptySLARemainder2'];
            List<Messaging.SingleEmailMessage> email_sendList2=new List<Messaging.SingleEmailMessage>();            
            for(Opportunity op2 : OpptyTosendRem2){
                Messaging.SingleEmailMessage email_send2 = new  Messaging.SingleEmailMessage();
				if (defaultEmail.size() > 0 ) {
                email_send2.setOrgWideEmailAddressId(defaultEmail.get(0).Id);
                }
                //email_send2.setToAddresses(new String[] {Op2.Assigned_Dealer__r.Dealer_Email__c });
                email_send2.setToAddresses(new String[] {dealerEmails.get(op2.Assigned_dealer__c) });
        //Set CC address for Escalation
        String[] ccAddresses = new String[] {op2.Owner.Manager.Email};
        if(!ccAddresses.isEmpty() && op2.Owner.Manager.Email != null)
  		  email_send2.setccAddresses(ccAddresses); 
                string subject2=emailTemp2.subject.replace('{!Opportunity.Name}', op2.Name).replace('{!Opportunity.Account}',op2.Account.Name);
                string body2=emailTemp2.Body.replace('{!Opportunity.Account}',op2.Account.Name).replace('{!Opportunity.Owner}',op2.owner.name).replace('{!Opportunity.Assigned_Dealer__c}',op2.Assigned_Dealer__r.Name).replace('{!Opportunity.Link}',orgURL+'/'+op2.id);  
                email_send2.setPlainTextBody(body2); 
                email_send2.setSubject(subject2);           
                email_send2.setTemplateId(emailTemp2.Id);
                email_send2.setSaveAsActivity(false);            
                email_sendList2.add(email_send2);
            }  
            Messaging.sendEmail(email_sendList2); 
            
          }catch(Exception e)
        {
            system.debug(e.getMessage()); 
        }
    
    }       
        
        global void finish(Database.BatchableContext BC)
		{
			/*if(!sr.isSuccess()){
			for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Account fields that affected this error: ' + err.getFields());
			}}*/
		}
        
    }
