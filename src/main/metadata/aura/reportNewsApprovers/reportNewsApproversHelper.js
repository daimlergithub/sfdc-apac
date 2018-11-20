({
    helperLoad : function(component) {
        var action = component.get("c.getGroupUserDetails");        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();                
                var grpmap = resp.groupDetails;
                var usrmap = resp.userDetails;
                var lstMetaData = resp.listMetaData;
                var trows='';
                component.set("v.columns", [{type:"text",label:"Approver List",fieldName:"Approvers"},{type:"text",label:"Public Group Name",fieldName:"Name"},{type:"text",label:"Group Members",fieldName:"Members"}]);                
                var data=[];
                for(var g in grpmap){
                    var gname=grpmap[g].DeveloperName; 
                    var gtype=grpmap[g].Type; 
                    var usrList = usrmap[g];
                    var gmems='';
                    if(usrList.length > 0){                        
                        for(var us in usrList){                            
                            gmems +=usrList[us].Name+', ';
                        }                        
                    }
                    var approverName = lstMetaData[gname];                       
                    if(gmems!=''){                          
                        gmems = gmems.replace(/,\s*$/, "");
                    }
                    else{                    
                        gmems='NA'
                    }
                    data.push({Approvers:approverName,Name:gname,Members: gmems});
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