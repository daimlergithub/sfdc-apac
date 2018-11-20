({
	doInit : function(component, event, helper) {
    	 if(component.get("v.recId") != null)
        {
        helper.retrieverecords(component, event, helper);  // helper function to retrieve the field Sets 
        }
         var actions = [
            { label: 'Edit', name: 'Edit' },
        ];
        component.set('v.mycolumns', [
            { label: 'Preferred',fieldName: 'Preferred__c', type: 'boolean'},          
            { label: 'Car Model',fieldName: 'RModel', type: 'text'},
            { label: 'Brand',fieldName: 'Brand__c', type: 'text'},
            { label: 'Class',fieldName: 'Class__c', type: 'text'},
            { label: 'Color',fieldName: 'Color__c', type: 'text'},
            {type:  'action', typeAttributes: { rowActions: actions } }
        ]);
    },
    editRecord : function(component, event, helper) 
    {
        component.set("v.tableAction","Edit"); 
        component.set("v.displayType","Card");
        component.set("v.isDuplicate",false);
        component.set("v.compVehiclesListForCancel",component.get("v.compVehiclesList"));
        var rowIndex = event.getSource().get("v.alternativeText");
        var row= component.get("v.compVehiclesList")[rowIndex];
        component.set("v.tempValue",row['Car_Model_Competitor__c']);
        // to populate values in model box... invoke below helper method
        helper.carModelChangeSC(component, event, helper);
        component.set("v.isOpen","true"); 
    }, 
    handleRowAction: function (component, event, helper) {
        component.set("v.tableAction","Edit");
        component.set("v.isDuplicate",false);
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit':
                component.set("v.tempValue",row['Car_Model_Competitor__c']);
                helper.carModelChangeSC(component, event, helper);
                component.set("v.isOpen","true"); 
                break;
        }
    },
	radioSelectedAdd: function(component, event, helper) {
        helper.selectedRecordIdhelper(component, event);
    },
    
    enableDisableEditableMode: function(component, event, helper) {
        if(component.get('v.editableMode')==false){
            component.set('v.editableMode', true);
        }else{
            component.set('v.editableMode', false);
        }
    },
    
	addCompVehicleRow : function(component, event, helper){
       component.set("v.isDuplicate",false);
       component.set("v.tableAction","New");
       component.set("v.brand","");component.set("v.tempValue","");component.set("v.color","");
       component.set("v.class","");component.set("v.leadDetail",""); component.set("v.Index",""); component.set("v.Preferred",""); 
       var intvehicles = component.get("v.compVehiclesList");
       var intVehicleforcancel = component.get("v.compVehiclesListForCancel"); 
       component.set("v.compVehiclesListForCancel",intvehicles);
        var len = intvehicles.length;
        intvehicles.push({
            'Related_Lead__c':component.get("v.recId")+len
            
        });
        component.set("v.compVehiclesList",intvehicles);
        component.set("v.isOpen","true");
    },
    
    toggleDiv:function(component, event, helper) {            
        var targetCmp = event.getSource();  
        var target = event.getParam("idToToggle");
        console.log('<<target'+target);
        var acc = component.find(target);
         console.log('<<acc'+acc);
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
    },
     carModelChangeSC: function(component, event, helper) {
     helper.carModelChangeSC(component, event, helper);
    },
    cancel: function(component, event, helper) {
        component.set("v.isDuplicate",false);
        helper.cancel(component, event, helper);       
    },
   closeModel: function(component, event, helper) {
        component.set("v.tableAction","Close") ; 
        helper.cancel(component, event, helper);       
    }, 
   commitIntrestedVehicles: function(component, event, helper) {
        component.set("v.isDuplicate",false);
        var listVeh= component.get("v.carmodellist"); 
        var index= component.get("v.preferredrowindex");
        //debugger;
        for (var i = 0; i < listVeh.length; i++) {
          if(i == index)
           {
               listVeh[i].Preferred__c=true;                 
           }
           else{
            listVeh[i].Preferred__c=false; 
           } 
          }
        component.set("v.compVehiclesList",listVeh); 
        component.set("v.isOpen","false");
       //invoke below helper method ...once we get Oppty ID
        if(component.get("v.recId") != null)
        {
         helper.commitIntVehicles(component, event, helper);  
        }
        //$A.get('e.force:refreshView').fire();  
    },
     handleSuccess:function(component,event,helper){    
        component.set("v.isOpen","false");
        var toastEvent = $A.get("e.force:showToast");        
        toastEvent.setParams({
            mode: 'dismissible',
            message: 'Record Saved Successfully!',
            type : 'success',
            duration:'0.5',
        }); 
        toastEvent.fire();        
    },   
    getId : function(component, event, helper) {
     component.set("v.recId", event.getParam("OppId"));
     helper.commitIntVehicles(component, event, helper);          
     }
})