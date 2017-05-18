public class MBJ_FS_Case_Intermediate_Controller{
    
    private final Case redirectCase;
    Public String RecordTypeid {get;set;}
    Public ID retailTaskID {get;set;}
    Public String accountId;
    Public String fromAccountId {get;set;}
    public String userid {get;set;}
    List<Network> Net;
    String accid;
    
    public MBJ_FS_Case_Intermediate_Controller(ApexPages.StandardController stdController){
        this.redirectCase = (Case)stdController.getrecord();
        Net =[SELECT UrlPathPrefix from Network where id=:Network.getNetworkId() LIMIT 1];
        fromAccountId = Apexpages.currentpage().getparameters().get('fromAccountId1');
         RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
        accid=Apexpages.currentpage().getparameters().get('def_account_id');
      
    }
    
    public PageReference Redirect(){
        PageReference returnURL;
        RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
        retailTaskID = Apexpages.currentpage().getparameters().get('retailTaskID');
        if(retailTaskID != null){
            Retail_Task__c rtlTask = [Select id,Account__r.id from Retail_Task__c where id=:retailTaskID limit 1];
            accountId = rtlTask.Account__r.id;
       }
        
        userid = Userinfo.getUserId();
        redirectCase.Retail_Task__c = retailTaskID ;
        
/************** If Case is created from "New Case" button in "Retail Task" record ***************/
        If(RecordTypeid!=Null && retailTaskID!=Null){
            RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
              
            if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Inquiry_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                    }
                    returnURL.getParameters().put('retURL',retailTaskID);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('retailTaskID',retailTaskID);
                    returnURL.getParameters().put('AccountID', accountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MB Complaint'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                    //Account acc=[Select Name from Account where id=:accountId limit 1];
                    pageReference p= new PageReference('/500/e?cas4_lkid='+fromAccountId+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+fromAccountId);
                    return p;
                    
            }
            else if( rt!=Null && rt.Name != Null && rt.Name == 'Inquiry'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                    //Account acc=[Select Name from Account where id=:accountId limit 1];
                    pageReference p= new PageReference('/500/e?cas4_lkid='+fromAccountId+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+fromAccountId);
                    return p;
                    
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                    returnURL.getParameters().put('retURL',retailTaskID);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('retailTaskID',retailTaskID);
                    returnURL.getParameters().put('AccountID', accountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
                    returnURL.getParameters().put('retURL',retailTaskID);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('retailTaskID',retailTaskID);
                    returnURL.getParameters().put('AccountID', accountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                returnURL.getParameters().put('retURL',retailTaskID);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('retailTaskID',retailTaskID);
                returnURL.getParameters().put('AccountID', accountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
                if (Site.getPathPrefix() != Null){
                   returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Complaint_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
                    }
                    returnURL.getParameters().put('retURL',retailTaskID);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('retailTaskID',retailTaskID);
                    returnURL.getParameters().put('AccountID', accountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else
            { 
                if(net.size()>0 &&net[0].UrlPathPrefix!=null){
                returnURL = new pagereference('/'+net[0].UrlPathPrefix+'/500/e?RecordType='+RecordTypeid+'&nooverride=1');
                }
                else{
                returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e?RecordType='+RecordTypeid+'&nooverride=1');
                }
                returnURL.setredirect(false);
                return returnURL;
            }
        }

/***************** If Case is created from an Account *********************/
        else If(RecordTypeid!=Null && fromAccountId!=Null){
            RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
              
            if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Inquiry_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                    }
                    returnURL.getParameters().put('retURL',fromAccountId);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('AccountID', fromAccountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                    returnURL.getParameters().put('retURL',fromAccountId);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('AccountID', fromAccountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
                    returnURL.getParameters().put('retURL',fromAccountId);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('AccountID', fromAccountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                    returnURL.getParameters().put('retURL',fromAccountId);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('AccountID', fromAccountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Complaint_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
                    }
                    returnURL.getParameters().put('retURL',fromAccountId);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('AccountID', fromAccountId);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
            }
              
            else if( rt!=Null && rt.Name != Null && rt.Name == 'Inquiry'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                   //Account acc=[Select Name from Account where id=:fromAccountId limit 1];
                   pageReference p= new PageReference('/500/e?cas4_lkid='+fromAccountId+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+fromAccountId);
                   return p;
                    
            }
                    
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MB Complaint'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                    //Account acc=[Select Name from Account where id=:fromAccountId limit 1];
                    pageReference p= new PageReference('/500/e?cas4_lkid='+fromAccountId+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+fromAccountId);
                    return p;
                    
            }
            
            else
            {  
                if(net.size()>0 &&net[0].UrlPathPrefix!=null){
                    returnURL = new pagereference('/'+net[0].UrlPathPrefix+'/500/e?RecordType='+RecordTypeid+'&nooverride=1');
                }
                else{
                returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e?RecordType='+RecordTypeid+'&nooverride=1');
                }
                 returnURL.setredirect(false);
                return returnURL;
            }
        }

/************ If Case is created directly from "New" button **************/
        else
        {
        returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/500/o&save_new_url=/500/e?&retURL=%2F500%2Fo');
        RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
        Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
        String retURL = result.getKeyPrefix()+'/o';
    
        If(RecordTypeid!=Null){
            RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
            if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
                if (Site.getPathPrefix() != Null){
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Inquiry_Page');
                }
                else {
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                }
                returnURL.getParameters().put('retURL',accid);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID',accid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
                
          else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                    }
                returnURL.getParameters().put('retURL',accid);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID',accid);
                
                returnURL.setredirect(false);
                return returnURL;
            }
                
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    }
               returnURL.getParameters().put('retURL',accid);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID',accid);
                returnURL.setredirect(false);
                return returnURL;
            }
             else if( rt!=Null && rt.Name != Null && rt.Name == 'MB Complaint'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                    List<Account> acc=[Select Name from Account where id=:accid ];
                    if(acc.size()>0){
                    pageReference p= new PageReference('/500/e?cas4_lkid='+acc[0].id+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+accid);
                    return p;
                    }
                    else{
                    pageReference p= new PageReference('/500/e?nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL=/500/o');
                    return p;
                    
                    }
                    
            }
            else if( rt!=Null && rt.Name != Null && rt.Name == 'Inquiry'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/500/e');
                    }
                    else {
                    returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                    }
                    List<Account> acc=[Select Name from Account where id=:accid ];
                    if(acc.size()>0){
                    pageReference p= new PageReference('/500/e?cas4_lkid='+acc[0].id+'+&nooverride=0&ownerid='+userid+'&RecordType='+rt.id+'&retURL='+accid);
                    return p;
                    }
                    else{
                    pageReference p= new PageReference('/500/e?nooverride=0&ownerid='+userid+'retURL=/500/o');
                    return p;
                    
                    }
            }
                
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                    }
                returnURL.getParameters().put('retURL',accid);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID',accid);
                returnURL.setredirect(false);
                return returnURL;
               
            }
                
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
                if (Site.getPathPrefix() != Null){
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+Site.getPathPrefix()+'/apex/MBJ_FS_Complaint_Page');
                    }
                    else {
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
                    }
                returnURL.getParameters().put('retURL',accid);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID',accid);
                returnURL.setredirect(false);
                return returnURL;
                
            }
            else
            {  
                Account acc=[Select Name from Account where id=:accid limit 1];
                returnURL = new pagereference('/500/e?RecordType='+RecordTypeid+''+'cas4_lkid='+acc.id+'+&nooverride=0');
                returnURL.setredirect(false);
                return returnURL;
                }
                
            }
            if(net.size()>0 &&net[0].UrlPathPrefix!=null)
            {
            returnURL = new pagereference('/'+net[0].UrlPathPrefix+'/500/e?retURL=%2F500%2Fo&nooverride=0');
            }
            else{  
                List<Account> acc=[Select Name from Account where id=:accid ];
                   
                    if(acc.size()>0){
                    //pageReference p= new PageReference('/500/e?cas4_lkid='+acc[0].id+'+&nooverride=0&retURL=/500/o');
                    pageReference p= new PageReference('/500/e?cas4_lkid='+acc[0].id+'+&nooverride=0&retURL='+accid);
                    return p;
                    }
                    else{
                    pageReference p= new PageReference('/500/e?nooverride=0&retURL=/500/o');
                    return p;
                    
                    }
            
            }
            returnURL.setredirect(false);
            return returnURL;
        }        
    }
}