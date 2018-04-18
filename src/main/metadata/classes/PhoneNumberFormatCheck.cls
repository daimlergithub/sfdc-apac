/**
** Class: PhoneNumberFormatCheck
** Description: Class to check phone number format. Code added for India Track.
** Created By: Shashi Goswami
** Date: 2018/03/06
**/

public Class PhoneNumberFormatCheck{
    //India
    //Home Phone
    Integer digitsPhoneNumber ;
    String areaCodeCheck = '^[1-9]{1}[0-9]{1,3}$';
    String phoneCheck = '^[1-9]{1}[0-9]{5,7}$';
    String mobileCheck = '^[1-9]{1}[0-9]{9}$';
    public boolean homePhoneFieldFormatIN(String hmCountryCode, String hmAreaCode, String hmphoneNumber){
        if(hmCountryCode =='' && (hmAreaCode != '' || hmphoneNumber != '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Home_Phone_Format));
            return false;
        }
        else if(hmCountryCode!='' && (hmCountryCode==label.INPhoneCountryCode)){
            //Area code & Phone number validation
            if((hmAreaCode != '' && hmphoneNumber == '') || (hmAreaCode == '' && hmphoneNumber != '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Home_Phone_Format));
                return false;
            }
            else if(hmAreaCode != '' && hmphoneNumber != ''){
                if(!(Pattern.matches(areaCodeCheck, hmAreaCode) && Pattern.matches(phoneCheck, hmphoneNumber) && Pattern.matches(mobileCheck, hmAreaCode+hmphoneNumber))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Home_Phone_Format));
                    return false;
                }
            }
            
        }
        else if(hmCountryCode!='' && (hmCountryCode!=label.INPhoneCountryCode) && hmphoneNumber != null && !String.isBlank(hmphoneNumber)){
            try{
                digitsPhoneNumber = Integer.valueOf(hmphoneNumber);
            }
            catch(exception e){
                
            }
            if(!hmphoneNumber.isNumeric()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Home_Phone_Number_allows_digits_only));
                return false;
            }
        }
        return true;
    }
    //Work Phone
    public boolean workPhoneFieldFormatIN(String wkCountryCode, String wkAreaCode, String wkphoneNumber){
        if(wkCountryCode =='' && (wkAreaCode != '' || wkphoneNumber != '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Work_Phone_Format));
            return false;
        }
        else if(wkCountryCode!='' && (wkCountryCode==label.INPhoneCountryCode)){
            //Area code & Phone number validation
            if((wkAreaCode != '' && wkphoneNumber == '') || (wkAreaCode == '' && wkphoneNumber != '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Work_Phone_Format));
                return false;
            }
            else if(wkAreaCode != '' && wkphoneNumber != ''){
                if(!(Pattern.matches(areaCodeCheck, wkAreaCode) && Pattern.matches(phoneCheck, wkphoneNumber) && Pattern.matches(mobileCheck, wkAreaCode+wkphoneNumber))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Work_Phone_Format));
                    return false;
                }
            }
            
        }
        else if(wkCountryCode!='' && (wkCountryCode!=label.INPhoneCountryCode) && wkphoneNumber != null && !String.isBlank(wkphoneNumber)){
            if(!wkphoneNumber.isNumeric()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Work_Phone_Number_allows_digits_only));
                return false;
            }
        }
        return true;
    }
    //Fax
    public boolean faxFieldFormatIN(String faxCountryCode, String faxAreaCode, String faxphoneNumber){
        if(faxCountryCode =='' && (faxAreaCode != '' || faxphoneNumber != '')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Fax_Format));
            return false;
        }
        else if(faxCountryCode!='' && (faxCountryCode==label.INPhoneCountryCode)){
            //Area code & Fax number validation
            if((faxAreaCode != '' && faxphoneNumber == '') || (faxAreaCode == '' && faxphoneNumber != '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Fax_Format));
                return false;
            }
            else if(faxAreaCode != '' && faxphoneNumber != ''){
                if(!(Pattern.matches(areaCodeCheck, faxAreaCode) && Pattern.matches(phoneCheck, faxphoneNumber) && Pattern.matches(mobileCheck, faxAreaCode+faxphoneNumber))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Fax_Format));
                    return false;
                }
            }
            
        }
        else if(faxCountryCode!='' && (faxCountryCode!=label.INPhoneCountryCode) && faxphoneNumber != null && !String.isBlank(faxphoneNumber)){
            if(!faxphoneNumber.isNumeric()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Fax_allows_digits_only));
                return false;
            }
        }
        return true;
    }
    //Mobile Phone
    public boolean mobilePhoneFieldFormatIN(String mbCountryCode, String mbphoneNumber){
        if(mbCountryCode =='' && mbphoneNumber != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Mobile_Phone_Format));
            return false;
        }
        else if(mbCountryCode!='' && mbCountryCode!=label.INPhoneCountryCode && mbphoneNumber != null && !String.isBlank(mbphoneNumber)){
            if(!mbphoneNumber.isNumeric()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Mobile_Number_allows_digits_only));
                return false;
            }
        }
        else if(mbCountryCode!='' && (mbCountryCode==label.INPhoneCountryCode) && mbphoneNumber != ''){
            //Phone number validation
            if(!Pattern.matches(mobileCheck, mbphoneNumber)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Mobile_Phone_Format));
                return false;
            }
        }
        
        return true;
    }

    //Check phone format in Contact Table of account detail page
    public boolean detailPagePhoneFormat(String phoneNumber){
        if(phoneNumber != '' && !String.isBlank(phoneNumber) && !phoneNumber.startsWith('+')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Phone_Number_Starts_With_Sign));
            return false;
        }
        else if(phoneNumber != '' && !String.isBlank(phoneNumber) && phoneNumber.length()>3 && phoneNumber.startsWith('+91')){
            phoneNumber = phoneNumber.substring(3,phoneNumber.length());
            if(phoneNumber != '' && !String.isBlank(phoneNumber) && !Pattern.matches(mobileCheck, phoneNumber)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Contact_Format_First_Digit_NonZero));
                return false;
            }
        }
        else if(phoneNumber != '' && !String.isBlank(phoneNumber) && phoneNumber.length()>1){
            phoneNumber = phoneNumber.substring(1,phoneNumber.length());
            if(!phoneNumber.isNumeric()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.India_Contact_Format_allows_only_digits));
                return false;
            }
        }
        return true;
    }
}