@isTest
public class QueryBuilderTest {
static testMethod void callingRunQuery(){


System.debug('@@@Started Query@@@@');
    
/*list<SObject> accountList = QueryBuilderService.RunQuery('Account', null, false, 
QueryBuilderService.BuildRelationshipFilter(new list<String>{'0010l000003YNxOAAW',
'001123456789123458'}, 'Id', true), new List<String>{'Name'}, QueryBuilderService.ASC_DIR_ORDER, 1, true);  */

List<User> standardUser = QueryBuilderService.RunQuery('User', new list<String>{
'Id','FirstName','LastName','Username','Email','ProfileId'}, new list<String>(), 
'Profile.Name = \'System Administrator\' and isActive=true', null, null, 1, false);   
    
System.runAs(standardUser[0]){
  list<SObject> contactList = QueryBuilderService.RunQueryWithoutSharing('Contact', new list<String>{'Id'}, new list<String>(), null, null, null, 1, false);
    
    contactList = QueryBuilderService.RunQueryWithoutSharing('Contact', null, false, null, null, null, 1, false);
}    
    
    System.debug('@@@End Query@@@@'); 


    }

}