@isTest
private class DMLManagerServiceTest {
    
    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through insertAsSystem ignore CRUD/FLS
    */
    static testMethod void systemInsert(){
        Opportunity o1 = new Opportunity(Name='Original1 Opp',StageName='Won',CloseDate=Date.today());
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            DMLManagerService.insertAsSystem(new Opportunity[]{o1});
        }
    }

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through updateAsSystem ignore CRUD/FLS
    */
/*    static testMethod void systemUpdate(){
        Account a1 = new Account(Name='Apple Account');

        System.runAs(new User(Id = UserInfo.getUserId())){
            insert a1;
        }
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            a1.Name = 'Apple Updated';
            DMLManagerService.updateAsSystem(new Account[]{a1});
            Account a1Reload = [SELECT Name FROM Account WHERE Id = :a1.Id];
            System.assertEquals('Apple Updated', a1Reload.Name);
        }
    }*/
    
    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through upsertAsSystem ignore CRUD/FLS
    */
    /*static testMethod void systemUpsert(){
        Account a1 = new Account(Name='Apple Account');

        System.runAs(new User(Id = UserInfo.getUserId())){
            insert a1;
        }
        
        Account a1Clone = new Account(Id = a1.Id, Name= 'Apple Updated');
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            DMLManagerService.upsertAsSystem(new Account[]{a1Clone});
            Account a1Reload = [SELECT Name FROM Account WHERE Id = :a1.Id];
            System.assertEquals('Apple Updated', a1Reload.Name);
        }
    }*/

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through deleteAsSystem ignore CRUD/FLS
    */
    static testMethod void systemDelete(){
        User newUser = ensureRestrictedUser();

        System.runAs(newUser){
            Account a1 = new Account(Name='Apple Account',RecordTypeId='012280000000f0p');
            insert a1;
            DMLManagerService.deleteAsSystem(new Account[]{a1});
        }
    }

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through insertAsUser fail for FLS restricted users
    */
    static testMethod void flsRestrictedInsert(){
        Campaign c1 = new Campaign(Name = 'Test1 Campaign');
        System.runAs(new User(Id = UserInfo.getUserId())){
            insert new Campaign[]{c1};
        }
        
        Opportunity o1 = new Opportunity(Name='Original1 Opp',CampaignId=c1.Id,StageName='Won',CloseDate=Date.today());
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            try{
                DMLManagerService.insertAsUser(new Opportunity[]{o1});
                System.assert(false,'Expected a DML Error! newUser shouldn\'t be able to insert Opportunity.CampaignId');
            }
            catch(DMLManagerService.FLSException flse){
                //expected
                System.assertEquals(Opportunity.SObjectType,flse.objType);
                System.assertEquals(DMLManagerService.Operation.OP_INSERT,flse.op);
                System.assertEquals(Opportunity.SObjectType.fields.CampaignId,flse.field);
            }
        }

    }

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through upsertAsUser succeed for users with no FLS restrictions
    */
    static testMethod void flsUnrestrictedUpsert(){
        Campaign c1 = new Campaign(Name = 'Test1 Campaign');
        Campaign c2 = new Campaign(Name = 'Test2 Campaign');
        System.runAs(new User(Id = UserInfo.getUserId())){
            insert new Campaign[]{c1,c2};
        }
        
        Opportunity o1 = new Opportunity(Name='Original1 Opp',CampaignId=c1.Id,StageName='Won',CloseDate=Date.today());
        DMLManagerService.upsertAsUser(new Opportunity[]{o1});
        System.assert(o1.Id != null);

        o1.Name='Updated1 Opp';
        o1.CampaignId = c2.Id;
        
        Opportunity o2 = new Opportunity(Name='Test2 Opp',CampaignId=c2.Id,StageName='Won',CloseDate=Date.today());
        
        DMLManagerService.upsertAsUser(new Opportunity[]{o1,o2});

        List<Opportunity> reload = [SELECT Id, Name, CampaignId FROM Opportunity ORDER BY Id];
        System.assertEquals(reload.size(),2);
        System.assertEquals('Updated1 Opp',reload[0].Name);
        System.assertEquals(c2.Id,reload[0].CampaignId);
        System.assertEquals('Test2 Opp',reload[1].Name);
        System.assertEquals(c2.Id,reload[1].CampaignId);
        System.assert(reload[1].Id != null);
    }

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations run through upsertAsUser fail for FLS restricted users
    */
