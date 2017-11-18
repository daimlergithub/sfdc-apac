/**
 * Class Name	: CtrlMessageServiceKRDFW.cls
 * Function		: MBK Message Popup Controller
 * VFPage		: PageMessagePopupKRDFW.page
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 메시지전송 팝업 관리 컨트롤러(템플릿, 전송대상자(싱글용/멀티용), 전송개체저장)	
*/
public with sharing class CtrlMessageServiceKRDFW {
	public Boolean isBulk{get;set;}
	public Boolean doc{get;set;}
	public Boolean IsSend{get;set;}
	public String TargetID{get;set;}
	public String actionType{get;set;}
    public String Mtype{get;set;}
    public String socLabel{get;set;}
    public String bulkSocName{get;set;}
    public String pageBulkMessageId{get;set;}
    public MBK_Messages__c viewObject{get;set;}
    public Attachment mmsFile1{get;set;}
    public Attachment mmsFile2{get;set;}
    public Attachment mmsFile3{get;set;}
    public Integer fileSize1{get;set;}
    public Integer fileSize2{get;set;}
    public Integer fileSize3{get;set;}
    public Integer MemberCount{get;set;}
    public Integer TargetCount{get;set;}
    public ApexPages.StandardSetController MessageStcon{get;set;}
    public Integer NoOfRecords {get;set;} 
    public Integer TemplateSize {get;set;}
    public String SendTemplateId{get;set;}
    //public List<MBK_Message_Template__c> MessageTemplates{get;set;}
    //private map<Id, MBK_Message_Template__c> retTemplates{get;set;}
    
    //Template 변경
    public List<Template__c> MessageTemplatesOrg{get;set;}
    private map<Id, Template__c> retTemplatesOrg{get;set;}    
    
    
    private static Map<String, Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe() ;
    private MBK_Bulk_Message__c BulkMessage{get;set;}
    
    public CtrlMessageServiceKRDFW(){
    	IsSend = false;
    	isBulk = false;
    	doc = true;
    	socLabel = 'Bulk Messages';
    	TargetID = Apexpages.currentPage().getParameters().get('id');
    	actionType = Apexpages.currentPage().getParameters().get('action');
    	pageBulkMessageId = Apexpages.currentPage().getParameters().get('bulkMessageId');
    	if(Mtype == null) Mtype = 'SMS/MMS';
		mmsFile1 = new Attachment ();
		mmsFile2 = new Attachment ();
		mmsFile3 = new Attachment ();
		//MessageTemplates = new List<MBK_Message_Template__c>();
		MessageTemplatesOrg = new List<Template__c>();
		viewObject = new MBK_Messages__c();
		fileSize1 = 0;
		fileSize2 = 0;
		fileSize3 = 0;
		TemplateSize = 0;
		NoOfRecords = 0;				

		if(TargetID <> null){
			if(actionType == system.label.MBK_MessageType_Edit) getMBKMessage();			//Message
	    	else if(TargetID.left(3) == getObjectPrefix('Lead__c')) getTargetLead();		//leads
	    	else if(TargetID.left(3) == getObjectPrefix('Account')) getTargetAccount();		//Account
	    	else if(TargetID.left(3) == getObjectPrefix('Task')) getTargetTask();			//Task
	    	else if(TargetID.left(3) == getObjectPrefix('Case')) getTargetCase();			//Case
	    	else if(TargetID.left(3) == getObjectPrefix('Campaign')) getTargetCampaign();	//Campaign
	    	else if(TargetID.left(3) == getObjectPrefix('Survey__c')) getTargetSurvey();	//Survey
		}else if(pageBulkMessageId <> null){
			BulkMessage = new MBK_Bulk_Message__c();
			getPageBulkMessages();
		}
		TypeOfTemplates();
    }
	
	private String getObjectPrefix(String objectName){
		Schema.SObjectType sObjectType = sObjectTypes.get(objectName) ;
		Schema.DescribeSObjectResult result = sObjectType.getDescribe() ;
		String keyPrefix = result.getKeyPrefix();
		return keyPrefix;
	}
	
	/* get Message Templates, param:Mtype */    
	public void TypeOfTemplates() {
        /*
        retTemplates =  new map<Id, MBK_Message_Template__c>([SELECT Id, Subject__c, Contents__c, Template_ID__c, Type__c 
		        												FROM MBK_Message_Template__c
		                										WHERE Type__c =: Mtype AND Active__c = true]);
		*/		                										
		String query = ' SELECT Id, Subject__c, Message_Detail__c, Template_ID__c, RecordType.Name '
					+ 'FROM Template__c WHERE Active__c = true ';			
					if(Mtype == 'KaKao') query += 'AND RecordType.Name = \'KaKao\' ';
					else query += 'AND (RecordType.Name = \'SMS\' Or RecordType.Name = \'MMS\') ';
system.debug(query);					
		List<Template__c> temps = Database.query(query);					 		                										
		retTemplatesOrg = new map<Id, Template__c>();		                										
		
		for(Template__c temp:temps){
			retTemplatesOrg.put(temp.Id, temp);
		}
		            										
    	TemplateSize = 5;
    	//MessageStcon = new ApexPages.StandardSetController(retTemplates.values());
    	MessageStcon = new ApexPages.StandardSetController(retTemplatesOrg.values());
    	MessageStcon.setPageSize(TemplateSize);
    	if(NoOfRecords == null) NoOfRecords = 0;
    	else NoOfRecords = MessageStcon.getResultSize();
    	MessageTemplatesOrg = getTemplatesOrg();
    	
    	viewObject.subject__c = null;
    	viewObject.message__c = null;
    	viewObject.Set_Sending_Time__c = null;
    }
    
    /*
    // MBK_Message_Template pagging
    public List<MBK_Message_Template__c> getTemplates(){
    	List<MBK_Message_Template__c> lList = new List<MBK_Message_Template__c>();
    	for(MBK_Message_Template__c l : (List<MBK_Message_Template__c>)MessageStcon.getRecords()){
    		lList.add(l);
    	}

    	if(lList.size() < 5){
    		integer cnt = 5-lList.size();
    		for(integer i = 0; i < cnt; i++){
    			MBK_Message_Template__c tempInsert = new MBK_Message_Template__c();
    			lList.add(tempInsert);
    		}
    	}
    	system.debug(lList.size());
    	return lList;
    }
    */

    // Template__c pagging
    public List<Template__c> getTemplatesOrg(){
    	List<Template__c> lList = new List<Template__c>();
    	for(Template__c l : (List<Template__c>)MessageStcon.getRecords()){
    		lList.add(l);
    	}

    	if(lList.size() < 5){
    		integer cnt = 5-lList.size();
    		for(integer i = 0; i < cnt; i++){
    			Template__c tempInsert = new Template__c();
    			lList.add(tempInsert);
    		}
    	}
    	system.debug(lList.size());
    	return lList;
    }    

	public Boolean TemplateHasNext{
    	get{
    		if(MessageStcon == null) return false;
    		else return MessageStcon.getHasNext();
    	}
    	set;
    }
    
    public Boolean TemplateHasPrevious{
    	get{
    		if(MessageStcon == null) return false;
    		else return MessageStcon.getHasPrevious();
    	}
    	set;
    }
    
    public Integer TemplatePageNumber{
    	get{
    		if(MessageStcon == null) return 1;
    		else return MessageStcon.getPageNumber();
    	}
    	set;
    }
    
    public void TemplateFirst(){
    	if(MessageStcon <> null){
	    	MessageStcon.first();
	    	MessageTemplatesOrg = getTemplatesOrg();
    	}
    }
    
    public void TemplateLast(){
    	if(MessageStcon <> null){
	    	MessageStcon.last();
	    	MessageTemplatesOrg = getTemplatesOrg();
    	}
    }
    
    public void TemplatePrevious(){
    	if(MessageStcon <> null){
	    	MessageStcon.previous();
	    	MessageTemplatesOrg = getTemplatesOrg();
    	}
    }
    
    public void TemplateNext(){
    	if(MessageStcon <> null){
    		MessageStcon.next();
    		MessageTemplatesOrg = getTemplatesOrg();
    	}
    }    
    // MBK_Message_Template pagging
        
    private void getTargetLead(){
    	Lead__c target = [SELECT Id, Name, Contact__c, Contact__r.UCID__c, Contact__r.PersonMobilePhone, Contact__r.PersonEmail, 
    							Contact__r.Name, Contact__r.Email2__c, Contact__r.Opt_In_SMS__c, Contact__r.KaKao_Talk_ID__c, 
    							Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c, 
    							Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c
						FROM Lead__c WHERE Id =: TargetID];
    	viewObject.Leads__c = target.Id;
    	viewObject.Account_Name__c = target.Contact__r.Name;
		//if(!target.Contact__r.Opt_In_SMS__c) doc = false;
    	if(target.Contact__r.Personal_Agreement__c <> 'Yes') doc = false;	
    	else if(target.Contact__r.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
    	else if(target.Contact__r.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
    	else if(target.Contact__r.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;
    	
    	viewObject.Opt_In_SMS__c  = target.Contact__r.Opt_In_SMS__c;
    	viewObject.Personal_Agreement__c = target.Contact__r.Personal_Agreement__c;
    	viewObject.Personal_Information_Third_Party_Release__c = target.Contact__r.Personal_Information_Third_Party_Release__c;
    	viewObject.Personal_Abroad_Agreement__c = target.Contact__r.Personal_Abroad_Agreement__c;
    	viewObject.Agreement_to_commit_info_processing__c = target.Contact__r.Agreement_to_commit_info_processing__c;
    	viewObject.KaKaoTalk_ID__c = target.Contact__r.KaKao_Talk_ID__c; 
    	viewObject.UCID__c = target.Contact__r.UCID__c; 
    	viewObject.phoneNum__c = target.Contact__r.PersonMobilePhone;		
    }
    
    private void getTargetAccount(){
    	Account target = [SELECT Id, Name, UCID__c, PersonMobilePhone, PersonEmail, Opt_In_SMS__c, KaKao_Talk_ID__c,
    							 Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c,
    							 Agreement_to_commit_info_processing__c 
    						FROM Account WHERE Id =: TargetID];
system.debug('target:'+target);    						
    	viewObject.Account__c = target.Id;
    	viewObject.Account_Name__c = target.Name;
		//if(!target.Opt_In_SMS__c) doc = false;
    	if(target.Personal_Agreement__c <> 'Yes') doc = false;	
    	else if(target.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
    	else if(target.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
    	else if(target.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;
    	
    	viewObject.Opt_In_SMS__c  = target.Opt_In_SMS__c;
    	viewObject.Personal_Agreement__c = target.Personal_Agreement__c;
    	viewObject.Personal_Information_Third_Party_Release__c = target.Personal_Information_Third_Party_Release__c;
    	viewObject.Personal_Abroad_Agreement__c = target.Personal_Abroad_Agreement__c;
    	viewObject.Agreement_to_commit_info_processing__c = target.Agreement_to_commit_info_processing__c;
    	viewObject.KaKaoTalk_ID__c = target.KaKao_Talk_ID__c; 
    	viewObject.UCID__c = target.UCID__c; 
    	viewObject.phoneNum__c = target.PersonMobilePhone;
    }
    
    private void getTargetTask(){
    	Task target = [SELECT Id, Account_Name__c, CustomerName__c, PersonMobilePhone__c, UCID__c, Email_Address__c, Phone__c 
    					FROM Task WHERE Id =: TargetID];

    	viewObject.Account_Name__c = target.Account_Name__c;
    	doc = true; //확인	
    	viewObject.UCID__c = target.UCID__c; 
    	viewObject.phoneNum__c = target.PersonMobilePhone__c == null ? target.Phone__c : target.PersonMobilePhone__c;		
    }
    
    private void getTargetCase(){
    	Case target = [SELECT Id, Contact.Account.Id, Contact.Account.UCID__c, Contact.Account.PersonMobilePhone, Contact.Account.PersonEmail, 
    							Contact.Account.Name, Contact.Account.Email2__c, Contact.Account.Opt_In_SMS__c, Contact.Account.KaKao_Talk_ID__c, 
    							Contact.Account.Personal_Agreement__c, Contact.Account.Personal_Information_Third_Party_Release__c,
    							Contact.Account.Personal_Abroad_Agreement__c, Contact.Account.Agreement_to_commit_info_processing__c
    						FROM Case WHERE Id =: TargetID];
    	viewObject.Case__c = target.Id;
    	viewObject.Account_Name__c = target.Contact.Account.Name;
		//if(!target.Contact.Account.Opt_In_SMS__c) doc = false;    	
    	if(target.Contact.Account.Personal_Agreement__c <> 'Yes') doc = false;	
    	else if(target.Contact.Account.Personal_Information_Third_Party_Release__c <> 'Yes') doc = false;
    	else if(target.Contact.Account.Personal_Abroad_Agreement__c <> 'Yes') doc = false;
    	else if(target.Contact.Account.Agreement_to_commit_info_processing__c <> 'Yes') doc = false;
    	
    	viewObject.Opt_In_SMS__c  = target.Contact.Account.Opt_In_SMS__c;
    	viewObject.Personal_Agreement__c = target.Contact.Account.Personal_Agreement__c;
    	viewObject.Personal_Information_Third_Party_Release__c = target.Contact.Account.Personal_Information_Third_Party_Release__c;
    	viewObject.Personal_Abroad_Agreement__c = target.Contact.Account.Personal_Abroad_Agreement__c;
    	viewObject.Agreement_to_commit_info_processing__c = target.Contact.Account.Agreement_to_commit_info_processing__c;
    	viewObject.KaKaoTalk_ID__c = target.Contact.Account.KaKao_Talk_ID__c; 
    	viewObject.UCID__c = target.Contact.Account.UCID__c; 
    	viewObject.phoneNum__c = target.Contact.Account.PersonMobilePhone;										 
    }
    
    private void getTargetCampaign(){
		bulkSocName = [SELECT Name FROM Campaign WHERE Id =: TargetID].Name;
		AggregateResult[] memberResults = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID];
		AggregateResult[] targetResults = [SELECT Count(Id)cnt FROM CampaignMember WHERE CampaignId =: TargetID
											
											AND Contact.Account.Personal_Agreement__c = 'Yes'
											AND Contact.Account.Personal_Information_Third_Party_Release__c = 'Yes'
											AND Contact.Account.Personal_Abroad_Agreement__c = 'Yes'
											AND Contact.Account.Agreement_to_commit_info_processing__c = 'Yes' ];
											//AND Contact.Account.Opt_In_SMS__c = true
		MemberCount = Integer.valueOf(memberResults[0].get('cnt'));
		TargetCount = Integer.valueOf(targetResults[0].get('cnt'));
		isBulk = true;
		socLabel = 'Campaign'; 									
    }                
    
	private void getTargetSurvey(){
		isBulk = true;
		socLabel = 'Survey'; 	
    }    
    
    private void getPageBulkMessages(){
		BulkMessage = [SELECT Id, PageSearch__c, PageSearchCount__c, PageSearchIDs__c
							FROM MBK_Bulk_Message__c WHERE Id =: pageBulkMessageId];
		MemberCount = integer.valueOf(BulkMessage.PageSearchCount__c);
		TargetCount = integer.valueOf(BulkMessage.PageSearchCount__c);
		isBulk = true;
		socLabel = 'Page Bulk Message';
    }
    
    private void getMBKMessage(){
    	viewObject = [SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c, IsModify__c, 
							Leads__c, SendTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
							altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
							processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
							Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, 
							Agreement_to_commit_info_processing__c, Opt_In_SMS__c  
						FROM MBK_Messages__c WHERE Id =: TargetID];
		SendTemplateId = viewObject.SendTemplate__c; 						  		
		List<Attachment> Attachments;				
		if(viewObject.AttachmentImages__c){
			Attachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: TargetID];
			if(Attachments.size() >= 1) mmsFile1 = Attachments[0]; 
			if(Attachments.size() >= 2) mmsFile2 = Attachments[1]; 
			if(Attachments.size() == 3)	mmsFile3 = Attachments[2];
		}
		if(viewObject.channel__c == 'A') Mtype = 'KaKao';
    }
    
	/**
	 * SMS/LMS/MMS/KaKao Sending
	 **/
    public PageReference SendingMessage(){
		// Create a savepoint
		Savepoint sp = Database.setSavepoint();    	
		try{			
			SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
system.debug('SendTemplateId:'+SendTemplateId);			
			String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
system.debug('messagebyte:'+messagebyte);			
			//VC
			if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'KaKao Talk Error, Select Template'));
				return null;	
			}else{
				MBK_Messages__c insertObject = viewObject.clone();		
				//Sending Object Field Setting
				if(SendTemplateId <> null && SendTemplateId <> ''){					
		    		//MBK_Message_Template__c setTemplate = retTemplates.get(SendTemplateId);
		    		Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
		    		insertObject.SendTemplate__c = setTemplate.Id;
					insertObject.templateCode__c = setTemplate.Template_ID__c;	    		
				}
				if(Mtype == 'KaKao') insertObject.channel__c = system.label.MBK_Message_Channel_KaKao;
				else if(Mtype == 'SMS/MMS'){
					if(messagebyte <> null && integer.valueOf(messagebyte) > 80){
						insertObject.channel__c = system.label.MBK_Message_Channel_MMS;
					}else{
						insertObject.channel__c = system.label.MBK_Message_Channel_SMS;
					}
				}
				
				insertObject.custGubun__c  = system.label.MBK_Message_custGubun;
				//MMS파일 처리(Attachment)				
				if(mmsFile1.Name <> null || mmsFile2.Name <> null || mmsFile3.Name <> null){
					insertObject.AttachmentImages__c = true;
				}					 
				insertObject.senderKey__c = system.label.MBK_Message_SenderKey;
				insertObject.Status__c = 'Reserved';
				if(insertObject.Set_Sending_Time__c == null) insertObject.Set_Sending_Time__c = Datetime.now();
				//Send
				List<MBK_Messages__c> sendObjects = new List<MBK_Messages__c>();
				sendObjects.add(insertObject);
				insert sendObjects;
				List<Attachment> insertAttachments = new List<Attachment>();
				if(mmsFile1.Name <> null){
					mmsFile1.ParentId = insertObject.Id;
					insertAttachments.add(mmsFile1);
				}
				if(mmsFile2.Name <> null){
					mmsFile2.ParentId = insertObject.Id;
					insertAttachments.add(mmsFile2);
				}
				if(mmsFile3.Name <> null){
					mmsFile3.ParentId = insertObject.Id;
					insertAttachments.add(mmsFile3);
				}				
				if(insertAttachments.size() > 0){
					insert insertAttachments;
					mmsFile1 = new Attachment();
					mmsFile2 = new Attachment();
					mmsFile3 = new Attachment();
				}				
				insertObject = [SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c, IsModify__c, 
									Leads__c, SendTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
									altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
									processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
									Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, 
									Agreement_to_commit_info_processing__c, Opt_In_SMS__c  
								FROM MBK_Messages__c WHERE Id =: insertObject.Id];				
				if(!insertObject.IsModify__c){
					List<String> messageIds = new List<String>();
					messageIds.add(insertObject.Id);
					CtrlMessageAPIKRDFW.MBKMessageDirectSender(messageIds);
					if(TargetID.left(3) <> getObjectPrefix('Task')){
						//log					
						CtrlMessageAPIKRDFW.MBKMessageLogging(messageIds);
					}
				}
							
			}
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '['+Mtype+'] transfer has been requested.'));
			IsSend = true;
		}catch(Exception e){
			Database.rollback(sp);			
			system.debug('===== callout Exception =====');
			system.debug(e);
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'System Errpr:'+e));
		}
   		return null;
    }	
    
    /* bulk Sending */
    public PageReference BulkSendingMessage(){
		// Create a savepoint
		Savepoint sp = Database.setSavepoint();    	
		try{			
			String SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
			String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
			//VC
			if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No KaKaoTalk Template'));
				return null;	
			}else{
				if(socLabel == 'Page Bulk Message'){
					BulkMessage.Source_Object__c = 'Page';
					BulkMessage.Source_Object_Id__c = pageBulkMessageId; 
				}else{
					BulkMessage = new MBK_Bulk_Message__c();
					if(TargetID.left(3) == getObjectPrefix('Campaign')) BulkMessage.Source_Object__c = 'Campaign';
					else if(TargetID.left(3) == getObjectPrefix('Survey__c')) BulkMessage.Source_Object__c = 'Survey__c';
					BulkMessage.Source_Object_Id__c = TargetID;					
				}
				if(SendTemplateId <> null && SendTemplateId <> ''){					
		    		//MBK_Message_Template__c setTemplate = retTemplates.get(SendTemplateId);
		    		Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
		    		BulkMessage.Template_ID__c = setTemplate.Id;
					BulkMessage.Template_Code__c = setTemplate.Template_ID__c;	  		
				}				
				BulkMessage.Set_Sending_Time__c = viewObject.Set_Sending_Time__c == null ? Datetime.now() : viewObject.Set_Sending_Time__c;
				BulkMessage.Message__c = viewObject.message__c;		
				BulkMessage.Subject__c = viewObject.subject__c;

				if(Mtype == 'KaKao') BulkMessage.channel__c = system.label.MBK_Message_Channel_KaKao;
				else if(Mtype == 'SMS/MMS'){
					if(messagebyte <> null && integer.valueOf(messagebyte) > 80){
						BulkMessage.channel__c = system.label.MBK_Message_Channel_MMS;
					}else{
						BulkMessage.channel__c = system.label.MBK_Message_Channel_SMS;
					}
				}
				
				upsert BulkMessage;
				if(BulkMessage.channel__c == 'M'){
					//MMS파일 처리(Attachment)		
					List<Attachment> insertAttachments = new List<Attachment>();
					if(mmsFile1.Name <> null){
						mmsFile1.ParentId = BulkMessage.Id;
						insertAttachments.add(mmsFile1);
					}
					if(mmsFile2.Name <> null){
						mmsFile2.ParentId = BulkMessage.Id;
						insertAttachments.add(mmsFile2);
					}
					if(mmsFile3.Name <> null){
						mmsFile3.ParentId = BulkMessage.Id;
						insertAttachments.add(mmsFile3);
					}				
					if(insertAttachments.size() > 0){
						insert insertAttachments;
						mmsFile1 = new Attachment();
						mmsFile2 = new Attachment();
						mmsFile3 = new Attachment();
					}	
				}					
			}
			if(BulkMessage.Source_Object__c == 'Page'){
				MBKBulkMessageCreateKRDFWBatch bulkBatch = new MBKBulkMessageCreateKRDFWBatch();
				bulkBatch.batchId = BulkMessage.Id;
				bulkBatch.batchType = 'Page';
				database.executeBatch(bulkBatch, 1);
			}
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'Bulk ['+Mtype+'] transfer has been requested.'));
			IsSend = true;
			return null;
		}catch(Exception e){
			Database.rollback(sp);			
			system.debug('===== callout Exception =====');
			system.debug(e);
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error : '+e));
		}
   		return null;
    }
    
    /* Message update */
    public PageReference updateMessage(){
		// Create a savepoint
		Savepoint sp = Database.setSavepoint();    	
		try{			
			SendTemplateId = Apexpages.currentPage().getParameters().get('SendTemplate');
			String messagebyte = Apexpages.currentPage().getParameters().get('messagebyte');
			//VC
			if(Mtype == 'KaKao' && (SendTemplateId == null || SendTemplateId == '')){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No KaKaoTalk Template'));
				return null;	
			}else{
				//Sending Object Field Setting
				if(SendTemplateId <> null && SendTemplateId <> ''){					
		    		//MBK_Message_Template__c setTemplate = retTemplates.get(SendTemplateId);
		    		Template__c setTemplate = retTemplatesOrg.get(SendTemplateId);
		    		viewObject.SendTemplate__c = setTemplate.Id;
					viewObject.templateCode__c = setTemplate.Template_ID__c;	    		
				}
				
				if(Mtype == 'KaKao') viewObject.channel__c = system.label.MBK_Message_Channel_KaKao;
				else if(Mtype == 'SMS/MMS'){
					if(messagebyte <> null && integer.valueOf(messagebyte) > 80){
						viewObject.channel__c = system.label.MBK_Message_Channel_MMS;
					}else{
						viewObject.channel__c = system.label.MBK_Message_Channel_SMS;
					}
				}
				
				viewObject.custGubun__c  = system.label.MBK_Message_custGubun;
				//MMS파일 처리(Attachment)				
				if(mmsFile1.Name <> null || mmsFile2.Name <> null || mmsFile3.Name <> null){
					viewObject.AttachmentImages__c = true;
				}					 
				viewObject.senderKey__c = system.label.MBK_Message_SenderKey;
				
				//Send
				List<MBK_Messages__c> sendObjects = new List<MBK_Messages__c>();
				sendObjects.add(viewObject);
system.debug(sendObjects);				
				update sendObjects;
				List<Attachment> insertAttachments = new List<Attachment>();
				if(mmsFile1.Name <> null){
					mmsFile1.ParentId = viewObject.Id;
					insertAttachments.add(mmsFile1);
				}
				if(mmsFile2.Name <> null){
					mmsFile2.ParentId = viewObject.Id;
					insertAttachments.add(mmsFile2);
				}
				if(mmsFile3.Name <> null){
					mmsFile3.ParentId = viewObject.Id;
					insertAttachments.add(mmsFile3);
				}
				
				//Mtype변경시 이미지가 있으면 삭제
				if(Mtype <> 'MMS'){
					List<Attachment> delImgs = [SELECT Id FROM Attachment WHERE ParentId =: viewObject.Id];
					if(delImgs.size() > 0) delete delImgs;
				}
				
				if(insertAttachments.size() > 0){
					insert insertAttachments;
					mmsFile1 = new Attachment();
					mmsFile2 = new Attachment();
					mmsFile3 = new Attachment();
				}
				
				viewObject = [SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c, IsModify__c, 
									Leads__c, SendTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c ,
									altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, 
									processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c,
									Personal_Agreement__c, Personal_Information_Third_Party_Release__c, Personal_Abroad_Agreement__c, 
									Agreement_to_commit_info_processing__c, Opt_In_SMS__c  
								FROM MBK_Messages__c WHERE Id =: viewObject.Id];	

				if(!viewObject.IsModify__c){
					List<String> messageIds = new List<String>();
					messageIds.add(viewObject.Id);
					CtrlMessageAPIKRDFW.MBKMessageDirectSender(messageIds);
					if(TargetID.left(3) <> getObjectPrefix('Task')){
						//log			
						CtrlMessageAPIKRDFW.MBKMessageLogging(messageIds);
					}
				}		
			}
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, '['+Mtype+'] transfer has been requested.'));
			return null;
		}catch(Exception e){
			Database.rollback(sp);			
			system.debug('===== callout Exception =====');
			system.debug(e);
		}
   		return null;
    }
}