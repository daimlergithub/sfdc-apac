({
    helperLoad : function(component) {
        var action = component.get("c.getDependentPicklistValues");        
        action.setParams({
            fieldName : component.get("v.dependPicklistName")
        });       
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();                                
                var trows='';
                component.set("v.columns", [{type:"text",label:"WorkFlow Group",fieldName:"Workflows"},{type:"text",label:"Approval List",fieldName:"Approvers"}]);                
                var data=[];
                for(var g in resp){                   
                    var approverName = resp[g];
                    var approverString='';
                    if(approverName.length > 0){                        
                        for(var us in approverName){                            
                            approverString +=approverName[us]+', ';
                        }
                        if(approverString!=''){                        
                            approverString = approverString.replace(/,\s*$/, "");
                        }
                        else{                    
                            approverString='NA'
                        }                        
                    }
                    data.push({Workflows:g,Approvers:approverString});
                }                
                component.set("v.data",data);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });       
        $A.enqueueAction(action);
    }
})