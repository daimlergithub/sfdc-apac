/*
    Type:Test class
    Purpose:Test Class for batchReparentRecords
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 30-03-2018 by Abhishek Mohanty 
    2. Modified     
*/
@isTest 
public class batchReparentRecordsTest
{
    
    public static testmethod void testMethod1() 
    {
        User user1 = TestUtils.createAdminUser();
        System.runAs (user1) {
        Account duplicate_account= TestUtils.createPersonAccountAsUserAsOwner(user1);
        duplicate_account= TestUtils.UpdateAccount(duplicate_account.id);
        update duplicate_account;
        Account master_account = TestUtils.createCompanyAccount(user1);
        master_account.Primary_Address_Reference__c = TestUtils.createAddress(master_account.ID).ID;
        update master_account;
        Account dealer_account = TestUtils.createPersonAccountAsUserAsOwner(user1);
        dealer_account.Primary_Address_Reference__c = TestUtils.createAddress(dealer_account.ID).ID;
        update dealer_account;
                
        Vehicle__c  vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                                                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                                                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
            insert vehicles;
            
            Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE,Vehicle_Phone_picklist__c = 'Home Phone',vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel.Contact__c = duplicate_account.id;
            vRel.Vehicle_ID__c = vehicles.id;
            vRel.End_Date__c = null;
            vRel.Vehicle_address_picklist__c = '--None--';
            vRel.Owner_Dealer__c=dealer_account.id;
            vRel.Market__c='TH';
            insert vRel;
        
        Vehicle_Relationship__c vRel2 = new Vehicle_Relationship__c(Recall__c = FALSE,Vehicle_Phone_picklist__c = 'Home Phone',vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel2.Contact__c = master_account.id;
            vRel2.Vehicle_ID__c = vehicles.id;
            vRel2.End_Date__c = null;
            vRel2.Vehicle_address_picklist__c = 'Home Phone';
            vRel2.Owner_Dealer__c=dealer_account.id;
            vRel2.Market__c='TH';
            insert vRel2;
        
        Task obTask = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task');
        insert obTask;
        
        Task obTask2 = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task2');
        insert obTask2;
        
        Event evnt = new Event( Whatid=duplicate_account.id,Subject='Test subject',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt;
        
        Event evnt2 = new Event( Whatid=duplicate_account.id,Subject='Test subject2',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt2;
        
        Note nte=new Note(parentId=duplicate_account.Id,Title='Test merge');
        insert nte;
        
        Note nte2=new Note(parentId=duplicate_account.Id,Title='Test merge2');
        insert nte2;
        
        Attachment atchmnt=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge'),Name='Test Attachment Merge');
        insert atchmnt;
        
        Attachment atchmnt2=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge2'),Name='Test Attachment Merge2');
        insert atchmnt2;
        
        Duplicate_Merge_Info__c dmi=new Duplicate_Merge_Info__c(
                                    Duplicate_Customer__c=duplicate_account.id,
                                    Duplicate_Reason__c='Reason',
                                    status__c='New',
                                    Master_Customer__c=master_account.id,
                                    MD__c='TH'
        );
        
        insert dmi;
        
        List<Account> AccountList=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id in (:dmi.Master_Customer__c,:dmi.Duplicate_Customer__c)];
        Integer masterAccountTasks;
        Integer duplicateAccountTasks;
        Integer masterAccountevents;
        Integer duplicateAccountevents;
        Integer masterAccountnotes;
        Integer duplicateAccountnotes;
        Integer masterAccountattachments;
        Integer duplicateAccountattachments;
        Integer masterAccountVR;
        Integer duplicateAccountVR;
        for(Account a:AccountList){
            if(a.id==dmi.Master_Customer__c){
                masterAccountTasks=a.Tasks.size();
                masterAccountevents=a.Events.size();
                masterAccountnotes=a.Notes.size();
                masterAccountattachments=a.Attachments.size();
                masterAccountVR=a.Vehicle_Relationships2__r.size();
            }
            else if(a.id==dmi.Duplicate_Customer__c){
                duplicateAccountTasks=a.Tasks.size();
                duplicateAccountevents=a.Events.size();
                duplicateAccountnotes=a.Notes.size();
                duplicateAccountattachments=a.Attachments.size();
                duplicateAccountVR=a.Vehicle_Relationships2__r.size();
            }
        }
        
        
        Test.startTest();

            batchReparentRecords obj = new batchReparentRecords();
            DataBase.executeBatch(obj); 
            
            scheduledBatchReparentRecords sh1 = new scheduledBatchReparentRecords();
            String sch = '0  00 1 3 * ?';
            system.schedule('Test', sch, sh1);
            
        Test.stopTest();
        
        List<Account> AccountList2=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id = :dmi.Master_Customer__c];
        Integer masterAccountTasks_aftermerge;
        Integer masterAccountevents_aftermerge;        
        Integer masterAccountnotes_aftermerge;        
        Integer masterAccountattachments_aftermerge;        
        Integer masterAccountVR_aftermerge;
        for(Account a:AccountList2){
            masterAccountTasks_aftermerge=a.Tasks.size();
            masterAccountevents_aftermerge=a.Events.size();
            masterAccountnotes_aftermerge=a.Notes.size();
            masterAccountattachments_aftermerge=a.Attachments.size();
            masterAccountVR_aftermerge=a.Vehicle_Relationships2__r.size();
        }
        system.assertEquals(masterAccountTasks+duplicateAccountTasks, masterAccountTasks_aftermerge);
        system.assertEquals(masterAccountevents+duplicateAccountEvents, masterAccountEvents_aftermerge);
        system.assertEquals(masterAccountnotes+duplicateAccountnotes, masterAccountnotes_aftermerge);
        system.assertEquals(masterAccountattachments+duplicateAccountattachments, masterAccountattachments_aftermerge);
        //system.assertEquals(masterAccountVR+duplicateAccountVR, masterAccountVR_aftermerge);
       }
    }
}