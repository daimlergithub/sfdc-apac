/**
 * Class Name	: MBKBulkMessageCreateKRDFWBatch.cls
 * Function		: Bulk 메시지 생성
 * VFPage		: N/A
 * Author		: I2MAX
 * Date			: 2017.11.03
 * Description	: 	
*/	
global class MBKBulkMessageCreateKRDFWBatch implements Database.Batchable<sObject>{
	global String batchId{get;set;}
	global String batchType{get;set;}
	private static Map<String, Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe() ;
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = ' SELECT Id,channel__c,Message__c,PageSearchIDs__c,Processed__c,Set_Sending_Time__c,Template_ID__c,Subject__c, '
				+' Source_Object_Id__c, Template_Code__c FROM MBK_Bulk_Message__c WHERE Id =\''+batchId+'\'';		
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<MBK_Bulk_Message__c> scope) {
 		//Page Bulk 처리
 		if(batchType == 'Page'){
 			for(MBK_Bulk_Message__c temp:scope){
 				if(temp.Set_Sending_Time__c == null) temp.Set_Sending_Time__c = system.now(); 
 				Set<Id> AccountIds = new Set<Id>();
	 			Set<Id> LeadIds = new Set<Id>();
	 			Set<Id> TaskIds = new Set<Id>();
 				List<Attachment> images = new List<Attachment>();
 				List<String> targetIds = temp.PageSearchIDs__c.split(',');
 				for(String target:targetIds){
			    	if(target.left(3) == getObjectPrefix('Lead__c')) LeadIds.add(target);
			    	else if(target.left(3) == getObjectPrefix('Account')) AccountIds.add(target);
			    	else if(target.left(3) == getObjectPrefix('Task')) TaskIds.add(target);
 				}
 				List<MBK_Messages__c> targetMsgs = new List<MBK_Messages__c>();
 				if(LeadIds.size() > 0){
 					List<Lead__c> leads = [SELECT Id, Contact__c, Contact__r.Name,Contact__r.Opt_In_SMS__c,Contact__r.Personal_Agreement__c,
 												Contact__r.Personal_Information_Third_Party_Release__c, Contact__r.Personal_Abroad_Agreement__c,
 												Contact__r.Agreement_to_commit_info_processing__c, Contact__r.KaKao_Talk_ID__c, Contact__r.UCID__c,
 												Contact__r.Mobile__c
 					  						FROM Lead__c WHERE Id IN: LeadIds];
					for(Lead__c lead:leads){
						MBK_Messages__c target = new MBK_Messages__c();
 					    target.Leads__c = lead.Id;
					    target.Account_Name__c = lead.Contact__r.Name;
					    target.Opt_In_SMS__c  = lead.Contact__r.Opt_In_SMS__c;
					    target.Personal_Agreement__c = lead.Contact__r.Personal_Agreement__c;
					    target.Personal_Information_Third_Party_Release__c = lead.Contact__r.Personal_Information_Third_Party_Release__c;
					    target.Personal_Abroad_Agreement__c = lead.Contact__r.Personal_Abroad_Agreement__c;
					    target.Agreement_to_commit_info_processing__c = lead.Contact__r.Agreement_to_commit_info_processing__c;
					    target.KaKaoTalk_ID__c = lead.Contact__r.KaKao_Talk_ID__c; 
					    target.UCID__c = lead.Contact__r.UCID__c; 
					    target.phoneNum__c = lead.Contact__r.Mobile__c;	
					    
			    		target.MBKMessageTemplate__c = temp.Template_ID__c;
						target.templateCode__c = temp.Template_Code__c;	   
					    target.channel__c = temp.channel__c;
					    target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
					    target.subject__c = temp.subject__c;
					    target.message__c = temp.message__c;
					    target.custGubun__c  = system.label.MBK_Message_custGubun;
						target.senderKey__c = system.label.MBK_Message_SenderKey;
						target.Status__c = 'Reserved';
					    targetMsgs.add(target);	
					}
 				}
 				if(AccountIds.size() > 0){
 					List<Account> accounts = [SELECT Id, Name, Opt_In_SMS__c, Personal_Agreement__c, KaKao_Talk_ID__c, UCID__c,
 												Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,
 												Agreement_to_commit_info_processing__c, Mobile__c
 											FROM Account WHERE Id IN: AccountIds];
					for(Account acc:accounts){
						MBK_Messages__c target = new MBK_Messages__c();
 					    target.Account__c = acc.Id;
					    target.Account_Name__c = acc.Name;
					    target.Opt_In_SMS__c  = acc.Opt_In_SMS__c;
					    target.Personal_Agreement__c = acc.Personal_Agreement__c;
					    target.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
					    target.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
					    target.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;
					    target.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c; 
					    target.UCID__c = acc.UCID__c; 
					    target.phoneNum__c = acc.Mobile__c;	
					    
			    		target.MBKMessageTemplate__c = temp.Template_ID__c;
						target.templateCode__c = temp.Template_Code__c;	   
					    target.channel__c = temp.channel__c;
					    target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
					    target.subject__c = temp.subject__c;
					    target.message__c = temp.message__c;
					    target.custGubun__c  = system.label.MBK_Message_custGubun;
						target.senderKey__c = system.label.MBK_Message_SenderKey;
						target.Status__c = 'Reserved';
					    targetMsgs.add(target);	
					} 				
 				}
 				if(TaskIds.size() > 0){
 					List<Task> tasks = [SELECT Id, Account_Name__c, CustomerName__c, UCID__c, Phone__c 
 										FROM Task WHERE Id IN: TaskIds];
					for(Task task:tasks){
						MBK_Messages__c target = new MBK_Messages__c();
					    target.Account_Name__c = task.Account_Name__c;
					    //target.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c; 
					    target.UCID__c = task.UCID__c; 
					    target.phoneNum__c = task.Phone__c;	
					    
			    		target.MBKMessageTemplate__c = temp.Template_ID__c;
						target.templateCode__c = temp.Template_Code__c;	   
					    target.channel__c = temp.channel__c;
					    target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
					    target.subject__c = temp.subject__c;
					    target.message__c = temp.message__c;
					    target.custGubun__c  = system.label.MBK_Message_custGubun;
						target.senderKey__c = system.label.MBK_Message_SenderKey;
						target.Status__c = 'Reserved';
					    targetMsgs.add(target);	
					} 	 															
 				}
 				insert targetMsgs;
 				//Task logging
 				List<MBK_Messages__c> logMsgs = new List<MBK_Messages__c>();
 				for(MBK_Messages__c log:targetMsgs){
 					if(log.Account__c <> null || log.Leads__c <> null) logMsgs.add(log);
 				}
 				MBKMessageLogging(logMsgs);
		    	//MMS파일 처리(Attachment)
				if(temp.channel__c == 'M'){
					List<Attachment> atts = new List<Attachment>();
					images = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE ParentId =: temp.Id];
					for(MBK_Messages__c targetMsg:targetMsgs){
						for(Attachment img:images){
							Attachment mesImg = new Attachment();
							mesImg.Body = img.Body;
							mesImg.Name = img.Name;
							mesImg.ParentId = targetMsg.Id;
							atts.add(mesImg);
						}
					}
					insert atts;
				}
 			}
 		}
 		else
 		{
 			//Campaign	
 			for(MBK_Bulk_Message__c temp:scope){
 				if(temp.Set_Sending_Time__c == null) temp.Set_Sending_Time__c = system.now();
				List<Campaign_Member__c> targetResults = [SELECT Id, Contact_Id__c, Contact_Id__r.UCID__c, Contact_Id__r.Mobile__c, 
																Contact_Id__r.Name, Contact_Id__r.Opt_In_SMS__c, Contact_Id__r.KaKao_Talk_ID__c, 
																Contact_Id__r.Personal_Agreement__c, Contact_Id__r.Personal_Information_Third_Party_Release__c,
																Campaign__c, Contact_Id__r.Personal_Abroad_Agreement__c, Contact_Id__r.Agreement_to_commit_info_processing__c
															FROM Campaign_Member__c WHERE Campaign__c =: temp.Source_Object_Id__c];
 				List<MBK_Messages__c> targetMsgs = new List<MBK_Messages__c>();
 				for(Campaign_Member__c member:targetResults ){
					MBK_Messages__c target = new MBK_Messages__c();
					target.Account__c = member.Contact_Id__c;
					target.Campaign__c = member.Campaign__c;
					target.Account_Name__c = member.Contact_Id__r.Name;
					target.Opt_In_SMS__c  = member.Contact_Id__r.Opt_In_SMS__c;
					target.Personal_Agreement__c = member.Contact_Id__r.Personal_Agreement__c;
					target.Personal_Information_Third_Party_Release__c = member.Contact_Id__r.Personal_Information_Third_Party_Release__c;
					target.Personal_Abroad_Agreement__c = member.Contact_Id__r.Personal_Abroad_Agreement__c;
					target.Agreement_to_commit_info_processing__c = member.Contact_Id__r.Agreement_to_commit_info_processing__c;
					target.KaKaoTalk_ID__c = member.Contact_Id__r.KaKao_Talk_ID__c; 
					target.UCID__c = member.Contact_Id__r.UCID__c; 
					target.phoneNum__c = member.Contact_Id__r.Mobile__c;	
										    
					target.MBKMessageTemplate__c = temp.Template_ID__c;
					target.templateCode__c = temp.Template_Code__c;	   
					target.channel__c = temp.channel__c;
					target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
					target.subject__c = temp.subject__c;
					target.message__c = temp.message__c;
					target.custGubun__c  = system.label.MBK_Message_custGubun;
					target.senderKey__c = system.label.MBK_Message_SenderKey;
					target.Status__c = 'Reserved';
 					targetMsgs.add(target);		
 				}
 				insert targetMsgs;
 				MBKMessageCampaignLogging(temp);
		    	//MMS파일 처리(Attachment)
				if(temp.channel__c == 'M'){
					List<Attachment> images = new List<Attachment>();
					List<Attachment> atts = new List<Attachment>();
					images = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE ParentId =: temp.Id];
					for(MBK_Messages__c targetMsg:targetMsgs){
						for(Attachment img:images){
							Attachment mesImg = new Attachment();
							mesImg.Body = img.Body;
							mesImg.Name = img.Name;
							mesImg.ParentId = targetMsg.Id;
							atts.add(mesImg);
						}
					}
					insert atts;
				}
 			}	
 		}

	}
	
	global void finish(Database.BatchableContext BC) {
	} 
	
	private String getObjectPrefix(String objectName){
		Schema.SObjectType sObjectType = sObjectTypes.get(objectName) ;
		Schema.DescribeSObjectResult result = sObjectType.getDescribe() ;
		String keyPrefix = result.getKeyPrefix();
		return keyPrefix;
	}
	
	private void MBKMessageLogging(List<MBK_Messages__c> MBKMessages){
		List<Task> insertTasks = new List<Task>();
		for(MBK_Messages__c temp:MBKMessages){
			Task log = new Task();
			if(temp.Account__c <> null) log.WhatId = temp.Account__c;
			else if(temp.Campaign_Member__c <> null) log.WhatId = temp.Campaign_Member__c;
			else if(temp.Case__c <> null) log.WhatId = temp.Case__c;
			else if(temp.Leads__c <> null) log.WhatId = temp.Leads__c;
			
			String sendType = '';
			if(temp.channel__c == 'A') sendType = 'KakaoTalk';
			else if(temp.channel__c == 'M') sendType = 'MMS';
			else sendType = 'SMS';
			RecordType rectype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name =: sendType];
			log.RecordTypeId = rectype.Id;						
			log.Subject = '[MBK]'+temp.LastModifiedDate+'/'+temp.Set_Sending_Time__c+'/'+temp.sndDtm__c+'/'+sendType+'/'+temp.subject__c;
			log.Status = 'Closed';			
			insertTasks.add(log);	
		}
		insert insertTasks;	
	}

	private void MBKMessageCampaignLogging(MBK_Bulk_Message__c target){		 
		String sendType = '';
			
		if(target.channel__c == 'A') sendType = 'KakaoTalk';
		else if(target.channel__c == 'M') sendType = 'MMS';
		else sendType = 'SMS';		
		RecordType rectype = [SELECT Id FROM RecordType WHERE SobjectType = 'Task' AND Name =: sendType];
		
		Task log = new Task();
		log.RecordTypeId = rectype.Id;
		log.WhatId = target.Source_Object_Id__c;
		log.Subject = '[MBK]'+target.Set_Sending_Time__c+'/'+sendType+'/'+target.subject__c;
		log.Status = 'Closed';	
		insert log;									 	 
	}	
}