trigger AddCouponsToOrder on Order (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('AddCouponsToOrder')) {
        return;
    }
    
    String mbdaOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MBDA Order').getRecordTypeId();
    Map<String, Id> couponNameToOrderId = new Map<String, Id>();
    Map<Id, String> errorMessages = new Map<Id, String>();
    Boolean hasMBDAOrder = false;
    if(trigger.isUpdate) {
           for(Order tempOrder : trigger.new) {
            if(tempOrder.RecordTypeId == mbdaOrderRecordTypeId && tempOrder.Coupon_Number__c != trigger.oldMap.get(tempOrder.Id).Coupon_Number__c) {
                hasMBDAOrder = true;
                addCouponToMap(tempOrder.Coupon_Number__c, tempOrder.Id, couponNameToOrderId, errorMessages);
            }
        }
    } else {
        for(Order tempOrder : trigger.new) {
            if(tempOrder.RecordTypeId == mbdaOrderRecordTypeId) {
                hasMBDAOrder = true;
                addCouponToMap(tempOrder.Coupon_Number__c, tempOrder.Id, couponNameToOrderId, errorMessages);
            }
        }
    }
    
    if(hasMBDAOrder)
    {
        if(hasErrors(errorMessages)) {
            return;
        }
        List<MBDA_Coupon__c> relatedCoupons = [select Id, Name, Status__c, Order__c from MBDA_Coupon__c where Name in :couponNameToOrderId.KeySet() and Name != null];
        Map<String, MBDA_Coupon__c> codeToCoupon = new Map<String, MBDA_Coupon__c>();
        for(MBDA_Coupon__c tempCoupon : relatedCoupons) {
            codeToCoupon.put(tempCoupon.Name, tempCoupon);
        }
        
        List<MBDA_Coupon__c> updatedCoupons = new List<MBDA_Coupon__c>();
        for(String tempCouponName : couponNameToOrderId.KeySet()) {
            Id tempOrderId = couponNameToOrderId.get(tempCouponName);
            MBDA_Coupon__c tempCoupon = codeToCoupon.get(tempCouponName);
            if(checkCouponStatus(errorMessages, tempOrderId, tempCoupon, tempCouponName)) {
                updatedCoupons.add(new MBDA_Coupon__c(Id = tempCoupon.Id, Status__c = '使用', Order__c = tempOrderId));
            }
        }
        
        if(hasErrors(errorMessages)) {
            return;
        }
        update updatedCoupons;
    }
    
    private Boolean checkCouponStatus(Map<Id, String> tempErrorMessages, Id tempOrderId, MBDA_Coupon__c tempCoupon, String tempCouponName) {
            if(tempCoupon == null) {
                    String tempErrorMessage = '无法找到 Coupon Number[' + tempCouponName + ']';
                    addErrorMessageToRecordMap(tempOrderId, tempErrorMessage, tempErrorMessages);
                    return false;
            } else if(tempCoupon.Status__c == '使用' && tempCoupon.Order__c != tempOrderId) {
                String tempErrorMessage = 'Coupon Number[' + tempCoupon.Name + '] 状态为：' + tempCoupon.Status__c ;
                addErrorMessageToRecordMap(tempOrderId, tempErrorMessage, tempErrorMessages);
                return false;
            }
            return true;
    }
    
    private Boolean hasErrors(Map<Id, String> tempErrorMessages) {
        if(tempErrorMessages.size() > 0) {
            for(Id tempOrderId : tempErrorMessages.keySet()) {
                    trigger.newMap.get(tempOrderId).addError(tempErrorMessages.get(tempOrderId));
            }
            return true;
        }
        return false;
    }
    
    private void addCouponToMap(String tempCoupons, Id tempOrderId, Map<String, Id> tempCouponNameToOrderId, Map<Id, String> tempErrorMessages) {
        if(tempCoupons != null) {
            List<String> couponList = tempCoupons.split(';');
            for(String tempCoupon : couponList) {
                if(tempCouponNameToOrderId.containsKey(tempCoupon)) {
                    //errorMessages.add(tempOrderId);
                    addErrorMessageToRecordMap(tempOrderId, 'Coupen Code has been in another order.', tempErrorMessages);
                    continue;
                }
                tempCouponNameToOrderId.put(tempCoupon, tempOrderId);
            }
        }
    }
    
    private void addErrorMessageToRecordMap(Id tempOrderId, String tempErrorMessage, Map<Id, String> tempErrorMessages) {
            if(tempErrorMessages.containsKey(tempOrderId)) {
                String tempMessage = tempErrorMessages.get(tempOrderId);
                tempMessage = tempMessage + ' | ' + tempErrorMessage;
                tempErrorMessages.put(tempOrderId, tempMessage);
            } else {
                tempErrorMessages.put(tempOrderId, tempErrorMessage);
            }
    }
}