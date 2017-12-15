global class EmailNotificationfor5days10days15days implements Database.Batchable<sobject>,database.stateful,Database.AllowsCallouts
{
	List<Contact> MonkContacts = new List<Contact>();
	global database.QueryLocator start(database.BatchableContext bc)
    { 
    	//Select Id,Dealer_Lead_Status__c,Assigned_Dealer__c,Dealer_Assigned_Date_Time__c from Lead__c where Dealer_Assigned_Date_Time__c != null and Assigned_Dealer__c != null and ((RecordType.Name =' + '\'Sales Leads\'' + 'and Dealer_Lead_Status__c !=' + \'Lost(Dealer)'\ + 'and Dealer_Lead_Status__c !=' + \'Received'\ + 'and Dealer_Lead_Status__c !=' + \'Lost'\ + 'and Dealer_Lead_Status__c !=' + \'Invoiced'\ + ')OR (RecordType.Name =' + \'Aftersales Leads'\ + 'and Dealer_Lead_Status__c !=' + \'Lost(Dealer)'\ + 'and Dealer_Lead_Status__c !=' + \'Service Completed'\ + 'and Dealer_Lead_Status__c !=' + \'Lost'\ + '))';
    	return Database.getQueryLocator([Select Id,Dealer_Lead_Status__c,Assigned_Dealer__c,Dealer_Assigned_Date_Time__c,OwnerId,Owner.Email from Lead__c where Dealer_Assigned_Date_Time__c != null and Assigned_Dealer__c != null and ((RecordType.Name = 'Sales Leads' and Dealer_Lead_Status__c != 'Lost(Dealer)' and Dealer_Lead_Status__c != 'Received' and Dealer_Lead_Status__c != 'Lost' and Dealer_Lead_Status__c != 'Invoiced')OR (RecordType.Name = 'Aftersales Leads' and Dealer_Lead_Status__c != 'Lost(Dealer)' and Dealer_Lead_Status__c !='Service Completed' and Dealer_Lead_Status__c != 'Lost'))]);
    }  
    
    global void execute(database.BatchableContext bc,List<Lead__c> scope)
    {  
    	List<BusinessHours> businessHrsList = [SELECT Id FROM BusinessHours WHERE Id =:  Label.korea_Business_Hours_Id];
        User usr = [select id, UserType from user where id =: userInfo.getuserId()];
        List<Holiday> holidaysList =  BusinessHrHolidaysRetriever.retrieveHolidays(businessHrsList[0], usr);
        List<Date> weekEndDateList = BusinessHrHolidaysRetriever.weekendDatesLst(system.Today()-35, system.today()+35);
        Set<Date> dateSet = new set<Date>();
        Date todayDate = system.Today();
		Integer dateDifference5Days = 0;
		Integer dateDifference10Days = 0;
		Integer dateDifference15Days = 0;		
		Date check5DayEmailTriggerDate;
		Date check10DayEmailTriggerDate;
		Date check15DayEmailTriggerDate;
		Date notification5DaysDate;
		Date notification10DaysDate;
		Date notification15DaysDate;
		List<Lead__c> leadEscalation5DaysList = new List<Lead__c>();
		List<Lead__c> leadEscalation10DaysList = new list<Lead__c>();
		List<Lead__c> leadEscalation15DaysList = new list<Lead__c>();
		List<Messaging.Email> sendEmailList = new List<Messaging.Email>();		
		List<EmailTemplate>  emailNotificationTemplates = [select id ,developername from EmailTemplate where developername = 'No_modifications_are_made_in_5_days' or developername = 'No_modifications_are_made_in_10_days' or developername = 'No_modifications_are_made_in_15_days'];
		system.debug(emailNotificationTemplates[0].developername + '   *$*$*$*  ' + emailNotificationTemplates[1].developername + '   *#*#*#*#*   ' + emailNotificationTemplates[2].developername);
        for(Holiday hol: holidaysList)
        {
        	dateSet.add(hol.ActivityDate);
        	system.debug('***$$$*** Business Hours dates   ' + dateSet);
        }
        dateSet.addAll(weekEndDateList);
        for(Lead__c lead : scope)
        {
        	system.debug(lead.Dealer_Assigned_Date_Time__c.date() + '   Date and *$*$*$* Lead Id  ' + lead.Id);
        	check5DayEmailTriggerDate = lead.Dealer_Assigned_Date_Time__c.date();
        	check10DayEmailTriggerDate = lead.Dealer_Assigned_Date_Time__c.date();
        	check15DayEmailTriggerDate = lead.Dealer_Assigned_Date_Time__c.date();
        	dateDifference5Days = 0;
			dateDifference10Days = 0;
			dateDifference15Days = 0;
        	system.debug(check5DayEmailTriggerDate + '   ***$$$***   '+check10DayEmailTriggerDate + '    *$*$*$* notification15DaysDate  ' + check15DayEmailTriggerDate);
        	do
	        {
	         	check5DayEmailTriggerDate += 1;
	         	if(!dateSet.contains(check5DayEmailTriggerDate))
	         	{
	         		dateDifference5Days+=1;
	         	}
	         	system.debug(dateDifference5Days + '   *$*$***$$$*** check5DayEmailTriggerDate    ' + check5DayEmailTriggerDate);
	        }
	        while(dateDifference5Days <= 4);
	        notification5DaysDate = check5DayEmailTriggerDate;
	        
	        do
	        {
	         	check10DayEmailTriggerDate += 1;
	         	if(!dateSet.contains(check10DayEmailTriggerDate))
	         	{
	         		dateDifference10Days+=1;
	         	}
	         	system.debug(dateDifference10Days + '   *$*$***$$$*** check10DayEmailTriggerDate    ' + check10DayEmailTriggerDate);
	        }
	        while(dateDifference10Days <= 9);
	        notification10DaysDate = check10DayEmailTriggerDate;
	        
	        do
	        {
	         	check15DayEmailTriggerDate += 1;
	         	if(!dateSet.contains(check15DayEmailTriggerDate))
	         	{
	         		dateDifference15Days+=1;
	         	}
	         	system.debug(dateDifference15Days + '   *$*$***$$$*** check15DayEmailTriggerDate    ' + check15DayEmailTriggerDate);
	        }
	        while(dateDifference15Days <= 14);
	        notification15DaysDate = check15DayEmailTriggerDate;
	        
        	system.debug(notification5DaysDate + '   ***$$$***   '+notification10DaysDate + '    *$*$*$* notification15DaysDate  ' + notification15DaysDate);
        	
        	if(notification5DaysDate == system.today())
        	{	
        		//get monk contact
            	Contact MonkContact = MonkCotact(lead.Owner.Email);
            	system.debug('*$*$*$* MonkContact ' + MonkContact);
            	MonkContacts.add(MonkContact);
        		system.debug( '   5 days difference Condition *$*$*  ' + emailNotificationTemplates[2].Id);
				Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
				sendEmail.setSaveAsActivity(false);
				sendEmail.setTargetObjectId(MonkContact.Id);
				sendEmail.setTemplateId(emailNotificationTemplates[2].Id);
				sendEmail.setWhatId(lead.Id);
				//sendEmail.setOrgWideEmailAddressId('0D228000000GoJl');
				sendEmailList.add(sendEmail);
        	}
        	else if(notification10DaysDate == system.today())
        	{	
        		//get monk contact
            	Contact MonkContact = MonkCotact(lead.Owner.Email);
            	system.debug('*$*$*$* MonkContact ' + MonkContact);
            	MonkContacts.add(MonkContact);
        		system.debug( '   10 days difference Condition *$*$*  ' + emailNotificationTemplates[0].Id);
        		Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
				sendEmail.setSaveAsActivity(false);
				sendEmail.setTargetObjectId(MonkContact.Id);
				sendEmail.setTemplateId(emailNotificationTemplates[0].Id);
				sendEmail.setWhatId(lead.Id);
				//sendEmail.setOrgWideEmailAddressId('0D228000000GoJl');
				sendEmailList.add(sendEmail);
        	}
        	else if(notification15DaysDate == system.today())
        	{	
        		//get monk contact
            	Contact MonkContact = MonkCotact(lead.Owner.Email);
            	system.debug('*$*$*$* MonkContact ' + MonkContact);
            	MonkContacts.add(MonkContact);
        		system.debug( '   15 days difference Condition *$*$*  ' + emailNotificationTemplates[1].Id);
        		Messaging.SingleEmailMessage sendEmail = new Messaging.SingleEmailMessage();
				sendEmail.setSaveAsActivity(false);
				sendEmail.setTargetObjectId(MonkContact.Id);
				sendEmail.setTemplateId(emailNotificationTemplates[1].Id);
				sendEmail.setWhatId(lead.Id);
				//sendEmail.setOrgWideEmailAddressId('0D228000000GoJl');
				sendEmailList.add(sendEmail);
        	}
        } 
        try
        {   
        	if(!sendEmailList.isEmpty() && sendEmailList != null)
        	{
        		Messaging.SendEmailResult[] results = Messaging.sendEmail(sendEmailList);
	            if (results[0].success) 
	            {                
	                System.debug('The email was sent successfully.');
	            } 
        	}               
        }		
        catch(Exception e)
        {
            system.debug('5Days, 10Days, 15Days Email Notification Failure Error ======> {Error:  '+ e.getdmlMessage(0) + '}');
        } 
              
    }
    
    @TestVisible
    private static Contact MonkCotact(String mailAdd)
    {   
        String monkLastName = 'Contact' + Math.round(Math.random() * (1000 - 1)) + 1;
        while(true)
        {
            list<Contact> contactList = [select id from Contact where lastName=:monkLastName];
            if (contactList.size()<1) 
            {
                Contact monkc = new Contact(lastName=monkLastName,Email=mailAdd);
                insert monkc;
                return monkc;
            }
            monkLastName = 'monkContact' + Math.round(Math.random() * (1000 - 1)) + 1;
        }       
        return null;
    }
    
    global void finish(database.BatchableContext bc)
    {
        if(!MonkContacts.isEmpty() && MonkContacts != null)
        {
        	delete MonkContacts;
        }
    }
}