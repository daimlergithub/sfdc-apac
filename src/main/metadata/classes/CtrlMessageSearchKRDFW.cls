/**
 * Created by ms on 2018-06-21.
 */

public with sharing class CtrlMessageSearchKRDFW {
	public Boolean displayLayer {get;set;} //2018.6.22 추가
	public Map<String, String> sendTarget {get;set;} //2018.6.22 추가
	public Map<String, MessageSearch> sendTargetMap {get;set;} //2018.6.22 추가
	public List<MessageSearch> sendTargetList {get;set;} //2018.6.22 추가
	public list<MessageSearch> MessageSearchList{get;set;}
	public Map<String, MessageSearch> MessageSearchMap {get;set;} //2018.6.22 추가
	public String searchStr{get;set;}
	private map<String, String> compMap{get;set;}
	public Boolean allChecked{get;set;}
	public Integer chkCount{get;set;}
	public String idList {get;set;}
	public Boolean isPartner{get;set;}
	public String popupUrl{get;set;}
	public String linkUrl{get;set;}
	public String Mtype{get;set;}
	public String preMtype{get;set;} // 2018.6.26 추가
	public CtrlMessageSearchKRDFW(){
		displayLayer = false;
		sendTarget = new Map<String, String>();
		sendTargetMap = new Map<String, MessageSearch>();
		sendTargetList = new List<MessageSearch>();
		MessageSearchList = new list<MessageSearch>();
		MessageSearchMap = new Map<String, MessageSearch>();
		compMap = new map<String, String>();
		allChecked = false;
		chkCount = 0;
		idList ='';
		searchStr = '';
		isPartner = getIsParnter();
		Mtype = 'customer';
		preMtype = Mtype;
		if(isPartner){
			popupUrl = '/MBKorea/apex/PageMessagePopupKRDFW';
			linkUrl = '/MBKorea';
		}else{
			popupUrl = '/apex/PageMessagePopupKRDFW';
			linkUrl = '';
		}
	}

	private Boolean getIsParnter(){
		User user = [SELECT Id, AccountId FROM User WHERE Id =: userinfo.getuserid()];
		if(user.AccountId == null) return false;
		else return true;
	}

	//2018.6.22 검색결과가 sendTarget 맵에 있으면 checked변수가 true로 설정되도록 변경
	public void targetSearch(){
		setIdAndCount();
		allChecked = false;
		if(preMtype != Mtype){
			sendTarget.clear();
			sendTargetMap.clear();
			sendTargetList.clear();
			idList = '';
			chkCount = 0;

			preMtype = Mtype;
		}
		MessageSearchList = new list<MessageSearch>();
		try{
			//딜러 검색 옵션 추가
			if(Mtype == 'parnter'){
				List<User> userList = new List<User>();
				if(searchStr <> null && searchStr <> '') {
					searchStr = searchStr.replace('-', '\\-');
					String searchquery = 'FIND {' + searchStr + '*} IN ALL FIELDS RETURNING '
							+ ' User(Id, MBK_Partner_Roles__c, UserType, User_Role__c, User_Profile__c, Phone, MobilePhone, Market__c, Email, Name, Dealer_Outlet_Name__c)';
					List<List<SObject>>searchList = search.query(searchquery);
					for(SObject temp:searchList[0]){
						User tUser = (User) temp;
						if(tUser.Market__c == 'KR' && tUser.ContactID <> null){
							userList.add(tUser);
						}
					}
				}else{
					userList = [SELECT MBK_Partner_Roles__c, UserType, User_Role__c, User_Profile__c, Phone, MobilePhone, Market__c, Email, Name, Dealer_Outlet_Name__c FROM User WHERE Market__c = 'KR' AND ContactID <> null];
				}

				for(User temp:userList){
					if(temp.MobilePhone != null) {
						MessageSearch views = new MessageSearch();
						if (sendTarget.containsKey(temp.Id)) views.checked = true; else views.checked = false;
						views.doc = true;
						views.recordId = temp.Id;
						views.AccountName = temp.Name;	//name
						views.UCID = temp.User_Profile__c;					//profile
						views.Mobile = temp.MobilePhone;
						views.KaKao = temp.User_Role__c;					//role
						views.Personal_Agreement = temp.Name;		//email
						views.Related = '(Community) ' + temp.Name;	//etc
						MessageSearchList.add(views);
					}
				}

				MessageSearchMap = new Map<String, MessageSearch>();
				for(MessageSearch ms : MessageSearchList){
					MessageSearchMap.put(ms.recordId, ms);
				}
			}else if(searchStr <> null && searchStr <> '' && Mtype == 'customer'){
				searchStr = searchStr.replace('-','\\-');
				String searchquery = 'FIND {'+ searchStr +'*} IN ALL FIELDS RETURNING '
						+ ' Account(Id, Name, UCID__c, Mobile__c, Opt_In_SMS__c, KaKao_Talk_ID__c,'
						+ '  Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,'
						+ '  Agreement_to_commit_info_processing__c, General_Personal_Information_Mandatory__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c, '
						+ '	 General_Personal_Info_Mandatory__c, Targeted_Advert_Info_Optional_STCCC__c, Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c),'
						+ ' Lead__c(Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.Mobile__c,'
						+ '  Contact__r.Name, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c, '
						+ '  Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, '
						+ '  Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c, Contact__r.General_Personal_Information_Mandatory__c, '
						+ '  Contact__r.General_Personal_InfoThirdParty_Optional__c, Contact__r.Targeted_Advertising_Info_Optional__c, Contact__r.General_Personal_Info_Mandatory__c, Contact__r.Targeted_Advert_Info_Optional_STCCC__c),'
						+ ' Campaign(Id), '
						+ ' Case(Id, Subject, CaseNumber,Account.Id, Account.UCID__c, Account.Mobile__c, '
						+ '  Account.Name, Account.Opt_In_SMS__c, Account.KaKao_Talk_ID__c, '
						+ '  Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c,'
						+ '  Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c, Account.General_Personal_Information_Mandatory__c, '
						+ '  Account.General_Personal_InfoThirdParty_Optional__c, Account.Targeted_Advertising_Info_Optional__c, Account.General_Personal_Info_Mandatory__c, Account.Targeted_Advert_Info_Optional_STCCC__c),'
						+ ' Task(Id, Account_Name__c, Email_Address__c, UCID__c, Phone__c, Subject, What.Id, Who.Id,  What.Name, Who.Name)'
						+ ' limit 1000';
				List<List<SObject>>searchList = search.query(searchquery);
				List<Account> accountList = searchList[0];
				List<Lead__c> leadList = searchList[1];
				List<Campaign> CampaignList = searchList[2];
				List<Case> caseList = searchList[3];
				List<Task> taskList = searchList[4];
				//data setting
				for(Account temp:accountList){
					Boolean doc = false; //Account Doc체크

					//Doc 체크 4개(1개라도 통과하면 발송 함)
					//1. CCC Consent (old)
					//Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Agreement_to_commit_info_processing__c
					if(temp.Personal_Agreement__c == 'Yes' && temp.Personal_Information_Third_Party_Release__c == 'Yes' && temp.Agreement_to_commit_info_processing__c == 'Yes') doc = true;

					//2. Contact Method and Customer Consent (Old)
					//General_Personal_Information_Mandator__c, General_Personal_InfoThirdParty_Optional__c, Targeted_Advertising_Info_Optional__c
					if(temp.General_Personal_Information_Mandatory__c == 'Yes' && temp.General_Personal_InfoThirdParty_Optional__c == 'Yes' && temp.Targeted_Advertising_Info_Optional__c == 'Yes') doc = true;

                    //3. Contact Method and Customer Consent (Old)
                    //Agreement_to_commit_info_proces_CC_Old__c, Personal_Agreement_CC_Old__c, Personal_Info_Third_Party_Release_CC_Old__c
                    if(temp.Agreement_to_commit_info_proces_CC_Old__c == 'Yes' && temp.Personal_Agreement_CC_Old__c == 'Yes' && temp.Personal_Info_Third_Party_Release_CC_Old__c == 'Yes') doc = true;

					//4. SalesTouch & CCC Consent (new)
					//General_Personal_Info_Mandatory__c, 	Targeted_Advert_Info_Optional_STCCC__c
					if(temp.General_Personal_Info_Mandatory__c == 'Yes' && temp.Targeted_Advert_Info_Optional_STCCC__c == 'Yes') doc = true;

					if(doc && temp.Mobile__c != null){
						compMap.put(temp.Id, temp.Id);
						MessageSearch views = new MessageSearch();
						if(sendTarget.containsKey(temp.Id)) views.checked = true;
						else views.checked = false;
						views.Opt_In_SMS = temp.Opt_In_SMS__c;
						views.Personal_Agreement = temp.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = temp.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = temp.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = temp.Agreement_to_commit_info_processing__c;

						views.General_Personal_Information_Mandatory = temp.General_Personal_Information_Mandatory__c;
						views.General_Personal_InfoThirdParty_Optional = temp.General_Personal_InfoThirdParty_Optional__c;
						views.Targeted_Advertising_Info_Optional = temp.Targeted_Advertising_Info_Optional__c;
						views.General_Personal_Info_Mandatory = temp.General_Personal_Info_Mandatory__c;
						views.Targeted_Advert_Info_Optional_STCCC = temp.Targeted_Advert_Info_Optional_STCCC__c;
                        views.Agreement_to_commit_info_proces_CC_Old = temp.Agreement_to_commit_info_proces_CC_Old__c;
                        views.Personal_Agreement_CC_Old = temp.Personal_Agreement_CC_Old__c;
                        views.Personal_Info_Third_Party_Release_CC_Old = temp.Personal_Info_Third_Party_Release_CC_Old__c;

						views.recordId = temp.Id;
						views.AccountName = temp.Name;
						views.UCID = temp.UCID__c;
						views.Mobile = temp.Mobile__c;
						views.KaKao = temp.KaKao_Talk_ID__c;
						views.Doc = doc;
						views.Related = '(Account) '+temp.Name;
						MessageSearchList.add(views);
					}
				}

				for(Lead__c temp:leadList){
					Account acc = temp.Contact__r;
					Boolean doc = false; //Account Doc체크

					//Doc 체크 4개(1개라도 통과하면 발송 함)
					//1. Contact Method and Customer Consent (Old), 3. CCC Consent (old)
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

					if(doc && compMap.get(acc.Id) == null && acc.Mobile__c != null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						if(sendTarget.containsKey(acc.Id)) views.checked = true;
						else views.checked = false;
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;

						views.General_Personal_Information_Mandatory = acc.General_Personal_Information_Mandatory__c;
						views.General_Personal_InfoThirdParty_Optional = acc.General_Personal_InfoThirdParty_Optional__c;
						views.Targeted_Advertising_Info_Optional = acc.Targeted_Advertising_Info_Optional__c;
						views.General_Personal_Info_Mandatory = acc.General_Personal_Info_Mandatory__c;
						views.Targeted_Advert_Info_Optional_STCCC = acc.Targeted_Advert_Info_Optional_STCCC__c;
                        views.Agreement_to_commit_info_proces_CC_Old = acc.Agreement_to_commit_info_proces_CC_Old__c;
                        views.Personal_Agreement_CC_Old = acc.Personal_Agreement_CC_Old__c;
                        views.Personal_Info_Third_Party_Release_CC_Old = acc.Personal_Info_Third_Party_Release_CC_Old__c;

						views.AccountName = acc.Name;
						views.UCID = acc.UCID__c;
						views.Mobile = acc.Mobile__c;
						views.KaKao = acc.KaKao_Talk_ID__c;
						views.Doc = doc;
						views.Related = 'Lead : ' + temp.Name;
						MessageSearchList.add(views);
					}
				}

				Set<Id> CampaignIds = new Set<Id>();
				for(Campaign temp:CampaignList){
					CampaignIds.add(temp.Id);
				}
				List<CampaignMember> targetResults1 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c,
															Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
															Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
															Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
															Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
															Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c
													FROM CampaignMember WHERE Campaign.Id IN: CampaignIds
													AND Contact.Account.Personal_Agreement__c = 'Yes' AND Contact.Account.Personal_Information_Third_Party_Release__c = 'Yes' AND Contact.Account.Agreement_to_commit_info_processing__c = 'Yes'];

				List<CampaignMember> targetResults2 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c,
															Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
															Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
															Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
															Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
															Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c
													FROM CampaignMember WHERE Campaign.Id IN: CampaignIds
													AND Contact.Account.General_Personal_Information_Mandatory__c = 'Yes' AND Contact.Account.General_Personal_InfoThirdParty_Optional__c = 'Yes' AND Contact.Account.Targeted_Advertising_Info_Optional__c = 'Yes'];

				List<CampaignMember> targetResults3 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c,
															Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
															Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
															Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
															Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
															Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c
													FROM CampaignMember WHERE Campaign.Id IN: CampaignIds
													AND Contact.Account.General_Personal_Info_Mandatory__c = 'Yes' AND Contact.Account.Targeted_Advert_Info_Optional_STCCC__c = 'Yes'];

                List<CampaignMember> targetResults4 = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c, Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Campaign.Questionnaire__c,
                                                            Contact.Account.KaKao_Talk_ID__c, Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Main_Dealer__r.Name, Contact.Account.Main_Dealer__r.Dealer_Address_CN__c,
                                                            Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
                                                            Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c,
                                                            Contact.Account.General_Personal_Information_Mandatory__c, Contact.Account.General_Personal_InfoThirdParty_Optional__c, Contact.Account.Targeted_Advertising_Info_Optional__c,
                                                            Contact.Account.General_Personal_Info_Mandatory__c, Contact.Account.Targeted_Advert_Info_Optional_STCCC__c
                                                    FROM CampaignMember WHERE Campaign.Id IN: CampaignIds
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

				for(CampaignMember temp:targetMaps.values()){
					Account acc = temp.Contact.Account;
					Boolean doc = true; //Account Doc체크
					if(doc && compMap.get(acc.Id) == null && acc.Mobile__c != null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						if(sendTarget.containsKey(acc.Id)) views.checked = true;
						else views.checked = false;
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;

						views.General_Personal_Information_Mandatory = acc.General_Personal_Information_Mandatory__c;
						views.General_Personal_InfoThirdParty_Optional = acc.General_Personal_InfoThirdParty_Optional__c;
						views.Targeted_Advertising_Info_Optional = acc.Targeted_Advertising_Info_Optional__c;
						views.General_Personal_Info_Mandatory = acc.General_Personal_Info_Mandatory__c;
						views.Targeted_Advert_Info_Optional_STCCC = acc.Targeted_Advert_Info_Optional_STCCC__c;
                        views.Agreement_to_commit_info_proces_CC_Old = acc.Agreement_to_commit_info_proces_CC_Old__c;
                        views.Personal_Agreement_CC_Old = acc.Personal_Agreement_CC_Old__c;
                        views.Personal_Info_Third_Party_Release_CC_Old = acc.Personal_Info_Third_Party_Release_CC_Old__c;

						views.recordId = acc.Id;
						views.AccountName = acc.Name;
						views.UCID = acc.UCID__c;
						views.Mobile = acc.Mobile__c;
						views.KaKao = acc.KaKao_Talk_ID__c;
						views.Doc = true;
						views.Related = '(Campaign:'+temp.Campaign.Campaign_Code__c+') '+temp.Campaign.Name;
						MessageSearchList.add(views);
					}
				}

				for(Case temp:caseList){
					Account acc = temp.Account;
					Boolean doc = false; //Account Doc체크

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

					if(doc && compMap.get(acc.Id) == null && acc.Mobile__c != null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						if(sendTarget.containsKey(acc.Id)) views.checked = true;
						else views.checked = false;
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;

						views.General_Personal_Information_Mandatory = acc.General_Personal_Information_Mandatory__c;
						views.General_Personal_InfoThirdParty_Optional = acc.General_Personal_InfoThirdParty_Optional__c;
						views.Targeted_Advertising_Info_Optional = acc.Targeted_Advertising_Info_Optional__c;
						views.General_Personal_Info_Mandatory = acc.General_Personal_Info_Mandatory__c;
						views.Targeted_Advert_Info_Optional_STCCC = acc.Targeted_Advert_Info_Optional_STCCC__c;
                        views.Agreement_to_commit_info_proces_CC_Old = acc.Agreement_to_commit_info_proces_CC_Old__c;
                        views.Personal_Agreement_CC_Old = acc.Personal_Agreement_CC_Old__c;
                        views.Personal_Info_Third_Party_Release_CC_Old = acc.Personal_Info_Third_Party_Release_CC_Old__c;

						views.recordId = acc.Id;
						views.AccountName = acc.Name;
						views.UCID = acc.UCID__c;
						views.Mobile = acc.Mobile__c;
						views.KaKao = acc.KaKao_Talk_ID__c;
						views.Doc = true;
						views.Related = '(Case:'+temp.CaseNumber+') '+temp.Subject;
						MessageSearchList.add(views);
					}
				}

				for(Task temp:taskList){
					Boolean doc = true; //Task Doc체크
					if(doc && temp.Phone__c != null){
						MessageSearch views = new MessageSearch();
						if(sendTarget.containsKey(temp.Id)) views.checked = true;
						else views.checked = false;
						views.recordId = temp.Id;
						views.AccountName = temp.Account_Name__c;
						views.UCID = temp.UCID__c;
						views.Mobile = temp.Phone__c;
						views.KaKao = null;
						views.Doc = true;
						views.Related = '(Task) '+temp.Subject;
						views.RelatedWhat = temp.What.Id;
						views.RelatedWho = temp.Who.Id;
						views.RelatedWhatName = temp.What.Name;
						views.RelatedWhoName = temp.Who.Name;
						MessageSearchList.add(views);
					}
				}

				MessageSearchMap = new Map<String, MessageSearch>();
				for(MessageSearch ms : MessageSearchList){
					MessageSearchMap.put(ms.recordId, ms);
				}
			}else{
				GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
				gu.debug('검색할 단어를 입력 하세요.');
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '검색할 단어를 입력 하세요.'));
			}
		}catch(Exception e){
			GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
			gu.debug('검색 결과에 에러가 있습니다, 검색어를 변경 해주세요.');
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '검색 결과에 에러가 있습니다, 검색어를 변경 해주세요.'));
		}
	}

	//2018.06.22 메시지 수신대상자 확인 버튼 추가
	public void viewTargetList(){
		setIdAndCount();
		for(MessageSearch ms : MessageSearchMap.values()){
			if(sendTarget.containsKey(ms.recordId)){
				sendTargetMap.put(ms.recordId, ms);
			}
			else{
				if(sendTargetMap.containsKey(ms.recordId)){
					sendTargetMap.remove(ms.recordId);
				}
			}
		}

		sendTargetList = sendTargetMap.values();
		displayLayer = true;
	}

	public void removeTarget(){
		String sTarget = ApexPages.currentPage().getParameters().get('sendTarget');
		String tCount = ApexPages.currentPage().getParameters().get('targetCount');
		if(sTarget != null) {
			idList = idList.replace(',' + sTarget, '');
			sendTarget.remove(sTarget);
			sendTargetMap.remove(sTarget);

			if(MessageSearchMap.containsKey(sTarget)){
				MessageSearchMap.get(sTarget).checked = false;
			}
		}
		if(tCount != null) chkCount = Integer.valueOf(tCount) - 1;


		sendTargetList = sendTargetMap.values();
	}

	public void hideTargetList(){
		displayLayer = false;
	}

	@remoteAction
	public static String messageScheduling(String messageIds, String chkCnt){
		if(messageIds <> null && messageIds <> ''){
			MBK_Bulk_Message__c bulks = new MBK_Bulk_Message__c();
			bulks.PageSearch__c = true;
			bulks.PageSearchIDs__c = messageIds;
			bulks.PageSearchCount__c = integer.valueOf(chkCnt);
			insert bulks;
			return bulks.Id;
		}
		return 'failed';
	}

	public class MessageSearch{
		public String recordId{get;set;}
		public String AccountName{get;set;}
		public Boolean Opt_In_SMS{get;set;}
		public String Personal_Agreement{get;set;}
		public String Personal_Information_Third_Party_Release{get;set;}
		public String Personal_Abroad_Agreement{get;set;}
		public String Agreement_to_commit_info_processing{get;set;}

		public String General_Personal_Information_Mandatory{get;set;}
		public String General_Personal_InfoThirdParty_Optional{get;set;}
		public String Targeted_Advertising_Info_Optional{get;set;}
		public String General_Personal_Info_Mandatory{get;set;}
		public String Targeted_Advert_Info_Optional_STCCC{get;set;}

        public String Agreement_to_commit_info_proces_CC_Old{get;set;}
        public String Personal_Agreement_CC_Old{get;set;}
        public String Personal_Info_Third_Party_Release_CC_Old{get;set;}

		public String KaKao{get;set;}
		public String UCID{get;set;}
		public String Mobile{get;set;}
		public Boolean Doc{get;set;}
		public String Related{get;set;}
		public String RelatedWhat{get;set;}
		public String RelatedWho{get;set;}
		public String RelatedWhatName{get;set;}
		public String RelatedWhoName{get;set;}
		public Boolean checked{get;set;}
	}

	//2018.6.22 다른 내용을 검색하더라도 초기화되지 않게 수정
	public void allChecking() {
		for(MessageSearch msItem : MessageSearchList) {
			msItem.checked = allChecked;
			if(allChecked) {
				if(!sendTarget.containsKey(msItem.recordId)) {
					chkCount++;
					idList += ',' + msItem.recordId;
					sendTarget.put(msItem.recordId, msItem.recordId);
				}
			}
			else{
				if(sendTarget.containsKey(msItem.recordId)) {
					chkCount--;
					idList = idList.replace(',' + msItem.recordId, '');
					sendTarget.remove(msItem.recordId);
				}
			}
		}
		system.debug('idList : ' + idList);
		system.debug('chkCount : ' + chkCount);
	}

	public void setIdAndCount(){
		sendTarget.clear();
		String sTarget = ApexPages.currentPage().getParameters().get('sendTarget');
		String tCount = ApexPages.currentPage().getParameters().get('targetCount');
		idList = sTarget;
		if(sTarget != null){
			List<String> targetList = sTarget.split(',');
			for(String target : targetList){
				sendTarget.put(target, target);
			}
		}
		if(tCount != null) chkCount = Integer.valueOf(tCount);
		system.debug('idList : ' + idList);
		system.debug('chkCount : ' + chkCount);
	}
}