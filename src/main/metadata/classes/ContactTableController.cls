/*
    Type:      Extension Controller(Account) for VF page -ContactTable
    ---------------------------------------------------------------
    
    
    26-10-2015 Created by Narasimha Gundurao
    04-07-2017 Modified by Mohammed Touseef Ahmed
    History: added condition of market for phone number format
*/

public class ContactTableController 
{
    /* Variables Declaration */ 
    private ApexPages.StandardController stdController;
    public boolean editMode {get; set;} 
    public string AccId {get; set;}
    public Account ParAcc {get; set;}
    public boolean refreshPage {get; set;}
	public String mbCountryCode{get;set;}
    public String mbAreaCode{get;set;}
    public String mbMobilepart1{get;set;}
    public String mbMobilepart2{get;set;}
    public String hmCountryCode{get;set;}
    public String hmAreaCode{get;set;}
    public String hmPhonepart1{get;set;}
    public String hmPhonepart2{get;set;}
    public String wkCountryCode{get;set;}
    public String wkAreaCode{get;set;}
    public String wkPhonepart1{get;set;}
    public String wkPhonepart2{get;set;}
	
    public String homePhoneAreaCodePart1{get;set;}
    public String homePhoneAreaCodePart2{get;set;}
    public String homePhoneAreaCodePart3{get;set;}
    public String workPhoneAreaCodePart1{get;set;}
    public String workPhoneAreaCodePart2{get;set;}
    public String workPhoneAreaCodePart3{get;set;}
    public String mobilePhoneAreaCodePart1{get;set;}
    public String mobilePhoneAreaCodePart2{get;set;}
    public String mobilePhoneAreaCodePart3{get;set;}
    public AreaCodeTranslation__mdt areacodeKR ;
    Public Boolean profilename{get;set;}
    public boolean editMode1 {get; set;}
   // public String MarketDescriminator= [Select Market__c From User Where Id =:UserInfo.getUserId()][0].Market__c;
    /**
    *@Description : Constructor.
    *@Date : 26/10/2015
    *@param:Apexpages Standard Controller (Account)
    *@return:This mehtod does not return any value.

    */ 
    Public boolean disableButtons{get;set;}
     
