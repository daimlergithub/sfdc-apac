trigger CommunityFileShare on Community_Files__c (before update,before delete,after update) {    
    if(trigger.isbefore){
         if(trigger.isupdate){
             //Modified : Kavya
             //RCP-89   :As MPC Admin, files in the server can be automatically removed to recover space. This function can be disabled/enabled by Admin
             CommunityFileHandler CFH = new CommunityFileHandler();
             CFH.deleteExpiredFileRecords(Trigger.new);
         }       
    }    
}