({    
    editRecord : function(component, event, helper) 
    {
        component.set("v.editIt",true);
        console.log(component.get("v.addressObj").Id);
    }, 
   
    ConfirmdeleteRecord : function(component, event, helper) 
    {
        component.set("v.deleteit",true);        
    },
    
    
    closeModel: function(component, event, helper) {     
        component.set("v.deleteit", false);
    },
    
    
    deleteRecord : function(component, event, helper) 
    {
       try
       {
        var action =component.get("c.deleteRecordDB");
        
        action.setParams({
            deleterecid : component.get("v.addressObj").Id
        });
        
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
			    
                var compEvent = component.getEvent("AddressDeleted");
                compEvent.setParam("indexDeleted", component.get("v.index"));
			    compEvent.fire();  
			    
                component.set("v.deleteit",false);
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({	title: "Success!",
                                          	message: "Record Deleted",
                        					type: "success",
                                          duration: "500"
                    					});
                    toastEvent.fire();
            }
           else if (state === "ERROR") 
           {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var errMsg = 'Backend Response Error : ' + errors[0].message;
                        helper.showToast('sticky', 'Error', errMsg);
                    } else {
                        var errMsg = 'Backend Response Error : ' + JSON.stringify(errors);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                } else {
                    helper.showToast('Call to SFDC returned an empty error');
                }
            } 
               else {
                // Neither success nor error
                console.log('Call ended with status:' + state);
                helper.showToast('sticky', 'Warning', state);
            }
        });
        $A.enqueueAction(action);
       }
        catch (e) 
        {
            var errMsg = 'Operation failed, please file a support request : ' + e;
            helper.showToast('sticky', 'Error', errMsg);
        }
    },
    
    viewRecord:function(component, event, helper) {
        component.set("v.recordView",true);                 
    },
    
    cancelViewRecord: function(component, event, helper) {
        component.set("v.recordView",false);
    }
})