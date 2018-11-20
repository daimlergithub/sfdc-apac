/* ***********************************************************************************
* Created By:kavya 
* Created Date:12-July-2018
* Modified Date:23-Oct-2018
* Company:Infosys Ltd
* Description: Community File trigger handler class(handler of CommunityFileShare.
* **********************************************************************************/
public class CommunityFileHandler {    
    //Added:By kavya
    //RCP-89 :As MPC Admin, files in the server can be automatically removed to recover space. This function can be disabled/enabled by Admin
    public void deleteExpiredFileRecords(List<Community_Files__c> filesList){
        //Modified: Related Files to be deleted and their names to be stored in Community File
        ContentDocument[] relatedDeletions = new List<ContentDocument>();
        communityFileReport cfr= communityFileReport.getfileDetails();
        for(Community_Files__c file: filesList) {
            if(file.Expired__c) {
                String titles='';
                Integer row = 0;
                List<ContentDocument> relatedFiles = cfr.cfIdcdListMap.get(file.Id);
                if(relatedFiles!=null && !relatedFiles.isEmpty()){
                    relatedDeletions.addAll(relatedFiles);
                    for(ContentDocument cd:relatedFiles ){
                        row = row+1;
                        //titles=titles+cd.Title+',';
                        titles += row+'.'+cd.Title+' : '+Math.round(cd.ContentSize/1024*100)/100+'KB ' + '\n';
                    }
                }
                file.Related_Files__c=titles;
            }
        }
        delete relatedDeletions;
    }
}