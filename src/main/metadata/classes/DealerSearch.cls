Public WithOut Sharing class DealerSearch{
public String size { get; set; }

//This is Our collection of the class/wrapper objects AddingParticipatingDealer 
Public List<AddingParticipatingDealer> wrapperlist{get;set;}
Public Integer noOfRecords{get; set;}
private String objectAPIName;
// Create a new Map to verify whether the Account is already added in the Map
Map <id,Account> SelectedAccountMap = new Map <id,Account>();
Set<id> Checkid = New Set<id>();

List<Group> grplist=new List<Group>();
public boolean display{get;set;}
public list<Account> selectedList {get;set;}
public String regionValue {get;set;}    
public List<SelectOption> regionOptions {get;set;}

public String dealerCode {get;set;} 
public String DealerNDCode {get;set;} 
public String Name  {get;set;} 
public String DealerActive  {get;set;} 
public String obId {get;set;}
public Boolean panelStopper {get;set;}
public String soql {get;set;}
Set<String> getDealerNDCode= new Set<String>();
map<string,id> assgroupMap = new map<string,id>();
List<DM_Material__share> cpnShares = new List<DM_Material__share>();
List<Survey__Share> cpnShares1 = new List<Survey__Share>();
// private String soql {get;set;}

public DealerSearch(){ 
    regionOptions = new List<SelectOption>();
    regionOptions.add(new SelectOption('aid','All Dealer'));
    regionOptions.add(new SelectOption('sid','Select A Dealer'));
    //SearchLogic();
    panelStopper = false;
    Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name,Dealer_Type__c,Dealer_GC_Code__c,Dealer_ND_Code__c,Parent.Dealer_ND_Code__c FROM Account Where RecordType.Name = 'Dealer' AND MD__c ='KR' AND Dealer_Active__c = true]));
   
   
    obId =ApexPages.currentPage().getParameters().get('id');
    if(obId != '')
    {
      objectAPIName = (Id.valueOf(obId)).getSObjectType().getDescribe().getName();
    }
    
    
    
}

//Returns a list of wrapper objects for the sObjects in the current page set
Public Void dropDown(){
    if(regionValue == 'sid' ){
        panelStopper = true;
    } 
    else if(regionValue == 'aid' ){
        panelStopper = false;
        
    Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name,Dealer_Type__c,Dealer_GC_Code__c,Dealer_ND_Code__c,Parent.Dealer_ND_Code__c FROM Account Where RecordType.Name = 'Dealer' AND MD__c ='KR' AND Dealer_Active__c = true])); 
    setCon.setpagesize(10);
    }
}

public ApexPages.StandardSetController setCon {get;set;}


Public void SearchLogic(){
     
     Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
     String md = 'KR';
     String dea = 'Dealer';
    
    //Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Dealer_Sales_Type__c,Dealer_Type__c,Dealer_GC_Code__c,Dealer_ND_Code__c,Name,Company_Name__c,Dealer_Group__c,Dealer_Province__c FROM Account WHERE Dealer_Type__c =: dealerType AND Dealer_GC_Code__c=:dealerCode AND RecordType.Name = 'Dealer' AND MD__c ='KR' AND Dealer_Active__c = true ]));
    
  String soql = 'SELECT Dealer_Sales_Type__c,Dealer_Type__c,Dealer_GC_Code__c,Dealer_ND_Code__c,Name,Company_Name__c,Dealer_Group__c,Dealer_Province__c,Parent.Dealer_ND_Code__c FROM Account '
   + 'where (RecordTypeId =\'' + dealerRecordtypeid   + '\' AND Dealer_Active__c = true  AND '  
    + 'MD__c = \'' + String.escapeSingleQuotes(md) +'\')  '; 
           
  if (!String.isBlank(dealerCode))
  soql += ' and Dealer_GC_Code__c =\''+String.escapeSingleQuotes(dealerCode)+'\'';
if (!String.isBlank(DealerNDCode))
  soql += ' and Dealer_ND_Code__c =\''+String.escapeSingleQuotes(DealerNDCode )+'\'';  
if (!String.isBlank(Name ))
  soql += ' and Name like \''+String.escapeSingleQuotes(Name)+'\'';

  
   system.debug('++++++++++++++++++++++'+ soql); 
   //runQuery();
    Setcon = new ApexPages.StandardSetController(Database.query(soql));
    
    setCon.setpagesize(10);
    noOfRecords = setCon.getResultSize();
   getAccount();
}
Public List<AddingParticipatingDealer> getAccount(){
    getSelectedAccount();
    wrapperlist = new List<AddingParticipatingDealer>();
    for(Account cc : (List<Account>)Setcon.getRecords()){
        AddingParticipatingDealer wrapAcc = new AddingParticipatingDealer();
        wrapAcc.con = cc;               // Holding Account
        if(SelectedAccountMap.containsKey(cc.Id)){
            wrapAcc.bool = true;    // check if Checkbox is checked in vf page    
        }
        else{
            wrapAcc.bool = false;    // Used as Checkbox in vf page, default is not selected
        }
        wrapperlist.add(wrapAcc);
    }
    return wrapperlist;
}

