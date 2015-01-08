trigger CalculateLeftHours on Order (before update, before insert) {
    if (!UtilCustomSettings.isEnabled('CalculateLeftHours')) {
        return;
    }
    
    String mbdaOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MBDA Order').getRecordTypeId();
    for(Order tempOrder : trigger.new) {
        if(tempOrder.RecordTypeId == mbdaOrderRecordTypeId) {
            Decimal totalQuantity = (tempOrder.Total_Quantity__c == null)? 0: tempOrder.Total_Quantity__c;
            Decimal usedHours = (tempOrder.Used_hours__c == null)? 0: tempOrder.Used_hours__c;
            Decimal leftHours = totalQuantity - usedHours;
            tempOrder.LeftHours__c = (leftHours > 0)? leftHours: 0;
        }
    }
}