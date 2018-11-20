@IsTest
public class AuraLabelHelperTest {

    @IsTest
    public static void simpleAccountTest() {
        List<String> fieldNames = new List<String> ();
        fieldNames.add('Id');
        fieldNames.add('Name');
        fieldNames.add('Customer__c');
        fieldNames.add('Customer__r.Name');

        Map<String, String> result = AuraLabelHelper.retrieveFieldLablesFromFieldList(fieldNames, 'Address__c');
        System.debug(result);
        System.assert(result.containsKey('id'));
        System.assert(result.containsKey('customer__r_name'));

    }

}