public void getSelectedAccount(){
    if(wrapperlist!=null){
        for(AddingParticipatingDealer  wr:wrapperlist){
            if(wr.bool == true){
                SelectedAccountMap.put(wr.con.id,wr.con); // Add the selected Account id in to 
                Checkid.add(wr.con.id);
            }
            else{
                SelectedAccountMap.remove(wr.con.id); // If you uncheck the Account, remove it from the selectedAccountMap
                Checkid.remove(wr.con.id);
            }
        }

    }

}
public void  ShareRecordd(){

   Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
   List<Account> acc = New List<Account>();
    
    obId =ApexPages.currentPage().getParameters().get('id');
    getSelectedAccount();
    selectedList = SelectedAccountMap.values();
    system.debug('selectedList----'+selectedList);
    for(Account selac : selectedList)
    {
     if(selac.Dealer_ND_Code__c != null)
     {
       if(selac.Dealer_Type__c == 'Outlet')
        {
          getDealerNDCode.add(selac.Dealer_ND_Code__c);
          getDealerNDCode.add(selac.Parent.Dealer_ND_Code__c);
        }
        else
        {
          getDealerNDCode.add(selac.Dealer_ND_Code__c);
        }
     }
    }
    
    if(!getDealerNDCode.isEmpty() && getDealerNDCode != null)
    {
        grplist = [select id ,Name ,Type from Group where Name IN: getDealerNDCode];
    }
    if(grplist != null)
    {
    for(Group assg:grplist)
    {               
        assgroupMap.put(assg.Name, assg.id);
        system.debug('assg.Name'+assg.Name);
    }
    
            
        for(id m:assgroupMap.values())
        {                       
            /*CampaignShare share = new CampaignShare();
           // share.CampaignAccessLevel = UtilConstant.read_Access;
           share.CampaignAccessLevel  = 'Read';
           // share.CampaignId = obId;
            share.CampaignId = obId;
            share.UserOrGroupId = m;*/
            if(objectAPIName == 'DM_Material__c')
            {
            DM_Material__Share share=new DM_Material__Share();
            share.AccessLevel = 'Read';
            share.ParentID = obId;
            share.UserOrGroupId = m;
            cpnShares.add(share);
            }
            else if(objectAPIName == 'Survey__c')
            {
             Survey__Share share1=new Survey__Share();
             share1.AccessLevel = 'Read';
             share1.ParentID = obId;
             share1.UserOrGroupId = m;
             cpnShares1.add(share1);
            }
        }           
        if (!cpnShares.isEmpty() || !cpnShares1.isEmpty()) {
            try {
            system.debug('cpnShares--'+cpnShares);
            system.debug('cpnShares--'+cpnShares);
            if(objectAPIName == 'DM_Material__c')
            {
                insert cpnShares;
            }
            else if(objectAPIName == 'Survey__c')
            {
              insert cpnShares1;
            }
                
            } catch (DMLException e) {
                System.debug('Issues while sharing Campaign : ' + e);
            }
        }           
    }
    
}

public void first(){
    Setcon.first();
    system.debug('++++++++++++++First'+Setcon);
}
 
 // returns the last page of records
 public void last() {
     Setcon.last();
 }

// returns the previous page of records
 public void previous() {
     Setcon.previous();
 }

//disable first and prev button
public Boolean hasPrevious {
    get {
        return Setcon.getHasPrevious();
    }
    set;
}

//display the next page of records
public void next() {
    Setcon.next();
}

//disable the next and last buttons
public Boolean hasnext {
    get {
        return Setcon.getHasNext();
    }
    set;
}
public integer pageNumber{
    get{
        return Setcon.getPageNumber();
    }
    set;
}

Public class AddingParticipatingDealer{
    Public Account con{get;set;}
    Public boolean bool{get;set;}
}
}