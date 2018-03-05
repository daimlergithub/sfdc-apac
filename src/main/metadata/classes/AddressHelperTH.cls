/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Mohammed Touseef Ahmed
*/
public with sharing class AddressHelperTH {

    /**             
     * @Description: Updates Primary Address related details on account once Preferred__c is checked.
     * @author     : Mohammed Touseef Ahmed
     * @Date       : 02/07/2017
     * @param      : list of new addresses 
     * @return     : void
     * @see:       : AddressHelperTH
     */

    public static void updateAcclinkAddress(list < Address__c > listNewAddress) {
        Set < Id > addrssId = new Set < Id > ();
        List < Account_Link__c > alUpdate = new List < Account_link__c > ();
        for (Address__c addr: listNewAddress) {
            if (!addr.Preferred__c) {
                addrssId.add(addr.Id);
            }
        }
        Map < Id, Account_link__c > alMap = new Map < Id, Account_link__c > ();
        for (Account_link__c al: [select id, Retail_Address_Reference__c, Retail_Address_Type__c, Retail_Province__c, Retail_City__c, Retail_Distinct__c, Retail_Address_Line_1__c, Retail_Address_Line_2__c, Retail_ZipCode__c from Account_link__c where Retail_Address_Reference__c in: addrssId]) {
            alMap.put(al.Retail_Address_Reference__c, al);
        }
        for (Address__c addr: listNewAddress) {
            if (!addr.Preferred__c && alMap.containskey(addr.Id)) {
                //alMap.get(addr.Id).Retail_Address_Reference__c = addr.Id;
                alMap.get(addr.Id).Retail_Address_Type__c = addr.Address_Type__c;
                alMap.get(addr.Id).Retail_Province__c = (addr.Province__c != null ? addr.Province__c : '');
                alMap.get(addr.Id).Retail_City__c = (addr.Sub_District__c != null ? addr.Sub_District__c : '').left(35);
                alMap.get(addr.Id).Retail_Distinct__c = ((addr.District__c != null ? addr.District__c : '') + (addr.Block__c != null ? addr.Block__c : '')).left(35);
                alMap.get(addr.Id).Retail_Address_Line_1__c = ((addr.Address_Line_1__c) != null ? addr.Address_Line_1__c : '').left(35);
                alMap.get(addr.Id).Retail_Address_Line_2__c = ((addr.Address_Line_2__c) != null ? addr.Address_Line_2__c : '').left(35);
                alMap.get(addr.Id).Retail_ZipCode__c = (addr.ZipCode__c != null ? addr.ZipCode__c : '');
                alUpdate.add(alMap.get(addr.Id));
            }
        }
        if (alUpdate.size() > 0)
            update alUpdate;
    }

    public static void updateAddressOnAccount(list < Address__c > listNewAddress) {
        Set < Id > AccIdSet = new Set < Id > ();
        map < Id, Account > updateAccntMap = new map < Id, Account > ();
        list < Account > updateAccntList = new list < Account > ();
        List < Account > accList = new List < account > ();
        for (Address__c addr: listNewAddress) {
            if (addr.preferred__c) {
                if (string.isnotblank(addr.Customer__c)) AccIdSet.add(addr.Customer__c);
                if (string.isnotblank(addr.Customer__c)) acclist.add(new account(id = addr.Customer__c));
            }
        }
        if (AccIdSet != null && !AccIdSet.isEmpty()) {
            //List<Account> accList = [select id,Primary_Address__c from Account where id in : AccIdSet Limit 10];     
            if (accList != null && !accList.isEmpty()) {
                for (Account acc: accList) {
                    for (Address__c addr: listNewAddress) {
                        if (acc.Id == addr.Customer__c) {
                            if (addr.Address_Line_1__c != null && addr.Address_Line_1__c != '')
                                acc.Primary_Address__c = addr.Address_Line_1__c;
                            if (addr.Address_Line_2__c != null && addr.Address_Line_2__c != '')
                                acc.Primary_Address__c += ' ' + addr.Address_Line_2__c;
                            if (addr.Sub_District__c != null && addr.Sub_District__c != '')
                                acc.Primary_Address__c += ' ' + addr.Sub_District__c;
                            if (addr.District__c != null && addr.District__c != '')
                                acc.Primary_Address__c += ' ' + addr.District__c;
                            if (addr.Province__c != null && addr.Province__c != '')
                                acc.Primary_Address__c += ' ' + addr.Province__c;
                            if (addr.Country__c != null && addr.Country__c != '')
                                acc.Primary_Address__c += ' ' + addr.Country__c;
                            if (addr.ZipCode__c != null && addr.ZipCode__c != '')
                                acc.Primary_Address__c += ' ' + addr.ZipCode__c;
                            updateAccntMap.put(acc.Id, acc);
                        }
                    }
                    if (updateAccntMap.containsKey(acc.Id) && acc.Id != null) {
                        updateAccntList.add(updateAccntMap.get(acc.Id));
                    }
                }
            }
        }
        if (updateAccntList != null && !updateAccntList.isEmpty()) {
            update updateAccntList;
        }

    }

    /**             
     * @Description: Gives arror message if we try to enter Address with same  Address_Type__c for an account
     * @author     : Mohammed Touseef Ahmed
     * @Date       : 02/07/2017
     * @param      : list of new addresses 
     * @return     : void
     * @see:       : AddressHelperTH
     */
    public static void validateSameAddressType(List < Address__c > triggerNew, map < id, Address__c > addressOldMap, boolean isInsert, boolean isUpdate) {
        set < id > accountId = new set < id > ();
        if (IsInsert) {
            //get the related accountIds
            for (Address__c add: triggerNew) {
                accountId.add(add.Customer__c);
            }

            for (Address__c addresList: [select Address_Type__c from Address__c where Customer__c IN: accountId]) {
                for (Address__c addType: triggerNew) {
                    if (
                        (addType.MD__c == Label.TH) &&
                        (addType.Address_Type__c == 'Home' || addType.Address_Type__c == 'Business') &&
                        (addresList.Address_Type__c == addType.Address_Type__c)
                    ) {
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);
                    }
                }

            }

        }
        if (isUpdate) {
            for (Address__c add: triggerNew) {
                Address__c oldaddress = addressOldMap.get(add.Id);
                if (oldaddress.Address_Type__c != add.Address_Type__c) {
                    accountId.add(add.Customer__c);
                }
            }
            for (Address__c addresList: [select Address_Type__c from Address__c where Customer__c IN: accountId]) {
                for (Address__c addType: triggerNew) {
                    if ((addType.MD__c == Label.TH) && (addType.Address_Type__c == 'Home' || addType.Address_Type__c == 'Business') &&
                        ((addresList.Address_Type__c == addType.Address_Type__c) && (addType.Address_Type__c != null))) {
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);
                    }
                }
            }
        }
    }

    /**             
     * @Description: update Primary_Address_Display__c field on account on update of address
     * @author     : Mohammed Touseef Ahmed
     * @Date       : 02/07/2017
     * @param      : list of new addresses 
     * @return     : void
     * @see:       : AddressHelperTH
     */

    public static void updatePrimaryAddressOnAccount(map < ID, Address__c > newMap) {

        set < id > accountId = new set < id > ();
        list < Account > accountList = new list < Account > ();

        //get the related accountIds
        for (Address__c add: newMap.values()) {
            accountId.add(add.Customer__c);
        }

        for (Account acc: [select id, Primary_Address_Reference__c from Account where id IN: accountId]) {
            if ((acc.Primary_Address_Reference__c != null) && (newMap.containsKey(acc.Primary_Address_Reference__c))) {
                if (newMap.get(acc.Primary_Address_Reference__c).Customer__c == acc.id) {
                    Address__c add = newMap.get(acc.Primary_Address_Reference__c);
                    acc.Primary_Address_Display__c = add.Province__c + add.City__c + add.District__c + add.Block__c + add.Address_Line_1__c + add.Address_Line_2__c;
                    accountList.add(acc);
                }
            }
        }

        if (!accountList.isEmpty() || accountList != null) {
            update accountList;
        }


    }

    /**             
     * @Description: update Account on Delete of address       
     * @Date       : 15/11/2016
     * @param      : list of old addresses 
     * @return     : void
     * @see:       : AddressHelperTH
     */

    public static void updateAccountonDeletion(List < Address__c > OldAddress) {
        set < id > accountId = new set < id > ();
        list < Account > accountList = new list < Account > ();
        //get the related accountIds
        for (Address__c add: OldAddress) {
            accountId.add(add.Customer__c);
            System.debug('Customer__c' + accountId);
        }

        for (Account acc: [select id, Primary_Address_Reference__c, Customer_LastUpdatedDate__c from Account where id IN: accountId]) {
            acc.Customer_LastUpdatedDate__c = Datetime.now();
            System.debug('Customer__date' + acc.Customer_LastUpdatedDate__c);
            accountList.add(acc);
        }

        if (!accountList.isEmpty() || accountList != null) {
            update accountList;
        }


    }
    /**             
     * @Description: update Account on delete/insert/update of address       
     * @Date       : 15/11/2016
     * @param      : list of old addresses 
     * @return     : void
     * @see:       : AddressHelperTH
     */
    public static void updateAddressCDM(List < Address__c > Address, string MarketDiscriminator, string updateType) {
        set < id > accountId = new set < id > ();
        list < Account > accountList = new list < Account > ();
        //get the related accountIds
        for (Address__c add: Address) {
            accountId.add(add.Customer__c);
        }
        if (accountId.size() > 0) {
            for (Account acc: [select id, recordtypeid from Account where id IN: accountId]) {
                accountList.add(acc);
            }
            try {

                set < ID > accids = new set < ID > ();
                for (Account accrec: accountlist) {
                    accids.add(accrec.id);
                }
                CDMInformatica_Services.createCustomerCDM(accids, MarketDiscriminator, updateType);
            }
            Catch(exception e) {
                CustomLogUtil.CustomLoggingEntry('Error Occured' + e.getmessage() + '-- ' + e.getlinenumber());
            }
        }
    }
    /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List < Address__c > addList) {

        for (Address__c addr: addList) {
            if (Test.isRunningTest()) {
                addr.isTestRunning__c = true;
            }
            if (addr.Market__c == '' || addr.Market__c == NULL) {
                addr.Market__c = addr.MD__c;
            }
        }
    }
}