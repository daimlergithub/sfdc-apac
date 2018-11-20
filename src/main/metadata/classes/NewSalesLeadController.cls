/**
**New Controller Class to Re Direct VF page as per Lead Record Type selection
** Created By: Namitha
** Date: 2018-03-27
History:
Author                         Date                    Description
**/
public with sharing class NewSalesLeadController {
    public Opportunity opp {get;set;}
    public string rec {get;set;}
     
    public NewSalesLeadController(ApexPages.StandardController controller) {
        
    }
    
    public PageReference goToRecordTypePage() {        
        string accId = ApexPages.currentPage().getParameters().get('retURL');
        if(accID != NULL){
            system.debug('inside'+accid);
	    if(userInfo.getUserType() == 'PowerPartner')
                accID = accID.right(accID.Length()-accID.lastIndexOf('/'));
            accID = accId.replace('/','');
            if(accID.startsWith('001')){
                accID = accID.substring(0,15);
            }
            else
                accID = '';
            
        }    
        else{
            accId = ApexPages.currentPage().getParameters().get('accid');
            if(accid == NULL)
                accID = '';
        }
		if(FeatureManagement.checkPermission([SELECT Id, DeveloperName FROM CustomPermission WHERE DeveloperName = 'AccessFSOppIN'].DeveloperName)){
            Id fsId = UtilRecordType.getRecordTypeIdByName('Opportunity', System.Label.Finance_Lead);
            String newPageUrl = '/006/e?retURL=%2F006%2Fo&RecordType='+fsId+'&ent=Opportunity&nooverride=1&accid='+accID;
            PageReference leadPage = new PageReference(newPageUrl);
            return leadPage;
        }
        else if(!(FeatureManagement.checkPermission([SELECT Id, DeveloperName FROM CustomPermission WHERE DeveloperName = 'AccessFSOppIN'].DeveloperName))){
            opp = new opportunity();
			opp.recordtypeid = ApexPages.currentPage().getParameters().get('RecordType');
             system.debug('rec----------opp'+opp.recordtypeid);
             
             //sadananda added for single record access 
              List<String> availableCaseTypes =  UtilRecordType.GetAvailableRecordTypeNamesForSObject(Opportunity.SObjectType );

               if ( availableCaseTypes.size() >1)
               {
             
                    rec = opp.recordtypeid;
                  system.debug('rec----------'+rec);
                  rec = UtilRecordType.getRecordTypeNameById('Opportunity',rec);
                }
                else if ( availableCaseTypes.size() ==1)
                {rec  = availableCaseTypes[0];}
                
 
			if(rec == Label.Aftersales_Lead){
                PageReference leadPage = new PageReference('/apex/AfterSalesLeadPage'+'?accid='+accID);
                leadPage.setRedirect(true);
                return leadPage;
            }
            else if (rec == Label.Sales_Lead){
                PageReference leadPage = new PageReference('/apex/SalesLeadPage'+'?accid='+accID);
                leadPage.setRedirect(true);
                return leadPage;            
            }
            else if (rec == 'Finance Lead'){
                String newPageUrl = '/006/e?retURL=%2F006%2Fo&RecordType='+opp.recordtypeid+'&ent=Opportunity&nooverride=1&accid='+accID;
                PageReference leadPage = new PageReference(newPageUrl);
                return leadPage;
            }
        }
        return null;
    }
}