/*    static testMethod void flsRestrictedUpsert(){
        Campaign c1 = new Campaign(Name = 'Test1 Campaign');
        Campaign c2 = new Campaign(Name = 'Test2 Campaign');
        Opportunity o1 = new Opportunity(Name='Original1 Opp',CampaignId=c1.Id,StageName='Won',CloseDate=Date.today());

        System.runAs(new User(Id = UserInfo.getUserId())){
            insert new SObject[]{c1,c2,o1};
        }
        
        System.assert(o1.Id != null);

        o1.Name='Updated1 Opp';
        o1.CampaignId = c2.Id;
        
        Opportunity o2 = new Opportunity(Name='Test2 Opp',CampaignId=c2.Id,StageName='Won',CloseDate=Date.today());
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            try{
                DMLManagerService.upsertAsUser(new Opportunity[]{o1,o2});
                System.assert(false,'Expected a DML Error! newUser shouldn\'t be able to update Opportunity.CampaignId');
            }
            catch(DMLManagerService.FLSException flse){
                //expected
                System.assertEquals(Opportunity.SObjectType,flse.objType);
                System.assertEquals(DMLManagerService.Operation.OP_UPDATE,flse.op);
                System.assertEquals(Opportunity.SObjectType.fields.CampaignId,flse.field);
            }
        }

    }*/
    
    /**
    
    * @date 6/22/2016
    * @description Tests that FLS is enforced even if field is not selected in SOQL query
    */
    /*static testMethod void flsRestrictedUpdateOfFieldNotSelected(){
        Campaign c1 = new Campaign(Name = 'Test1 Campaign');
        Campaign c2 = new Campaign(Name = 'Test2 Campaign');
        Opportunity o1 = new Opportunity(Name='Original1 Opp',CampaignId=c1.Id,StageName='Won',CloseDate=Date.today());

        System.runAs(new User(Id = UserInfo.getUserId())){
            insert new SObject[]{c1,c2,o1};
        }
        
        System.assert(o1.Id != null);
        
        Opportunity o1Reload = [SELECT Id, Name FROM Opportunity WHERE Id = :o1.Id];
        o1Reload.Name='Updated1 Opp';
        o1Reload.CampaignId = c2.Id;
        
        User newUser = ensureRestrictedUser();
        
        System.runAs(newUser){
            try{
                DMLManagerService.updateAsUser(new Opportunity[]{o1Reload});
                System.assert(false,'Expected a DML Error! newUser shouldn\'t be able to update Opportunity.CampaignId');
            }
            catch(DMLManagerService.FLSException flse){
                //expected
                System.assertEquals(Opportunity.SObjectType,flse.objType);
                System.assertEquals(DMLManagerService.Operation.OP_UPDATE,flse.op);
                System.assertEquals(Opportunity.SObjectType.fields.CampaignId,flse.field);
            }
        }
    }*/
    
    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations succeed for users without CRUD or FLS restrictions
    */
    static testMethod void crudUnrestrictedInsertUpdateDelete(){
        User usr=TestUtils.createAdminUser();
        usr.UserpermissionsMarketinguser=true;
        usr.market__c=null;
        update usr;
        system.runAs(usr){
            Campaign c1 = new Campaign(Name='Test1 Campaign');
            DMLManagerService.insertAsUser(c1);
    
            //Would blow up if the Campaign wasn't inserted (List has no rows for assignment)       
            Campaign c1Reload = [SELECT Id, Name, StartDate FROM Campaign WHERE Id = :c1.Id];
            System.assert(c1Reload.StartDate == null);
    
            c1Reload.StartDate = Date.today();       
    
            DMLManagerService.updateAsUser(c1Reload);
    
            c1Reload = [SELECT Id, Name, StartDate FROM Campaign WHERE Id = :c1.Id];
            System.assertEquals(Date.today(),c1Reload.StartDate);
            
            DMLManagerService.deleteAsUser(c1Reload);
    
            List<Campaign> reloaded = [SELECT Id, Name FROM Campaign];
            System.assertEquals(0,reloaded.size());
    	}
    }

    /**
    
    * @date 6/22/2016
    * @description Tests that DML operations fail for CRUD restricted users
    */
    static testMethod void crudRestrictedInsertUpdateDelete(){
        User newUser = ensureRestrictedUser();

        Campaign c1 = new Campaign(Name='Test1 Campaign');
        System.runAs(new User(Id = UserInfo.getUserId())){
            insert c1;
        }

        System.runAs(newUser) {
            // First try to insert a new object (including field two)
            try{
                Campaign c2 = new Campaign(Name='Test2  Campaign');
                DMLManagerService.insertAsUser(c2);
                System.assert(false,'Expected a DML Error!, newUser shouldn\'t be able to insert a Campaign');
            }
            catch(DMLManagerService.CRUDException crude){
                //expected
                System.assertEquals(Campaign.SObjectType,crude.objType);
                System.assertEquals(DMLManagerService.Operation.OP_INSERT,crude.op);
            }

            // Second, try to update the already inserted (previously) object, including field two
            try{
                c1.Name = 'Updated1 Campaign';
                DMLManagerService.updateAsUser(c1);
                System.assert(false,'Expected a DML Error!, newUser shouldn\'t be able to update a Campaign');
            }
            catch(DMLManagerService.CRUDException crude){
                //expected
                System.assertEquals(Campaign.SObjectType,crude.objType);
                System.assertEquals(DMLManagerService.Operation.OP_UPDATE,crude.op);
            }
            
            try{
                DMLManagerService.deleteAsUser(c1);
                System.assert(false,'Expected a DML Error!, newUser shouldn\'t be able to delete a Campaign');
            }
            catch(DMLManagerService.CRUDException crude){
                //expected
                System.assertEquals(Campaign.SObjectType,crude.objType);
                System.assertEquals(DMLManagerService.Operation.OP_DELETE,crude.op);
            }
        }
    }
    
    /**
    
    * @date 6/22/2016
    * @description Tests that upserts fail when records are set with erroneous ids
    */
    static testmethod void testFailedUpdateWithErroneousId(){
        User usr=TestUtils.createAdminUser();
        usr.UserpermissionsMarketinguser=true;
        usr.market__c=null;
        update usr;
        system.runAs(usr){
            Campaign c1 = new Campaign(Name = 'Test1 Campaign');
            Id cId = null;
        
            insert new SObject[]{c1};
            cId = c1.Id;
            delete c1;
            
            try{
                Campaign c1Resurrected = new Campaign(Id = cId, Name = 'Resurrected Campaign');
                DMLManagerService.upsertAsUser(c1Resurrected);
                System.assert(false,'Expected a DMLManagerServiceException! Attempting to update a record with an erroneous Id should fail');
            }
            catch(DMLManagerService.DMLManagerException dmle){
                //expected
                System.assert(dmle.getMessage().contains('An existing record could not be found'));
            }
		}
    } 
    
    /**
    
    * @date 6/22/2016
    * @description Creates CRUD/FLS restricted user
    * @return User User with restricted CRUD/FLS permissions
    */
    private static User ensureRestrictedUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Read Only']; 
        
        User newUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='crudmanageruser1@testorg.com');
            
        insert newUser;
        
        assignObjectPermission(newUser,'Opportunity',true,true,false);
        
        return newUser;
    }
    
    /**
    
    * @date 6/22/2016
    * @description Creates and assigns a permission set with the given CRUD permissions for a given SObject type to the given user
    */
    private static void assignObjectPermission(User u, String objectType, Boolean create, Boolean edit, Boolean remove){
        PermissionSet ps = new PermissionSet(Name = 'Enable' + objectType, Label = 'Enable ' + objectType);
        insert ps;                                  
                                            
        ObjectPermissions oPerm = new ObjectPermissions(ParentId = ps.Id,
            PermissionsRead = true,
            PermissionsCreate = create,
            PermissionsEdit = edit,
            PermissionsDelete = remove,
            SObjectType = objectType);
            
        insert oPerm;                                   
                    
        PermissionSetAssignment assign = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);                       
        insert assign;                                                  
    }
}