    public  ContactTableController(ApexPages.StandardController stdController)
    {
        editMode = false;
        editMode1 = false;
        AccId = stdController.getId();
        if(!test.isRunningTest()){  
        stdController.addFields(new List<String> {'Id','Fax_Last_Modified_By__c','Work_Fax_Last_Modified_By__c','Fax_Last_Modified_Date__c','Fax2_Last_Modified_Date__c','Mobile__c','Mobile2__c','Individual_Home_Phone__c','Home_Phone_2__c','Work_Phone__c','Phone','Email__c','Email2__c','Email3__c','Fax2__c','Fax','Fax_Validity2__c','Fax_Validity__c','Email_Status__c','Email_Status_2__c','Work_Phone_Last_Modified_Date__c','Work_Phone_Last_Modified_Date2__c',
            'Email_Status_3__c','Work_Phone_Status__c','Work_Phone_Status_2__c','Individual_Home_Phone_Status__c', 'Home_Phone_Status_2__c' ,'Mobile_Status__c','SMS_MMS_IM_Status_2__c','Email_Last_Modified_By__c','Email_Last_Modified_By2__c','Email_Last_Modified_By3__c','Email_Last_Modified_Date__c','Email_Last_Modified_Date2__c',
           'Work_Phone_Last_Modified_By__c','Work_Phone_Last_Modified_By2__c','Home_Phone_Last_Modified_By__c','Home_Phone_Last_Modified_By2__c','SMS_Last_Modified_By__c','SMS_Last_Modified_By2__c','SMS_Last_Modified_Date__c','SMS_Last_Modified_Date2__c','Home_Phone_Last_Modified_Date__c','Home_Phone_Last_Modified_Date2__c','Email_Last_Modified_Date3__c','MD__c'});
             
            } 
        ParAcc = (Account)stdController.getRecord(); 
        /*
        profilename = FALSE;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        if(usrProfileName.contains('Dealer')){
            profilename = TRUE;
        }
        */
        profile p = [select Name from profile where id =:userinfo.getprofileId()];
        disableButtons = true;
        system.debug('p.Name :'+p.Name);
        if(p.Name.contains('Dealer')){
            system.debug('Test 123');            
            disableButtons = true;          
        }
        if(disableButtons == true){
             //editMode = true;
             editMode1 = true;
        }
       
     }
     
    
    /**
    *@Description : This method makes editMode true which allows the user to input values to the phone numbers  and email fields.
    *@Date : 26/10/2015
    *@param: None
    *@return:This mehtod does not return any value.

    */ 
    public void PhoneNumberFormat(){
      
        if(!(String.isBlank(ParAcc.Individual_Home_Phone__c)) && (ParAcc.MD__c=='KR' || ParAcc.MD__c==Label.TH)){
          if(!ParAcc.Individual_Home_Phone__c.contains('-')){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.label.Insufficient_privilege));
          }
          else{
              String[] resultshomePhoneAreaCode= ParAcc.Individual_Home_Phone__c.split('-');
            if(resultshomePhoneAreaCode.size() < 3)
            {
              homePhoneAreaCodePart1='';
              homePhoneAreaCodePart2=resultshomePhoneAreaCode[0];
              homePhoneAreaCodePart3=resultshomePhoneAreaCode[1]; 
            }
            else
            {
                homePhoneAreaCodePart1=resultshomePhoneAreaCode[0];
                homePhoneAreaCodePart2=resultshomePhoneAreaCode[1];
                homePhoneAreaCodePart3=resultshomePhoneAreaCode[2]; 
            }
          }              
        }

        if(!(String.isBlank(ParAcc.Work_Phone__c)) && (ParAcc.MD__c=='KR' || ParAcc.MD__c==Label.TH)){ 
            if(!ParAcc.Work_Phone__c.contains('-')){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.label.Insufficient_privilege));
            }
            else{
                String[] resultsworkPhoneAreaCode= ParAcc.Work_Phone__c.split('-'); 
                if(resultsworkPhoneAreaCode.size() < 3)
                {   
                    workPhoneAreaCodePart1= '';
                    workPhoneAreaCodePart2=resultsworkPhoneAreaCode[0];
                    workPhoneAreaCodePart3=resultsworkPhoneAreaCode[1];
                }
                else
                {
                    workPhoneAreaCodePart1=resultsworkPhoneAreaCode[0];
                    workPhoneAreaCodePart2=resultsworkPhoneAreaCode[1];
                    workPhoneAreaCodePart3=resultsworkPhoneAreaCode[2]; 
                }
            }
        } 
        if(!(String.isBlank(ParAcc.Mobile__c)) && (ParAcc.MD__c=='KR' || ParAcc.MD__c==Label.TH)){ 
            if(!ParAcc.Mobile__c.contains('-')){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.label.Insufficient_privilege));
            }
            else{
                String[] resultsMobilePhoneAreaCode= ParAcc.Mobile__c.split('-');  
                if(resultsMobilePhoneAreaCode.size() < 3)
                {
                    mobilePhoneAreaCodePart1='';
                    mobilePhoneAreaCodePart2=resultsMobilePhoneAreaCode[0];
                    mobilePhoneAreaCodePart3=resultsMobilePhoneAreaCode[1]; 
                }
                else
                {
                    mobilePhoneAreaCodePart1=resultsMobilePhoneAreaCode[0];
                    mobilePhoneAreaCodePart2=resultsMobilePhoneAreaCode[1];
                    mobilePhoneAreaCodePart3=resultsMobilePhoneAreaCode[2];    
                } 
            }
        } 
    }
	
	/**
    *@Description : This method makes editMode true which allows the user to input values to the phone numbers  and email fields for Thailand market only.
    *@Date : 05/04/2017
    *@param: None
    *@return:This mehtod does not return any value.

    */ 
    public void PhoneNumberFormatTH()
    {      
        if(!(String.isBlank(ParAcc.Individual_Home_Phone__c)))
        {         
              String[] resultshomePhoneAreaCode= ParAcc.Individual_Home_Phone__c.split('-');
              if(resultshomePhoneAreaCode.size()>1)
              {
                hmCountryCode=resultshomePhoneAreaCode[0];              
                hmAreaCode=resultshomePhoneAreaCode[1];
                hmPhonepart1=resultshomePhoneAreaCode[2];
                hmPhonepart2=resultshomePhoneAreaCode[3]; 
              }         
        }
         else
                hmCountryCode='+66';

        if(!(String.isBlank(ParAcc.Work_Phone__c)))
        { 
            
                String[] resultsworkPhoneAreaCode= ParAcc.Work_Phone__c.split('-'); 
                 if(resultsworkPhoneAreaCode.size()>1)
              { 
                    wkCountryCode=resultsworkPhoneAreaCode[0];              
                    wkAreaCode=resultsworkPhoneAreaCode[1];
                    wkPhonepart1=resultsworkPhoneAreaCode[2];
                    wkPhonepart2=resultsworkPhoneAreaCode[3]; 
              }
                             
            
        } 
        else
                wkCountryCode='+66'; 
                
        if(!(String.isBlank(ParAcc.Mobile__c)))
        {            
                String[] resultsMobilePhoneAreaCode= ParAcc.Mobile__c.split('-');  
                 if(resultsMobilePhoneAreaCode.size()>1)
                {   
                    mbCountryCode=resultsMobilePhoneAreaCode[0];
                    mbAreaCode=resultsMobilePhoneAreaCode[1];                                        
                    mbMobilepart1=resultsMobilePhoneAreaCode[2];
                    mbMobilepart2=resultsMobilePhoneAreaCode[3];                
                }               
        }
        else
            mbCountryCode='+66';
         
    }
	
    public void EditAccount()    
    {
        editMode = true; 
        editMode1 = true;
        if(ParAcc.MD__c == 'KR'){
            PhoneNumberFormat();
        }
        else if (ParAcc.MD__c==Label.TH)
        {
            PhoneNumberFormatTH();
        }
    }
    
    public void UpdateAccountTH()  
    {
       
       if
       (
       (String.isBlank(hmAreaCode)) && 
       (String.isBlank(hmCountryCode)) &&
       (String.isBlank(hmPhonepart1)) &&
       (String.isBlank(hmPhonepart2))
       )
       {
        system.debug('***');
           ParAcc.Individual_Home_Phone__c='';
       } 
        else if(hmAreaCode!='' && hmCountryCode!='' && hmPhonepart1!='' &&  hmPhonepart2!='')
      {     
        if(hmAreaCode.startsWith('0'))
            hmAreaCode=hmAreaCode.removeStart('0');
               ParAcc.Individual_Home_Phone__c=hmCountryCode+'-'+hmAreaCode+'-'+hmPhonepart1+'-'+hmPhonepart2;             
      }      
       else
       {
       system.debug('***');
           ParAcc.Individual_Home_Phone__c='';
       }
       
      if
      (
      (String.isBlank(wkAreaCode)) &&
      (String.isBlank(wkCountryCode)) && 
      (String.isBlank(wkPhonepart1)) && 
      (String.isBlank(wkPhonepart2))
      )
      {
               ParAcc.Work_Phone__c='';
      }
       else if(wkAreaCode!='' && wkCountryCode!='' && wkPhonepart1!='' &&  wkPhonepart2!='')
      {     
        if(wkAreaCode.startsWith('0'))
            wkAreaCode=wkAreaCode.removeStart('0');
               ParAcc.Work_Phone__c=wkCountryCode+'-'+wkAreaCode+'-'+wkPhonepart1+'-'+wkPhonepart2;            
      }      
      else
      { 
             ParAcc.Work_Phone__c='';
      }
       
      if
      (
      (String.isBlank(mbAreaCode)) &&
      (String.isBlank(mbCountryCode)) && 
      (String.isBlank(mbMobilepart1)) &&
      (String.isBlank(mbMobilepart2))
      )
      
      {              
               ParAcc.Mobile__c='';
      }
      else if(mbAreaCode!='' && mbCountryCode!='' && mbMobilepart1!='' &&  mbMobilepart2!='')
      {     
        if(mbAreaCode.startsWith('0'))
            mbAreaCode=mbAreaCode.removeStart('0');
               ParAcc.Mobile__c=mbCountryCode+'-'+mbAreaCode+'-'+mbMobilepart1+'-'+mbMobilepart2;              
      }        
      else
      {             
             ParAcc.Mobile__c='';
      }
      
        try
        {
             system.debug('***'+ParAcc.Individual_Home_Phone__c);
        system.debug('***'+ParAcc.Mobile__c);
        system.debug('***'+ParAcc.Work_Phone__c);
         system.debug('***'+ParAcc.Email__c);
            if
            (
            ParAcc.Individual_Home_Phone__c == '' && 
            ParAcc.Mobile__c == '' && 
            ParAcc.Work_Phone__c == '' && 
            ParAcc.Email__c == null
            )
            {
                        
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.contact_information));
            } 
            else
            {  
                    
                    if(ParAcc != null)
                        refreshPage = true;
                      
                        update ParAcc;
            }            
        }
        
        catch(DMLException de)
        {
            refreshPage = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,de.getDmlMessage(0)));
            
        }
    }
    
    /**
    *@Description : This method updates the Account with the values entered by user to phone number and email fields.
    *@Date : 26/10/2015
    *@param: None
    *@return:This mehtod does not return any value.

    */ 
    
    public void UpdateAccount()  
    {
     if(ParAcc != null && ParAcc.Md__c =='KR' )

            {
       if((String.isBlank(homePhoneAreaCodePart1)) && (String.isBlank(homePhoneAreaCodePart2)) && (String.isBlank(homePhoneAreaCodePart3)))
       {
           ParAcc.Individual_Home_Phone__c='';
       } 
       else if((!(String.isBlank(homePhoneAreaCodePart1)) || (String.isBlank(homePhoneAreaCodePart1))) && (!(String.isBlank(homePhoneAreaCodePart2)) || (String.isBlank(homePhoneAreaCodePart2))) && (!(String.isBlank(homePhoneAreaCodePart3)) || (String.isBlank(homePhoneAreaCodePart3))))
       {
           ParAcc.Individual_Home_Phone__c= homePhoneAreaCodePart1+'-'+homePhoneAreaCodePart2+'-'+homePhoneAreaCodePart3;
           if(ParAcc.Individual_Home_Phone__c.startsWith(' -'))
            {
                ParAcc.Individual_Home_Phone__c = ParAcc.Individual_Home_Phone__c.removeStart(' -');
            }
       }
        else
         {
           ParAcc.Individual_Home_Phone__c='';
         }
       
      if((String.isBlank(workPhoneAreaCodePart1)) && (String.isBlank(workPhoneAreaCodePart2)) && (String.isBlank(workPhoneAreaCodePart3)))
      {
               ParAcc.Work_Phone__c='';
      }
      else if((String.isBlank(workPhoneAreaCodePart1) || !(String.isBlank(workPhoneAreaCodePart1))) && (String.isBlank(workPhoneAreaCodePart2) || !(String.isBlank(workPhoneAreaCodePart2))) && (String.isBlank(workPhoneAreaCodePart3) || !(String.isBlank(workPhoneAreaCodePart3))))
      {
               ParAcc.Work_Phone__c= workPhoneAreaCodePart1+'-'+workPhoneAreaCodePart2+'-'+workPhoneAreaCodePart3;
               if(ParAcc.Work_Phone__c.startsWith(' -'))
                {
                    ParAcc.Work_Phone__c = ParAcc.Work_Phone__c.removeStart(' -');
                }
      }
        else
        { 
             ParAcc.Work_Phone__c='';
        }
        if((String.isBlank(mobilePhoneAreaCodePart1)) && (String.isBlank(mobilePhoneAreaCodePart2)) && (String.isBlank(mobilePhoneAreaCodePart3)))
      {
               ParAcc.Mobile__c='';
      }
      else if((!(String.isBlank(mobilePhoneAreaCodePart1)) || (String.isBlank(mobilePhoneAreaCodePart1))) && (!(String.isBlank(mobilePhoneAreaCodePart2)) || (String.isBlank(mobilePhoneAreaCodePart2))) && (!(String.isBlank(mobilePhoneAreaCodePart3)) || (String.isBlank(mobilePhoneAreaCodePart3))))
      {
               ParAcc.Mobile__c=mobilePhoneAreaCodePart1+'-'+mobilePhoneAreaCodePart2+'-'+mobilePhoneAreaCodePart3;
               if(ParAcc.Mobile__c.startsWith(' -'))
                {
                    ParAcc.Mobile__c = ParAcc.Mobile__c.removeStart(' -');
                }
      }
        else
        { 
             ParAcc.Mobile__c='';
        }
      }
      else if(ParAcc != null && ParAcc.Md__c =='TH')
      {
        UpdateAccountTH();
      }

        try
        {
            if(ParAcc != null)
            {
                refreshPage = true;
                update ParAcc;         
                }   
                
        }
        
        catch(DMLException de)
        {
            refreshPage = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,de.getDmlMessage(0)));
            
        }
    }
    /**
    *@Description : This method gets all the Areacode of Home Phone and Work Phone.
    *@Date : 26/10/2015
    *@param: None
    *@return:This mehtod returns list of Areacode.

    */   
    public List<SelectOption> getAreacodeItems() {
      
            AreaCodeTranslation__mdt  areacodeTH=new AreaCodeTranslation__mdt();
            List<SelectOption> options = new List<SelectOption>();
            User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
            if(u.Market__c=='KR')
            {      
                areacodeKR = [SELECT Id,Phone_EN1__c,Phone_TR1__c,Phone_EN2__c,Phone_TR2__c,Phone_EN3__c,Phone_TR3__c ,Phone_EN4__c,Phone_TR4__c,Phone_EN5__c,Phone_TR5__c,Phone_EN6__c,Phone_TR6__c,Phone_EN7__c,Phone_TR7__c,
           Phone_EN8__c,Phone_TR8__c,Phone_EN9__c,Phone_TR9__c,Phone_EN10__c,Phone_TR10__c,Phone_EN11__c,Phone_TR11__c,Phone_EN12__c,Phone_TR12__c,Phone_EN13__c,Phone_TR13__c,Phone_EN14__c,Phone_TR14__c,
           Phone_EN15__c,Phone_TR15__c,Phone_EN16__c,Phone_TR16__c,Phone_EN17__c,Phone_TR17__c,Phone_EN18__c,Phone_EN19__c,Mobile_Code1__c,Mobile_Code2__c
            FROM AreaCodeTranslation__mdt WHERE MD__c  = 'KR' LIMIT 1];
                  
                Map<String,String> phoneAreaCodeMapKR = new Map<String,String>();
                phoneAreaCodeMapKR.put(' ',System.label.None);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN1__c,areacodeKR.Phone_EN1__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN2__c,areacodeKR.Phone_EN2__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN3__c,areacodeKR.Phone_EN3__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN4__c,areacodeKR.Phone_EN4__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN5__c,areacodeKR.Phone_EN5__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN6__c,areacodeKR.Phone_EN6__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN7__c,areacodeKR.Phone_EN7__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN8__c,areacodeKR.Phone_EN8__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN9__c,areacodeKR.Phone_EN9__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN10__c,areacodeKR.Phone_EN10__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN11__c,areacodeKR.Phone_EN11__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN12__c,areacodeKR.Phone_EN12__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN13__c,areacodeKR.Phone_EN13__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN14__c,areacodeKR.Phone_EN14__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN15__c,areacodeKR.Phone_EN15__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN16__c,areacodeKR.Phone_EN16__c);
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN17__c,areacodeKR.Phone_EN17__c); 
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN18__c,areacodeKR.Phone_EN18__c); 
                phoneAreaCodeMapKR.put(areacodeKR.Phone_EN19__c,areacodeKR.Phone_EN19__c); 
                phoneAreaCodeMapKR.put(areacodeKR.Mobile_Code1__c,areacodeKR.Mobile_Code1__c); 
                phoneAreaCodeMapKR.put(areacodeKR.Mobile_Code2__c,areacodeKR.Mobile_Code2__c); 

                          
                options.add(new SelectOption(' ',System.label.None));              
                options.add(new SelectOption( areacodeKR.Phone_EN1__c,areacodeKR.Phone_EN1__c+'      '+areacodeKR.Phone_TR1__c));
                options.add(new SelectOption( areacodeKR.Phone_EN2__c,areacodeKR.Phone_EN2__c+'       '+areacodeKR.Phone_TR2__c));
                options.add(new SelectOption( areacodeKR.Phone_EN3__c,areacodeKR.Phone_EN3__c+'       '+areacodeKR.Phone_TR3__c));
                options.add(new SelectOption( areacodeKR.Phone_EN4__c,areacodeKR.Phone_EN4__c+'       '+areacodeKR.Phone_TR4__c));
                options.add(new SelectOption( areacodeKR.Phone_EN5__c,areacodeKR.Phone_EN5__c+'       '+areacodeKR.Phone_TR5__c));
                options.add(new SelectOption( areacodeKR.Phone_EN6__c,areacodeKR.Phone_EN6__c+'       '+areacodeKR.Phone_TR6__c));
                options.add(new SelectOption( areacodeKR.Phone_EN7__c, areacodeKR.Phone_EN7__c+'        '+areacodeKR.Phone_TR7__c));
                options.add(new SelectOption( areacodeKR.Phone_EN8__c,areacodeKR.Phone_EN8__c+'       '+areacodeKR.Phone_TR8__c));
                options.add(new SelectOption( areacodeKR.Phone_EN9__c,areacodeKR.Phone_EN9__c+'        '+areacodeKR.Phone_TR9__c ));   
                options.add(new SelectOption( areacodeKR.Phone_EN10__c,areacodeKR.Phone_EN10__c+'       '+areacodeKR.Phone_TR10__c));
                options.add(new SelectOption( areacodeKR.Phone_EN11__c,areacodeKR.Phone_EN11__c+'       '+areacodeKR.Phone_TR11__c));
                options.add(new SelectOption( areacodeKR.Phone_EN12__c,areacodeKR.Phone_EN12__c+'       '+areacodeKR.Phone_TR12__c));
                options.add(new SelectOption( areacodeKR.Phone_EN13__c,areacodeKR.Phone_EN13__c+'       '+areacodeKR.Phone_TR13__c)); 
                options.add(new SelectOption( areacodeKR.Phone_EN14__c,areacodeKR.Phone_EN14__c+'       '+areacodeKR.Phone_TR14__c));
                options.add(new SelectOption( areacodeKR.Phone_EN15__c,areacodeKR.Phone_EN15__c+'       '+areacodeKR.Phone_TR15__c));
                options.add(new SelectOption( areacodeKR.Phone_EN16__c,areacodeKR.Phone_EN16__c+'       '+areacodeKR.Phone_TR16__c));
                options.add(new SelectOption( areacodeKR.Phone_EN17__c,areacodeKR.Phone_EN17__c+'       '+areacodeKR.Phone_TR17__c ));
                options.add(new SelectOption( areacodeKR.Mobile_Code1__c,areacodeKR.Mobile_Code1__c));
                options.add(new SelectOption( areacodeKR.Mobile_Code2__c,areacodeKR.Mobile_Code2__c));
                options.add(new SelectOption( areacodeKR.Phone_EN18__c,areacodeKR.Phone_EN18__c));
                options.add(new SelectOption( areacodeKR.Phone_EN19__c,areacodeKR.Phone_EN19__c));                
                if(!(String.isBlank(homePhoneAreaCodePart1)) && !phoneAreaCodeMapKR.containsKey(homePhoneAreaCodePart1)){
                    options.add(new SelectOption( homePhoneAreaCodePart1,homePhoneAreaCodePart1));
                }
                if(!(String.isBlank(workPhoneAreaCodePart1)) && !phoneAreaCodeMapKR.containsKey(workPhoneAreaCodePart1)){
                    options.add(new SelectOption( workPhoneAreaCodePart1,workPhoneAreaCodePart1));
                }  
            }
            else if(u.Market__c==Label.TH)
            {
                areacodeTH = [SELECT Id,Phone_EN1__c,Phone_TR1__c,Phone_EN2__c,Phone_TR2__c,Phone_EN3__c,Phone_TR3__c ,
                Phone_EN4__c,Phone_TR4__c,Phone_EN5__c,Phone_TR5__c,Phone_EN6__c,Phone_TR6__c,Phone_EN7__c,Phone_TR7__c,
                 Phone_EN8__c,Phone_TR8__c,Phone_EN9__c,Phone_TR9__c,Phone_EN10__c,Phone_TR10__c,Phone_EN11__c,
                 Phone_TR11__c,Phone_EN12__c,Phone_TR12__c,Phone_EN13__c,Phone_TR13__c,Phone_EN14__c,Phone_TR14__c, 
                  Phone_EN15__c,Phone_TR15__c,Phone_EN16__c,Phone_TR16__c,Phone_EN17__c,Phone_TR17__c,Phone_EN18__c,
                  Phone_EN19__c,Phone_EN20__c,Phone_EN21__c,Mobile_Code1__c,Mobile_Code2__c
                FROM AreaCodeTranslation__mdt WHERE MD__c  = 'TH' LIMIT 1];
            
            
                Map<String,String> phoneAreaCodeMapTH = new Map<String,String>();
                phoneAreaCodeMapTH.put(' ',System.label.None);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN1__c,areacodeTH.Phone_EN1__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN2__c,areacodeTH.Phone_EN2__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN3__c,areacodeTH.Phone_EN3__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN4__c,areacodeTH.Phone_EN4__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN5__c,areacodeTH.Phone_EN5__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN6__c,areacodeTH.Phone_EN6__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN7__c,areacodeTH.Phone_EN7__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN8__c,areacodeTH.Phone_EN8__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN9__c,areacodeTH.Phone_EN9__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN10__c,areacodeTH.Phone_EN10__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN11__c,areacodeTH.Phone_EN11__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN12__c,areacodeTH.Phone_EN12__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN13__c,areacodeTH.Phone_EN13__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN14__c,areacodeTH.Phone_EN14__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN15__c,areacodeTH.Phone_EN15__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN16__c,areacodeTH.Phone_EN16__c);
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN17__c,areacodeTH.Phone_EN17__c); 
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN18__c,areacodeTH.Phone_EN18__c); 
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN19__c,areacodeTH.Phone_EN19__c); 
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN20__c,areacodeTH.Phone_EN20__c); 
                phoneAreaCodeMapTH.put(areacodeTH.Phone_EN21__c,areacodeTH.Phone_EN21__c); 
             
                       
            
                options.add(new SelectOption(' ',System.label.None));
                options.add(new SelectOption( areacodeTH.Phone_EN1__c,areacodeTH.Phone_EN1__c));        
                options.add(new SelectOption( areacodeTH.Phone_EN9__c,areacodeTH.Phone_EN9__c));  
                options.add(new SelectOption( areacodeTH.Phone_EN4__c,areacodeTH.Phone_EN4__c)); 
                options.add(new SelectOption( areacodeTH.Phone_EN10__c,areacodeTH.Phone_EN10__c));
                options.add(new SelectOption( areacodeTH.Phone_EN12__c,areacodeTH.Phone_EN12__c));
                options.add(new SelectOption( areacodeTH.Phone_EN6__c,areacodeTH.Phone_EN6__c));
                options.add(new SelectOption( areacodeTH.Phone_EN11__c,areacodeTH.Phone_EN11__c)); 
                options.add(new SelectOption( areacodeTH.Phone_EN8__c,areacodeTH.Phone_EN8__c));  
                options.add(new SelectOption( areacodeTH.Phone_EN18__c,areacodeTH.Phone_EN18__c));              
                options.add(new SelectOption( areacodeTH.Phone_EN2__c,areacodeTH.Phone_EN2__c));
                options.add(new SelectOption( areacodeTH.Phone_EN7__c, areacodeTH.Phone_EN7__c));
                options.add(new SelectOption( areacodeTH.Phone_EN3__c,areacodeTH.Phone_EN3__c));
                options.add(new SelectOption( areacodeTH.Phone_EN15__c,areacodeTH.Phone_EN15__c));
                options.add(new SelectOption( areacodeTH.Phone_EN16__c,areacodeTH.Phone_EN16__c));
                options.add(new SelectOption( areacodeTH.Phone_EN14__c,areacodeTH.Phone_EN14__c));                
                options.add(new SelectOption( areacodeTH.Phone_EN5__c,areacodeTH.Phone_EN5__c));
                options.add(new SelectOption( areacodeTH.Phone_EN13__c,areacodeTH.Phone_EN13__c));
                options.add(new SelectOption( areacodeTH.Phone_EN17__c,areacodeTH.Phone_EN17__c));
                options.add(new SelectOption( areacodeTH.Phone_EN19__c,areacodeTH.Phone_EN19__c));    
                 options.add(new SelectOption( areacodeTH.Phone_EN19__c,areacodeTH.Phone_EN20__c));  
                 options.add(new SelectOption( areacodeTH.Phone_EN19__c,areacodeTH.Phone_EN21__c));   
           
                if(!(String.isBlank(homePhoneAreaCodePart1)) && !phoneAreaCodeMapTH.containsKey(homePhoneAreaCodePart1)){
                    options.add(new SelectOption( homePhoneAreaCodePart1,homePhoneAreaCodePart1));
                }
                if(!(String.isBlank(workPhoneAreaCodePart1)) && !phoneAreaCodeMapTH.containsKey(workPhoneAreaCodePart1)){
                    options.add(new SelectOption( workPhoneAreaCodePart1,workPhoneAreaCodePart1));
                }  
            }
                return options; 
        } 
    /**
    *@Description : This method gets the Mobile code.
    *@Date : 26/10/2015
    *@param: None
    *@return:This mehtod does return Mobile Codes.
    */     
    public List<SelectOption> getMobileAreacodeItems() {
        User u = [SELECT Id,Market__c FROM User WHERE Id=:UserInfo.getUserId()] ;
        AreaCodeTranslation__mdt  mobileAreaCodeKR=new AreaCodeTranslation__mdt();
        AreaCodeTranslation__mdt  mobileAreaCodeTH=new AreaCodeTranslation__mdt();
         List<selectOption> options = new List<selectOption>();
        if(u.Market__c==Label.KR)
        {
          mobileAreaCodeKR = [SELECT Id,Mobile_Code1__c,Mobile_Code2__c,Mobile_Code3__c,Mobile_Code4__c,Mobile_Code5__c,Mobile_Code6__c,Mobile_Code7__c FROM AreaCodeTranslation__mdt WHERE MD__c  = 'KR' LIMIT 1]; 
          options.add(new SelectOption(' ',System.label.None));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code1__c,mobileAreaCodeKR.Mobile_Code1__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code2__c,mobileAreaCodeKR.Mobile_Code2__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code3__c,mobileAreaCodeKR.Mobile_Code3__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code4__c,mobileAreaCodeKR.Mobile_Code4__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code5__c,mobileAreaCodeKR.Mobile_Code5__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code6__c,mobileAreaCodeKR.Mobile_Code6__c));
           options.add(new SelectOption(mobileAreaCodeKR.Mobile_Code7__c,mobileAreaCodeKR.Mobile_Code7__c));  
        }
        else if(u.Market__c==Label.TH)
        {
            mobileAreaCodeTH = [SELECT Id,Mobile_Code1__c,Mobile_Code2__c,Mobile_Code3__c,Mobile_Code4__c,Mobile_Code5__c,Mobile_Code6__c,Mobile_Code7__c,
                                Mobile_Code8__c,Mobile_Code9__c,Mobile_Code10__c,Mobile_Code11__c,Mobile_Code12__c,Mobile_Code13__c,Mobile_Code14__c,Mobile_Code15__c,
                                Mobile_Code16__c,Mobile_Code17__c,Mobile_Code18__c,Mobile_Code19__c,Mobile_Code20__c,Mobile_Code21__c,Mobile_Code22__c,Mobile_Code23__c,Mobile_Code24__c,
                                Mobile_Code25__c FROM AreaCodeTranslation__mdt WHERE MD__c  = 'TH' LIMIT 1]; 
            options.add(new SelectOption(' ',System.label.None));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code1__c,mobileAreaCodeTH.Mobile_Code1__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code2__c,mobileAreaCodeTH.Mobile_Code2__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code3__c,mobileAreaCodeTH.Mobile_Code3__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code4__c,mobileAreaCodeTH.Mobile_Code4__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code5__c,mobileAreaCodeTH.Mobile_Code5__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code6__c,mobileAreaCodeTH.Mobile_Code6__c));
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code7__c,mobileAreaCodeTH.Mobile_Code7__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code8__c,mobileAreaCodeTH.Mobile_Code8__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code9__c,mobileAreaCodeTH.Mobile_Code9__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code10__c,mobileAreaCodeTH.Mobile_Code10__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code11__c,mobileAreaCodeTH.Mobile_Code11__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code12__c,mobileAreaCodeTH.Mobile_Code12__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code13__c,mobileAreaCodeTH.Mobile_Code13__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code14__c,mobileAreaCodeTH.Mobile_Code14__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code15__c,mobileAreaCodeTH.Mobile_Code15__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code16__c,mobileAreaCodeTH.Mobile_Code16__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code17__c,mobileAreaCodeTH.Mobile_Code17__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code18__c,mobileAreaCodeTH.Mobile_Code18__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code19__c,mobileAreaCodeTH.Mobile_Code19__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code20__c,mobileAreaCodeTH.Mobile_Code20__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code21__c,mobileAreaCodeTH.Mobile_Code21__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code22__c,mobileAreaCodeTH.Mobile_Code22__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code23__c,mobileAreaCodeTH.Mobile_Code23__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code24__c,mobileAreaCodeTH.Mobile_Code24__c));  
           options.add(new SelectOption(mobileAreaCodeTH.Mobile_Code25__c,mobileAreaCodeTH.Mobile_Code25__c));  
           
        }           
           return options;
    }
  /**
  *@Description : This method Makes Edit mode false.
  *@Date : 26/10/2015
  *@param: None
  *@return:This mehtod does not return any value.
  */
    public PageReference CancelUpdate()
    {
        editMode = false; 
        editMode1 = false;
        PageReference page = new PageReference('/apex/ContactTable?Id='+ParAcc.Id);
        page.setRedirect(true);
        return page;
    }    
}