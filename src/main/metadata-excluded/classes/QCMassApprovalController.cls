/*
    Type:       Controller for QCMassApproval Visualforce page 
    Purpose:    Mass Approve QC
    User Story: Defect#0984
    Used By:    QCMassApproval .page
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-10-12
*/

public with sharing class QCMassApprovalController {

    private String [] arrObjIds;    
    
    public QCMassApprovalController(){           
        Map<String, String> params = ApexPages.currentPage().getParameters();        
        String strObjIds = params.get('objIds');        
        arrObjIds = strObjIds.split(',');                  
    }    

    public pageReference massApproved (){

        String qcprefix = Schema.getGlobalDescribe().get('QC__c').getDescribe().getKeyPrefix();
        Map<String, String> params = ApexPages.currentPage().getParameters();        

        if (arrObjIds.size() > 0) {
            List<QC__c> qcs = [Select Id, Qualified__c, Status__c, Approved__c, Approved_Time__c From QC__c Where Id In :arrObjIds];
            for (QC__c qc : qcs){
                if (qc.Qualified__c == 'Pass' && qc.Approved__c != 'Yes') {
                    qc.Approved__c = 'Yes';      
                    qc.Approved_Time__c = Datetime.now();              
                }
            }
            
            try{
                Database.update(qcs, false);
                PageReference pr = new PageReference('/' + qcprefix );
                pr.setRedirect(true);
                return pr;
            } catch (DMLException ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }
        }  
        return null;         
    }
}