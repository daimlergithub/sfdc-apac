@isTest(SeeAllData=false)

public class RecordTypeAccessServiceTest{
    
static testMethod void callingRunQuery(){


ID myid=RecordtypeAccessService.getRecordTypeId('Account','Dealer');

string name=RecordtypeAccessService.getRecordTypeName('Account','012280000000f0p');

}}