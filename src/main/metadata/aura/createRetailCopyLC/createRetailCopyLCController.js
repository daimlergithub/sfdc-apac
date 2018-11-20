({
    doInit : function(component, event, helper) {
        console.log('displaymode' +component.get("v.displayMode"));
        if(component.get("v.displayMode")=='Card Table'){
            helper.retriveCardTableFields(component,helper); //helper method to get Card Table fields
        }
        else{
            helper.retriveDataTableFields(component,helper); //helper method to get Lightning Data Table Fields 
        }
        console.log( JSON.stringify($A.get("$SObjectType.CurrentUser")));
        console.log($A.get("$SObjectType.CurrentUser.Id"));
    },
    
    //function which will set the value for dealer lookup field starts
    setaccDealerValue : function(component, event, helper) {
        var target = event.getParam("selectedValue"); 
        console.log('<<target boo'+target);
        component.set("v.accRec.Main_Dealer__c", target);
    },
    
    radioSelectedAdd: function(component, event, helper) {
        helper.selectedRecordIdhelper(component, event);//helper to get the selected record id in Card Table
    },
    
    createRetailCopy: function(component, event, helper) {
        helper.createRetail(component, helper); //helper to create Retail Copy Record based on Salected Row   
    },
    
    cancelFunction: function(component, event, helper) {
        helper.gotoURL('/'+component.get("v.recordId"),event);    
    },
    
    display : function(component, event, helper) {
        console.log('<<came ere sow');
        //helper.toggleHelperdisplay(component, event);
        if(component.get("v.enablepopupt1")==true){
            console.log('<<came ere sow');
            component.set('v.enablepopupt1',false);    
        }else{
            component.set('v.enablepopupt1',true);
            helper.selectedRecordIdhelperFromButtonClick(component, event);
            var market = component.get('v.userRec.Market__c');
            if(market == 'TH' || market == 'JP' || market == 'KR'){
                component.set("v.tableSelectedhover", 't1');    
            }else{
                component.set("v.tableSelectedhover", 't2');
            }    
        }  
    },
    
    displayOut : function(component, event, helper) {
        console.log('<<came ere not sow');
        //helper.toggleHelper(component, event);
        component.set('v.enablepopupt1',false);
        //helper.selectedRecordIdhelper(component, event);
        console.log('<<aura if is false');
    },
    
    closepopOver: function(component, event, helper) {
        // for Hide/Close Model,set the "enablepopupt1" attribute to "Fasle"  
        component.set("v.enablepopupt1", false);
        
    },
    
    getMainDealerValue: function(component, event, helper) { 
        var targetCmp = event.getSource();    
        console.log('targetCmp-->',targetCmp);
        var accrecValue = component.get("v.accRec") || {};
        console.log('accrecValue-->',accrecValue);
        console.log('targetCmp.get("v.value")-->',targetCmp.get("v.value"));
        accrecValue[targetCmp.get("v.fieldName")] = targetCmp.get("v.value");        
        component.set("v.accRec", accrecValue);
        console.log('accrecValue-->', JSON.stringify(component.get("v.accRec")));
    },
    
    handleSubmit: function(component, event, helper){
        var targetCmp = event.getSource();    
        console.log('targetCmp-->',targetCmp);   
        console.log('targetCmp fields-->',targetCmp.get("v.fields")); 
        console.log('targetCmp objectApiName-->',targetCmp.get("v.objectApiName")); 
        console.log('targetCmp value-->',targetCmp.get("v.value")); 
        console.log('targetCmp value-->',targetCmp.get("v.label")); 
        console.log('targetCmp fieldName-->',targetCmp.get("v.fieldName")); 
    },
    //function to retrieve the selected row on data table and show in RecordForm
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');  
        console.log('row' +row);
        switch (action.name) {    
            case 'show_details':
                helper.showDetails(cmp,row);
                break;    
        }
    },
    
})