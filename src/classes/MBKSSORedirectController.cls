public class MBKSSORedirectController
{

    
    String internalIdpSettingName = 'MBKCommunitySSOSetup';
    
    String idpUrlWithRelayState = '' ;
    
    Map<String, String> settingNameToIdpLoginUrl = new Map<String, String>();
    
    public Boolean ShowErrorMessage {get; set;}
    
    public MBKSSORedirectController() 
    {
        ShowErrorMessage = false;
        settingNameToIdpLoginUrl = getExternalServerUrl();
        
        if (!settingNameToIdpLoginUrl.containsKey(internalIdpSettingName))
        {
            ShowErrorMessage = true;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.WARNING, 'Idp login endpoint missed. Please contact your system admin.');
            ApexPages.addMessage(errorMessage);
        }
        

        idpUrlWithRelayState = settingNameToIdpLoginUrl.get(internalIdpSettingName);
        String id = ApexPages.currentPage().getParameters().get('id');
        System.debug('ID HERE IS >>>>>>'+id);
        if(id!= null && id!= '')
        {
           idpUrlWithRelayState = idpUrlWithRelayState + '&id='+ EncodingUtil.urlEncode(id, 'UTF-8');
          
        }

    }
    public PageReference forwardToAuthPage()
    {

        String url = idpUrlWithRelayState ;
      PageReference p = new PageReference(url);
      return p;
    }
    Public String getIdpUrlWithRelayState()
    {
        return idpUrlWithRelayState;
    }
    
    private Map<String, String> getExternalServerUrl()
    {
        Map<String, String> result = new Map<String, String>();
        List<ExternalServer__c> externalServerInstances = ExternalServer__c.getAll().values(); //(dataSetName);
        for (ExternalServer__c tempInstance : externalServerInstances)
        {
            if (tempInstance != null && tempInstance.IsActive__c == true && tempInstance.Endpoint__c != null)
            {
                result.put(tempInstance.Name, tempInstance.Endpoint__c);
            }
        }
        return result;
    }
}