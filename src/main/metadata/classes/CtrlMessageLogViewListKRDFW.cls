/**
 * Class Name	: CtrlMessageLogViewListKRDFW.cls
 * Function		: MBK Message Send Logs Controller
 * VFPage		: PageMessageLogViewListKRDFW
 * Author		: I2MAX
 * Date			: 2017.09.29
 * Description	: 전송개체 관리(예약수정, 예약취소, view 리스트 정렬)	
*/
public with sharing class CtrlMessageLogViewListKRDFW {
	public List<MBK_Messages__c> MBKMessageLogs{get;set;}
	public ApexPages.StandardSetController MessageStcon{get;set;}
	public Integer NoOfRecords {get;set;}
	public Integer LogsSize {get;set;}
	public String sortField = 'LastModifiedDate';  // default sort column
	public String baseUrl{get;set;}
	public Boolean isPartner{get;set;}
	private String sApplySOQL = ''; 
	private Boolean notSort;
	// the current sort direction. defaults to ascending
    public String sortDir {
        get{ 
        	if(sortDir == null){  
        		sortDir = 'asc'; 
        	}
        	return sortDir;  
        }
        set;
    }
    // the current field to sort by. defaults to role name
    public String getsortField() {
        return sortField;
    }

    // the current field to sort by. 
    public void setsortField(String value) {
        sortField = value;
    }

	public CtrlMessageLogViewListKRDFW(){
		baseUrl = 'https://'+URL.getSalesforceBaseUrl().getHost();
		notSort = false;
		isPartner = getIsParnter();
		LogsSize = 100;
		NoOfRecords = 0;		
		sApplySOQL = ' SELECT Account__c, Account_Name__c, Campaign_Member__c, Case__c, KaKaoTalk_ID__c, IsModify__c, '  
					+' LastModifiedDate, Leads__c, MBKMessageTemplate__c, Name, Id, Set_Sending_Time__c, Status__c, UCID__c, altCode__c, ' 
					+' altMsg__c, channel__c, code__c, custGubun__c, AttachmentImages__c, message__c, phoneNum__c, ' 
					+' processed__c, reqDtm__c, senderKey__c, sn__c, sndDtm__c, subject__c, templateCode__c, Campaign__c '
					+' FROM MBK_Messages__c Order By LastModifiedDate desc limit 50000';
		toggleSort();									
	}
	
	private Boolean getIsParnter(){
		User user = [SELECT Id, AccountId FROM User WHERE Id =: userinfo.getuserid()];
		if(user.AccountId == null) return false;
		else return true;
	}
 	// MBK_Message_Logs pagging
    public List<MBK_Messages__c> getMessageLogs(){
    	List<MBK_Messages__c> lList = new List<MBK_Messages__c>();
    	for(MBK_Messages__c l : (List<MBK_Messages__c>)MessageStcon.getRecords()){
    		lList.add(l);
    	}
    	return lList;
    }    
	public Boolean LogsHasNext{
    	get{
    		if(MessageStcon == null) return false;
    		else return MessageStcon.getHasNext();
    	}
    	set;
    }
    
    public Boolean LogsHasPrevious{
    	get{
    		if(MessageStcon == null) return false;
    		else return MessageStcon.getHasPrevious();
    	}
    	set;
    }
    
    public Integer LogsPageNumber{
    	get{
    		if(MessageStcon == null) return 1;
    		else return MessageStcon.getPageNumber();
    	}
    	set;
    }
    
    public void LogsFirst(){
    	if(MessageStcon <> null){
	    	MessageStcon.first();
	    	MBKMessageLogs = getMessageLogs();
    	}
    }
    
    public void LogsLast(){
    	if(MessageStcon <> null){
	    	MessageStcon.last();
	    	MBKMessageLogs = getMessageLogs();
    	}
    }
    
    public void LogsPrevious(){
    	if(MessageStcon <> null){
	    	MessageStcon.previous();
	    	MBKMessageLogs = getMessageLogs();
    	}
    }
    
    public void LogsNext(){
    	if(MessageStcon <> null){
    		MessageStcon.next();
    		MBKMessageLogs = getMessageLogs();
    	}
    }    
    // MBK_Message_Logs pagging
    
	
    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        // simply toggle the direction
        if(!notSort) sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
       	else sortDir = sortDir;
       	 
        integer iIndex = sApplySOQL.indexOf('Order By');
        if (iIndex > -1){
          sApplySOQL = sApplySOQL.substringBefore('Order By');
          sApplySOQL = sApplySOQL + ' Order By ' + sortField + ' ' + sortDir;
        }
		List<MBK_Messages__c> Logs = Database.query(sApplySOQL+' limit 50000');
    	MessageStcon = new ApexPages.StandardSetController(Logs);
    	MessageStcon.setPageSize(LogsSize);
    	if(NoOfRecords == null) NoOfRecords = 0;
    	else NoOfRecords = MessageStcon.getResultSize();
    	MBKMessageLogs = getMessageLogs();
    	notSort = false;	
    }  
	
	public void pageRefresh(){
		notSort = true;
		toggleSort();
	}	

	@RemoteAction
	public static Boolean ScheduleSendCancel(String MessageId){
		try{
			MBK_Messages__c cancelData = [SELECT Id, processed__c, Status__c FROM MBK_Messages__c WHERE Id =: MessageId];
			cancelData.processed__c = true;
			cancelData.Status__c = 'Cancel';
			update cancelData;
		}catch (System.Exception e){
			GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance();
			gu.DebugException(e,userinfo.getUserId());
			return false;
		}
		
		return true;
	}

    
}