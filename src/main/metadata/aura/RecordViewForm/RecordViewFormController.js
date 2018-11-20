({
    doInit : function(component, event, helper) 
	{
        var data = component.get("v.data");
    },
    
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_more':
                var modalBody;
                $A.createComponent( "c:RecordFullViewForm",
                                   {
                                       recordId : row.Id.replace('/',''),
                                       Fields   : component.get('v.Allcolumns'),
                                       objectApiName: component.get('v.objectApiName')
                                   },
                                   function(content, status) {
                                       if (status === "SUCCESS") {
                                           modalBody = content;
                                           component.find('overlayLib').showCustomModal({
                                               header: row.Name,
                                               body: modalBody, 
                                               showCloseButton: true,
                                               cssClass: "mymodal",
                                           })
                                       }
                                       
                                   });
                
                break;
            case 'edit':
                
                var recordId = row.Id.replace('/','');
                component.set("v.editIt",true);
                component.set("v.recordAlId",recordId);
                event.preventDefault();
                
                break; 
                
            case 'delete':
                var recordId = row.Id.replace('/','');
                component.set("v.recordAlId",recordId);
                component.set("v.deleteIt",true);
                break;
        }
        
    },
    closeModel: function(component, event, helper) {     
        component.set("v.deleteIt", false);
    },
    	
    deleteRecord : function(component, row) {
        debugger;
        		
        component.find("accnLinkRecord").deleteRecord($A.getCallback(function(deleteResult) {
            // NOTE: If you want a specific behavior(an action or UI behavior) when this action is successful 
            // then handle that in a callback (generic logic when record is changed should be handled in recordUpdated event handler)
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                // record is deleted
                console.log("Record is deleted.");
            } else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
        }));
    },
    	
    
})