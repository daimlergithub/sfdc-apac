/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to display All Dealers Account Based on Search Criteria 
                         Business Conditions :
                          * Search Filter to get All Dealers Account Which Will Be Added As Participating Dealer                      
JIRA NO             :    SFDCJP-1606                                               
************************************************************************************/
Public With Sharing class AccountTable{
    public String size { get; set; }

    //This is Our collection of the class/wrapper objects AddingParticipatingDealer 
    Public List<AddingParticipatingDealer> wrapperlist{get;set;}
    Public Integer noOfRecords{get; set;}

    // Create a new Map to verify whether the Account is already added in the Map
    Map <id,Account> SelectedAccountMap = new Map <id,Account>();
    Set<id> Checkid = New Set<id>();
    List<Participating_Dealer__c > parDealer = New List<Participating_Dealer__c >();

    public boolean display{get;set;}
    public list<Account> selectedList {get;set;}
    public String regionValue {get;set;}    
    public List<SelectOption> regionOptions {get;set;}
    public List<SelectOption> DealerTypepick {get;set;}
    public List<SelectOption> Dealerpick {get;set;}
    public List<SelectOption> Dealercars  {get;set;}
    public String dealerType {get;set;}
    public String dealerCode {get;set;} 
    public String dealerSalestype {get;set;} 
    public String DealerServiceFun {get;set;} 
    public String DealerSalesfunc {get;set;} 
    public String DealerUsedCarFunc {get;set;} 
    public String DealerUsedCarCorner {get;set;} 
    public String DealerAMGPerformance {get;set;} 
    public String DealerNDCode {get;set;} 
    public String CompanyName {get;set;} 
    public String Name  {get;set;} 
    public String DealerGroup {get;set;} 
    public String DealerProvince {get;set;} 
    public String DealerCarsDlrClassSales {get;set;}
    public String DealerActive  {get;set;} 
    public String CamId {get;set;}
    public Boolean panelStopper {get;set;}
    public String soql {get;set;}
   
    // private String soql {get;set;}

    public AccountTable(){ 
        regionOptions = new List<SelectOption>();
        regionOptions.add(new SelectOption('aid','All Dealer'));
        regionOptions.add(new SelectOption('sid','Select A Dealer'));
        //SearchLogic();
        panelStopper = false;
        Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name,Dealer_Type__c,phone,City__c,Dealer_GC_Code__c FROM Account Where RecordType.Name = 'Dealer' AND MD__c ='JP']));
        DealerTypepick = new List<SelectOption>();
        DealerTypepick.add(new SelectOption('','---None--'));
        DealerTypepick.add(new SelectOption('Outlet','Outlet'));
        DealerTypepick.add(new SelectOption('Company','Company'));
       
        Dealerpick = new List<SelectOption>();
        Dealerpick.add(new SelectOption('','---None--'));
        Dealerpick.add(new SelectOption('Yanase','Yanase'));
        Dealerpick.add(new SelectOption('Stern','Stern'));
        Dealerpick.add(new SelectOption('Independent','Independent'));
        CamId =ApexPages.currentPage().getParameters().get('id');
        
        
        Dealercars   = new List<SelectOption>();
        Dealercars.add(new SelectOption('','---None--'));
        Dealercars.add(new SelectOption('NORMAL','NORMAL'));
        Dealercars.add(new SelectOption('SATELLITE','SATELLITE'));
        Dealercars.add(new SelectOption('AUTHORIZEDFACTORY','AUTHORIZEDFACTORY'));
        Dealercars.add(new SelectOption('Metro','Metro'));
        Dealercars.add(new SelectOption('Provincial','Provincial'));
        Dealercars.add(new SelectOption('Rural','Rural'));
    }
    
    //Returns a list of wrapper objects for the sObjects in the current page set
    Public Void dropDown(){
        if(regionValue == 'sid' ){
            panelStopper = true;
        } 
        else if(regionValue == 'aid' ){
            panelStopper = false;
            //SearchLogic();
        Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name,Dealer_Type__c,phone,City__c,Dealer_GC_Code__c FROM Account Where RecordType.Name = 'Dealer' AND MD__c ='JP'])); 
        setCon.setpagesize(10);
        }
    }
    
    public ApexPages.StandardSetController setCon {get;set;}
   
   
   /*
    public void runQuery() {
     //soql = 'SELECT Name,Dealer_Type__c,phone,City__c,Dealer_GC_Code__c FROM Account where name != null  '; 
    try {
      Setcon = new ApexPages.StandardSetController(Database.query(soql));
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }  
      setCon.setpagesize(10);
        noOfRecords = setCon.getResultSize();
        getAccount();
  }  */  
    Public void SearchLogic(){
         
         Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
         String md = 'JP';
         String dea = 'Dealer';
        
        //Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Dealer_Sales_Type__c,Dealer_Service_Func__c,Dealer_Sales_func__c,Dealer_UsedCar_Func__c,Dealer_Type__c,phone,City__c,Dealer_GC_Code__c,Dealer_UsedCarCorner__c,Dealer_AMGPerformance__c,Dealer_ND_Code__c,Name,Company_Name__c,Dealer_Group__c,Dealer_Province__c,Dealer_Cars_Dlr_Class_Sales__c FROM Account WHERE Dealer_Type__c =: dealerType AND Dealer_GC_Code__c=:dealerCode AND RecordType.Name = 'Dealer' AND MD__c ='JP' ]));
        
      String soql = 'SELECT Dealer_Sales_Type__c,Dealer_Service_Func__c,Dealer_Sales_func__c,Dealer_UsedCar_Func__c,Dealer_Type__c,phone,City__c,Dealer_GC_Code__c,Dealer_UsedCarCorner__c,Dealer_AMGPerformance__c,Dealer_ND_Code__c,Name,Company_Name__c,Dealer_Group__c,Dealer_Province__c,Dealer_Cars_Dlr_Class_Sales__c FROM Account '
       + 'where (RecordTypeId =\'' + dealerRecordtypeid   + '\' AND '  
        + 'MD__c = \'' + String.escapeSingleQuotes(md) +'\')  '; 
               
    if (!String.isBlank(dealerType))
      soql += ' and Dealer_Type__c =\''+String.escapeSingleQuotes(dealerType)+'\'';
      
    if (!String.isBlank(dealerCode ))
      soql += ' and Dealer_GC_Code__c =\''+String.escapeSingleQuotes(dealerCode)+'\'';
    if (!String.isBlank(dealerSalestype))
      soql += ' and Dealer_Sales_Type__c =\''+String.escapeSingleQuotes(dealerSalestype)+'\'';  
    if (!String.isBlank(DealerServiceFun ))
      soql += ' and Dealer_Service_Func__c ='+String.escapeSingleQuotes(DealerServiceFun);
    if (!String.isBlank(DealerSalesfunc  ))
      soql += ' and Dealer_Sales_func__c ='+String.escapeSingleQuotes(DealerSalesfunc  );
    if (!String.isBlank(DealerUsedCarFunc ))
      soql += ' and Dealer_UsedCar_Func__c ='+String.escapeSingleQuotes(DealerUsedCarFunc );  
      
      if (!String.isBlank(DealerUsedCarCorner ))
      soql += ' and Dealer_UsedCarCorner__c ='+String.escapeSingleQuotes(DealerUsedCarCorner);
    if (!String.isBlank(DealerAMGPerformance ))
      soql += ' and Dealer_AMGPerformance__c ='+String.escapeSingleQuotes(DealerAMGPerformance);
    if (!String.isBlank(DealerNDCode ))
      soql += ' and Dealer_ND_Code__c =\''+String.escapeSingleQuotes(DealerNDCode )+'\'';  
    if (!String.isBlank(Name ))
      soql += ' and Name =\''+String.escapeSingleQuotes(Name )+'\'';
    if (!String.isBlank(DealerGroup))
      soql += ' and Dealer_Group__c =\''+String.escapeSingleQuotes(DealerGroup )+'\'';
    if (!String.isBlank(DealerProvince ))
      soql += ' and Dealer_Province__c =\''+String.escapeSingleQuotes(DealerProvince)+'\''; 
      if (!String.isBlank(DealerCarsDlrClassSales  ))
      soql += ' and Dealer_Cars_Dlr_Class_Sales__c  =\''+String.escapeSingleQuotes(DealerCarsDlrClassSales )+'\''; 
      if (!String.isBlank(DealerActive))
      soql += ' and Dealer_Active__c ='+String.escapeSingleQuotes(DealerActive ); 
      
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

    public void  clickMe(){
        List<Account> acc = New List<Account>();
        
        CamId =ApexPages.currentPage().getParameters().get('id');
        getSelectedAccount();
        selectedList = SelectedAccountMap.values();
        
        
        List<Participating_Dealer__c> participateDealer = [select id ,Dealer__c ,Campaign__c From Participating_Dealer__c where Campaign__c =:camid AND Dealer__c =: SelectedAccountMap.keySet()  ];
        
             for(Participating_Dealer__c newpd : participateDealer ){
             
                       
                       if(SelectedAccountMap.containsKey(newpd.Dealer__c)){
                          
                         SelectedAccountMap.remove(newpd.Dealer__c);  // removing Duplicate Ids
                       
                       }    
            }
        
        
        
        for(Account pdMain : SelectedAccountMap.values()){
        Participating_Dealer__c pd = New Participating_Dealer__c();
        pd.Campaign__c = CamId;
        pd.Dealer__c = pdMain.Id;
        
        parDealer.add(pd);
        }
        
        Insert parDealer;
        
        //PageReference nextPage = new PageReference('/' +camId );
       // return nextPage;
       
        
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