public class MBJ_FS_Case_Intermediate_Controller{

    private final Case redirectCase;
    Public String RecordTypeid {get;set;}
    Public ID retailTaskID {get;set;}
    Public String accountId;
    Public String fromAccountId {get;set;}
    public String userid {get;set;}
    List<Network> Net;
    
    public MBJ_FS_Case_Intermediate_Controller(ApexPages.StandardController stdController){
        this.redirectCase = (Case)stdController.getrecord();
        Net =[SELECT UrlPathPrefix from Network where id=:Network.getNetworkId() LIMIT 1];
    //  userContact = [Select Id, Name From Contact Where Id In (Select ContactId From User Where Id = :UserInfo.getUserId())];
    }
    
    public PageReference Redirect(){
        PageReference returnURL;
        RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
        retailTaskID = Apexpages.currentpage().getparameters().get('retailTaskID');
        if(retailTaskID != null){
            Retail_Task__c rtlTask = [Select id,Account__r.id from Retail_Task__c where id=:retailTaskID limit 1];
            accountId = rtlTask.Account__r.id;
        }
        fromAccountId = Apexpages.currentpage().getparameters().get('fromAccountId');
        
        userid = Userinfo.getUserId();
        redirectCase.Retail_Task__c = retailTaskID ;
        
        /****** If Case is created from "New Case" button in "Retail Task" record*****/
        If(RecordTypeid!=Null && retailTaskID!=Null){
            RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
              
            if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                returnURL.getParameters().put('retURL',retailTaskID);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('retailTaskID',retailTaskID);
                returnURL.getParameters().put('AccountID', accountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                returnURL.getParameters().put('retURL',retailTaskID);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('retailTaskID',retailTaskID);
                returnURL.getParameters().put('AccountID', accountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                returnURL.getParameters().put('retURL',retailTaskID);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('retailTaskID',retailTaskID);
                returnURL.getParameters().put('AccountID', accountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                returnURL.getParameters().put('retURL',retailTaskID);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('retailTaskID',retailTaskID);
                returnURL.getParameters().put('AccountID', accountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
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
                system.debug('===='+net);
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
        
        /****** If Case is created from an Account *****/
        else If(RecordTypeid!=Null && fromAccountId!=Null){
            RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
              
            if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('AccountID', fromAccountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('AccountID', fromAccountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('AccountID', fromAccountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('AccountID', fromAccountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
            
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
            
                returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('AccountID', fromAccountId);
                returnURL.getParameters().put('ownerid', userid);
                returnURL.setredirect(false);
                return returnURL;
            }
           
                
            else if( rt!=Null && rt.Name != Null && rt.Name == 'Inquiry'){
                    
                returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID', fromAccountId);
                returnURL.setredirect(false);
                return returnURL;
            }
                    
            else if( rt!=Null && rt.Name != Null && rt.Name == 'MB Complaint'){
                    
                returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e');
                returnURL.getParameters().put('retURL',fromAccountId);
                returnURL.getParameters().put('RecordType',rt.id);
                returnURL.getParameters().put('ownerid', userid);
                returnURl.getParameters().put('AccountID', fromAccountId);
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
        
        /****** If Case is created directly from "New" button *****/
        else
        {
            returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/setup/ui/recordtypeselect.jsp?ent=Case&retURL=/500/o&save_new_url=/500/e?&retURL=%2F500%2Fo');
            RecordTypeid = ApexPages.currentPage().getParameters().get('RecordType');
            Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
            String retURL = result.getKeyPrefix()+'/o';
            
            If(RecordTypeid!=Null){
                RecordType rt=[Select id,Name from Recordtype WHERE id=:RecordTypeid limit 1];
         
                if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Inquiry Case'){
                    
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Inquiry_Page');
                    returnURL.getParameters().put('retURL',retURL);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
                }
                
                else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Customer Request Case'){
            
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Request_Page');
                    returnURL.getParameters().put('retURL',retURL);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
                }
                
                else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Contract Closing Case'){
            
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_ContractClosing_Page');
                    returnURL.getParameters().put('retURL',retURL);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
                }
                
                else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Finance Quotation Case'){
            
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Case_Quotation_Page');
                    returnURL.getParameters().put('retURL',retURL);
                    returnURL.getParameters().put('RecordType',rt.id);
                    returnURL.getParameters().put('ownerid', userid);
                    returnURL.setredirect(false);
                    return returnURL;
                }
                
                else if( rt!=Null && rt.Name != Null && rt.Name == 'MBF Complaint Management Case'){
            
                    returnURL = new PageReference(System.URL.getSalesforceBaseURL().toExternalForm()+'/apex/MBJ_FS_Complaint_Page');
                    returnURL.getParameters().put('retURL',retURL);
                    returnURL.getParameters().put('RecordType',rt.id);
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
            if(net.size()>0 &&net[0].UrlPathPrefix!=null)
            {
            returnURL = new pagereference('/'+net[0].UrlPathPrefix+'/500/e?retURL=%2F500%2Fo&nooverride=0');
            }
            else{
            returnURL = new pagereference(System.URL.getSalesforceBaseURL().toExternalForm()+'/500/e?retURL=%2F500%2Fo&nooverride=0');
            }
            
            
            returnURL.setredirect(false);
            return returnURL;
        //  return Null;
        }        
    }
}