/***************Working Code **************9.0*************************************
        Page Controller
        ---------------------------------------------------------------
        History:
         
    ******************************************************************/
    global with sharing class RetailCampaignSegmentationController_TH {
        
        public Set<Id> accIdToGetRetailPerson;
        public Set<Id> vehIdToGetVehExtLink;
        public Set<Id> vehIdSetForContract;
        public List<Account_Link__c> accLinkRetaiPersonList;
        Public Map<Id,Account_Link__c> toRoleAndAccLinkMap;
        public String getop;
        
        //To save the query in segmentation criteria object
        public String saveQuery{get;set;}
        
        private String retailCampaignId;
        Boolean vehicleFind;
        Boolean vehicleRelFind;
        //Boolean vehicleRetailFind;
        Boolean accountFilter;
        
        //pagination
        public  ApexPages.StandardSetController con {get;set;}
        public Integer totalrecords{get;set;}
        Public Integer size{get;set;} 
        Public Integer noOfRecords{get; set;} 
        
        //Find the initail soql lentght of all queries
        public Integer vehRelLength;
        public Integer leadLength;
        public Integer retailaskLength;
        public Integer addressLength;
        public Integer campLength;
        public Integer accLinkLength;
        public Integer recallLength;
        public Integer VehRetCopyLength;
        public Integer accountLenght;
        
        // For soql
        public String accountSoql;
        public String leadSoql;
        public String vehicleRelSoql;
        public String vehicleSoql;
        public String AccountLinkSoql;
        public String campaignMemSoql;
        public String RetailTaskSoql;
        public String AddressSoql;
        public String recallSoql;
        public String VehRetCopySoql;
        
        public Set<Id> accountIdSet;
        public Set<Id> vehIdSet;//to store the recall object vehicles
        public Set<Id> vehIdSet1;//to store the vehicle retail copy object vehicles 
        public Integer recallCount;
        
        //To define field types 
        public Set<String> recallFields;
        public Set<String> numberFields;
        public Set<String> dateFields;
        public Set<String> textFields;
        public Set<String> pickListFields;
        public Set<String> multiplePickListFields;
        public Set<String> vehicleFields;
        public Set<String> vehicleRelFields;    
        public Set<String> AccountLinkFields;
        public Set<String> retialCampaignFields;
        public Set<String> RetailTaskFields;
        public Set<String> AddressFields;
        
        public Retail_campaign__c curRetCamp = new Retail_campaign__c();//to hold current retail campaign
        
        //To check the parent retail campaign type and set car relation in vehicleRelSoql 
        public String parCampType;
        public  String Sales =  '(Car_Relation__c=\'Sales\' or Car_Relation__c=\'Driver\' or Car_Relation__c=\'Aftersales\')';
        public String AfterSalesOrFinance = '(Car_Relation__c=\'Sales\' or Car_Relation__c=\'Driver\' or Car_Relation__c=\'Aftersales\')';
        
        //To get the dynamic picklist values
        Public Set<String> retTaskStatus = new Set<String>{'Draft', 'Waiting for Approval', 'Approved', 'Rejected','In service','Expired','pullback','Save','Waiting for cancellation approval','Cancellation Approved','Cancelled','Active', 'Matured','Cancelled','Early Termination','Subrogation','Consent Termination','Forced Termination','Change of Owner'};
        public Set<String> specialMarkAcc = new Set<String>{'Automotive related','Dealer','Fire department','Lawyer','Insurance Company','MBJ','Ministry of Transport','Police'};
        public Set<String> accStatus = new Set<String>{'Customer', 'Prospect'};
        public Set<String> LeadDealerStatus = new Set<String>{'Not Started','On-going','Order Placed','Purchased(Only Non BDC)','Lost'};
        public Set<String> retTaskType = new Set<String>{'Standard Warranty','Used Car Warranty','Loan','Lease','Service Program'};
        public Set<String> retProductName = new Set<String>{'Welcome Plan','Welcome Plan Plus','Open End Lease','Open End Lease (Select)','Open End Lease (Select Plus) ','Close End Lease','Close End Lease (Mileage Plan Select)','Close End Lease (Mileage Plan Select Plus)','Close End Lease (Mileage Plan)','Re-lease (Open End)','Re-lease (Close End Mileage Plan)','Re-lease (Close End)','Re-loan','Super Welcome Plan','Super Welcome Plan Plus','Start Up Plan','Normal Loan','Dual Auto Loan'};
        public Set<String> retFinanceProductName = new Set<String>{'Welcome Plan','Welcome Plan Plus','Open End Lease','Open End Lease (Select)','Open End Lease (Select Plus)  ','Close End Lease','Close End Lease (Mileage Plan Select)','Close End Lease (Mileage Plan Select Plus)','Close End Lease (Mileage Plan)','Re-lease (Open End)','Re-lease (Close End Mileage Plan)','Re-lease (Close End)','Re-loan','Super Welcome Plan','Super Welcome Plan Plus','Start Up Plan','Normal Loan','Dual Auto Loan'};

        public String jsonFilter { get; set; }
        public Map<String, Object> filterMap;
        public Map<String, Object> contentMap;
        
        
        Public Set<Id> leadSet;
        Public Set<Id> AccountLinkSet ;
        Public Set<Id> AddressSet;
        Public Set<Id> CampaignMemebrset;
        Public Set<Id> accountSoqlset;
        Public Set<Id> vehicleRetailCustomer ;
        Public Set<Id> vechicleCustomer; 
        Public Set<Id> vehicleRetailtask;
        Public Set<Id> vehicleRelCopyMain ;
        
        
        // For data model
        public Account account { get; set; }
        public Lead__c lead { get; set; }
        public Vehicle__c vehicle { get; set; }
        public Vehicle_Relationship__c vehicleRel { get; set; }
        public Account_Link__c AlkRec{ get; set; }
        //public Retail_Task__c RatilTask{ get; set; }
        public Address__c  address{ get; set; }
        public campaign_member__C camMem {get; set;}
        public recall__C recall {get; set;}
        public user u;
        public Map<Id,recall__c> vehIdRecallRecMap;
        public Map<Id,Account_Link__c> vehIdAccLinkRecMap;
        
        //To get the record types
        string personAccntRecTypId;
        String retailTaskLeaseRecType;
        String retailTaskLoanRecType;
        String retailTaskInsRecType;
        String vehRetCopyRecType;
        String dealerAccntRecTypId;
        String retailPesonRecType;
        String retailTaskcontractType;
        
        //String retailCompanyRecType;
        
        //Segmentation_Base__c
        public String segmentationBase{set;get;}
        
        public RetailCampaignSegmentationController_TH()
        {
            size = 100;
            system.debug('++++++++++'+con);
            retailCampaignId = ApexPages.currentPage().getParameters().get('id');
            personAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            //retailTaskLeaseRecType = Schema.SobjectType.Retail_Task__c.getRecordTypeInfosByName().get('Lease Contract').getRecordTypeId();
            //retailTaskLoanRecType = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Loan Contract').getRecordTypeId();
            //retailTaskInsRecType = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Insurance Contract').getRecordTypeId();
            //retailTaskcontractType = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
            retailPesonRecType = Schema.sObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
            //retailCompanyRecType = Schema.sObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            dealerAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            vehRetCopyRecType=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
            curRetCamp = [SELECT Id,Name,Segmentation_Base__c,Parent_Campaign1__r.Campaign_Type__c FROM Retail_campaign__C WHERE ID =: retailCampaignId];
            u = [SELECT Id,ContactId,Dealer_GC_Code__c,Contact.Account.name FROM User WHERE Id =:userInfo.getUserId() ];
            segmentationBase = curRetCamp.Segmentation_Base__c;
            if(curRetCamp.Parent_Campaign1__c != NULL){
                if(curRetCamp.Parent_Campaign1__r.Campaign_Type__c == 'Sales'){
                    parCampType = Sales;
                } else {
                    parCampType = AfterSalesOrFinance;
                }
            }
           
            
           
            
            setFieldType();
        }
        
        public String selectedValueSales {set;get;}
        public String selectedValueService {set;get;}
        public String selectedValue {set;get;}// holding the value which they selected either 'company' or 'outlet'
      
       
        public List<SelectOption> InterestModel{
            get{
                InterestModel= new List<SelectOption>();
                InterestModel.add(new SelectOption('', '--None--'));
      Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Interest_Model__c;
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          for( Schema.PicklistEntry f : ple)
         {
             InterestModel.add(new SelectOption(f.getValue(), f.getLabel()));
           }
                return InterestModel;
            }
            set;
        }  
        public List<SelectOption> Occupation{
            get{
                Occupation= new List<SelectOption>();
                Occupation.add(new SelectOption('', '--None--'));
      Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Occupation__c;
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          for( Schema.PicklistEntry f : ple)
         {
             Occupation.add(new SelectOption(f.getValue(), f.getLabel()));
           }
                return Occupation;
            }
            set;
        }
     
        public List<SelectOption> provincemodel{
            get{
                provincemodel= new List<SelectOption>();
                provincemodel.add(new SelectOption('', '--None--'));
           for(AggregateResult resul:[select Province__c from RegionMasterInfo__c  where Province__c!=null group by Province__c]){
                  provincemodel.add(new SelectOption((String)resul.get('Province__c'),(String)resul.get('Province__c')));
           }
               return provincemodel;
            }
            set;
        }
        
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            options.add(new SelectOption('Company','Company'));
            options.add(new SelectOption('Outlet','Outlet'));
            return options;
        }
        public List<SelectOption> SpecialMarkonAccount{
            get{
                SpecialMarkonAccount= new List<SelectOption>();
                SpecialMarkonAccount.add(new SelectOption('', '--None--'));
                Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Special_Mark_on_Account__c;
                for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                    if(specialMarkAcc.contains(entry.getValue()))
                    SpecialMarkonAccount.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                return SpecialMarkonAccount;
            }
            set;
        }
        
    public List<SelectOption> gender{
        get{
            gender= new List<SelectOption>();
            gender.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Gender__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                gender.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return gender;
        }
        set;
    }
    
    public List<SelectOption> personalAgreement{
        get{
            personalAgreement = new List<SelectOption>();
            personalAgreement.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Personal_Agreement__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                personalAgreement.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return personalAgreement;
        }
        set;
    }
    
     public List<SelectOption> hobbies{
        get{
            hobbies = new List<SelectOption>();
            //RetailOptOutContactReason.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Hobby__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                hobbies.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return hobbies;
        }
        set;
    }
    
     public List<SelectOption> idType{
        get{
            idType = new List<SelectOption>();
            //RetailOptOutContactReason.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.ID_Type__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                idType.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return idType;
        }
        set;
    }
        
        public List<SelectOption> Customerphase{
            get{
                Customerphase= new List<SelectOption>();
                Customerphase.add(new SelectOption('', '--None--'));
                Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Customer_Lifecycle_Phase__c;
                for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                    Customerphase.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                return Customerphase;
            }
            set;
        }
        
         public List<SelectOption> status{
            get{
                status= new List<SelectOption>();
                status.add(new SelectOption('', '--None--'));
                Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Status__c;
                for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                    if(accStatus.contains(entry.getValue()))
                    status.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                return status;
            }
            set;
        }
        
        public List<SelectOption> DealerLeadStatus{
            get{
                DealerLeadStatus= new List<SelectOption>();
                DealerLeadStatus.add(new SelectOption('', '--None--'));
                Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Lead__c.fields.Dealer_Lead_Status__c;
                for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                    if(LeadDealerStatus.contains(entry.getValue()))
                    DealerLeadStatus.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                return DealerLeadStatus;
            }
            set;
        }
        
         /*public List<SelectOption> RetailSalesSanction{
            get{
                RetailSalesSanction= new List<SelectOption>();
                RetailSalesSanction.add(new SelectOption('', '--None--'));
                RetailSalesSanction.add(new SelectOption('A', 'A'));
                RetailSalesSanction.add(new SelectOption('B', 'B'));
                RetailSalesSanction.add(new SelectOption('C', 'C'));
                RetailSalesSanction.add(new SelectOption('D', 'D'));
                RetailSalesSanction.add(new SelectOption('E', 'E'));
                RetailSalesSanction.add(new SelectOption('F', 'F'));
                return RetailSalesSanction;
            }
            set;
        }*/
         
         public List<SelectOption> RetailOptOutContactReason{
            get{
                RetailOptOutContactReason= new List<SelectOption>();
                Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account_Link__c.fields.Retail_OptOutContact_Reason__c;
                for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                    RetailOptOutContactReason.add(new SelectOption(entry.getValue(), entry.getLabel()));
                }
                return RetailOptOutContactReason;
            }
            set;
        }
        
        public void defineAllTypes(){
        
           system.debug('+++++Working++++++++');
            saveQuery = '';//initilizing default as empty
            accountIdSet = new Set<Id>();
            accountFilter = false;
            vehIdSet = new Set<Id>();
            vehIdSet1 = new Set<Id>();
            recallCount = 0;
            vehicleRelFind = false;
            vehicleFind = false;
            vehIdRecallRecMap = new Map<Id,recall__C>();
            vehIdAccLinkRecMap = new Map<Id,Account_Link__c>();
            accIdToGetRetailPerson = new Set<Id>();
            vehIdToGetVehExtLink = new Set<Id>();
            vehIdSetForContract = new Set<Id>();
            toRoleAndAccLinkMap = new Map<Id,Account_Link__c>();
            leadSet = new Set<id>();
            AccountLinkSet = new Set<id>();
            AddressSet= new Set<id>();
            CampaignMemebrset = new set<id>();
            accountSoqlset= new Set<id>();
            vehicleRetailCustomer = new Set<id>();
            vechicleCustomer = new Set<id>();
            vehicleRetailtask = new Set<id>();
            vehicleRelCopyMain = new Set<id>();
                      
        }
      
        public PageReference searchAccount(){    
            defineAllTypes();
            
            system.debug('================='+jsonFilter);
            filterMap = (Map<String, Object>)JSON.deserializeUntyped(jsonFilter);
            system.debug('I am filter map'+filterMap);
            contentMap = (Map<String, Object>)(filterMap.get('content'));
            system.debug('I am content map'+contentMap);
            setSoql();//================================================================================================================>>1
            try{
            
            if(vehicleRelSoql.endsWith('AND  ') || vehicleRelSoql.endsWith('AND ')){
                vehicleRelSoql = vehicleRelSoql.removeEnd('AND  ').removeEnd('AND ');
            }
            
            if(leadSoql.length()>leadLength){
                //saveQuery += 'AND Id IN('+leadSoql+')';
                system.debug('FinalLeadSoql'+leadSoql);
                List<Lead__C> leadList = Database.query(leadSoql+ 'limit 1000');
                for(Lead__C vr : leadList){
                    accountIdSet.add(vr.Contact__c);
                    leadSet.add(vr.Contact__c);
                }
                if(segmentationBase == 'customer' ){
                saveQuery += ' AND Id IN :leadSet ';
                }
                if(segmentationBase == 'Vehicle' ){
                saveQuery +=' AND Contact__c IN :leadSet';
                }
                if(segmentationBase == 'Contract'){
                  saveQuery += ' AND Related_Contact__c IN : leadSet';
                }
            }
            
            if(AccountLinkSoql.length()>accLinkLength){
                AccountLinkSoql = AccountLinkSoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name').replace('Retail_Sales_Consultant__c', 'Retail_Sales_Consultant__r.Name').replace('Selling_Dealer__c', 'Selling_Dealer__r.Name');
                //saveQuery += 'AND Id IN('+AccountLinkSoql+')';
                system.debug('FianlAccountLinkSoql '+AccountLinkSoql);
                List<Account_Link__C> accLinkList = Database.query(AccountLinkSoql + 'limit 1000');
                for(Account_Link__C vr : accLinkList){
                    accountIdSet.add(vr.toRole__c);
                    toRoleAndAccLinkMap.put(vr.toRole__c,vr);
                    AccountLinkSet.add(vr.toRole__c);
                }
                
                if(segmentationBase == 'customer' ){
                saveQuery += ' AND Id IN :AccountLinkSet ';
                }
                if(segmentationBase == 'Vehicle' ){
                saveQuery += ' AND Contact__c IN :AccountLinkSet ';
                }
                if(segmentationBase == 'Contract'){
                  saveQuery += ' AND Related_Contact__c IN : AccountLinkSet';
                }
            }
    
            if(AddressSoql.length()>addressLength){
                //saveQuery += 'AND Id IN('+AddressSoql+')';
                system.debug('FinalAddressSoql '+AddressSoql);
                List<Address__c> addList = Database.query(AddressSoql+ 'limit 1000');
                for(Address__c vr : addList ){
                    accountIdSet.add(vr.Customer__c);
                    AddressSet.add(vr.Customer__c);
                }
                
                if(segmentationBase == 'customer' ){
                saveQuery += ' AND Id IN :AddressSet ';
                }
                if(segmentationBase == 'Vehicle' ){
                saveQuery += ' AND Contact__c IN : AddressSet ';
                }
                if(segmentationBase == 'Contract'){
                  saveQuery += ' AND Related_Contact__c IN : AddressSet';
                }
            }
        
            if(campaignMemSoql.length()>campLength){
                //saveQuery += 'AND Id IN('+campaignMemSoql+')';
                system.debug('FinalcampaignMemSoql'+campaignMemSoql);
                List<Campaign_Member__c> camMemList = Database.query(campaignMemSoql+ 'limit 1000');
                for(Campaign_Member__c vr : camMemList ){
                    accountIdSet.add(vr.Contact_Id__c);
                    CampaignMemebrset.add(vr.Contact_Id__c);
                }
                //saveQuery += ' AND Id IN :CampaignMemebrset ';
                if(segmentationBase == 'customer' ){
                saveQuery += ' AND Id IN :CampaignMemebrset ';
                }
                if(segmentationBase == 'Vehicle' ){
                saveQuery += ' AND Contact__c IN : CampaignMemebrset ';
                }
                if(segmentationBase == 'Contract'){
                  saveQuery += ' AND Related_Contact__c IN : CampaignMemebrset';
                }
            }
    
            //for recall object records
            if(recallSoql.length()>recallLength){
                System.debug('recallSoqlFinal>>>>'+recallSoql);
               // saveQuery += 'AND Vehicle_Id__c IN ('+recallSoql+') ';
                List<recall__c> recallList = Database.query(recallSoql + ' LIMIT 1000');
                for(recall__c rc : recallList){
                    vehIdSet.add(rc.Vehicle_Id__c);
                    vehIdRecallRecMap.put(rc.Vehicle_Id__C,rc);
                }
               vehicleRelSoql+= 'AND Vehicle_Id__c IN: vehIdSet ';
               saveQuery += 'AND Vehicle_Id__c IN : vehIdSet ';
            }
            
            
            //for vehicleRetailCopy records
            if(VehRetCopySoql.length()>VehRetCopyLength){
                VehRetCopySoql = VehRetCopySoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name').replace('Service_Advisor__c', 'Service_Advisor__r.Name').replace('Service_Dealer__c', 'Service_Dealer__r.name');
                system.debug('vehicleRetialCopySoql'+VehRetCopySoql);
                //saveQuery += 'AND Vehicle_Id__c IN ('+VehRetCopySoql+') ';
                List<Account_Link__c> vehRetialList = Database.query(VehRetCopySoql+' limit 1000');
                
                for(Account_Link__c ac : vehRetialList){
                    vehIdSet1.add(ac.Vehicle__c);
                    vehIdAccLinkRecMap.put(ac.vehicle__c,ac);
                    vehicleRelCopyMain.add(ac.toRole__c);
                }
                 system.debug('++++++vehIdSet1 ++++++'+vehIdSet1 );
                 system.debug('++++++vehIdSet2 ++++++'+vehicleRelCopyMain );
                 system.debug('++++++vehIdSet1 ++++++'+vehRetialList );
                vehicleRelSoql+= 'AND Vehicle_Id__c IN: vehIdSet1 ';
                //saveQuery += 'AND Vehicle_Id__c IN : vehIdSet1 ';
                if(segmentationBase == 'customer' ){
                //saveQuery += ' AND Id IN :vehicleRelCopyMain ';
                }
                if(segmentationBase == 'Vehicle' ){
                saveQuery += ' AND Vehicle_Id__c IN: vehIdSet1 ';
                }
                if(segmentationBase == 'Contract'){
                  saveQuery += ' AND Related_Contact__c IN : vehicleRelCopyMain';
                }
            }
            
            System.debug('----'+vehRelLength+'----'+vehicleRelSoql.length()+'----'+segmentationBase);
            if(vehicleRelSoql.length()>vehRelLength && segmentationBase != 'Vehicle'){
                vehicleRelSoql = vehicleRelSoql.replace('Last_Service_Dealer__c','Last_Service_Dealer__r.Name');
                system.debug('vehiclerelSoqlAtCommon>>>>'+vehicleRelSoql);
                List<Vehicle_relationship__C> vehRelList = Database.query(vehicleRelSoql + ' limit 1000');
                For(Vehicle_relationship__C vr : vehRelList){
                    if(segmentationBase == 'Customer'){
                    accountIdSet.add(vr.Contact__c);
                    vehicleRetailCustomer.add(vr.Contact__c);
                  system.debug('++vehicleRetailCustomer+++++'+vehicleRetailCustomer);
                    }
                    else if(segmentationBase == 'Contract'){
                        vehIdSetForContract.add(vr.Contact__c);
                        vehicleRetailtask.add(vr.Vehicle_ID__c);
                        
                    }
                }
                if(segmentationBase == 'Customer'){
                saveQuery += ' AND ID IN : vehicleRetailCustomer';
                }else if(segmentationBase == 'Contract'){
                    saveQuery += ' AND Related_Vehicle__c IN : vehicleRetailtask';
                }
            }
            
            if(accountSoql.length()>accountLenght && segmentationBase != 'Customer'){
                system.debug('AccountSoqlatCommon ' + accountSoql);
                //List<account> accList = Database.Query(accountSoql+' LIMIT 500');
                MAP<id,account> accList=new MAP<ID,account>((List<Account>)Database.Query(accountSoql+' LIMIT 1000'));
                accountIdSet=accList.keyset();
                vechicleCustomer=acclist.keyset();
            }
    
            system.debug('accountIdsetbeforegogingtoSegmentationBase'+accountIdSet);
            if(segmentationBase == 'Customer' ){
                //Searhs the accounts according to all other filters
                if(accountIdSet.size()==0 && accountFilter){
                    accountSoql += '';
                }
                else if(accountSoql.endsWith('AND ') || accountSoql.endsWith('AND  ')){
                    accountSoql += 'ID IN :accountIdSet ';
                }
                else{
                    accountSoql += ' AND ID IN :accountIdSet ';
                }
                system.debug('FinalAccountSoql>>>>>>>>'+accountSoql);
                system.debug('FinalAccountSoql>>>>>>>>'+accountIdSet.size());
                system.debug('FinalAccountSoql>>>>>>>>'+accountIdSet);
               // List<account> accList = Database.Query(accountSoql+' limit 20000');
               // system.debug('>>>>>'+accList.size());
               saveQuery = saveQuery.replace('AND AND','AND');
               system.debug('++++++++++++'+saveQuery );
               saveQuery = saveQuery.replace('AND  AND','AND');
                if(saveQuery.endsWith('AND ') || saveQuery.endsWith('AND  ')){
                saveQuery = saveQuery.replace('AND ','');
                }
                system.debug('++++++++++++'+saveQuery );
                List<account> accList = Database.Query(saveQuery+' limit 1000');
                Map<Id,Account> accIdAccountMap = new Map<Id,Account>();
                for(Account acc : accList){
                    accIdToGetRetailPerson.add(acc.Id);
                    accIdAccountMap.put(acc.Id,acc);
                    
                    for(Account_Link__c alin:acc.Account_Links__r)
                    {
                      if(alin.Selling_Dealer__c!=null)
                      {
                        toRoleAndAccLinkMap.put(alin.toRole__c,alin);
                      }
                    }
                    
                }
                system.debug('accLinkRetaiPersonList'+accIdToGetRetailPerson);
                accLinkRetaiPersonList = [SELECT Id,toRole__c,fromRole__c,Selling_Dealer__c,fromRole__r.Dealer_GC_Code__c,Retail_Sales_Consultant__c FROM Account_Link__c WHERE RecordType.Name = 'Retail Person' AND toRole__c IN : accIdToGetRetailPerson];
                system.debug('accLinkRetaiPersonList'+accLinkRetaiPersonList);
                system.debug('accLinkRetaiPersonList'+accLinkRetaiPersonList.size());
                if(selectedValue == 'Outlet'){
                     accList.clear();
                     if(accLinkRetaiPersonList.size()>0)
                     for(Account_Link__c accl : accLinkRetaiPersonList){
                         if(accl.fromRole__r.Dealer_GC_Code__c == u.Dealer_GC_Code__c){
                             accList.add(accIdAccountMap.get(accl.toRole__c));
                         }
                         system.debug('accListForOutLet'+accList);
                     }
                }
                system.debug('One'+accList.size());
                system.debug('saveQueryfinal'+saveQuery);
                //con = new ApexPages.StandardSetController(saveQuery);
                con = new ApexPages.StandardSetController(accList);
                con.setPageSize(100); 
                noOfRecords = con.getResultSize();
                getloadwrapAccountList();
                //noOfRecords =0;
                
                
            } else if(segmentationBase == 'Vehicle'){
                if(vechicleCustomer.size()>0){
                    if(vehicleRelSoql.endsWith('AND ')){    
                        vehicleRelSoql+='Vehicle_ID__r.Related_contact__c IN : accountIdSet';
                        saveQuery +='Contact__c IN : vechicleCustomer';
                    } else {
                        vehicleRelSoql+=' AND Vehicle_ID__r.Related_contact__c IN : accountIdSet';
                        saveQuery +=' AND Contact__c IN : vechicleCustomer';
                    }
                }
                system.debug('finalvehiclerelSoql>>>>'+vehicleRelSoql);
                system.debug('+++++vehicle+++++++'+saveQuery );
                
                saveQuery = saveQuery.replace('AND  AND','AND');
               system.debug('++++++++++++'+saveQuery );
               saveQuery = saveQuery.replace('AND AND','AND');
                if(saveQuery.endsWith('AND ') || saveQuery.endsWith('AND  ')){
                //saveQuery = saveQuery.replace('AND ','');
                saveQuery = saveQuery.removeEnd('AND ');
                }
                 system.debug('++++++++++++'+saveQuery );
                //List<Vehicle_relationship__C> vehRelList = Database.query(vehicleRelSoql + ' limit 1000');
                List<Vehicle_relationship__C> vehRelList = Database.query(saveQuery + ' limit 1000');
                for(Vehicle_Relationship__c vr : vehRelList){
                    vehIdToGetVehExtLink.add(vr.Vehicle_ID__c);
                }
                //con = new ApexPages.StandardSetController(vehRelList);
                con = new ApexPages.StandardSetController(vehRelList);
                con.setPageSize(100); 
                noOfRecords = con.getResultSize();
                getloadwrapAccountList(); 
            } else if(segmentationBase == 'Contract'){
              
               
               
             
                
                
            } 
            }
            catch (Exception e){
 string s = 'Maximum view state size limit (135KB) exceeded ' ;
 if (s.contains('Maximum view state size limit 135KB exceeded' ))
 {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,label.Matched_records_are_too_much_please_add_more_criteria));
                
            } 
            
            else{
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, label.Cannot_extract_records_with_this_filter_condition_Please_change_filter_condition));
            e.getMessage();
            System.debug('The following exception has occurred: ' + e.getMessage()); 
            }
            }//system.debug('saveQueryfinal'+saveQuery);
            accountIdSet.clear();
            return null;
        }
        
        public void setSoql(){
        //String market='TH';
      //SB2018---added line 676 by Sushma for querying current user's market
            String market=[Select market__c from user where id=:UserInfo.getUserId()][0].market__c;
            //accountSoql = 'SELECT Id, Name, Market__c,PersonHomePhone, PersonMobilePhone,Individual_Home_Phone__c, Mobile__c, Email__c,(select id,toRole__c,Sales_Representative__c,Retail_Sales_Consultant__c,fromRole__c,Selling_Dealer__c from Account_Links__r WHERE RecordTypeId = \''+retailPesonRecType + '\'), Phone, PersonEmail,Status__c,Vehicle_Amount__c,Interest_Model__c from Account WHERE RecordTypeId =\'' + personAccntRecTypId + '\' AND ';
            accountSoql = 'SELECT Id, Name, Market__c,PersonHomePhone, PersonMobilePhone,Individual_Home_Phone__c, Mobile__c, Email__c,(select id,toRole__c,Sales_Representative__c,Retail_Sales_Consultant__c,fromRole__c,Selling_Dealer__c from Account_Links__r WHERE RecordTypeId = \''+retailPesonRecType + '\'), Phone, PersonEmail,Status__c,Vehicle_Amount__c,Interest_Model__c from Account WHERE md__C=\''+market+'\' AND RecordTypeId =\'' + personAccntRecTypId + '\' AND ';
           // vehicleRelSoql = 'Select Contact__c,Vehicle_ID__c,Car_Relation__c,End_Date__c,Vehicle_ID__r.FirstRegistrationDate__c,Vehicle_ID__r.Class__c,Vehicle_ID__r.Car_Model__r.Model_Name__c,Vehicle_ID__r.Model_Description__c,New_Used__c From Vehicle_Relationship__c where Contact__r.RecordTypeId =\'' + personAccntRecTypId + '\' AND \''+parCampType+'\' AND ';
            vehicleRelSoql = 'Select Contact__c,Vehicle_ID__c,Handover_Date__c,Car_Relation__c,End_Date__c,Vehicle_ID__r.FirstRegistrationDate__c,Vehicle_ID__r.Class__c,Vehicle_ID__r.Car_Model__r.Model_Name__c,Car_Model__r.Series_Description__c,Vehicle_ID__r.Model_Description__c,New_Used__c From Vehicle_Relationship__c where md__C=\''+market+'\' AND Contact__r.RecordTypeId =\'' + personAccntRecTypId + '\' AND '+parCampType+' AND ';
            system.debug('dhanamjaya3333333333' +vehicleRelSoql);
            if(selectedValueService=='Outlet'){
                vehicleRelSoql += 'Last_Service_Dealer__c =\''+ u.Contact.AccountId+'\' AND ';
            }
            recallSoql = 'SELECT Vehicle_Id__c,Recall_No__c,Status__c From Recall__c Where';
            VehRetCopySoql = 'SELECT Vehicle__c,NextInspectionDate__c,toRole__c,LastInspectionDate__c,LastWorkDate__c,NextServiceDate__c,Service_Advisor__c,Service_Dealer__c FROM Account_Link__c WHERE RecordTypeId = \'' + vehRetCopyRecType + '\' AND ';
            //leadSoql = 'SELECT Contact__c from Lead__c where ';
            leadSoql = 'SELECT Contact__c from Lead__c where md__C=\''+market+'\' AND ';
            //campaignMemSoql = 'Select Contact_Id__c From Campaign_Member__c where ';
            campaignMemSoql = 'Select Contact_Id__c From Campaign_Member__c where md__C=\''+market+'\' AND ';
            //AccountLinkSoql = 'SELECT toRole__c,LastWorkDate__c,LastInspectionDate__c,Sales_Representative__c,Retail_Sales_Consultant__c,Selling_Dealer__c From Account_Link__c WHERE RecordTypeId = \''+retailPesonRecType + '\' AND '; 
            AccountLinkSoql = 'SELECT toRole__c,LastWorkDate__c,LastInspectionDate__c,Sales_Representative__c,Retail_Sales_Consultant__c,Selling_Dealer__c From Account_Link__c WHERE  md__C=\''+market+'\' AND RecordTypeId = \''+retailPesonRecType + '\' AND '; 
            AddressSoql = 'SELECT Customer__c From Address__c where ';
           //AddressSoql = 'SELECT Customer__c From Address__c where md__C=\''+market+'\' AND';
            RetailTaskSoql = 'SELECT Account__c,Account__r.RecordTypeId,Finance_Product_Name__c,Product_Name__c,EndDate__c,Type__c,Duration__c,Status__c,Latest_Sales_Person__c,Related_Vehicle__c,Related_Dealer__c,ContractNumber__c,Supporting_Dealer__c,Activation_Dealer_Code__c From Retail_Task__c WHERE (RecordTypeId =\'' + retailTaskLeaseRecType + '\' or  RecordTypeId = \'' + retailTaskLoanRecType + '\' or RecordTypeId = \''+retailTaskInsRecType + '\'or RecordTypeId = \''+ retailTaskcontractType + '\') AND Account__r.RecordTypeId = \'' + personAccntRecTypId + '\' AND ';
            if(u.contactId != NULL){
                RetailTaskSoql += 'Related_Dealer__c = \''+u.Contact.AccountId+'\' AND ';
            }
            
            if(segmentationBase == 'Customer')
                saveQuery += accountSoql;
            else if(segmentationBase == 'vehicle')
                saveQuery += vehicleRelSoql;
                
            else if(segmentationBase == 'Contract')
                saveQuery += RetailTaskSoql;
                
            accountLenght = accountSoql.length();
            retailaskLength = RetailTaskSoql.length();
            leadLength =  leadSoql.length();
            campLength = campaignMemSoql.length();
            addressLength = AddressSoql.length();
            accLinkLength = AccountLinkSoql.length();
            vehRelLength = vehicleRelSoql.length();
            recallLength = recallSoql.length();
            VehRetCopyLength = VehRetCopySoql.length();
            
            System.debug('-----contentMap-----'+contentMap);
            List<Object> customerFilterItems = (List<Object>)contentMap.get('Customer');
            List<Object> leadFilterItems = (List<Object>)contentMap.get('Interest');
            List<Object> AccountLinkFilterItems = (List<Object>)contentMap.get('AccountLink');
            List<Object> AddressFilterItems = (List<Object>)contentMap.get('Address');
            List<Object> campaignFilterItems = (List<Object>)contentMap.get('Campaign');
            List<Object> vehicleFilterItems = (List<Object>)contentMap.get('Vehicle');
            List<Object> vehicleretailItems = (List<Object>)contentMap.get('VehicleRetailcopy');
            List<Object> vehiclerelItems = (List<Object>)contentMap.get('VehicleRelation');
            List<Object> RetailTaskFilterItems = (List<Object>)contentMap.get('Contract');
            
            if(customerFilterItems != NULL && !customerFilterItems.isEmpty()){
                accountFilter = true;
            }
            if(vehicleFilterItems != NULL && vehiclerelItems != NULL && !vehicleFilterItems.isEmpty() && !vehiclerelItems.isEmpty()){
                vehicleFind = true;
                vehicleRelFind = true;
             }
            
            setSubSoql(customerFilterItems, 'account');
            setSubSoql(leadFilterItems, 'lead');
            setSubSoql(AccountLinkFilterItems, 'AccountLink');
            setSubSoql(AddressFilterItems, 'Address');
            setSubSoql(campaignFilterItems, 'campaign');
            setSubSoql(vehicleFilterItems, 'vehicle');
            setSubSoql(vehiclerelItems,'VehicleRelation');
            setSubSoql(vehicleretailItems,'VehicleRetailcopy');    
            setSubSoql(RetailTaskFilterItems, 'RetailTask');
            
            system.debug('saveQueryfinal'+saveQuery); 
        }
      
               public void setSubSoql(List<Object> filterItems, String cluster)
        {
           
           system.debug('Entered into filterItems'+filterItems);
           system.debug('Entered into cluster'+cluster);
           
                Integer bracketCount = 0;
                
                if(filterItems != null){
                    for(Object filterItem : filterItems){
                        Map<String, Object> filterItemMap = (Map<String, Object>)filterItem;
                        System.debug('Filter Item Map'+filterItemMap);
                        
                        String field = (String)filterItemMap.get('field');
                        String operation = getOperation((String)filterItemMap.get('operation'),field,(String)filterItemMap.get('criteria'));
                        String criteria = getCriteria(field, (String)filterItemMap.get('criteria'));
                        String logic = (String)filterItemMap.get('logic');
                        Boolean bracket = (Boolean)filterItemMap.get('bracket');
                        String subSoql = '';
                        //To Find Vehicle fileter is added or not
                        if(vehicleRelFind && vehicleFind && logic == '' && cluster == 'vehicle'){
                            logic = ' AND ';
                        }
                        
                        if(vehicleFields.contains(field)){
                            field = 'Vehicle_ID__r.' + field;
                          system.debug('Sample'+field ); 
                        }
                        if(retialCampaignFields.contains(field)){
                            field = 'Retail_Campaign_Id__r.' + field;
                        }
                        
                        if(recallFields.contains(field) && cluster == 'vehicle'){
                            if(recallCount == 0)
                            {
                                if(operation.equalsIgnoreCase('Like'))
                                {
                                recallSoql += ' '+field+' '+operation +'  '+ criteria +' ';
                                }else{
                                recallSoql += ' '+field+' '+operation+' '+criteria +' ';
                                }
                                recallCount++;

                            }
                            else{
                                recallSoql += 'AND '+field+' '+operation+' '+criteria+' ';
                            }
                        }
                        else{
                         if(operation.equalsIgnoreCase('Like'))
                                {
                                 System.debug('i am here soql'+criteria);
                                 subSoql += field +' '+ operation+' '+ criteria +' '; 
                                 System.debug('i am here soql'+subSoql);

                                }else{
                                subSoql += field + operation +' '+criteria + ' '; 
                                System.debug('i am here soql11'+subSoql);
                        }
                        }
                            
                        if(bracket){
                            subSoql = subSoql.removeEnd(' ');
                            subSoql += (++bracketCount > 1 ? ') ' : ' ') + logic + ' (';
                        }
                        else{
                            subSoql += logic + ' ';
                        }
                        System.debug('finalsubsoql'+subSoql);
                        if(cluster == 'account'){
                            accountSoql += subSoql;
                            if(segmentationBase == 'customer'){
                            saveQuery += subSoql;
                            }
                        }
                        else if(cluster == 'lead'){
                            leadSoql += subSoql;
                        }
                        else if(cluster == 'vehicle' || cluster == 'VehicleRelation'){
                            if(!recallFields.contains(field))
                            vehicleRelSoql += subSoql;
                            system.debug('++++++subSoql++++++++'+vehicleRelSoql );
                            if(segmentationBase == 'vehicle'){
                            saveQuery += subSoql;
                            }
                            system.debug('++++++subSoql++++++++'+subSoql);
                            system.debug('++++++subSoql++++++++'+saveQuery);
                        }
                        else if(cluster == 'VehicleRetailcopy'){
                            VehRetCopySoql += subSoql;
                            
                            
                        }
                        else if(cluster == 'AccountLink'){
                            AccountLinkSoql += subSoql;
                        }
                        else if(cluster == 'RetailTask'){
                           RetailTaskSoql += subSoql;
                           saveQuery += subSoql;
                        }
                        else if(cluster == 'Address'){
                            AddressSoql += subSoql;
                        }
                        else if(cluster == 'Campaign'){
                            campaignMemSoql+= subSoql;
                        }
                    }
                    system.debug('bracketCounttttttttttttttttttttttttttttt'+bracketCount);
                    if(cluster == 'account'){
                        accountSoql += (bracketCount > 0 ? ') ' : '');
                    }
                    else if(cluster == 'lead'){
                        leadSoql += (bracketCount > 0 ? ') ' : '');
                    }
                     else if(cluster == 'vehicle' || cluster == 'VehicleRelation'){
                        vehicleRelSoql += (bracketCount > 0 ? ') ' : '');
                    }
                    else if(cluster == 'AccountLink'){
                        RetailTaskSoql += (bracketCount > 0 ? ') ' : '');
                    }
                    else if(cluster == 'RetailTask'){
                        RetailTaskSoql += (bracketCount > 0 ? ') ' : '');
                    }
                    else if(cluster == 'Address'){
                        AddressSoql += (bracketCount > 0 ? ') ' : '');
                    }
                    else if(cluster == 'campaign'){
                        campaignMemSoql+= (bracketCount > 0 ? ') ' : '');
                    }
                }
                system.debug('saveQueryfinal'+saveQuery);
        }  
 
       
        public List<wrapperAccount> wrapperList{set;get;}
            
        // Create a new Map to verify whether the Account is already added in the Map
        Map <id,Account> SelectedAccountMap = new Map <id,Account>();      
        Map <id,Vehicle_Relationship__c> SelectedVrMap = new Map <id,Vehicle_Relationship__c>();      
       // Map <id,Retail_Task__c> SelectedRetailTaskMap = new Map <id,Retail_Task__c>();      
         
        // This method process accounts and formats List of wrapper Accounts to be used with checkbox 
        public list<wrapperAccount> getloadwrapAccountList()
        {
            getSelectedRecords();
            
            wrapperList = new  List<wrapperAccount>();
            if(segmentationBase == 'Customer'){
            system.debug('+++Working++++++++');
            system.debug('+++Working++++++++'+wrapperList );
               
               
                for(Account a : (List<Account>)con.getRecords()){
                    wrapperAccount wrapAcc = new wrapperAccount();
                    wrapAcc.acc = a;        
                    if(toRoleAndAccLinkMap.containsKey(a.Id))
                        wrapAcc.accLink = toRoleAndAccLinkMap.get(a.Id);
                    if(SelectedAccountMap.containsKey(a.id)){
                        wrapAcc.isSelected = true;    
                    }
                    else{
                        wrapAcc.isSelected = false;   
                    }
                    wrapperList.add(wrapAcc);   
                }
               
                system.debug('+++++++ONE+++++++++++'+wrapperList);
                system.debug('+++++++ONE+++++++++++'+wrapperList.size());
                
            }
            else if(segmentationBase == 'Vehicle'){
                    
                for(Vehicle_Relationship__c a : (List<Vehicle_Relationship__c>)con.getRecords()){
                    wrapperAccount wrapAcc = new wrapperAccount();
                    wrapAcc.veh = a;
                    if(vehIdRecallRecMap.get(a.Vehicle_ID__c) != NULL)
                    wrapAcc.recall = vehIdRecallRecMap.get(a.Vehicle_ID__c);
                    if(vehIdAccLinkRecMap.get(a.Vehicle_ID__c) != NULL)
                    wrapAcc.accLink = vehIdAccLinkRecMap.get(a.Vehicle_ID__c);
                    if(SelectedVrMap.containsKey(a.id)){
                        wrapAcc.isSelected = true;   
                    }
                    else{
                        wrapAcc.isSelected = false;  
                    }
                    
                    wrapperList.add(wrapAcc);  
                    
                }
                
            }
            else if(segmentationBase == 'Contract'){
                   
                /*for(Retail_Task__c a : (List<Retail_Task__c>)con.getRecords()){
                    wrapperAccount wrapAcc = new wrapperAccount();
                    wrapAcc.retail = a;                          
                    if(SelectedRetailTaskMap.containsKey(a.id)){
                        wrapAcc.isSelected = true;   
                    }
                    else{
                        wrapAcc.isSelected = false;   
                    }
                    
                    wrapperList.add(wrapAcc);   
                }*/
               
            }
                system.debug('Called Wrapper method size---- '+wrapperList.size());
                
            return wrapperList;
        }
            
        //This methods holds the records which is checked and which is unchecked
        public void getSelectedRecords(){
        system.debug('%^%^%^%^%^%^%^%^%^%^%^%^');
       // system.debug('%^%^%^%^%^%^%^%^%^%^%^%^ wrapperList '+wrapperList );
            if(wrapperList !=null ){
           // system.debug('%^%^%^%^%^%^%^%^%^%^%^%^ wrapperList '+wrapperList.size());
                for(wrapperAccount wr:wrapperList){
                
                   if(wr!=null)
                   {
                    if(wr.isSelected == true){
                        if(segmentationBase == 'Customer')
                        SelectedAccountMap.put(wr.acc.id,wr.acc);
                        else if(segmentationBase == 'Vehicle')
                        SelectedVrMap.put(wr.veh.id,wr.veh);
                        //else if(segmentationBase == 'Contract')
                        //SelectedRetailTaskMap.put(wr.retail.id,wr.retail);
                    }
                    if(wr.isSelected == false)
                    {
                        if(segmentationBase == 'Customer'){
                        system.debug('%^%^%^%^%^%^%^%^%^%^%^%^ wr.acc.id'+wr.acc.id);
                        if(wr.acc.id !=null)
                        {
                        SelectedAccountMap.remove(wr.acc.id); 
                        }  
                        else if(segmentationBase == 'Vehicle'){
                        if(wr.veh.id !=null)
                        {
                        SelectedVrMap.remove(wr.veh.id); 
                        }
                        } 
                        else if(segmentationBase == 'Contract'){
                        //SelectedRetailTaskMap.remove(wr.retail.id);
                        }
                        }  
                    }
                    }
                }
            }
        }
      
        // Wrapper class will be to used to have list of accounts with checkbox to Add to Campaign
        public class wrapperAccount{
            public Account acc {set;get;}
            public Vehicle_Relationship__c veh {set;get;}
            public Retail_Task__c retail {set;get;}
            public Boolean isSelected {set;get;}
            public Recall__c recall{set;get;}
            public Account_Link__c accLink{set;get;}
            
            
        }
        
        
        //Add campaign members to Retail campiang
        public PageReference addToCampaign(){
        System.debug('retailCampaignId === '+retailCampaignId);
            if(retailCampaignId == null) return null;
            
            //Calling this method to add the current page selected records
            getSelectedRecords();
            
            List<Campaign_Member__c> retailCampaignMembers = new List<Campaign_Member__c>();
            List<Campaign_Member__c> prevCamMembersList = [SELECT Id,Contact_Id__c,Vehicle__c,Retail_Task__c FROM Campaign_Member__c WHERE Retail_Campaign_Id__c =: retailCampaignId];
            Map<Id,Campaign_Member__c> conIdcamMemMap = new Map<Id,Campaign_Member__c>();
            for(Campaign_Member__c cm : prevCamMembersList){
                conIdcamMemMap.put(cm.Contact_Id__c,cm);    
            }
            if(segmentationBase == 'Customer'){
                if(SelectedAccountMap.size()>0){
                    /*List<Account_Link__c> accLinkRetaiPersonList = [SELECT Id,toRole__c,Selling_Dealer__c FROM Account_Link__c WHERE RecordType.Name = 'Retail Person' AND toRole__c IN : accIdToGetRetailPerson];
                    Map<Id,Id> toRoleAndSelDelMap = new Map<Id,Id>();
                    for(Account_Link__c al : accLinkRetaiPersonList){
                        toRoleAndSelDelMap.put(al.toRole__c,al.Selling_Dealer__c);
                    }*/
                    for(Account curAcc : SelectedAccountMap.values()){
                        if(!conIdcamMemMap.containsKey(curAcc.id)){
                            Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                            member.Contact_Id__c= curAcc.id; 
                            if(toRoleAndAccLinkMap.containsKey(curAcc.Id)){
                                member.Preferred_Dealer__c = toRoleAndAccLinkMap.get(curAcc.Id).Selling_Dealer__c;
                            }
                            retailCampaignMembers.add(member);   
                        }
                    }
                }
            }
            else if(segmentationBase == 'Vehicle'){
                if(SelectedVrMap.size()>0){
                    List<Account_Link__c> vehExtAccLinkList = [SELECT Id,Vehicle__c,Service_Dealer__c FROM Account_Link__c WHERE RecordType.Name = 'Vehicle External Link' AND Vehicle__c IN : vehIdToGetVehExtLink];
                    Map<Id,Id> vehIdAndSerDelMap = new Map<Id,Id>();
                    for(Account_Link__c al : vehExtAccLinkList){
                        vehIdAndSerDelMap.put(al.Vehicle__c,al.Service_Dealer__c);
                    }
                    System.debug('mapfromVehicleBase'+vehIdAndSerDelMap);
                    for(Vehicle_Relationship__c curVr : SelectedVrMap.values()){
                        if(!conIdcamMemMap.containsKey(curVr.Contact__c) || (conIdcamMemMap.containsKey(curVr.Contact__c) && conIdcamMemMap.get(curVr.Contact__c).Vehicle__c != curVr.Vehicle_ID__c)){
                            Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                            member.Contact_Id__c= curVr.Contact__c;
                            member.Vehicle__c = curVr.Vehicle_ID__c;
                            member.Vehicle_Relationship__c = curVr.Id;
                            member.Preferred_Dealer__c = vehIdAndSerDelMap.get(curVr.Vehicle_ID__c);
                            retailCampaignMembers.add(member);
                        }
                    }
                }
            }
            else if(segmentationBase == 'Contract'){
                /*if(SelectedRetailTaskMap.size() > 0){
                    for(Retail_Task__c curRec : SelectedRetailTaskMap.values()){
                        if(!conIdcamMemMap.containsKey(curRec.Account__c) || (conIdcamMemMap.containsKey(curRec.Account__c) && conIdcamMemMap.get(curRec.Account__c).Retail_Task__c != curRec.Id)){
                            Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                            member.Retail_Task__c = curRec.Id;
                            if(curRec.Account__c != NULL)
                                member.Contact_Id__c= curRec.Account__c;
                            if(curRec.Related_Vehicle__c != NULL)
                                member.Vehicle__c = curRec.Related_Vehicle__c;
                            if(curRec.Related_Dealer__c != NULL)
                                member.Preferred_Dealer__c = curRec.Related_Dealer__c;
                                if(curRec.Id!= NULL)
                                member.Contract__c = curRec.Id;
                            retailCampaignMembers.add(member);
                        }    
                    }
                }*/
            }
           
            System.debug('retailCampaignMembersAfter'+retailCampaignMembers);
            try {
                if(retailCampaignMembers != NULL && !retailCampaignMembers.isEmpty())
                insert retailCampaignMembers;
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
                return null;
            }
            return new PageReference('/' + retailCampaignId);
        }
        
        private String getOperation(String operation,String field, String criteria){
            operation = operation.replace('Exclude', '!=');
            operation = operation.replace('Include', 'Like');
            operation = operation.replace('Equals', '=');
            operation = operation.replace('Greater Than', '>');
            operation = operation.replace('Less Than', '<');
            //For from and to date filter this will give '>' symbol for from and gives '=' for null operaions
            system.debug('+++++criteria++++ ++++op'+criteria);
            if(dateFields.contains(field))
            {
               if(criteria == 'null')
                {
                    operation = '=';    
                }
                 else if(criteria.startsWith(';'))
                  {
                    operation = '<=';
                  }

                  else{
                   operation = '>';
                  }
            } 
            getop = operation;
            system.debug('getop--'+getop);
            return operation;
        }
        
        private String getCriteria(String field, String criteria){
        system.debug('+++++criteria++++++++'+criteria);

            if(textFields.contains(field) || pickListFields.contains(field) || multiplePickListFields.contains(field)){
              if(getop.equalsIgnoreCase('Like'))
                {
                 criteria = '\'%' + criteria + '%\'';
                }else
                {
                 criteria = '\'' + criteria + '\'';
                }
                return criteria;
            }
            else if(dateFields.contains(field)){
            
                if(criteria == 'null'){
                criteria = null;
            }
         else if(criteria.startsWith(';'))
            {
            criteria  = criteria.replace(';','');
            criteria = (Date.parse(criteria) + ' ').left(10);
            system.debug('+++++criteria++++++++'+criteria);
            }
            else if(criteria.contains(';')){
               String[] arrCriteia = criteria.split(';');
               System.debug('Before changing the criteria'+criteria );
               if(vehicleFields.contains(field)){
                   criteria = (Date.parse(arrCriteia[0]) + ' ').left(10)+' AND Vehicle_Id__r.'+field+'<='+(Date.parse(arrCriteia[1]) + ' ').left(10);
               }
               else{
                   criteria = (Date.parse(arrCriteia[0]) + ' ').left(10)+' AND '+field+'<='+(Date.parse(arrCriteia[1]) + ' ').left(10);
               }
               System.debug('After changing the criteria'+criteria);
            }
            else
                criteria = (Date.parse(criteria) + ' ').left(10);
            }
            return criteria;
        }
       
        private void setFieldType(){
            numberFields = new Set<String>{'Vehicle_Amount__c', 'CurrentMileage__c'};
            dateFields = new Set<String>{'PersonBirthdate', 'LastServiceDate__c', 'End_Date__c','Handover_Date__c','LastServiceDate__c', 'NextServiceDate__c','FirstRegistrationDate__c', 'Registration_Date__c', 'Expected_Close_Date__c','Expected_Registration_Date__c','NextInspectionDate__c','LastWorkDate__c','LastInspectionDate__c','EndDate__c'};
            textFields = new Set<String>{'Recall_No__c','Retail_Sales_Consultant__c','New_Used__c','PersonEmail', 'Modification_Package__c','Model_Description__c', 'ZipCode__c', 'Selling_Dealer__c','Name','Sales_Representative__c','Last_Service_Dealer__c','Service_Advisor__c','Service_Dealer__c','Car_Model__r.Series_Description__c' };
            pickListFields = new Set<String>{'Market__c','Customer_Type__c','Special_Mark_on_Account__c','Gender__c','Personal_Agreement__c','ID_Type__c','Customer_Lifecycle_Phase__c','Status__c', 'Province__c', 'Occupation__c', 'Type','Type__c', 'Range__c','Car_Relation__c', 'Class__c','Car_Model__r.Model_Name__c', 'Dealer_Lead_Status__c','Retail_Sales_Sanction__c','Product_Name__c','Finance_Product_Name__c','New_Used__c'};
            multiplePickListFields = new Set<String>{'Hobby__c','Interest_Model__c', 'Retail_OptOutContact_Reason__c'};
            vehicleFields = new Set<String>{'Model_Description__c','Modification_Package__c','Range__c','FirstRegistrationDate__c', 'Class__c','Car_Model__r.Model_Name__c','Car_Model__r.Series_Description__c'};
            vehicleRelFields = new Set<String>{'Car_Relation__c', 'Handover_Date__c', 'Last_Service_Dealer__c', 'Registration_Date__c', 'Selling_Dealer__c','Service_Advisor__c','Customer_Type__c','New_Used__c','End_Date__c'};
            AccountLinkFields =new Set<String>{'Sales_Representative__c','Selling_Dealer__c','Retail_Sales_Consultant__c', 'Retail_Visit_OptOut__c', 'Retail_Sales_Sanction__c', 'Retail_Postal_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_OptOutContact_Reason__c','NextServiceDate__c','NextInspectionDate__c','LastServiceDate__c', 'CurrentMileage__c', 'Service_Dealer__c','LastWorkDate__c','LastInspectionDate__c'};  
            recallFields = new Set<String>{'Recall_No__c','Status__c'};
            retialCampaignFields =new Set<String>{'Name'};
            RetailTaskFields =new Set<String>{ 'Product_Name__c','Finance_Product_Name__c', 'Type__c', 'Duration__c', 'Status__c','EndDate__c'};
            AddressFields = new Set<String>{'ZipCode__c' , 'Province__c'};
        }
        
        
        // returns the first page of records
        public void first() {
             con.first();
         }
         
         // returns the last page of records
         public void last() {
             con.last();
         }
        
        // returns the previous page of records
         public void previous() {
             con.previous();
         } 
        
        //disable first and prev button
        public Boolean hasPrevious {
            get {
            boolean b = false;
               if(con != null){ 
               b=con.getHasPrevious();
                }
                return b;
            }
            set;
        }
        
        //display the next page of records
        public void next() {
           system.debug('++++con+++++++'+con);
            con.next();
        }
        
        //disable the next and last buttons
        public Boolean hasnext {
            get {
            boolean a = false;
            if(con != null){
               a=con.getHasNext();
                
                }
                return a;
            }
            set;
        }
       @RemoteAction
       global static Segmentation_Criteria__c saveCriteriaa(String name,String query){
            Segmentation_Criteria__c sc = new Segmentation_Criteria__c();
            system.debug('----------------name'+name);
            system.debug('----------------query'+query);
            sc.name = name;
            sc.Criteria__c = query;
            insert sc;
            return sc;
       }
    }