({
    helperLoad : function(component) {
        var action = component.get("c.getDetails");        
        // Create a callback that is executed after the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();
                var newsMap = resp.newsMap;
                var newsIdcdListMap=resp.newsIdcdListMap;
                component.set("v.columns", [{type:"text",label:"News Number",fieldName:"number"},{type:"text",label:"Title",fieldName:"name"},{type:"text",label:"Created By",fieldName:"createdby"},{type:"text",label:"Document Status",fieldName:"documentstatus"},{type:"text",label:"Category",fieldName:"category"},{type:"text",label:"Share with Groups",fieldName:"sharewithgroups"},{type:"Date",label:"Start Date",fieldName:"startdate"},{type:"Date",label:"Expiration Date",fieldName:"enddate"},{type:"text",label:"Related File Details",fieldName:"files"}]);                       
                var data=[];
                var size = 0;
                for(var item in newsMap){
                    size = size+1;
                    var fileList = newsIdcdListMap[item];
                    var row = 0;
                    var files = '';
                    for(var index in fileList){
                       	row = row+1;
                        files += row+'.'+fileList[index].Title+' : '+Math.round(fileList[index].ContentSize/1024*100)/100+'KB ' + '\n';
                    }
                    data.push({number:newsMap[item].Name,name:newsMap[item].Title__c,createdby:newsMap[item].Owner_Name__c, documentstatus:newsMap[item].Document_Status__c ,category: newsMap[item].Category_Type__c,sharewithgroups:newsMap[item].Share_With_Groups__c, startdate: newsMap[item].Start_Date__c,enddate: newsMap[item].Expiration_Date__c,files:files});
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