({
	doInit : function(component, event, helper) {
        //Data table
       	component.set('v.mycolumns', [
            { label: 'Vehicle Model', fieldName: 'Vehicle_Model__c', type: 'text'},
            { label: 'Vehicle Brand', fieldName: 'Vehicle_Brand__c', type: 'text'},
            { label: 'Vehicle Class', fieldName: 'Vehicle_Class__c', type: 'text'},
            { label: 'Mileage Start', fieldName: 'Mileage_start__c', type: 'text'},
            { label: 'Mileage End', fieldName: 'Mileage_End__c', type: 'text'}
        ]);
      helper.retrieverecords(component, event, helper);  
    },  
    getId : function(component, event, helper) {
       component.set("v.accId", event.getParam("AccId"));
        helper.retrieverecords(component, event, helper);
            }
})