/** 
* Utility for Trigger on Contact for IN(India)
* Dealer gate keeper validation functionality 
* Author: Honey
* Created Date : 2018-07-11
*/
public class ContactHelperIN { 

    public static void AfterInsertUpdateEvents(List<Contact> contacts){        
        ContactHelperBase.AfterInsertUpdateEvents(contacts);
    } 

    public static void validateGateKeeper(List<Contact> contacts) {
        ContactHelperBase.validateGateKeeper(contacts);
    } 

}