({
	doInit: function (component, event, helper) {
        var actions = [
            { label: 'Edit', name: 'Edit' },
        ];
        component.set('v.mycolumns', [
            { label: 'Trade In Vehicle', editable:'false',fieldName: 'Trade_In_Vehicle__c', type: 'text'},          
            { label: 'Year of Manufacture', editable:'false',fieldName: 'Year_of_Manufacture__c', type: 'text'},
            { label: 'Mileage',editable:'false',fieldName: 'Mileage__c', type: 'text'},
            { label: 'Trim', editable:'false',fieldName: 'Trim__c', type: 'text'},
            {type:  'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.getRecordTypeID(component,event,helper);  
        if(component.get("v.recId") != null && component.get("v.recId") != "")
        {
           helper.retrieveTradeInVehicles(component,event,helper);
        }
    },
    editCard : function(component, event, helper) 
    {
        component.set("v.displayType","Card");
        var rowIndex = event.getSource().get("v.alternativeText");
        var row= component.get("v.tradeInVehiclesList")[rowIndex];
        //debugger;
        // to populate values in model box... invoke below helper method
        component.set("v.TradeInVeh",row['Trade_In_Vehicle__c']);
        component.set("v.YearOfManuf",row['Year_of_Manufacture__c']);
        component.set("v.Mileage",row['Mileage__c']);
        component.set("v.Trim",row['Trim__c']);
        component.set("v.TVehId",row['Id']);
        //open model:
        component.set("v.isOpen","true"); 
    }, 
    handleRowAction: function (component, event, helper) {
        //component.set("v.tableAction","Edit"); 
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit':
                component.set("v.TradeInVeh",row['Trade_In_Vehicle__c']);
        		component.set("v.YearOfManuf",row['Year_of_Manufacture__c']);
        		component.set("v.Mileage",row['Mileage__c']);
        		component.set("v.Trim",row['Trim__c']);
        		component.set("v.TVehId",row['Id']);
                //component.set("v.tempValue",row['Car_Model__c']);
                // to populate values in model box... invoke below helper method
                component.set("v.isOpen","true"); 
                break;
        }
    },
    handleNew:function (cmp, event, helper) {
        cmp.set("v.isOpen","true");
        
    },
    closeModel:function (cmp, event, helper) {
        cmp.set("v.isOpen","false");
        if(cmp.get("v.showError"))
        {
            cmp.set("v.isNewVisible","true");
        }
        cmp.set("v.showError",false);
        helper.retrieveTradeInVehicles(cmp,event,helper);
    },
    handleSubmit: function(cmp, event, helper) {
      var eventFields = event.getParam("fields");
      event.preventDefault(); // stop form submission
      var obj=[];
      obj.push(eventFields);
      //for storing data from model box(recordEditForm)
      if(cmp.get("v.TVehId")!= null)
      {
        obj[0].Id=cmp.get("v.TVehId");   
      }
      //debugger;  
      cmp.set("v.tradeInVehiclesList",obj);
      helper.saveRecord(cmp,event,helper);
    },
    handleSuccess:function(component,event,helper){    
        component.set("v.isOpen","false");
        var toastEvent = $A.get("e.force:showToast");        
        toastEvent.setParams({
            mode: 'dismissible',
            message: 'Record Saved Successfully!',
            type : 'success'            
        }); 
        toastEvent.fire();        
        helper.retrieveTradeInVehicles(component,event,helper);
    },   
  /*  onSave:function(component,event,helper){
        component.set("v.displayType","List");
        event.stopPropagation();
        var draftValues = event.getParam('draftValues');
        var tempVehicleList = component.get("v.tradeInVehiclesList");
        for(var j=0;j<tempVehicleList.length;j++){
            for(var i=0;i<draftValues.length;i++){
                for(var key in draftValues[i]){
                    tempVehicleList[j][key] = draftValues[i][key];
                }
                delete tempVehicleList[j]['Id'];  
            }
        }component.set("v.tradeInVehiclesList",tempVehicleList);  
        helper.saveRecord(component,event,helper);           
      },*/
    getId : function(component, event, helper) {
                component.set("v.recId", event.getParam("OppId"));
                helper.saveRecord(component, event, helper);          
            }   
})