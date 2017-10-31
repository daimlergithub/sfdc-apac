/*
    Type:       Class
    Purpose:    Detail in Campaign Offering or Campaign Package or Participating Dealer is created or updated or deleted 
    User Story: US-Cpn-017

    Used By:    Trigger
    ---------------------------------------------------------------
    History:

    18-June-2013 Stephano.shi (Breakingpoint)    Created
*/
public class campaignHistoryLogGeneration{
    
	public void logGeneration(String type, String action, Id cm, Id us, String objName){
		Audit_Trail__c[] records = new List<Audit_Trail__c>();
		
        // LOG Record
    	Audit_Trail__c chl = new Audit_Trail__c();
        
		chl.Name = objName;
		chl.Action__c = action;		// What operation
        chl.Date_of_Change__c = DateTime.now(); // when
		chl.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Audit_Trail__c', 'Campaign');
		chl.Campaign__c = cm;		// What campaign releated
		chl.User__c = us;			// Who makes the operation
		
		records.add(chl);
		
		UtilSobject.insertSobjects(records);
    }
}