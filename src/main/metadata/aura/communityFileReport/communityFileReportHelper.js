({
    helperLoad : function(component) {
        var action = component.get("c.getfileDetails");        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();                
                var comfiles = resp.communityFileMap;
                var condocs = resp.cfIdcdListMap;
                
                component.set("v.columns", [{type:"text",label:"Title",fieldName:"Name",iconName: "standard:file"},{type:"text",label:"Shared with Users",fieldName:"Users",iconName: "standard:user"},{type:"text",label:"Shared with Groups",fieldName:"Groups",iconName: "standard:groups"},{type:"Date",label:"Expiration Date",fieldName:"Date",iconName: "standard:record_delete"},{type:"text",label:"Related File Details",fieldName:"Files",iconName: "standard:file"}]);                       
                var data=[];
                var size = 0;
                for(var cf in comfiles){ 
                    //console.log(comfiles[cf].Name);
                    size = size+1;
                    var condocList = condocs[cf];
                    //console.log(condocList);
                    var row = 0;
                    if(typeof condocList == "undefined"){
                        console.log(comfiles[cf].Related_Files__c);
                        data.push({Name:comfiles[cf].Name,Users:comfiles[cf].SelectedUsers__c, Groups: comfiles[cf].SelectedGroups__c, Date: comfiles[cf].Expiration_Date__c,Files:comfiles[cf].Related_Files__c});
                    }
                    else{              
                        for(var cd in condocList){
                            row = row+1;
                            var files = '';
                            //console.log(cd);
                            //console.log(condocList[cd].Title);
                            files = row+'. '+condocList[cd].Title+' : '+Math.round(condocList[cd].ContentSize/1024*100)/100+'KB ';
                            
                            if(cd == 0){                            
                                data.push({Name:comfiles[cf].Name,Users:comfiles[cf].SelectedUsers__c, Groups: comfiles[cf].SelectedGroups__c, Date: comfiles[cf].Expiration_Date__c,Files:files});
                            }
                            else{
                                data.push({Name:'',Users:'', Groups: '', Date: '',Files:files});
                            }
                            
                        }
                    }
                    //data.push({Name:comfiles[cf].Name,Users:comfiles[cf].SelectedUsers__c, Groups: comfiles[cf].SelectedGroups__c, Date: comfiles[cf].Expiration_Date__c,Files:files});
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