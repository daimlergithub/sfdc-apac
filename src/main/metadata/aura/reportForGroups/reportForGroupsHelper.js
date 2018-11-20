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
                component.set("v.columns", [{type:"text",label:"Public Group Name",fieldName:"Name",iconName: "standard:groups"},{type:"text",label:"Group Type",fieldName:"Type",iconName:"standard:work_type_group"},{type:"text",label:"Group Members",fieldName:"Members",iconName:"standard:user"}]);                
                var data=[];
                var size=0;
                for(var g in grpmap){
                    size = size+1;
                    var gname=grpmap[g].DeveloperName; 
                    var gtype=grpmap[g].Type; 
                    var usrList = usrmap[g];
                    var gmems='';
                    if(usrList.length > 0){                        
                        for(var us in usrList){                            
                            gmems +=usrList[us].Name+', ';
                        }                        
                    }
                    if(gmems=='')
                        gmems='NA'
                        data.push({Name:gname,Type:gtype, Members: gmems});
                }            
                component.set("v.total",size);
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