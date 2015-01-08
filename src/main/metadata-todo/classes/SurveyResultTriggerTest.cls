/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @isTest
private class SurveyResultTriggerTest{

    static testMethod void testReviewAndChange(){
        User user3 = UtilTestData.createUser('QC SSI', 'CAC QC SV/TQM');

        System.debug('-------user3-------:'+user3);

        System.runAs(user3){
            Survey_Result__c sr1 = new Survey_Result__c(Start1__c='1.是', 
                                                        Start2__c='1.方便',
                                                        S1_S1__c='1.是',
                                                        S1_S2__c='1.一致',
                                                        S1_S3__c='1.自己决定',
                                                        S1_S4__c='2.不在访问日期内',
                                                        S1_Z1__c='9分',
                                                        S1_Z2__c='1.有',
                                                        B1__c='1.男');
            insert sr1;
            sr1 = [SELECT Start1__c, Start2__c, S1_S1__c, S1_S2__c,S1_S3__c, S1_S4__c, S1_Z1__c, S1_Z2__c, B1__c FROM Survey_Result__c WHERE id= :sr1.Id];
            System.debug('更新前Start1__c=' + sr1.Start1__c);
            System.debug('更新前Start2__c=' + sr1.Start2__c);
            System.debug('更新前S1_S1__c=' + sr1.S1_S1__c);
            System.debug('更新前S1_S2__c=' + sr1.S1_S2__c);
            System.debug('更新前S1_S3__c=' + sr1.S1_S3__c);
            System.debug('更新前S1_S4__c=' + sr1.S1_S4__c);
            System.debug('更新前S1_Z1__c=' + sr1.S1_Z1__c);
            System.debug('更新前S1_Z2__c=' + sr1.S1_Z2__c);
            System.debug('更新前B1__c=' + sr1.B1__c);

            Test.startTest();
            sr1.S1_Z1__c='8分';
            update sr1;
            sr1 = [SELECT S1_Z2__c FROM Survey_Result__c WHERE id= :sr1.Id];
            System.assertEquals(sr1.S1_Z2__c, '1.有');

            sr1.S1_S2__c='2.不一致';
            update sr1;
            sr1 = [SELECT S1_S4__c FROM Survey_Result__c WHERE id= :sr1.Id];
            System.assertEquals(sr1.S1_S4__c, null);
            Test.stopTest();
        }
    }
    
    static testMethod void testRemovePrefix(){
        User user2 = UtilTestData.createUser('QC SSI', 'CAC QC SV/TQM');
        
        System.debug('-------user2-------:'+user2);

        System.runAs(user2){
            //Prepare new Survey results
            List<Survey_Result__c> newSurveys = new List<Survey_Result__c>();
            Survey_Result__c sr1 = new Survey_Result__c(S1_S1a__c='-第一个',
                                                        S1_S2a__c='第二个',
                                                        S1_S5a__c='--第三个',
                                                        S1_Z1a__c='-还可以',
                                                        S1_Z2a__c='-还可以');
            newSurveys.add(sr1);
            insert newSurveys;
            Test.startTest();

            sr1 = [SELECT S1_S1a__c, S1_S2a__c, S1_S5a__c, S1_Z1a__c, S1_Z2a__c FROM Survey_Result__c WHERE id= :sr1.Id];
            //System.assertEquals(sr1.S1_S1a__c, '第一个');
            //System.assertEquals(sr1.S1_S2a__c, '第二个');
            //System.assertEquals(sr1.S1_S5a__c, '-第三个');
            // System.assertEquals(sr1.S1_Z1a__c, '还可以');
            // System.assertEquals(sr1.S1_Z2a__c, '还可以');
            Test.stopTest();
        }
    }
    
    static testMethod void testChangeCode(){
        User user1 = UtilTestData.createUser('QC SSI', 'CAC QC SV/TQM');

        System.debug('-------user1-------:'+user1);

        System.runAs(user1){

            // Prepare new Survey results
            List<Survey_Result__c> newSurveys = new List<Survey_Result__c>();
            Survey_Result__c sr1 = new Survey_Result__c(S1_S1__c='',
                                                        S1_S2__c='1',
                                                        S1_S3__c='张', 
                                                        S1_S4__c='张.张', 
                                                        S1_S5__c='1.张', 
                                                        S1_Z1__c='11', 
                                                        DealerName__c='北京奔驰-Patrick-1');
            Survey_Result__c sr2 = new Survey_Result__c(S1_S1__c='', 
                                                        S1_S2__c='2',
                                                        S1_S3__c='小', 
                                                        S1_S4__c='小.小', 
                                                        S1_S5__c='2.小', 
                                                        S1_Z1__c='22', 
                                                        DealerName__c='北京奔驰-Patrick-2');
            
            newSurveys.add(sr1);
            newSurveys.add(sr2);
            insert newSurveys;
            Test.startTest();
            sr1 = [SELECT S1_S1__c,S1_S1_Code__c,S1_S2_Code__c,S1_S3_Code__c,S1_S4_Code__c,S1_S5_Code__c,S1_Z1_Code__c FROM Survey_Result__c WHERE id= :sr1.Id];
            System.debug('Debug Output ======> {' + sr1.S1_S1__c + '}');
            System.assertEquals(sr1.S1_S1_Code__c, null);
            System.assertEquals(sr1.S1_S2_Code__c, '1');
            System.assertEquals(sr1.S1_S3_Code__c, null);
            System.assertEquals(sr1.S1_S4_Code__c, null);
            System.assertEquals(sr1.S1_S5_Code__c, '1');
            System.assertEquals(sr1.S1_Z1_Code__c, '11');

            sr2 = [SELECT S1_S1__c,S1_S1_Code__c,S1_S2_Code__c,S1_S3_Code__c,S1_S4_Code__c,S1_S5_Code__c,S1_Z1_Code__c FROM Survey_Result__c WHERE id= :sr2.Id];
            System.assertEquals(sr2.S1_S1_Code__c, null);
            System.assertEquals(sr2.S1_S2_Code__c, '2');
            System.assertEquals(sr2.S1_S3_Code__c, null);
            System.assertEquals(sr2.S1_S4_Code__c, null);
            System.assertEquals(sr2.S1_S5_Code__c, '2');
            System.assertEquals(sr2.S1_Z1_Code__c, '22');

            sr2.S1_S1__c = '32';
            sr2.S1_S2__c = '';
            sr2.S1_S3__c = '6.';
            update sr2;
            sr2 = [SELECT S1_S1_Code__c, S1_S2_Code__c, S1_S3_Code__c FROM Survey_Result__c WHERE id= :sr2.id];
            System.assertEquals(sr2.S1_S1_Code__c, '32');
            System.assertEquals(sr2.S1_S2_Code__c, null);
            // System.assertEquals(sr2.S1_S3_Code__c, '6');
            Test.stopTest();
        }

    }
}