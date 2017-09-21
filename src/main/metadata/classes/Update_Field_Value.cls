/*
    Type:       Batch Class
    Purpose:    Batch to update the field value of an object 
    ---------------------------------------------------------------
    History:

    18-Sep-2017 Sanjay Nandi    Created    
*/
global class Update_Field_Value implements Database.Batchable<sObject>,Database.Stateful{
   
   //Values to be assigned to the variables at the time of batch run
   global String Query;
   global map<string,string> fieldstoupdate;
   Global List<string> idsfailed;
   global Schema.SObjectType ObjectName;
   global Integer counter=0;
   global String MD = 'Unknown';
   
   //Start method of the batch
   global Database.QueryLocator start(Database.BatchableContext BC){
      // Query is defined at the time of batch execution 
      return Database.getQueryLocator(query);
   }
   
   //Execute method of Batch class
   global void execute(Database.BatchableContext BC, List<sObject> scope){ 
     for(sobject s: scope){
        //Assign given value to the field  provided
        for(string str: fieldstoupdate.keyset()){
                s.put(str,fieldstoupdate.get(str));
                //Capture the field value to the variable
                if(MD == 'Unknown'){
                    MD = fieldstoupdate.get(str);
                } 
            }
        }
     Database.SaveResult[] srList = database.update(scope,false);
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                counter++;
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                idsfailed.add(err.getMessage()+'----'+err.getFields()+'---'+sr.id);
                }
            }
        }
        //Capture Object Name on which the batch job is running 
        ObjectName = scope.getSObjectType();
    }
    
   //Finish method of batch class
   global void finish(Database.BatchableContext BC){
       //Show the required information 
        System.debug('\n'+ '********************************************'+'\n'+
                    'Object Name:' +ObjectName + '\n'+ 'Market:' +MD+ '\n'+
                    'SoQL / DML :' +query+'\n'+'# of records impacted:'
                     +counter+'\n'+'********************************************');
    List<Messaging.SingleEmailMessage> mails =   new List<Messaging.SingleEmailMessage>();
    }
}