({
   init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            { label: 'Service Number', fieldName: 'Service_Number__c', type: 'text'},
            { label: 'Service Details', fieldName: 'Service_Details__c', type: 'text'},
            { label: 'Service Date', fieldName: 'Service_Date__c', type: 'Date'},
            { label: 'Current Mileage', fieldName: 'Service_Mileage__c', type: 'number',cellAttributes: { alignment: 'left' }},
            { label: 'Repair Order Type', fieldName: 'Pay_Order_Type__c', type: 'text'}
        ]);
        var action = cmp.get('c.getServices');
        action.setParams({
            vehicleId:cmp.get("v.vehicleId")
        });
       
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                cmp.set('v.data', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
        }
    })