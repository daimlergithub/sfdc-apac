({
    fetchFactFields : function(component,event, helper)
    {
        try
        {
            var retriveFields = component.get("c.getFactoryFields");
            retriveFields.setParams({
                recordId: component.get("v.recordId"),
                componentName:'InlineAddressLightning',   
                accountRecordType: component.get("v.objAccount").RecordType.Name
            });
            retriveFields.setCallback(this, function(response) 
            {
                var valRes = response.getState();            
                if (valRes === "SUCCESS") 
                {
                    var factoryResponseObj = response.getReturnValue();
                    component.set("v.displayListAddress",factoryResponseObj.factoryFieldsMap['inputFields']);
                    component.set("v.displayOutputFieldListAddress",factoryResponseObj.factoryFieldsMap['outputFields']);
                    component.set("v.displaySidebarFields",factoryResponseObj.factoryFieldsMap['outputSideBarFields']);
                    component.set("v.lstAddresses", factoryResponseObj.addressList);
                    component.set("v.maxAddressCount",factoryResponseObj.maxAddressCount);
                    helper.checkLstAddressSize(component,event,helper);
                }
                else if (valRes === "ERROR") 
                {
                    var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            var errMsg = 'Backend Response Error : ' + errors[0].message;
                            helper.showToast('sticky', 'Error', errMsg);
                        } 
                        else 
                        {
                            var errMsg = 'Backend Response Error : ' + JSON.stringify(errors);
                            helper.showToast('sticky', 'Error', errMsg);
                        }
                    } 
                    else 
                    {
                        throw new Error('Call to SFDC returned an empty error');
                    }
            	} 
                else 
                {
                    // Neither success nor error
                    console.log('Call ended with status:' + valRes);
                    helper.showToast('sticky', 'Warning', valRes);
                }
                
            });
            $A.enqueueAction(retriveFields);
        }
        catch (e) 
        {
            var errMsg = 'Operation failed, please file a support request : ' + e;
            helper.showToast('sticky', 'Error', errMsg);
        }
        
    },
    
    checkLstAddressSize : function(component,event,helper)
    {
        try
        {
            var lstAddress = component.get("v.lstAddresses"); 
            if(lstAddress.length == component.get("v.maxAddressCount"))
                component.set("v.disableAddMoreAddress",true) ;
            else
                component.set("v.disableAddMoreAddress",false) ;  
        }
        catch (e) 
        {
            var errMsg = 'Operation failed, please file a support request : ' + e;
            helper.showToast('sticky', 'Error', errMsg);
        }          
    },
    
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
    }
})