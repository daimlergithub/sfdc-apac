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
	final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();

	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = ' SELECT Id,channel__c,Message__c,PageSearchIDs__c,Processed__c,Set_Sending_Time__c,Template_ID__c,Subject__c, '
				+' Source_Object_Id__c, Template_Code__c, OwnerId FROM MBK_Bulk_Message__c WHERE Id =\''+batchId+'\'';
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
				Set<Id> CaseIds = new Set<Id>();
				Set<Id> UserIds = new Set<Id>();
 				List<Attachment> images = new List<Attachment>();
 				List<String> targetIds = temp.PageSearchIDs__c.split(',');
 				for(String target:targetIds){
			    	if(target.left(3) == getObjectPrefix('Lead__c')) LeadIds.add(target);
			    	else if(target.left(3) == getObjectPrefix('Account')) AccountIds.add(target);
			    	else if(target.left(3) == getObjectPrefix('Task')) TaskIds.add(target);
					else if(target.left(3) == getObjectPrefix('User')) UserIds.add(target);
					else if(target.left(3) == getObjectPrefix('Case')) CaseIds.add(target);
 				}
 				List<MBK_Messages__c> targetMsgs = new List<MBK_Messages__c>();
 				if(LeadIds.size() > 0){
 					List<Lead__c> leads = [SELECT Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.Mobile__c, Contact__r.PersonEmail, Assigned_Dealer__c,
    											Contact__r.Name, Contact__r.Email2__c, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c,
												Contact__r.Main_Dealer__r.Name, Contact__r.Main_Dealer__r.Dealer_Address_CN__c, Appointment_DateTime__c,
												Requested_Service_DateTime1__c, Requested_Service_DateTime2__c,

												Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c,
												Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c,
												Contact__r.General_Personal_Information_Mandatory__c, Contact__r.General_Personal_InfoThirdParty_Optional__c, Contact__r.Targeted_Advertising_Info_Optional__c,
												Contact__r.General_Personal_Info_Mandatory__c, Contact__r.Targeted_Advert_Info_Optional_STCCC__c,
                                                Contact__r.Agreement_to_commit_info_proces_CC_Old__c, Contact__r.Personal_Agreement_CC_Old__c, Contact__r.Personal_Info_Third_Party_Release_CC_Old__c

 					  						FROM Lead__c WHERE Id IN: LeadIds];
					for(Lead__c lead:leads) {
						MBK_Messages__c target = new MBK_Messages__c();
						Boolean doc = false;

						//Doc 체크 4개(1개라도 통과하면 발송 함)
						//1. 3. CCC Consent (old)
						//Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
						if(lead.Contact__r.Personal_Agreement__c == 'Yes' && lead.Contact__r.Personal_Information_Third_Party_Release__c == 'Yes' && lead.Contact__r.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

						//2. Contact Method and Customer Consent (Old)
						//General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
						if(lead.Contact__r.General_Personal_Information_Mandatory__c == 'Yes' && lead.Contact__r.General_Personal_InfoThirdParty_Optional__c == 'Yes' && lead.Contact__r.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

                        //3. Contact Method and Customer Consent (Old)
                        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                        if(lead.Contact__r.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && lead.Contact__r.Personal_Agreement_CC_Old__c == 'Yes' && lead.Contact__r.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

						//4. SalesTouch & CCC Consent (new)
						//General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
						if(lead.Contact__r.General_Personal_Info_Mandatory__c == 'Yes' && lead.Contact__r.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

						if (doc) {
							target.Leads__c = lead.Id;
							target.Account_Name__c = lead.Contact__r.Name;
							target.Opt_In_SMS__c = lead.Contact__r.Opt_In_SMS__c;
							target.Personal_Agreement__c = lead.Contact__r.Personal_Agreement__c;
							target.Personal_Information_Third_Party_Release__c = lead.Contact__r.Personal_Information_Third_Party_Release__c;
							target.Personal_Abroad_Agreement__c = lead.Contact__r.Personal_Abroad_Agreement__c;
							target.Agreement_to_commit_info_processing__c = lead.Contact__r.Agreement_to_commit_info_processing__c;

							target.General_Personal_Information_Mandatory__c = lead.Contact__r.General_Personal_Information_Mandatory__c;
							target.General_Personal_InfoThirdParty_Optional__c = lead.Contact__r.General_Personal_InfoThirdParty_Optional__c;
							target.Targeted_Advertising_Info_Optional__c = lead.Contact__r.Targeted_Advertising_Info_Optional__c;
							target.General_Personal_Info_Mandatory__c = lead.Contact__r.General_Personal_Info_Mandatory__c;
							target.Targeted_Advert_Info_Optional_STCCC__c = lead.Contact__r.Targeted_Advert_Info_Optional_STCCC__c;
                            target.Agreement_to_commit_info_proces_CC_Old__c = lead.Contact__r.Agreement_to_commit_info_proces_CC_Old__c;
                            target.Personal_Agreement_CC_Old__c = lead.Contact__r.Personal_Agreement_CC_Old__c;
                            target.Personal_Info_Third_Party_Release_CC_Old__c = lead.Contact__r.Personal_Info_Third_Party_Release_CC_Old__c;

							target.KaKaoTalk_ID__c = lead.Contact__r.KaKao_Talk_ID__c;
							target.UCID__c = lead.Contact__r.UCID__c;
							target.phoneNum__c = lead.Contact__r.Mobile__c;
							target.MBKMessageTemplate__c = temp.Template_ID__c;
							target.templateCode__c = temp.Template_Code__c;
							target.channel__c = temp.channel__c;
							target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
							target.subject__c = temp.subject__c;
							target.custGubun__c = system.label.MBK_Message_custGubun;
							target.senderKey__c = system.label.MBK_Message_SenderKey;
							target.Status__c = 'Reserved';

							String message = temp.message__c;

							if (message <> null) {
								if (target.Account_Name__c <> null && target.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}', target.Account_Name__c);  //고객명
								message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
								if (lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c <> null && lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c);  //센터주소
								if (lead.Contact__r.Main_Dealer__r.Name <> null && lead.Contact__r.Main_Dealer__r.Name <> '') message = message.replaceAll('#\\{센터명\\}', lead.Contact__r.Main_Dealer__r.Name);  //센터명
								if (lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c <> null && lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', lead.Contact__r.Main_Dealer__r.Dealer_Address_CN__c);  //전시장주소

								if (target.templateCode__c == 'benz_01' && lead.Appointment_DateTime__c <> null) {
									String resDate = String.valueOf(lead.Appointment_DateTime__c.format('YYYY년 MM월 dd일 HH시mm분'));
									message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
								}
								if (target.templateCode__c == 'benz_02' && lead.Requested_Service_DateTime1__c <> null || lead.Requested_Service_DateTime2__c <> null) {
									String resDate = '';
									if (lead.Requested_Service_DateTime1__c <> null) resDate = String.valueOf(lead.Requested_Service_DateTime1__c.format('YYYY년 MM월 dd일 HH시mm분')); else if (lead.Requested_Service_DateTime2__c <> null) resDate = String.valueOf(lead.Requested_Service_DateTime2__c.format('YYYY년 MM월 dd일 HH시mm분'));
									message = message.replaceAll('#\\{예약시간\\}', resDate);  // #{예약시간}
								}
							}

							target.message__c = message;
							targetMsgs.add(target);
						}
					}
 				}
 				if(AccountIds.size() > 0){
 					List<Account> accounts = [SELECT Id, Name, UCID__c, Mobile__c, PersonEmail, Opt_In_SMS__c, KaKao_Talk_ID__c, Main_Dealer__r.Name, Main_Dealer__r.Dealer_Address_CN__c,
													Personal_Agreement__c, Personal_Information_Third_Party_Release__c,
													Personal_Abroad_Agreement__c, Agreement_to_commit_info_processing__c,
													General_Personal_Information_Mandatory__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c,
													General_Personal_Info_Mandatory__c, Targeted_Advert_Info_Optional_STCCC__c,
                                                    Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
 											FROM Account WHERE Id IN: AccountIds];
					for(Account acc:accounts) {
						MBK_Messages__c target = new MBK_Messages__c();
						Boolean doc = false;

						//Doc 체크 4개(1개라도 통과하면 발송 함)
						//1. 3. CCC Consent (old)
						//Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
						if(acc.Personal_Agreement__c == 'Yes' && acc.Personal_Information_Third_Party_Release__c == 'Yes' && acc.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

						//2. Contact Method and Customer Consent (Old)
						//General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
						if(acc.General_Personal_Information_Mandatory__c == 'Yes' && acc.General_Personal_InfoThirdParty_Optional__c == 'Yes' && acc.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

                        //3. Contact Method and Customer Consent (Old)
                        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                        if(acc.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && acc.Personal_Agreement_CC_Old__c == 'Yes' && acc.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

						//4. SalesTouch & CCC Consent (new)
						//General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
						if(acc.General_Personal_Info_Mandatory__c == 'Yes' && acc.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

						if (doc) {
							target.Account__c = acc.Id;
							target.Account_Name__c = acc.Name;
							target.Opt_In_SMS__c = acc.Opt_In_SMS__c;
							target.Personal_Agreement__c = acc.Personal_Agreement__c;
							target.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
							target.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
							target.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;

							target.General_Personal_Information_Mandatory__c = acc.General_Personal_Information_Mandatory__c;
							target.General_Personal_InfoThirdParty_Optional__c = acc.General_Personal_InfoThirdParty_Optional__c;
							target.Targeted_Advertising_Info_Optional__c = acc.Targeted_Advertising_Info_Optional__c;
							target.General_Personal_Info_Mandatory__c = acc.General_Personal_Info_Mandatory__c;
							target.Targeted_Advert_Info_Optional_STCCC__c = acc.Targeted_Advert_Info_Optional_STCCC__c;
                            target.Agreement_to_commit_info_proces_CC_Old__c = acc.Agreement_to_commit_info_proces_CC_Old__c;
                            target.Personal_Agreement_CC_Old__c = acc.Personal_Agreement_CC_Old__c;
                            target.Personal_Info_Third_Party_Release_CC_Old__c = acc.Personal_Info_Third_Party_Release_CC_Old__c;

							target.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c;
							target.UCID__c = acc.UCID__c;
							target.phoneNum__c = acc.Mobile__c;

							target.MBKMessageTemplate__c = temp.Template_ID__c;
							target.templateCode__c = temp.Template_Code__c;
							target.channel__c = temp.channel__c;
							target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
							target.subject__c = temp.subject__c;
							target.custGubun__c = system.label.MBK_Message_custGubun;
							target.senderKey__c = system.label.MBK_Message_SenderKey;
							target.Status__c = 'Reserved';

							String message = temp.message__c;
							if (message <> null) {
								if (target.Account_Name__c <> null && target.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}', target.Account_Name__c);  //고객명
								message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
								if (acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //센터주소
								if (acc.Main_Dealer__r.Name <> null && acc.Main_Dealer__r.Name <> '') message = message.replaceAll('#\\{센터명\\}', acc.Main_Dealer__r.Name);  //센터명
								if (acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //전시장주소
							}

							target.message__c = message;
							targetMsgs.add(target);
						}
					}
 				}

				if(CaseIds.size() > 0){
					List<Case> cases = [SELECT Id, Account.Id, Account.UCID__c, Account.Mobile__c, Account.PersonEmail,
												Account.Name, Account.Email2__c, Account.Opt_In_SMS__c, Account.KaKao_Talk_ID__c,
												Case_Dealer__c,Account.Main_Dealer__r.Dealer_Address_CN__c, Account.Main_Dealer__r.Name,
												Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c,
												Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c,
												Account.General_Personal_Information_Mandatory__c, Account.General_Personal_InfoThirdParty_Optional__c, Account.Targeted_Advertising_Info_Optional__c,
												Account.General_Personal_Info_Mandatory__c, Account.Targeted_Advert_Info_Optional_STCCC__c,
                                                Account.Agreement_to_commit_info_proces_CC_Old__c, Account.Personal_Agreement_CC_Old__c, Account.Personal_Info_Third_Party_Release_CC_Old__c
										FROM Case WHERE Id IN: CaseIds];

					for(Case cas:cases) {
						MBK_Messages__c target = new MBK_Messages__c();
						Account acc = cas.Account;
						Boolean doc = false;

						//Doc 체크 4개(1개라도 통과하면 발송 함)
						//1. 3. CCC Consent (old)
						//Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
						if(acc.Personal_Agreement__c == 'Yes' && acc.Personal_Information_Third_Party_Release__c == 'Yes' && acc.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

						//2. Contact Method and Customer Consent (Old)
						//General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
						if(acc.General_Personal_Information_Mandatory__c == 'Yes' && acc.General_Personal_InfoThirdParty_Optional__c == 'Yes' && acc.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

                        //3. Contact Method and Customer Consent (Old)
                        //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                        if(acc.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && acc.Personal_Agreement_CC_Old__c == 'Yes' && acc.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

						//4. SalesTouch & CCC Consent (new)
						//General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
						if(acc.General_Personal_Info_Mandatory__c == 'Yes' && acc.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

						if (doc) {
							target.Case__c = cas.Id;
							target.Account_Name__c = acc.Name;
							target.Opt_In_SMS__c = acc.Opt_In_SMS__c;
							target.Personal_Agreement__c = acc.Personal_Agreement__c;
							target.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
							target.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
							target.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;

							target.General_Personal_Information_Mandatory__c = acc.General_Personal_Information_Mandatory__c;
							target.General_Personal_InfoThirdParty_Optional__c = acc.General_Personal_InfoThirdParty_Optional__c;
							target.Targeted_Advertising_Info_Optional__c = acc.Targeted_Advertising_Info_Optional__c;
							target.General_Personal_Info_Mandatory__c = acc.General_Personal_Info_Mandatory__c;
							target.Targeted_Advert_Info_Optional_STCCC__c = acc.Targeted_Advert_Info_Optional_STCCC__c;
                            target.Agreement_to_commit_info_proces_CC_Old__c = acc.Agreement_to_commit_info_proces_CC_Old__c;
                            target.Personal_Agreement_CC_Old__c = acc.Personal_Agreement_CC_Old__c;
                            target.Personal_Info_Third_Party_Release_CC_Old__c = acc.Personal_Info_Third_Party_Release_CC_Old__c;

							target.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c;
							target.UCID__c = acc.UCID__c;
							target.phoneNum__c = acc.Mobile__c;

							target.MBKMessageTemplate__c = temp.Template_ID__c;
							target.templateCode__c = temp.Template_Code__c;
							target.channel__c = temp.channel__c;
							target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
							target.subject__c = temp.subject__c;
							target.custGubun__c = system.label.MBK_Message_custGubun;
							target.senderKey__c = system.label.MBK_Message_SenderKey;
							target.Status__c = 'Reserved';

							String message = temp.message__c;
							if (message <> null) {
								if (target.Account_Name__c <> null && target.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}', target.Account_Name__c);  //고객명
								message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
								if (acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //센터주소
								if (acc.Main_Dealer__r.Name <> null && acc.Main_Dealer__r.Name <> '') message = message.replaceAll('#\\{센터명\\}', acc.Main_Dealer__r.Name);  //센터명
								if (acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //전시장주소
							}
							target.message__c = message;
							targetMsgs.add(target);

						}
					}
				}

 				if(TaskIds.size() > 0){
 					List<Task> tasks = [SELECT Id, Account_Name__c, CustomerName__c, UCID__c, Email_Address__c, Phone__c 
 										FROM Task WHERE Id IN: TaskIds];
					for(Task task:tasks){
						MBK_Messages__c target = new MBK_Messages__c();
					    target.Account_Name__c = task.Account_Name__c; 
					    target.UCID__c = task.UCID__c; 
					    target.phoneNum__c = task.Phone__c;	
					    
			    		target.MBKMessageTemplate__c = temp.Template_ID__c;
						target.templateCode__c = temp.Template_Code__c;	   
					    target.channel__c = temp.channel__c;
					    target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
					    target.subject__c = temp.subject__c;
					    target.custGubun__c  = system.label.MBK_Message_custGubun;
						target.senderKey__c = system.label.MBK_Message_SenderKey;
						target.Status__c = 'Reserved';

						String message = temp.message__c;
						if(message <> null){
							if(target.Account_Name__c <> null && target.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}',target.Account_Name__c);  //고객명
							message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
						}

						target.message__c = message;
					    targetMsgs.add(target);
					} 	 															
 				}
				if(UserIds.size() > 0){
					List<User> users = [SELECT Id, Name, MobilePhone FROM User WHERE Id IN : UserIds];

					for(User user:users){
						MBK_Messages__c target = new MBK_Messages__c();
						target.Account_Name__c = user.Name;
						target.phoneNum__c = user.MobilePhone;

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

				List<CampaignMember> targetResults1 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c,Campaign.Questionnaire__r.Name,
														Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
														Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
														Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
														Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
														Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c,
                                                        Contact.Account.Agreement_to_commit_info_proces_CC_Old__c, Contact.Account.Personal_Agreement_CC_Old__c, Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c
													FROM CampaignMember WHERE Campaign.Id =: temp.Source_Object_Id__c
													AND Contact.Account.Personal_Agreement__c = 'Yes' AND Contact.Account.Personal_Information_Third_Party_Release__c = 'Yes' AND Contact.Account.Agreement_to_commit_info_processing__c = 'Yes'];

				List<CampaignMember> targetResults2 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c, Campaign.Questionnaire__r.Name,
															Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
															Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
															Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
															Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
															Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c,
                                                                Contact.Account.Agreement_to_commit_info_proces_CC_Old__c, Contact.Account.Personal_Agreement_CC_Old__c, Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c
													FROM CampaignMember WHERE Campaign.Id =: temp.Source_Object_Id__c
													AND Contact.Account.General_Personal_Information_Mandatory__c = 'Yes' AND Contact.Account.General_Personal_InfoThirdParty_Optional__c = 'Yes' AND Contact.Account.Targeted_Advertising_Info_Optional__c = 'Yes'];

				List<CampaignMember> targetResults3 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c, Campaign.Questionnaire__r.Name,
															Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
															Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
															Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
															Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
															Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c,
                                                            Contact.Account.Agreement_to_commit_info_proces_CC_Old__c, Contact.Account.Personal_Agreement_CC_Old__c, Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c
													FROM CampaignMember WHERE Campaign.Id =: temp.Source_Object_Id__c
													AND Contact.Account.General_Personal_Info_Mandatory__c = 'Yes' AND Contact.Account.Targeted_Advert_Info_Optional_STCCC__c = 'Yes'];

                List<CampaignMember> targetResults4 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c, Campaign.Questionnaire__r.Name,
                                                            Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
                                                            Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
                                                            Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
                                                            Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
                                                            Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c,
                                                            Contact.Account.Agreement_to_commit_info_proces_CC_Old__c, Contact.Account.Personal_Agreement_CC_Old__c, Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c
                                                    FROM CampaignMember WHERE Campaign.Id =: temp.Source_Object_Id__c
                                                    AND Contact.Account.Agreement_to_commit_info_proces_CC_Old__c = 'Yes' AND Contact.Account.Personal_Agreement_CC_Old__c = 'Yes' AND Contact.Account.Personal_Info_Third_Party_Release_CC_Old__c = 'Yes'];

				map<Id, CampaignMember> targetMaps = new map<Id, CampaignMember>();
				for(CampaignMember temp1:targetResults1){
					targetMaps.put(temp1.Id, temp1);
				}
				for(CampaignMember temp2:targetResults2){
					targetMaps.put(temp2.Id, temp2);
				}
				for(CampaignMember temp3:targetResults3){
					targetMaps.put(temp3.Id, temp3);
				}
                for(CampaignMember temp4:targetResults4){
                    targetMaps.put(temp4.Id, temp4);
                }

 				List<MBK_Messages__c> targetMsgs = new List<MBK_Messages__c>();
 				for(CampaignMember member:targetMaps.values()){
					MBK_Messages__c target = new MBK_Messages__c();
					if(member.Contact <> null && member.Contact.Account <> null){
						Account acc = member.Contact.Account;
						
						target.Account__c = acc.Id;
						target.Campaign__c = member.Campaign.Id;
						target.Account_Name__c = acc.Name;
						target.Opt_In_SMS__c  = acc.Opt_In_SMS__c;
						target.Personal_Agreement__c = acc.Personal_Agreement__c;
						target.Personal_Information_Third_Party_Release__c = acc.Personal_Information_Third_Party_Release__c;
						target.Personal_Abroad_Agreement__c = acc.Personal_Abroad_Agreement__c;
						target.Agreement_to_commit_info_processing__c = acc.Agreement_to_commit_info_processing__c;

						target.General_Personal_Information_Mandatory__c = acc.General_Personal_Information_Mandatory__c;
						target.General_Personal_InfoThirdParty_Optional__c = acc.General_Personal_InfoThirdParty_Optional__c;
						target.Targeted_Advertising_Info_Optional__c = acc.Targeted_Advertising_Info_Optional__c;
						target.General_Personal_Info_Mandatory__c = acc.General_Personal_Info_Mandatory__c;
						target.Targeted_Advert_Info_Optional_STCCC__c = acc.Targeted_Advert_Info_Optional_STCCC__c;
                        target.Agreement_to_commit_info_proces_CC_Old__c = acc.Agreement_to_commit_info_proces_CC_Old__c;
                        target.Personal_Agreement_CC_Old__c = acc.Personal_Agreement_CC_Old__c;
                        target.Personal_Info_Third_Party_Release_CC_Old__c = acc.Personal_Info_Third_Party_Release_CC_Old__c;

						target.KaKaoTalk_ID__c = acc.KaKao_Talk_ID__c; 
						target.UCID__c = acc.UCID__c; 
						target.phoneNum__c = acc.Mobile__c;	
											    
						target.MBKMessageTemplate__c = temp.Template_ID__c;
						target.templateCode__c = temp.Template_Code__c;	   
						target.channel__c = temp.channel__c;
						target.Set_Sending_Time__c = temp.Set_Sending_Time__c;
						target.subject__c = temp.subject__c;
						target.custGubun__c  = system.label.MBK_Message_custGubun;
						target.senderKey__c = system.label.MBK_Message_SenderKey;
						target.Status__c = 'Reserved';
						String message = temp.message__c;
						if(message <> null){
							if(target.Account_Name__c <> null && target.Account_Name__c <> '') message = message.replaceAll('#\\{고객명\\}',target.Account_Name__c);  //고객명
							message = message.replaceAll('#\\{회사명\\}', '메르세데스 벤츠 코리아');
							if(acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{센터주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //센터주소
							if(acc.Main_Dealer__r.Name <> null && acc.Main_Dealer__r.Name <> '') message = message.replaceAll('#\\{센터명\\}', acc.Main_Dealer__r.Name);  //센터명
							if(acc.Main_Dealer__r.Dealer_Address_CN__c <> null && acc.Main_Dealer__r.Dealer_Address_CN__c <> '') message = message.replaceAll('#\\{전시장주소\\}', acc.Main_Dealer__r.Dealer_Address_CN__c);  //전시장주소
							if(member.Campaign.Questionnaire__c <> null || member.Campaign.Questionnaire__c <> '') message = message.replaceAll('#\\{설문조사\\}', member.Campaign.Questionnaire__r.Name);	//설문조사
						}

						target.message__c = message;
	 					targetMsgs.add(target);
					}		
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
			else if(temp.CampaignMember__c <> null) log.WhatId = temp.CampaignMember__c;
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