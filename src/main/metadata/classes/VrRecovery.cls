/***********************************************************************************
Created By          :    Shiva Sai Pothu 
Company             :    NTT Data,Inc.
Usage               :    Daily report for VR Deletion                      
                                            
************************************************************************************/
global class VrRecovery implements Database.Batchable<sObject>,Schedulable
{     
    
    //String StartDateStrng = System.Label.Start_Date_for_VrDeletion_class;
    //DateTime StartDate = DateTime.valueof(StartDateStrng);
   // String EndDateStrng= System.label.End_Date_for_VrDeletion_Class;
    //DateTime EndDate= DateTime.valueof(EndDateStrng);
    global Database.queryLocator start(Database.BatchableContext bc)
    {        
        String query = 'Select id,Name,Contact__c,Contact__r.UCID__c,UsVIN__c, Car_Relation__c, Start_Date__c, End_Date__c, Vehicle_ID__r.Name,LastModifiedDate, LastModifiedBy.Name,MD__c from Vehicle_Relationship__c where isDeleted = true and RecordType.Name = \'Vehicle Relationship\' and MD__c = \'JP\' ALL ROWS';
        //'Select id,Name,Contact__c,Contact__r.UCID__c,UsVIN__c, Car_Relation__c, Start_Date__c, End_Date__c, Vehicle_ID__r.Name,LastModifiedDate, LastModifiedBy.Name,MD__c from Vehicle_Relationship__c where isDeleted = true and RecordType.Name = \'Vehicle Relationship\' and MD__c = \'JP\' and (LastModifiedDate>=:'+StartDateStrng+' AND LastModifiedDate<=:'+EndDateStrng+') ';
        
        System.debug('query----> '+query );
        //  String query = 'SELECT Id, Name, IsDeleted, LastModifiedDate FROM Vehicle_Relationship__c WHERE IsDeleted = True AND (LastModifiedDate>=:'+StartDate+' AND LastModifiedDate<=:'+EndDate+') AND MD__c='+'JP'+' ALL ROWS';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Vehicle_Relationship__c> scope)
    {
    if(scope!=null)
        {
            List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>(); 
            List<Vehicle_Relationship__c> Vrlist = new List<Vehicle_Relationship__c>();
             String VrsRecovered ='';
            for(Vehicle_Relationship__c c:scope)
            {
                Vrlist.add(c);
                String NewVr = c.id+','+c.Name+'\n';
                VrsRecovered = VrsRecovered + NewVr;
                // VrsRecovered.replaceAll('null','');
            }
            system.debug('Data--->'+Vrlist);
            //undelete Vrlist;
            System.debug('The restored Vr records are :'+Vrlist);
            //VrsRecovered = Vrlist;
            //String MainString = VrsRecovered;
       
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(VrsRecovered);
            string csvname= 'DeletedVrs.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);      
       
        
            Messaging.SingleEmailmessage mail = new Messaging.SingleEmailmessage();
            mail.setToAddresses((new String[] {'shiva.sai@nttdata.com','kiran.pedinenikalva@nttdata.com','dasepalle.abhishekh@nttdata.com'}));
            mail.setSenderDisplayName('VR Deleted Records');
            mail.setSubject('Vehicle Relationship records deleted');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('Kindly find the list of deleted VR records');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            system.debug('@@@@ sendEmail - mail : ' + mail);
            msgList.add(mail);
            Messaging.sendEmail(msgList);
            }
    }
    global void finish(Database.BatchableContext bc){
        
       //System.debug('*****StartDate from Label is***** '+StartDate);
        //System.debug('******End Date From Label is***** '+EndDate);
        
       
    }
    
    global void execute(SchedulableContext s){
        Database.executeBatch(this);        
    }
}
