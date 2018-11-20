public class sendLeadInfoToAutoLineKRController{
    public Boolean showHideButtons{get;set;}
    public sendLeadInfoToAutoLineKRController(ApexPages.StandardController apStdController) {
        showHideButtons = true;
    }

    //for returning to the detail view page.
    public PageReference doCancel() {
        return Page.ForceWindowClose;
    }
    
    //on button click,  invoking the method to send the lead details to informatica.
    public PageReference callInformaticaService(){
        //holding the Lead ids.
        Set<Id> leadIdSet = new Set<Id>(); 
        //for storing the lead related information
        Lead__c ld = new Lead__c(); 
        //fetching the value from custom setting by Sraavni Koppaka.
        Map<String, KR_Switch__c> allKRCustomSettingValues = KR_Switch__c.getAll(); 
        //getting the record id from the page url.
        Id leadId = ApexPages.currentPage().getParameters().get('Id'); 
        //adding the ids to the set, so that it can be passed as the parameter.
        leadIdSet.add(leadId); 
        
        showHideButtons = false;
        try{
            //querying the lead related information to check the condition.
            ld = [SELECT Id, Dealer_Lead_Status__c,Sent_to_Autoline__c, DMS_Sent_Flag__c, Market__c
                        FROM Lead__c 
                        WHERE Id =: leadId ];
            
            //checking the condition calling the autoline service.Lost and Purchased, exisiting condition. Sent to AL, DMS Sent and custom setting values are new logic for KR track.
            //Added KRSwitch conditions by Sravani Koppaka
            if(ld.Dealer_Lead_Status__c == 'Lost' || ld.Dealer_Lead_Status__c == 'Purchased(Only Non BDC)' || ( allKRCustomSettingValues.get('Autoline Lead Management Switch').Enable_Flag__c == True && allKRCustomSettingValues.get('Enable Autoline Flag Check').Enable_Flag__c == True && ld.DMS_Sent_Flag__c == True && ld.Market__c == 'KR')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.This_Lead_cannot_be_send_to_Autoline)); 
                return null;    
            }else if((allKRCustomSettingValues.get('Autoline Lead Management Switch').Enable_Flag__c == True && ld.Market__c == 'KR')){
                Boolean isSuccess = CDMInformatica_Services.createLeadInAL(leadIdSet, 'KR', 'Insert');
              
                if(isSuccess){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Successfully_Sent_Information_to_AutoLine)); 
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Successfully_Sent_Information_to_AutoLine)); 
                }
               
            }
           
        }Catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Successfully_Sent_Information_to_AutoLine)); 
        }
        return null;
    }//end of call informatica service method.
}//end of method.