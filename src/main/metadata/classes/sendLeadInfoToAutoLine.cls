/*
Created By: Dheeraj, Infosys Limited
Created Date: 22/06/2018.

Modification History
*/
public class sendLeadInfoToAutoLine{
    public Boolean showHideButtons{get;set;}
    public sendLeadInfoToAutoLine(ApexPages.StandardController apStdController) {
        showHideButtons = true;
    }

    //for returning to the detail view page.
    public PageReference doCancel() {
        return Page.ForceWindowClose;
    }
    
    //on button click,  invoking the method to send the lead details to informatica.
    public PageReference callInformaticaService(){
        Set<Id> leadIdSet = new Set<Id>(); //holding the Lead ids.
        Lead__c ld = new Lead__c(); //for storing the lead related information
        Map<String, JP_Switch__c> allJPCustomSettingValues = JP_Switch__c.getAll(); //fetching the value from custom setting.
        
        Id leadId = ApexPages.currentPage().getParameters().get('Id'); //getting the record id from the page url.
        leadIdSet.add(leadId); //adding the ids to the set, so that it can be passed as the parameter.
        
        showHideButtons = false;
        try{
            //querying the lead related information to check the condition.
            ld = [SELECT Id, Dealer_Lead_Status__c,Sent_to_Autoline__c, DMS_Sent_Flag__c, Market__c
                        FROM Lead__c 
                        WHERE Id =: leadId ];
            
            //checking the condition calling the autoline service.
            //lost and Purchased, exisiting condition. Sent to AL, DMS Sent and custom setting values are new logic for JP track.
            if(ld.Dealer_Lead_Status__c == 'Lost' || ld.Dealer_Lead_Status__c == 'Purchased(Only Non BDC)' || ( allJPCustomSettingValues.get('Autoline Lead Management Switch').Enable_Flag__c == True && allJPCustomSettingValues.get('Enable Autoline Flag Check').Enable_Flag__c == True && ld.Sent_to_Autoline__c == True && ld.DMS_Sent_Flag__c == True && ld.Market__c == 'JP')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.This_Lead_cannot_be_send_to_Autoline)); 
                return null;    
            }else if((allJPCustomSettingValues.get('Autoline Lead Management Switch').Enable_Flag__c == True && ld.Market__c == 'JP')){
                Boolean isSuccess = CDMInformatica_Services.createLeadInAl(leadIdSet, 'JP', 'Insert');
                if(isSuccess){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, System.Label.Successfully_Sent_Information_to_AutoLine)); 
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Web_service_callout_failed)); 
                }
                //return Page.ForceWindowClose; 
            }
            //return Page.ForceWindowClose; 
        }Catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Web_service_callout_failed)); 
        }
        return null;
    }//end of call informatica service method.
}//end of method.