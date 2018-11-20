({
    // initialisation function - retrieves the Market specific fields from the Apex Controller 
    // Gets the Market specific object (AccountContactDetailsFactoryWrapper) from Factory Model
    getFields: function(component, event, helper) {
        //call apex class method 
        var action = component.get('c.fetchFields');
        var params={"componentName":$A.get("$Label.c.AccountContactDetails")};
        action.setParams(params);
        //var self = this;
        action.setCallback(this, function(response){        
            helper.actionResponseHandler(component, response, helper, function(resObject,helper){ 
                try {
                    component.set('v.responseObject',resObject);
                    //Parse the response Object Input Fields into local Aura Variable
                    var arrayMapKeys = [];
                    for(var key in resObject.inputFieldsMap){
                        arrayMapKeys.push({key: key, value: resObject.inputFieldsMap[key]});
                    }
                    component.set("v.inputMap", arrayMapKeys);
                    console.log('inputMap' +component.get('v.inputMap'));
                    //Parse the response Object Output Fields into local Aura Variable
                    var arrayMapKeys = [];
                    for(var key in resObject.outputFieldsMap){
                        arrayMapKeys.push({key: key, value: resObject.outputFieldsMap[key]});
                    }
                    component.set("v.outputMap", arrayMapKeys);
                    console.log('outputMap' +component.get('v.outputMap'));
                    //Parse the response Object Label Map into local Aura Variable
                    var arrayMapKeys = [];
                    for(var key in resObject.labelTHMap){
                        arrayMapKeys.push({key: key, value: resObject.labelTHMap[key]});
                    }
                    component.set("v.labelMap", arrayMapKeys);
                    //Parse the response Object APILabel Map into local Aura Variable
                    var arrayMapKeys = [];
                    for(var key in resObject.apiLabelMap){
                        arrayMapKeys.push({key: key, value: resObject.apiLabelMap[key]});
                    }
                    component.set("v.apiLabelMap", arrayMapKeys);
                    component.set("v.iconMap", resObject.iconTHMap)
                    console.log('apiLabelMap' +JSON.stringify(component.get('v.apiLabelMap')));
                    console.log('inputFieldsMap' +JSON.stringify(component.get('v.inputMap')));
                    console.log('outputFieldsMap' +JSON.stringify(component.get('v.outputMap')));
                    console.log('labelMap' +JSON.stringify(component.get('v.labelMap')));
                }
                catch (e) {
                    var errMsg ='Something is wrong : '    + e ;
                    helper.showToast('sticky', 'Error', errMsg);
                }
            })       
        });
        // enqueue the Action   
        $A.enqueueAction(action);
    },
    // generic action method response handler - carries out error checking
    // and assuming successful invokes the supplied callback, including the
    // callback data
    actionResponseHandler : function (component, response, helper, test) {
        try
        { 
            var resObject = response.getReturnValue();
            //store response state 
            var state = response.getState();
            if (state === "SUCCESS") {
                if (resObject) {
                    test(resObject,helper);
                } else {
                    throw new Error('Call to SFDC returned an empty response');
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var errMsg = 'Factory Response Error : ' + errors[0].message;
                        helper.showToast('sticky', 'Error', errMsg);
                    } else {
                        var errMsg = 'Factory Response Error : ' + JSON.stringify(errors);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                } else {
                    throw new Error('Call to SFDC returned an empty error');
                }
            } else {
                // Neither success nor error
                console.log('Call ended with status:' + state);
                helper.showToast('sticky', 'Warning', state);
            }
        } catch (e) {
            var errMsg = 'Operation failed, please file a support request : ' + e;
            helper.showToast('sticky', 'Error', errMsg);
        }
    },
    //Funtion to show Toast Message on Record Save
    onSuccess: function(component, event, helper) {
        var successMsg ='The record has been updated successfully.';
        helper.showToast('sticky', 'Success', successMsg);
        component.set('v.EditEnabled', false);
        var getevent =	component.getEvent("saveMessage"); 
    getevent.setParams({
      recordTypeName : 'Success'
    });
    getevent.fire(); 
        //return 'Success';
        
    },
    //Toggle fucntion to switch between Edit mode and View Mode
    toggleEditMode: function(component, event, helper) {
        if(component.get('v.EditEnabled')==false){
            component.set('v.EditEnabled', true);
        }else{
            component.set('v.EditEnabled', false);
        }
    },
    //Function to show Toast on Error in Record Edit Form
    handleError : function(component, event, helper) {
        var eventsrc = event.getSource();
        var eventsrtt = event.getParam("errors");
        var eventname = event.getName();
        console.log('>>err'+JSON.stringify(event.getParam("errors")));
        console.log('<<errtes'+event.getName());
        //console.log('<<errtes'+eventsrtt.message);
        component.set('v.EditEnabled', true);
        //helper.showToast('sticky', 'Error','Error.');
         var getevent =	component.getEvent("saveMessage"); 
    getevent.setParams({
      recordTypeName : 'Error'
    });
    getevent.fire(); 
        //return 'Error';
    },
    //Show all toast messages
    showToast: function(mode, type, message) {
        console.log("entered into toast");
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({
            mode: mode,
            type: type,
            message: message
        });
        toastEvent.fire();
        $A.get("e.force:refreshView").fire();
    },
})