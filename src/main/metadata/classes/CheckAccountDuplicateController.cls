/*
Created By          :    Kiran  
Created Date        :    23.02.2017
Company             :    NTT Data,Inc.
Usage               :    This functionaly will check the duplicate account records and disply the matched records
                        
                         Business Conditions :
                          * Need to click on Duplicate check button.
                   
JIRA NO             :    SFDCJP-1056,SFDCJP-995                                    
 
MODIFICATION DETAILS:
Modified by          : Venky
Modified Date        : 3/28/2017
JIRA TIcket Number : SFDCJP-2095,SFDCJP-995
Modification Details : Updated Class to Work Company account record type and if Account Id match from EP dont display records in confirmed match.
*/
public class CheckAccountDuplicateController{
public Account objAccountDeDup{get;set;}
public Account objPersonAccount{get;set;}
public Account objPersonAccount1{get;set;}
public Address__c AddressSearch{get;set;}
public Address__c Address{get;set;}
public String AddressDetails{get;set;}
public string recordType{get;set;}
public Boolean show {get;set;}
public Boolean CompanyAcc{get;set;}
public List<Account> cResult{get;set;}
public String market;
public Boolean homeaddcheck;
public Map<String, JP_Switch__c> jpSwitchMap = JP_Switch__c.getAll();
public List<Account> DedupAccountList{get;set;}
public Boolean jpSwitchEnabledFlag{get;set;}
public Boolean nonContinuationResponse;
public HttpResponse custSearchResp;
public Continuation con = null;
public String requestLabel;
public JSON2ApexCustomerFromCDM custSearch;
public Map<Id, String> accIdToAddressMap{get;set;}

public void onLineDeduplication(){  
        objPersonAccount1 = new Account();
        Address=new Address__c();
        AddressSearch=new Address__c();
        homeaddcheck=false;         
        dedupAccountList  = new List<Account>();
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Check Duplicate')){
            jpSwitchEnabledFlag = jpSwitchMap.get('Check Duplicate').Enable_Flag__c;
        }
        
        if(!jpSwitchMap.isEmpty() && jpSwitchMap.containsKey('Non-Continuation Method')){
            nonContinuationResponse = jpSwitchMap.get('Non-Continuation Method').Enable_Flag__c;
        }
        
        List<Address__c> Addressrec=new List<Address__c>();
        objPersonAccount= [select id,Company_Name_Native_2__c,MD__c,UCID__c,VIN__c, Market__c, RecordType.Name,MB_Customer_Info_Remove__c,Phone,Mobile2__c,Company_Name__c, Allow_Data_Sharing2__c,Company_Name_Native_1__c , Foundation_date__c, Commercial_reg_no__c, Email__c,Email2__c,RecordTypeID,Email3__c,Salutation,Name,Work_Phone__c,Home_Phone_2__c,LastName,PersonEmail,Mobile__c,Loyalty_Card_No__c,LastName_Native_1__c,PersonBirthdate,FirstName_Native_1__c,FirstName,Individual_Home_Phone__c,PersonMobilePhone from Account WHERE Id =: apexpages.currentpage().getparameters().get('id')];
        market = objPersonAccount.MD__c;
        recordType = objPersonAccount.RecordType.Name;
        
        if(recordType == 'Company'){
            companyAcc = true;
        }else if(recordType == 'Person Account'){
            show = true;
        }
        if(apexpages.currentpage().getparameters().get('id') !=null)
        {
         Addressrec=[Select id,ZipCode__c,Address_Code__c,Province__c,Address_Line_1__c ,Address_Line_2__c,Block__c ,City__c ,District__c ,Block_Native__c ,City_Native__c ,Province_Native__c ,District_Native__c ,Customer__c,Address_Line_1_Native__c ,Address_Line_2_Native__c ,Address_Type__c from Address__c where Customer__c=:apexpages.currentpage().getparameters().get('id')];
       
        }
        if(Addressrec!=null)
        {
        for(Address__c ad:Addressrec)
        {
        if(ad.Address_Type__c =='Home')
        {
        homeaddcheck=true;
        }
        }
        }
        if(homeaddcheck ==true)
        {
        Address=[Select id,ZipCode__c, Market__c,Address_Code__c,Province__c,Address_Line_1__c ,Address_Line_2__c,Block__c ,City__c ,District__c ,Block_Native__c ,City_Native__c ,Province_Native__c ,District_Native__c ,Customer__c,Address_Line_1_Native__c ,Address_Line_2_Native__c ,Address_Type__c from Address__c where Customer__c=:apexpages.currentpage().getparameters().get('id') and Address_Type__c ='Home'];
        }
        objAccountDeDup= new Account();
        List<Account>   lstAcc = New List<Account>();    
        List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> listmess=new List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType>();
        
