/*
*    This trigger will sum duration on Reseration Event to related order.
1, When we insert Reserved event, the trigger will reCalculate the used hours on the Order.
2, When we update a Reserved event, the trigger will reCalculate the used hours on the order.
3, When we delete a Reserved event, the trigger will reCalculate the used hours on the order.
*/
trigger SumReservationDurationToOrder on Event (after delete, after insert, after update) {
    if (!UtilCustomSettings.isEnabled('SumReservationDurationToOrder')) {
        return;
    }
    
    String mbdaOrderPrefix = Schema.SObjectType.Order.getKeyPrefix();
    String reservationEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MBDA-Reservation').getRecordTypeId();
    Set<Id> relatedOrderIds = new Set<Id>(); // This set will store all relate order ids.
    // Add By Chaos for MBDA START
    Map<Id, Datetime> lastDateMap = new Map<Id, Datetime>();
    // Add By Chaos for MBDA END
    
    if(trigger.isInsert) {
        for(Event tempEvent : trigger.new) {
            if(tempEvent.RecordTypeId == reservationEventRecordTypeId && isUsed(tempEvent)) {
                if(tempEvent.WhatId == null || (!String.valueOf(tempEvent.WhatId).startsWith(mbdaOrderPrefix))) {
                    tempEvent.WhatId.addError('MBDA Event must relate to Order!');
                    return;
                }
                relatedOrderIds.add(tempEvent.WhatId);
                // Add By Chaos for MBDA START
                lastDateMap.put(tempEvent.WhatId, tempEvent.EndDateTime);
                // Add By Chaos for MBDA END
            }
        }
    }
    if(trigger.isUpdate) {
        for(Event tempEvent : trigger.new) {
            if(tempEvent.RecordTypeId == reservationEventRecordTypeId) {
                if(tempEvent.WhatId == null || (!String.valueOf(tempEvent.WhatId).startsWith(mbdaOrderPrefix))) {
                    tempEvent.WhatId.addError('MBDA Event must relate to Order!');
                    return;
                }
                relatedOrderIds.add(tempEvent.WhatId);
                // Add By Chaos for MBDA START
                lastDateMap.put(tempEvent.WhatId, tempEvent.EndDateTime);
                // Add By Chaos for MBDA END
            }
        }
    }
    if(trigger.isDelete) {
        for(Event tempEvent : trigger.old) {
            if(tempEvent.RecordTypeId == reservationEventRecordTypeId && isUsed(tempEvent)) {
                relatedOrderIds.add(tempEvent.WhatId);
            }
        }
    }
    
    if(relatedOrderIds.size() > 0) {
        List<Order> udpateOrders = new List<Order>();
        AggregateResult[] groupedResults = [select WhatId OrdId, SUM(DurationInMinutes) DurSum from Event where WhatId in :relatedOrderIds and RecordTypeId = :reservationEventRecordTypeId and (Activity_Status__c != 'Cancelled' and Activity_Status__c != '已取消' and Activity_Status__c != null) and WhatId != null group by WhatId];
        Map<Id, Decimal> aggregateMap = new Map<Id, Decimal>();
        for(AggregateResult tempResult : groupedResults) {
             Decimal tempSumHoursForOrder = (Decimal)tempResult.get('DurSum') / 60.0;
             String tempOrderId = (String)tempResult.get('OrdId');
             aggregateMap.put(tempOrderId, tempSumHoursForOrder);
        }
        for(Id tempOrderId : relatedOrderIds) {
            if(aggregateMap.containsKey(tempOrderId)) {
                // Modify By Chaos for MBDA START
                //udpateOrders.add(new Order(Id = tempOrderId, Used_hours__c = aggregateMap.get(tempOrderId)));
                udpateOrders.add(new Order(Id = tempOrderId, Used_hours__c = aggregateMap.get(tempOrderId), Last_Event_End_Date__c = lastDateMap.get(tempOrderId)));
                // Modify By Chaos for MBDA END
            }
            else {
                udpateOrders.add(new Order(Id = tempOrderId, Used_hours__c = 0, Last_Event_End_Date__c = null));
            }
        }
        update udpateOrders;
    }
    
    private Boolean isUsed(Event tempEvent) {
        Boolean result = false;
        if(tempEvent.Activity_Status__c != 'Cancelled' && tempEvent.Activity_Status__c != null) {
            return true;
        }
        return result;
    }
}