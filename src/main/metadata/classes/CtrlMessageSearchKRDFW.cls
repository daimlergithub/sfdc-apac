/**
 * Class Name	: CtrlMessageSearchKRDFW.cls
 * Function		: MBK Message Target Controller
 * VFPage		: PageMessageSearchKRDFW
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 전송 Target 검색(체크 후 싱글, 대량 발송)	
*/
public with sharing class CtrlMessageSearchKRDFW {
	public list<MessageSearch> MessageSearchList{get;set;}
	public String searchStr{get;set;}
	private map<String, String> compMap{get;set;}
	public Boolean allChecked{get;set;}
	public Integer chkCount{get;set;}
	public String idList {get;set;}
		
	public CtrlMessageSearchKRDFW(){
		MessageSearchList = new list<MessageSearch>();	
		compMap = new map<String, String>();
		allChecked = false;
		chkCount = 0;
		idList ='';
		searchStr = '';
	}

	public void targetSearch(){
		allChecked = false;
		chkCount = 0;
		idList ='';
		MessageSearchList = new list<MessageSearch>();	
		if(searchStr <> null && searchStr <> ''){
			try{
				searchStr = searchStr.replace('-','\\-');
				String searchquery = 'FIND {'+ searchStr +'*} IN ALL FIELDS RETURNING ' 
							+ ' Account(Id, Name, UCID__c, Mobile__c, Opt_In_SMS__c, KaKao_Talk_ID__c,'
							+ '  Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,'
							+ '  Agreement_to_commit_info_processing__c),'
							+ ' Lead__c(Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.Mobile__c,'
							+ '  Contact__r.Name, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c, '
							+ '  Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, '
							+ '  Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c), '
							+ ' Campaign(Id), '
							+ ' Case(Id, Subject, CaseNumber,Contact.Account.Id, Contact.Account.UCID__c, Contact.Account.Mobile__c, '
							+ '  Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Contact.Account.KaKao_Talk_ID__c, '
							+ '  Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,'
							+ '  Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c), '
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
					Boolean doc = true; //Account Doc체크
			    	//if(!temp.Opt_In_SMS__c) doc = false;
			    	if(temp.Personal_Agreement__c <> 'Yes') doc = false;	
			    	else if(temp.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
			    	else if(temp.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
			    	else if(temp.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;			
					if(doc){
						compMap.put(temp.Id, temp.Id);
						MessageSearch views = new MessageSearch();
						views.Opt_In_SMS = temp.Opt_In_SMS__c;
						views.Personal_Agreement = temp.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = temp.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = temp.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = temp.Agreement_to_commit_info_processing__c;					
						views.checked = false;
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
					Boolean doc = true; //Account Doc체크
			    	//if(!acc.Opt_In_SMS__c) doc = false;
			    	if(acc.Personal_Agreement__c <> 'Yes') doc = false;	
			    	else if(acc.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
			    	else if(acc.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
			    	else if(acc.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;					
					
					if(doc && compMap.get(acc.Id) == null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;					
						views.checked = false;
						views.recordId = acc.Id;
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
				List<CampaignMember> camMemList = [SELECT Id, Contact.AccountId, Contact.Account.UCID__c, Contact.Account.Mobile__c,
														Contact.Account.Name, Contact.Account.Opt_In_SMS__c, Contact.Account.KaKao_Talk_ID__c, 
														Campaign.Name, Campaign.Campaign_Code__c, Contact.Account.Personal_Agreement__c, 
														Contact.Account.Personal_Information_Third_Party_Release__c,
														Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c
													FROM CampaignMember WHERE Campaign.Id IN: CampaignIds];			
				for(CampaignMember temp:camMemList){
					Account acc = temp.Contact.Account;
					Boolean doc = true; //Account Doc체크
			    	//if(!acc.Opt_In_SMS__c) doc = false;
			    	if(acc.Personal_Agreement__c <> 'Yes') doc = false;	
			    	else if(acc.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
			    	else if(acc.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
			    	else if(acc.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;					
					if(doc && compMap.get(acc.Id) == null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;							
						views.checked = false;
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
					Account acc = temp.Contact.Account;
					Boolean doc = true; //Account Doc체크
			    	//if(!acc.Opt_In_SMS__c) doc = false;
			    	if(acc.Personal_Agreement__c <> 'Yes') doc = false;	
			    	else if(acc.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
			    	else if(acc.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
			    	else if(acc.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;							
					if(doc && compMap.get(acc.Id) == null){
						compMap.put(acc.Id, acc.Id);
						MessageSearch views = new MessageSearch();
						views.Opt_In_SMS = acc.Opt_In_SMS__c;
						views.Personal_Agreement = acc.Personal_Agreement__c;
						views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;						
						views.checked = false;
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
					if(doc){
						MessageSearch views = new MessageSearch();
						//views.Opt_In_SMS = true;
						//views.Personal_Agreement = acc.Personal_Agreement__c;
						//views.Personal_Information_Third_Party_Release = acc.Personal_Information_Third_Party_Release__c;
						//views.Personal_Abroad_Agreement = acc.Personal_Abroad_Agreement__c;
						//views.Agreement_to_commit_info_processing = acc.Agreement_to_commit_info_processing__c;						
						views.checked = false;
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
			}catch(Exception e){
				GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
				gu.debug('검색 결과에 에러가 있습니다, 검색어를 변경 해주세요.');
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '검색 결과에 에러가 있습니다, 검색어를 변경 해주세요.'));			
			}			
		}else{
			GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
			gu.debug('검색할 단어를 입력 하세요.');
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '검색할 단어를 입력 하세요.'));
		}		
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
	
	public void allChecking() {
		chkCount = 0;
		idList = '';
		
		for(MessageSearch msItem : MessageSearchList) {
			msItem.checked = allChecked;
			if(allChecked) {
				chkCount++;
				idList = idList + ',' + msItem.recordId;
			}
		}
	}
	
}