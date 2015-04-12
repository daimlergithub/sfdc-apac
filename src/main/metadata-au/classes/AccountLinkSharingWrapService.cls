/**
** Wrap service for account link to share.
** 1. Wraps "Contact2Contact" account links, find the CRM Code included in the field "Name" and share this record 
**    to the active users of the active dealers having this CRM Code.
** 2. Wraps "ContactSector" account links, find the CRM Code included in the field "Name" and share this record to 
**    the active users of the active dealers having this CRM Code. 
** 3. Wraps "ExternalLink" account links, find the CRM Code included in the field "Name" and share this record to 
**    the active users of the active dealers having this CRM Code. 
** 
** Created By: CC
** Date: 2014-6-11
**/
public class AccountLinkSharingWrapService{
    public AccountLinkSharingWrapService() {
    }
    
    public List<SharingWrapper> wrapAccountLinksByRecordTypes(List<Account_Link__c> accountLinks) {
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        Map<Id, RecordType> accountLinkTypes = new Map<Id, RecordType>([select Id, DeveloperName from RecordType where SObjectType = 'Account_Link__c']);
        List<Account_Link__c> contact2contacts = new List<Account_Link__c>();
        List<Account_Link__c> contactsectors = new List<Account_Link__c>();
        List<Account_Link__c> externallinks = new List<Account_Link__c>();
        for(Account_Link__c accountLink : accountLinks) {
            if(accountLinkTypes.get(accountLink.RecordTypeId) != null) {
                if(accountLinkTypes.get(accountLink.RecordTypeId).DeveloperName.equalsIgnoreCase('contact2contact')) {
                    contact2contacts.add(accountLink);
                } else if(accountLinkTypes.get(accountLink.RecordTypeId).DeveloperName.equalsIgnoreCase('contactsector')) {
                    contactsectors.add(accountLink);
                } else if(accountLinkTypes.get(accountLink.RecordTypeId).DeveloperName.equalsIgnoreCase('externallink')) {
                    externallinks.add(accountLink);
                }
            }
        }
        if(!contact2contacts.isEmpty()) {
            wrappers.addAll(wrapContact2Contact(contact2contacts));
        }
        if(!contactsectors.isEmpty()) {
            wrappers.addAll(wrapContactSector(contactsectors));
        }
        if(!externallinks.isEmpty()) {
            wrappers.addAll(wrapExternalLink(externallinks));
        }
        return wrappers;
    } 
    
    public List<SharingWrapper> wrapContact2Contact(List<Account_Link__c> contact2contacts) {
        return wrapAccountLinks(Schema.Account_Link__Share.RowCause.Contact_To_Contact_Share__c, contact2contacts, 'Read');
    }
    
    public List<SharingWrapper> wrapExternalLink(List<Account_Link__c> contactsectors) {
        return wrapAccountLinks(Schema.Account_Link__Share.RowCause.External_Link_Share__c, contactsectors, 'Read');
    }
    
    public List<SharingWrapper> wrapContactSector(List<Account_Link__c> externallinks) {
    	
        return wrapAccountLinks(Schema.Account_Link__Share.RowCause.Contact_Sector_Share__c, externallinks, 'Read');
    }
    
    private List<SharingWrapper> wrapAccountLinks(String rowCause, List<Account_Link__c> accountLinks, String accessLevel) {
        UserService userService = new UserService();
        Map<String, Set<Id>> crmCode2Users = userService.mapCrmCode2Users(accountLinks);

        Map<Id, Set<Id>> accountLink2Users = new Map<Id, Set<Id>>();
        for(Account_Link__c accountLink : accountLinks) {
                String crmCode =AccountLinkHelper.nameParsing(accountLink.Name);
                if(crmCode2Users.get(crmCode) != null) {
                    accountLink2Users.put(accountLink.Id, crmCode2Users.get(crmCode));
                }
        }
        return SharingWrapperService.wrapSharings(accountLink2Users, rowCause, accessLevel);
    }
}