        if(objPersonAccount.Name !=null ) 
        {    
            if(!jpSwitchEnabledFlag){   
                crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
                System.debug('@@@@@@@ response '+response );
               
                String companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordtypeID();
                String PersonAccountRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordtypeID();
               
                system.debug('recordType------------:'+recordType);
                             
                    if(objPersonAccount.Recordtypeid == PersonAccountRecordTypeID){
                    show = true;
                    objPersonAccount1.Recordtypeid=PersonAccountRecordTypeID ;
                    }else if(objPersonAccount.Recordtypeid == companyRecordTypeId ){
                    CompanyAcc=true;
                        objPersonAccount1.Recordtypeid = companyRecordTypeId; 
                    }
               
                if(objPersonAccount.MD__c == 'JP')
                {
                    if(objPersonAccount.Email__c != null )
                    {                      
                        objPersonAccount1.Email__c= objPersonAccount.Email__c;
                    }
                    
                    if(objPersonAccount.MD__c != null && objPersonAccount.MD__c == 'JP')
                    {                      
                        objPersonAccount1.MD__c = objPersonAccount.MD__c;
                    }
                    if(objPersonAccount.Recordtypeid == PersonAccountRecordTypeID){
                        objPersonAccount1.LastName = objPersonAccount.LastName;
                        if(objPersonAccount.FirstName != null){
                            objPersonAccount1.FirstName = objPersonAccount.FirstName;
                        }
                        
                    }else if(objPersonAccount.Recordtypeid ==companyRecordTypeId){
                         objPersonAccount1.Name =  objPersonAccount.Name; 
                    }
                    if(objPersonAccount.LastName_Native_1__c !=  null){
                        objPersonAccount1.LastName_Native_1__c = objPersonAccount.LastName_Native_1__c;   
                    }
                    if(objPersonAccount.Id!=  null){
                        objPersonAccount1.Id= objPersonAccount.Id;   
                    }
                    
                    if(objPersonAccount.Company_Name__c!=  null){
                        objPersonAccount1.Company_Name__c= objPersonAccount.Company_Name__c;   
                    }
                    if(objPersonAccount.Company_Name_Native_1__c !=  null){
                        objPersonAccount1.Company_Name_Native_1__c= objPersonAccount.Company_Name_Native_1__c;   
                    }
                    if(objPersonAccount.Foundation_date__c!=  null){
                        objPersonAccount1.Foundation_date__c= objPersonAccount.Foundation_date__c;   
                    }
                    if(objPersonAccount.Commercial_reg_no__c!=  null){
                        objPersonAccount1.Commercial_reg_no__c= objPersonAccount.Commercial_reg_no__c;   
                    }
                     if(objPersonAccount.Allow_Data_Sharing2__c!=  null){
                        objPersonAccount1.Allow_Data_Sharing2__c= objPersonAccount.Allow_Data_Sharing2__c;   
                    }
                    
                    if(objPersonAccount.LastName_Native_1__c !=  null){
                        objPersonAccount1.LastName_Native_1__c = objPersonAccount.LastName_Native_1__c;   
                    }
                    if(objPersonAccount.FirstName_Native_1__c !=  null){
                        objPersonAccount1.FirstName_Native_1__c = objPersonAccount.FirstName_Native_1__c;
                    }
                    if(objPersonAccount.Individual_Home_Phone__c !=  null){
                        objPersonAccount1.Individual_Home_Phone__c = objPersonAccount.Individual_Home_Phone__c;
                    }
                    if(objPersonAccount.Home_Phone_2__c !=  null){
                        objPersonAccount1.Home_Phone_2__c = objPersonAccount.Home_Phone_2__c ;
                    }
                    if(objPersonAccount.Work_Phone__c !=  null){
                        objPersonAccount1.Work_Phone__c = objPersonAccount.Work_Phone__c;
                    }
                    if(objPersonAccount.Phone!=  null){
                        objPersonAccount1.Phone= objPersonAccount.Phone;
                    }
                    if(objPersonAccount.Mobile2__c !=  null){
                        objPersonAccount1.Mobile2__c = objPersonAccount.Mobile2__c;
                    }
                    if(objPersonAccount.Email2__c !=  null){
                        objPersonAccount1.Email2__c = objPersonAccount.Email2__c;
                    }
                    if(objPersonAccount.Email3__c !=  null){
                        objPersonAccount1.Email3__c = objPersonAccount.Email3__c;
                    }
                    
                    if(objPersonAccount.Mobile__c!= null )
                    {              
                        objPersonAccount1.Mobile__c= objPersonAccount.Mobile__c;
                    }
                    if(objPersonAccount.PersonBirthdate!= null )
                    {              
                        objPersonAccount1.PersonBirthdate= objPersonAccount.PersonBirthdate;
                    }
                    if(objPersonAccount.MB_Customer_Info_Remove__c == true)
                    {              
                        objPersonAccount1.MB_Customer_Info_Remove__c= objPersonAccount.MB_Customer_Info_Remove__c;
                    }
                                    if(Address !=null)
                    {
                    if(Address.Address_Line_1__c !=null)
                    {
                    AddressSearch.Address_Line_1__c=Address.Address_Line_1__c;
                    }
                     if(Address.Address_Line_2__c!=null)
                    {
                    AddressSearch.Address_Line_2__c=Address.Address_Line_2__c;
                    }
                     if(Address.Block__c!=null)
                    {
                    AddressSearch.Block__c=Address.Block__c;
                    }
                     if(Address.Address_Type__c!=null)
                    {
                    AddressSearch.Address_Type__c=Address.Address_Type__c;
                    } 
                     if(Address.City__c !=null)
                    {
                    AddressSearch.City__c =Address.City__c;
                    }
                     if(Address.District__c !=null)
                    {
                    AddressSearch.District__c=Address.District__c;
                    }
                     if(Address.Province__c!=null)
                    {
                    AddressSearch.Province__c=Address.Province__c;
                    }
                     if(Address.Block_Native__c !=null)
                    {
                    AddressSearch.Block_Native__c=Address.Block_Native__c;
                    }
                     if(Address.City_Native__c !=null)
                    {
                    AddressSearch.City_Native__c=Address.City_Native__c;
                    }
                    if(Address.District_Native__c!=null)
                    {
                    AddressSearch.District_Native__c=Address.District_Native__c;
                    }
                    if(Address.Province_Native__c!=null)
                    {
                    AddressSearch.Province_Native__c=Address.Province_Native__c;
                    }
                    if(Address.Address_Line_1_Native__c!=null)
                    {
                    AddressSearch.Address_Line_1_Native__c=Address.Address_Line_1_Native__c;
                    }
                    if(Address.Address_Line_2_Native__c !=null)
                    {
                    AddressSearch.Address_Line_2_Native__c=Address.Address_Line_2_Native__c;
                    }
                    }
                                   
                }
                system.debug('objPersonAccount1%%%%%%%' + objPersonAccount1);
               if(Address !=null && AddressSearch!=null && objPersonAccount1 !=null)
                {
                 response =  UtilWebservice.validateCustomerDetailsWithAddress(objPersonAccount1,AddressSearch); 
                }
                if(Address ==null && objPersonAccount1 !=null)
                {
                 response =  UtilWebservice.validateCustomerDetails(objPersonAccount1); 
                }
                
                System.debug('@@@@@@@@@@ response '+response);
                //System.debug('@@@@@@@@@@ response '+response.CustomerIdentificationResponseMessage[0].Customer);
                if(response != null){
                    system.debug('##############'+response );
                    if(response.CustomerIdentificationResponseMessage!=null)
                    {
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Lastname !=null)
                        {
                            objAccountDeDup.Lastname=response.CustomerIdentificationResponseMessage[0].Customer.Lastname;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Name!=null)
                        {
                            objAccountDeDup.Name=response.CustomerIdentificationResponseMessage[0].Customer.Name;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                        {
                            objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Firstname !=null)
                        {
                            objAccountDeDup.Firstname=response.CustomerIdentificationResponseMessage[0].Customer.Firstname;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                        {
                            objAccountDeDup.Id=response.CustomerIdentificationResponseMessage[0].Customer.Id;
                        }
                       /* if(response.CustomerIdentificationResponseMessage[0].Customer.vin!=null)
                        {
                            objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.vin;
                        }*/
                        system.debug('&&& :'+response.CustomerIdentificationResponseMessage[0].Customer.Email_xc);
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Email_xc != null)
                        {   
                            objAccountDeDup.Email__c =response.CustomerIdentificationResponseMessage[0].Customer.Email_xc;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                        {
                            objAccountDeDup.Mobile__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.PersonBirthdate !=null)
                        {
                            objAccountDeDup.PersonBirthdate=Date.Valueof(response.CustomerIdentificationResponseMessage[0].Customer.PersonBirthdate);
                        }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc  !=null)
                        {
                            objAccountDeDup.Allow_Data_Sharing2__c=response.CustomerIdentificationResponseMessage[0].Customer.Allow_Data_Sharing2_xc ;
                        }
                        // if(response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc !=null)
                        // {
                        //     objAccountDeDup.vin__c=response.CustomerIdentificationResponseMessage[0].Customer.Mobile_xc;
                        // }
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Address_xc!=null)
                        {   
                            AddressDetails =response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Province_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].City_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].District_xc+ '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Block_xc + '  '+response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_1_xc+'  '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Line_2_xc;//response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Address_Code_xc +' '+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].ZipCode_xc + '  '+ 'Unnormalized Post Code'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_ZipCode_xc + 'Unnormalized Address'+ response.CustomerIdentificationResponseMessage[0].Customer.Address_xc[0].Temp_Address_xc;                
                            AddressDetails = AddressDetails.replace('null',' ');
                       }
                       
                        if(response.CustomerIdentificationResponseMessage[0].Customer.Id!=null)
                        {
                        if(objPersonAccount.Id != objAccountDeDup.Id)
                        {
                         lstAcc = [Select Name,FirstName,LastName,Phone ,Email__c,PersonBirthdate,Allow_Data_Sharing2__c,MB_Customer_Info_Remove__c,Dealer_Address_EN__c,PersonAssistantPhone,Dealer_General_Manager_Email__c From Account where  LastName=:objAccountDeDup.LastName OR Name=:objAccountDeDup.Name];// and FirstName =: objPersonAccount.FirstName];
                        }              
                     }
                    cResult = lstAcc;  
                    System.debug('@@@@@@@    lstAcc   lstAcc '+lstAcc );
                    System.debug('@@@@@@@    lstAcc   cResult '+cResult );
                    }
                  //  show = true;
                    if(response.CustomerIdentificationResponseMessage ==null)
                    {
                     //   show = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_matched_customer_found));
                    }
                  
                }
                if(response == null)
                {
                   //  show = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Result_Found));
                }
            }else{
                String endURL= generateCDMEndPointURLRules();
                /*
                Map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
                for(string str: mapURLs.keyset()){
                    if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                        endURL+=mapURLs.get(str).Informatica_URL__c+'?';
                    }
                }
                endURL += 'ip_Id=' + ((string.isnotblank(objPersonAccount.Id)) ? EncodingUtil.URLENCODE(objPersonAccount.Id, 'UTF-8') : '');
                endURL += '&ip_UCID=' + ((string.isnotblank(objPersonAccount.UCID__c)) ? EncodingUtil.URLENCODE(objPersonAccount.UCID__c, 'UTF-8') : '');
                */
                try{
                    if (label.New_Component == 'true') {
                        if(nonContinuationResponse && market == 'JP'){
                            Map < string, string > headerCDM = new Map < string, string > ();
                            headerCDM.put('Content-Type', 'application/json');
                            custSearchResp = CalloutHandlerService.sendCallout('GET', endUrl, 60000, headerCDM, null);
                            processResponse();
                        }else{
                            con = new Continuation(120);
                            con.continuationMethod = 'processResponse';
                            this.requestLabel = CalloutHandlerService.onLineDeduplicationCDMCallout(EndUrl, con);
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.No_Match_Found));
                       
                    }
                }catch (Exception e) {
                    system.debug('error'+ ' ---> '+ e.getlinenumber() + e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));                
                    CustomLogUtil.CustomLoggingEntry('Error Occured ' + e.getlinenumber() + e.getMessage());
                }
            }
        }   
    }
    
    public String generateCDMEndPointURLRules(){
        String endUrlGenerator='';
        map<String,CDM_Integration_URLs__c> mapURLs = CDM_Integration_URLs__c.getAll();
        For(string str: mapURLs.keyset()){
            if(mapURLs.get(str).Country__c == Market && mapURLs.get(str).Type__c==RecordType){
                endUrlGenerator+=mapURLs.get(str).Informatica_URL__c+'?';
            }
                      
        }
        List<Configuration_Rule__c> DedupCriteria= new List<Configuration_Rule__c>();
        DedupCriteria=[select id,(select id,Destination__c,Source__c,Object_API__c,Order__c from Configuration_Rule_Items__r where active__c=true order by Order__c) from Configuration_Rule__c where active__c=true and Market__c=:Market and type__c='Deduplication' and Sub_Type__c=:recordType limit 1];         
        if(DedupCriteria.size()>0){
            for(Configuration_Rule__c c:DedupCriteria){
                if(c.Configuration_Rule_Items__r!=null && c.Configuration_Rule_Items__r.size()>0){
                    for(Integer i=0; i<c.Configuration_Rule_Items__r.size();i++){
                        Configuration_Rule_Item__c cri =  new Configuration_Rule_Item__c();
                        cri=c.Configuration_Rule_Items__r[i];
                        if(i!=0){
                            endUrlGenerator+='&';
                        }
                        if(cri.Object_API__c=='Account'){
                            endUrlGenerator+=cri.Destination__c+'='+((string.isnotblank(string.valueof(objPersonAccount.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(objPersonAccount.get(cri.source__c)),'UTF-8'):'');
                        }
                        else if(cri.Object_API__c=='Address__c' && homeaddcheck){
                            if(cri.Destination__c=='ip_JPProvice'){
                                String tempProvinceTrans = doProvinceTranslation(Address);
                                endUrlGenerator+=cri.Destination__c+'='+((string.isnotblank(tempProvinceTrans))?EncodingUtil.URLENCODE(tempProvinceTrans,'UTF-8'):'');
                            }
                            else{
                                endUrlGenerator+=cri.Destination__c+'='+((string.isnotblank(string.valueof(Address.get(cri.source__c))))?EncodingUtil.URLENCODE(string.valueof(Address.get(cri.source__c)),'UTF-8'):'');
                            }   
                        }
                        else if(cri.Object_API__c=='Default'){
                             if(cri.Destination__c == 'ip_SendAddFlag'){
                                endUrlGenerator+=cri.Destination__c+'='+((string.isnotblank((String.ValueOf(homeaddcheck))))?EncodingUtil.URLENCODE(String.ValueOf(homeaddcheck),'UTF-8'):'');
                            }else{  
                            endUrlGenerator+=cri.Destination__c+'='+((string.isnotblank((cri.source__c)))?EncodingUtil.URLENCODE((cri.source__c),'UTF-8'):'');
                        }
                    }
                if(endUrlGenerator.charAt(endUrlGenerator.length()-1) == 38){
                            endUrlGenerator = endUrlGenerator.removeEnd('&');                           
                }
                 } //end of child loop iteration.
                }                                   
            }
        }
         System.debug('End url inside the generate url method using Rule Item ------------------------------->'+endUrlGenerator);                                                                                                               
        return endUrlGenerator;
    }
    
    public String doProvinceTranslation(Address__c AddressObj){
        String provinceStr = '';
        List<ProvinceTranslation__mdt> ProvinceCodeJP = [SELECT id,MD__c,Object__c,Picklist_Name__c,Province_EN1__c,Province_EN10__c,Province_EN11__c,Province_EN12__c,Province_EN13__c,  
                        Province_EN14__c,Province_EN15__c,Province_EN16__c,Province_EN17__c,Province_EN18__c,Province_EN19__c,Province_EN2__c,Province_EN20__c, 
                        Province_EN21__c,Province_EN22__c,Province_EN23__c,Province_EN24__c,Province_EN25__c,Province_EN26__c,Province_EN27__c,Province_EN28__c,    
                        Province_EN29__c,Province_EN3__c,Province_EN30__c,Province_EN31__c,Province_EN32__c,Province_EN33__c,Province_EN34__c,Province_EN35__c, 
                        Province_EN36__c,Province_EN37__c,Province_EN38__c,Province_EN39__c,Province_EN4__c,Province_EN40__c,Province_EN41__c,Province_EN42__c, 
                        Province_EN43__c,Province_EN44__c,Province_EN45__c,Province_EN46__c,Province_EN47__c,Province_EN5__c,Province_EN6__c,Province_EN7__c,   
                        Province_EN8__c,Province_EN9__c,Province_TR1__c,Province_TR10__c,Province_TR11__c,Province_TR12__c,Province_TR13__c,Province_TR14__c,   
                        Province_TR15__c,Province_TR16__c,Province_TR17__c,Province_TR18__c,Province_TR19__c,Province_TR2__c,Province_TR20__c,Province_TR21__c, 
                        Province_TR22__c,Province_TR23__c,Province_TR24__c,Province_TR25__c,Province_TR26__c,Province_TR27__c,Province_TR28__c,Province_TR29__c ,
                        Province_TR3__c,Province_TR30__c,Province_TR31__c,Province_TR32__c,Province_TR33__c,Province_TR34__c,Province_TR35__c,Province_TR36__c, 
                        Province_TR37__c,Province_TR38__c,Province_TR39__c,Province_TR4__c,Province_TR40__c,Province_TR41__c,Province_TR42__c,Province_TR43__c, 
                        Province_TR44__c,Province_TR45__c,Province_TR46__c,Province_TR47__c,Province_TR5__c,Province_TR6__c,Province_TR7__c,Province_TR8__c,Province_TR9__c 
                FROM ProvinceTranslation__mdt 
                WHERE MD__c=: AddressObj.MD__c LIMIT 1]; 
    
        for(ProvinceTranslation__mdt provinceCode : ProvinceCodeJP){
            if(AddressObj.Province__c == provinceCode.Province_EN1__c){
                provinceStr = provinceCode.Province_TR1__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN2__c){
                provinceStr = provinceCode.Province_TR2__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN3__c){
                provinceStr = provinceCode.Province_TR3__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN4__c){
                provinceStr = provinceCode.Province_TR4__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN5__c){
                provinceStr = provinceCode.Province_TR5__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN6__c){
                provinceStr = provinceCode.Province_TR6__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN7__c){
                provinceStr = provinceCode.Province_TR7__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN8__c){
                provinceStr = provinceCode.Province_TR8__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN9__c){
                provinceStr = provinceCode.Province_TR9__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN10__c){
                provinceStr = provinceCode.Province_TR10__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN11__c){
                provinceStr = provinceCode.Province_TR11__c;
            }            
            if(AddressObj.Province__c == provinceCode.Province_EN12__c){
                provinceStr = provinceCode.Province_TR12__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN13__c){
                provinceStr = provinceCode.Province_TR13__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN14__c){
                provinceStr = provinceCode.Province_TR14__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN15__c){
                provinceStr = provinceCode.Province_TR15__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN16__c){
                provinceStr = provinceCode.Province_TR16__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN17__c){
                provinceStr = provinceCode.Province_TR17__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN18__c){
                provinceStr = provinceCode.Province_TR18__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN19__c){
                provinceStr = provinceCode.Province_TR19__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN20__c){
                provinceStr = provinceCode.Province_TR20__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN21__c){
                provinceStr = provinceCode.Province_TR21__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN22__c){
                provinceStr = provinceCode.Province_TR22__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN23__c){
                provinceStr = provinceCode.Province_TR23__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN24__c){
                provinceStr = provinceCode.Province_TR24__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN25__c){
                provinceStr = provinceCode.Province_TR25__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN26__c){
                provinceStr = provinceCode.Province_TR26__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN27__c){
                provinceStr = provinceCode.Province_TR27__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN28__c){
                provinceStr = provinceCode.Province_TR28__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN29__c){
                provinceStr = provinceCode.Province_TR29__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN30__c){
                provinceStr = provinceCode.Province_TR30__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN31__c){
                provinceStr = provinceCode.Province_TR31__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN32__c){
                provinceStr = provinceCode.Province_TR32__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN33__c){
                provinceStr = provinceCode.Province_TR33__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN34__c){
                provinceStr = provinceCode.Province_TR34__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN35__c){
                provinceStr = provinceCode.Province_TR35__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN36__c){
                provinceStr = provinceCode.Province_TR36__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN37__c){
                provinceStr = provinceCode.Province_TR37__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN38__c){
                provinceStr = provinceCode.Province_TR38__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN39__c){
                provinceStr = provinceCode.Province_TR39__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN40__c){
                provinceStr = provinceCode.Province_TR40__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN41__c){
                provinceStr = provinceCode.Province_TR41__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN42__c){
                provinceStr = provinceCode.Province_TR42__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN43__c){
                provinceStr = provinceCode.Province_TR43__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN44__c){
                provinceStr = provinceCode.Province_TR44__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN45__c){
                provinceStr = provinceCode.Province_TR45__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN46__c){
                provinceStr = provinceCode.Province_TR46__c;
            }
            if(AddressObj.Province__c == provinceCode.Province_EN47__c){
                provinceStr = provinceCode.Province_TR47__c;
            }           
        }
        return provinceStr;
    }
    
    public Object processResponse() {
        HttpResponse res;
        if(nonContinuationResponse && market == 'JP'){
            res = custSearchResp;
        }else{
            res = Continuation.getResponse(this.requestLabel);
        }
        System.debug('Result is ------------------------------------------>'+res);
        try{
            this.requestLabel = res.getBody();
            CustomLogUtil.CustomLoggingEntry('Continuation Response Body' + res.getBody());
            if(res.getbody()=='{}'){
                CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +res.getbody());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
            }else if(res.getStatusCode()==500){
                CustomLogUtil.CustomLoggingEntry('Error Occured ' + res.getstatuscode() +'-- '+res.getStatusCode());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.The_request_could_not_reach_server));
            }else{
                list<string> set_accounts= new list<string>();
                if(nonContinuationResponse && market == 'JP'){
                    JSON2ApexCustomerCDM  custSearchForJP = JSON2ApexCustomerCDM.parse(res.getBody());
                    for(JSON2ApexCustomerCDM.cls_OP_UCID  cust : custSearchForJP.OP_UCID){
                        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                        System.debug('---------------------------------------->'+m);
                        if(string.valueof(m.get(Label.AdminClientNum))!=null)
                            set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                    }
                    System.debug('Account id set is ---------------------------------->'+set_accounts);
                }else{
                    custSearch=JSON2ApexCustomerFromCDM.parse(res.getbody());
                    system.debug('custSearch:'+custSearch);
                    
                    For(JSON2ApexCustomerFromCDM.Out_JSON_UCID_List cust : custSearch.out_JSON_UCID_List){
                        system.debug('cust:'+cust);
                        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(cust));
                        if(string.valueof(m.get(Label.AdminClientNum))!=null)
                            set_accounts.add(string.valueof(m.get(label.AdminClientNum)));
                    }
                }
                if(set_accounts.size()>0){
                    String addressFieldsQuery = ',Primary_Address_Reference__c, Primary_Address_Reference__r.Province__c, Primary_Address_Reference__r.City__c,Primary_Address_Reference__r.District__c,Primary_Address_Reference__r.Block__c,Primary_Address_Reference__r.Address_Line_1__c,Primary_Address_Reference__r.Address_Line_2__c,Primary_Address_Reference__r.Address_Code__c,Primary_Address_Reference__r.ZipCode__c,Primary_Address_Reference__r.Temp_ZipCode__c,Primary_Address_Reference__r.Temp_Address__c';                                                                                                                                                                                                                                                        
                    string querytxt='select id,firstname,isPersonAccount,UCID__c,Allow_data_sharing2__c,VIN__c,Recordtype.name,lastname,Name,mobile__c,Individual_Home_Phone__c,Work_Phone__c,Email__c,Primary_Address_Display__c from account where <Search> in (';
                    querytxt=querytxt.replace('<Search>',label.SearchKey); 
                    set<String> valueSet = new set<String>();
                    for(Integer i=0; i<set_accounts.size(); i++){
                        valueSet.add('\'' + String.escapeSingleQuotes(set_accounts[i]) + '\'');
                    }
                    if (valueSet.isEmpty()){
                        valueSet.add('\'\'');
                    }
                    querytxt=querytxt+ String.join(new list<String>(valueSet),',') + ') limit ' +label.limitsize;
                    for(account acc :database.query(querytxt)){
                        if(acc.Recordtype.name == 'Person Account' || acc.Recordtype.name == 'Company'){
                            if(acc.UCID__c != objPersonAccount.UCID__c){
                                DedupAccountList.add(acc);
                            }
                        }
                    }
                    if(DedupAccountList.size()>0){   
                        constructAddressMap();
                    }else{
                        CustomLogUtil.CustomLoggingEntry('Error Occured will calling ' + 'Response Body' +res.getbody());
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,Label.No_Match_Found));
                    }
                }
            }
        }Catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.InformaticaError));       
            CustomLogUtil.CustomLoggingEntry('Error Occured ' + e +'-- '+e.getMessage());
            System.debug('Exception occurred ----------------------------------------------->'+e);
        }
        return null;
    }
    
    //this method is used to construct the address field map.
    public void constructAddressMap(){
        accIdToAddressMap = new Map<Id, String>();
        String concatenateAddressFields; //used to concatenate the address fields.
        
        //iterating the constructed list.
        for(Account acc : DedupAccountList){
            concatenateAddressFields = '';
            
            if(acc.Primary_Address_Display__c != null){
                concatenateAddressFields = acc.Primary_Address_Display__c;
                concatenateAddressFields = concatenateAddressFields.replaceAll('null', '');
                accIdToAddressMap.put(acc.Id, concatenateAddressFields);
            
            }
        }//end of iterating the account records.
        
        //checking the size to avoid unnessary query.
        if(DedupAccountList.size() != accIdToAddressMap.size()){
            for(Address__c add : [SELECT Id, Customer__c, Province__c, City__c, District__c, Block__c, Address_Line_1__c, Address_Line_2__c, 
                                        Address_Code__c, ZipCode__c, Temp_ZipCode__c, Temp_Address__c
                                FROM Address__c 
                                WHERE Customer__c IN : DedupAccountList
                                AND Customer__c NOT IN : accIdToAddressMap.keySet()
                                AND Address_Type__c = 'Home']){
                concatenateAddressFields = add.Province__c +' '+ 
                                        add.City__c +' '+ 
                                        add.District__c +' '+ 
                                        add.Block__c +' '+ 
                                        add.Address_Line_1__c +' '+ 
                                        add.Address_Line_2__c +' '+ 
                                        add.Address_Code__c +' '+ 
                                        add.ZipCode__c +' Unnormalized Post Code '+ 
                                        add.Temp_ZipCode__c +' Unnormalized Addres '+ 
                                        add.Temp_Address__c ;
                concatenateAddressFields = concatenateAddressFields.replaceAll('null', '');
                accIdToAddressMap.put(add.Customer__c, concatenateAddressFields);
            }//end of address iteration.
        }//end of checking the size.
        
        for(Account acc : DedupAccountList){
            if(accIdToAddressMap.isEmpty() || !accIdToAddressMap.containsKey(acc.Id)){
                accIdToAddressMap.put(acc.Id, '');
            }
        }
        System.debug('Account id to address field map values are ---------------------------------------->'+accIdToAddressMap);
    }//end of constructing address map method.
    
}