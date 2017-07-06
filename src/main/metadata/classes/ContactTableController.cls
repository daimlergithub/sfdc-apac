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
    public String mbphoneNumber{get;set;}
    public String mbMobilepart1{get;set;}
    public String mbMobilepart2{get;set;}
    public String hmCountryCode{get;set;}
    public String hmphoneNumber{get;set;}
    public String hmPhonepart1{get;set;}
    public String hmPhonepart2{get;set;}
    public String wkCountryCode{get;set;}
    public String wkphoneNumber{get;set;}
    public String wkPhonepart1{get;set;}
    public String wkPhonepart2{get;set;}
    public String faxCountryCode{get;set;}
    public String faxphoneNumber{get;set;}
    
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
	public boolean editMode2 {get; set;}
   // public String MarketDescriminator= [Select Market__c From User Where Id =:UserInfo.getUserId()][0].Market__c;
    /**
    *@Description : Constructor.
    *@Date : 26/10/2015
    *@param:Apexpages Standard Controller (Account)
    *@return:This mehtod does not return any value.

    */ 
    Public boolean disableButtons{get;set;}
    public boolean firstsave{get;set;}
    public boolean secondsave{get;set;}  
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
        if(p.Name.contains('Dealer')){      
            disableButtons = true;          
        }
		 if(p.Name.contains('Japan')){
          editMode2 = false;
        
        }
        if(disableButtons == true){
             //editMode = true;
             editMode1 = true;
        }
       //Introduced for TH market      
         if(ParAcc.MD__c==Label.TH){  
            firstsave = true;  
            secondsave = false;
            mbCountryCode='+66';
            hmCountryCode='+66';
            wkCountryCode='+66';
            faxCountryCode='+66';
        }
        else
        {
            firstsave = false;  
            secondsave = true; 
        }
     }
     
    /**
    *@Description : This method makes editMode true which allows the user to input values to the phone numbers  and email fields.
    *@Date : 26/10/2015
    *@param: None
    *@return:This mehtod does not return any value.

    */
   
   /*CR20170523 public void PhoneNumberFormat(){
      
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
                   if(PaAcc.MD__c)
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
    CR20170523 */
    
    public void PhoneNumberFormat(){
      
        if(!(String.isBlank(ParAcc.Individual_Home_Phone__c)) && (ParAcc.MD__c=='KR')){
        
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

        if(!(String.isBlank(ParAcc.Work_Phone__c)) && (ParAcc.MD__c=='KR')){ 
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
        if(!(String.isBlank(ParAcc.Mobile__c)) && (ParAcc.MD__c=='KR')){ 
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
    *@CR#89 - Updated method for Phone number format for Thailand
    *@Date : 24/05/2017 
    */ 
    /*
   public void PhoneNumberFormatTH()
    {      
        if ((!String.IsBlank(ParAcc.Individual_Home_Phone__c)) &&  (ParAcc.Individual_Home_Phone__c.length()==11))
           {
                hmCountryCode=string.valueOf(ParAcc.Individual_Home_Phone__c).substring(0,3);      
                hmphoneNumber = string.valueOf(ParAcc.Individual_Home_Phone__c).substring(3,11);
                
           }else if((!String.IsBlank(ParAcc.Individual_Home_Phone__c)) &&  (ParAcc.Individual_Home_Phone__c.length()==14))
                {      
                  hmCountryCode=string.valueOf(ParAcc.Individual_Home_Phone__c).substring(0,4);     
                  hmphoneNumber = string.valueOf(ParAcc.Individual_Home_Phone__c).substring(4,14); 
               
                }           
        if ((!String.IsBlank(ParAcc.Work_Phone__c)) &&  (ParAcc.Work_Phone__c.length()==11))
      
           {
                wkCountryCode=string.valueOf(ParAcc.Work_Phone__c).substring(0,3);      
                wkphoneNumber = string.valueOf(ParAcc.Work_Phone__c).substring(3,11);
           }else if((!String.IsBlank(ParAcc.Work_Phone__c)) &&  (ParAcc.Work_Phone__c.length()==14))
                 {      
                  wkCountryCode=string.valueOf(ParAcc.Work_Phone__c).substring(0,4);     
                  wkphoneNumber = string.valueOf(ParAcc.Work_Phone__c).substring(4,14); 
                 }
            if ((!String.IsBlank(ParAcc.Mobile__c)) && (ParAcc.Mobile__c.length()==12) )
           {
                mbCountryCode=string.valueOf(ParAcc.Mobile__c).substring(0,3);      
                mbphoneNumber = string.valueOf(ParAcc.Mobile__c).substring(3,12);
           }else if((!String.IsBlank(ParAcc.Mobile__c)) && (ParAcc.Mobile__c.length()==14))
                {      
                  mbCountryCode=string.valueOf(ParAcc.Mobile__c).substring(0,4);     
                  mbphoneNumber = string.valueOf(ParAcc.Mobile__c).substring(4,14); 
                }
    }  
     */ 
     //Pavan start
    public void PhoneNumberFormatTH()
    {      
            string localhmPhone,localwkPhone,localMBPhone,localFaxPhone;
            localhmPhone=string.valueOf(ParAcc.Individual_Home_Phone__c);
             localwkPhone=string.valueOf(ParAcc.Work_Phone__c);
             localMBPhone=string.valueOf(ParAcc.Mobile__c);
              localFaxPhone=string.valueOf(ParAcc.fax);
            if ((!String.IsBlank(localhmPhone))&&(localhmPhone.length()>3))
            {
                hmCountryCode=localhmPhone.substring(0,3); 
                hmphoneNumber=localhmPhone.length()>3?localhmPhone.substring(3,localhmPhone.length()):hmCountryCode;
            }else
            {system.debug('im here');ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot save too short'));}
            if ((!String.IsBlank(localwkPhone))&& (localwkPhone.length()>3))
           {
               
                wkCountryCode=localwkPhone.substring(0,3);      
                wkphoneNumber=localwkPhone.length()>3?localwkPhone.substring(3,localwkPhone.length()):wkCountryCode;

           }
            if ((!String.IsBlank(localMBPhone)) && (localMBPhone.length()>3))
           {
                
                mbCountryCode=localMBPhone.substring(0,3);      
                mbphoneNumber=localMBPhone.length()>3?localMBPhone.substring(3,localMBPhone.length()):mbCountryCode;

           }
            if ((!String.IsBlank(localFaxPhone)) && (localFaxPhone.length()>3))
           {
                
                faxCountryCode=localFaxPhone.substring(0,3);      
                faxphoneNumber=localFaxPhone.length()>3?localFaxPhone.substring(3,localFaxPhone.length()):faxCountryCode;

           }
    }
     // pavan end
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
       (String.isBlank(hmphoneNumber)) && 
       (String.isBlank(hmCountryCode)) 
       )
       {
           ParAcc.Individual_Home_Phone__c='';
       } 
         else if(hmphoneNumber!='' && hmCountryCode!='')
      {     
        /*if(hmphoneNumber.startsWith('0'))
            hmphoneNumber=hmphoneNumber.removeStart('0');*/
               ParAcc.Individual_Home_Phone__c=hmCountryCode+hmphoneNumber;             
      }      
       else
       {
           ParAcc.Individual_Home_Phone__c='';
       }
       
      if
      (
      (String.isBlank(wkphoneNumber)) &&
      (String.isBlank(wkCountryCode)) 
      )
      {
               ParAcc.Work_Phone__c='';
      }
         else if(wkphoneNumber!='' && wkCountryCode!='')
      {     
        /*if(wkphoneNumber.startsWith('0'))
            wkphoneNumber=wkphoneNumber.removeStart('0');*/
             ParAcc.Work_Phone__c=wkCountryCode+wkphoneNumber;             
      }      
      else
      { 
             ParAcc.Work_Phone__c='';
      }
       
      if
      (
      (String.isBlank(mbphoneNumber)) &&
      (String.isBlank(mbCountryCode)) 
      )
      
      {              
               ParAcc.Mobile__c='';
      }
       else if(mbphoneNumber!='' && mbCountryCode!='')
      {     
        /*if(mbphoneNumber.startsWith('0'))
            mbphoneNumber=mbphoneNumber.removeStart('0');*/
               ParAcc.Mobile__c=mbCountryCode+mbphoneNumber;              
      }        
      else
      {             
             ParAcc.Mobile__c='';
      }
       if
      (
      (String.isBlank(faxphoneNumber)) &&
      (String.isBlank(faxCountryCode)) 
      )
      
      {              
               ParAcc.fax='';
      }
       else if(faxphoneNumber!='' && faxCountryCode!='')
      {     
      
               ParAcc.fax=faxCountryCode+faxphoneNumber;              
      }        
      else
      {             
             ParAcc.fax='';
      }
        try
        {
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