({
	 retrieverecords : function(component, event, helper) {
        //call retrievevehicleListInfo apex class method which retrieves all the vehicle info and pass it as wrapper
       if(component.get("v.recId")!= null)
       {
        console.log('<<entered here'+component.get("v.recId"));
        var retriveAddress = component.get("c.retrievevehicleListInfoFromOpptyID");
        retriveAddress.setParams({
            recId: component.get("v.recId")
        });
        retriveAddress.setCallback(this, function(response) {
            console.log(JSON.stringify(response));
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set('v.currentVehicles', response.getReturnValue().currentVehicleList);
                }
            else{
               console.log(JSON.stringify(response));
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
               mode: 'dismissible',
               message: 'An Error Occured. Kindly refresh or contact your Salesforce administrator.',
               type : 'error',
               duration:'0.9',
               }); 
              toastEvent.fire();
            }
            
        });
        $A.enqueueAction(retriveAddress);   
       }    
	   else if(component.get("v.accId")!= null)
       {
        console.log('<<entered here'+component.get("v.accId"));
        debugger;   
        var retriveveh = component.get("c.retrievevehicleListInfoFromAcctID");
        retriveveh.setParams({
            accId: component.get("v.accId")
        }); 
        retriveveh.setCallback(this, function(response) {
            console.log(JSON.stringify(response));
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.currentVehicles', response.getReturnValue().currentVehicleList);
                }
            else{
                alert('1:'+JSON.stringify(response)); 
               var toastEvent = $A.get("e.force:showToast");
               toastEvent.setParams({
               mode: 'dismissible',
               message: 'An Error Occured. Kindly refresh or contact your Salesforce administrator.',
               type : 'error',
               duration:'0.9',
               }); 
              toastEvent.fire();
            }
            
        });
        $A.enqueueAction(retriveveh);
      }
       },  
})