({
    myAction : function(component, event, helper) {
        var Components = [];
        var componentNameList = component.get("v.componentNameList");
        componentNameList.forEach( cmpName => {
            Components.push([cmpName, {'accId':component.get("v.AccId")}]);                      
        });
            $A.createComponents(
            Components,
            function(body, status, errorMessage) {
            if (status === "SUCCESS") {
            component.set("v.body",body);
        }else if (status === "INCOMPLETE") {
            //TODO: notify
            alert('Not Done');
        } else {
            alert('Error');
        }
        }
            )
        }
        })