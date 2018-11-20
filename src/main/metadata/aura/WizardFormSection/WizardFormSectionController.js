({
    doInit: function(component, event, helper) {
       console.log('**** INSIDE INIT');
       debugger; 
       var fieldMap = JSON.parse(JSON.stringify(component.get("v.fieldMap"))); 
       helper.createForm(component, fieldMap);
   },
   getAccId : function(component, event, helper) {
        if(event['$_params$']){
            //alert(JSON.stringify(event['$_params$']['value']));
            var accId = event['$_params$']['value'][0];
        }   
        var getevent = $A.get("e.c:GetAccountId");
        getevent.setParams({
            AccId: accId
        });
        getevent.fire();
    }
})