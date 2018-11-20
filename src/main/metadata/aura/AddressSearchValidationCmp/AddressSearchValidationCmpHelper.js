({
    //method to call the legacy system for finding duplicate accounts
    onlineDeduplication: function(component, event, helper) {
        var validateValues = component.get("c.onLineDedpulication");
        validateValues.setParams({"account":component.get("v.objAccount"),"address":component.get("v.objAddress"),"filterName":'AddressSearchValidation',"market":component.get("v.userMarket")});
        validateValues.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if(state==='SUCCESS'){
                    var retVal = resp.getReturnValue();
                    if(retVal!=null && retVal!='undefined') {
                        var val=retVal['Error'];
                        if(val.length>0){
                            component.set("v.hasError",true);
                            component.set("v.lstErrorMsg",retVal['Error']);
                            var errors=retVal['Error'];
                            for(var key in errors){
                                if(errors[key]!='Error'){
                                	helper.showToast('dismissible', 'Error', errors[key]);
                                }
                            }
                        }else if(val.length==0){
                            component.set("v.hasError",false);
                            component.set("v.firstsave",true); 
                            component.set("v.hasSpinner",true);
                            component.set("v.buttons",retVal['buttons']);
                            //alert('++++'+Boolean.valueOf(retVal['fromCDM'][0]));
                            //alert(retVal['fromCDM'][0]);
                            //component.set("v.fromCDM",Boolean(retVal['fromCDM'][0]));
                            //event to send data from lightning component to vf page
                            var vfBaseURL = component.get("v.vfHost");
                            var vf = component.find("vfFrame").getElement().contentWindow;
                            var message = {
                                topic: "com.mycompany.message",
                                selectedRecordId : component.get("v.selectedRecordId"),
                                objAccount :JSON.stringify(component.get("v.objAccount")),
                                firstsave:component.get("v.firstsave"),
                                userMarket:component.get("v.userMarket"),
                                objAddress:JSON.stringify(component.get("v.objAddress"))
                            };
                            vf.postMessage(message, vfBaseURL);
                        }
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            }
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                }
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('sticky', 'Error', errMsg);
            }
        });$A.enqueueAction(validateValues);
    },
    //method to Validate the address data entered
    validateAddress:function(component, event, helper){
        var validateValues = component.get("c.validateInputs");
        validateValues.setParams({"account":component.get("v.objAccount"),"address":component.get("v.objAddress"),"filterName":'AddressSearchValidation'});
        validateValues.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if(state==='SUCCESS'){
                    
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            }
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                }
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(validateValues);                
    },
    //method to validate and save account details
    saveAccount:function(component, event, helper){
        var validateValues = component.get("c.submitForm");
        validateValues.setParams({"account":component.get("v.objAccount"),"address":component.get("v.objAddress"),"filterName":'AddressSearchValidation',"market":component.get("v.userMarket")});
        validateValues.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if(state==='SUCCESS'){
                    var retVal = resp.getReturnValue();
                    if(retVal!=null && retVal!='undefined') {
                        var val=retVal['Error'];
                        if(val.length>0){
                            component.set("v.hasError",true);
                            component.set("v.lstErrorMsg",retVal['Error']);
                            var errors=retVal['Error'];
                            for(var key in errors){
                                if(errors[key]!='Error'){
                                	helper.showToast('dismissible', 'Error', errors[key]);
                                }
                            }
                        }else if(val.length==0){
                            component.set("v.hasError",false);
                            if(retVal['recordId']!='undefined'){
                            	var accountId=retVal['recordId'];
                            	window.open('/' + accountId, "_parent");
                            }
                        }
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            }
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                }
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(validateValues);
    },
    //method to close the New component
    closeModel: function(component, event, helper) {        
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Account"
        });
        homeEvt.fire();       
    },
    //method to create retailCopy for an Account
    createRetailCopy:function(component,row){
        $A.createComponent("c:createRetailCopyLC",{recordId : row.Id},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   var modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: 'Create Retail Copy',
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal",
                                   })
                               }
                               
                           });
    },
    //method to store recordtype of Account
    changeLayout: function(component, event, helper){
        //component.set("v.selectedRecordId",component.find("recordType").get("v.value"));
        component.set("v.selectedRecordId",event.getParam("recordTypeName"));
        debugger;
        var selectRecordtype = component.get("c.getRecTypeId");
        selectRecordtype.setParams({"recordTypeLabel":component.get("v.selectedRecordId")});
        selectRecordtype.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    var respVal = resp.getReturnValue();
                    if (respVal!=null && respVal!='undefined') {
                        component.set("v.selectedRecordtype",respVal);
                        component.set("v.objAccount.RecordTypeId",respVal);
                    }else if(respVal==null){
                        component.set("v.selectedRecordtype",respVal);
                        component.set("v.objAccount.RecordTypeId",respVal);
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            }  
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
            	}
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        $A.enqueueAction(selectRecordtype);   
        if(component.get("v.selectedRecordId")=='Person Account'){
            var accTypeLabel = $A.get("$Label.c.Person_Account_Information"); 
            component.set("v.accTypeLabel",accTypeLabel);
        }else if(component.get("v.selectedRecordId")=='Company'){ 
            var accTypeLabel = $A.get("$Label.c.Company_Account_Information"); 
            component.set("v.accTypeLabel",accTypeLabel);
        }
        //callback to fetch Account fields and buttons to be displayed on UI from Factory Model
        var fetchFields = component.get("c.getFields");
        fetchFields.setParams({"market":component.get("v.userMarket"),"recordType":component.get("v.selectedRecordId"),"componentName":'AddressSearchValidation'});
        fetchFields.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    var respVal = resp.getReturnValue();
                    if (respVal!=null && respVal!='undefined') {
                        debugger;
                        //alert(JSON.stringify(respVal['accountInputFields']));
                        component.set("v.displayListAccount",respVal['accountInputFields']);
                        component.set("v.displayListAddress",respVal['addressInputFields']);
                        component.set("v.buttons",respVal['buttons']);
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            }  
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
            	}
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                console.log(errMsg);
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(fetchFields);
        //callback function to get the columns of table showing Duplicate Accounts after clicking OnlineDeduplication Button
       var fetchTableColumns = component.get("c.getDataTableColumns");
        fetchTableColumns.setParams({"strObjectName":'Account',"market":component.get("v.userMarket"),"recordType":component.get("v.selectedRecordId"),"componentName":'AddressSearchValidation'});
        fetchTableColumns.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    var respVal = resp.getReturnValue();
                    if (respVal!=null && respVal!='undefined'){
                        component.set("v.colList",respVal);
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                                    component.set("v.hasError",false);
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            } 
                        }
                    }else{
                        var errMsg = errors[0].message;
                        component.set("v.hasError",false);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                }
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(fetchTableColumns);
    },
    //Show all toast messages
    showToast: function(mode, type, message) {
        console.log("entered into toast");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: mode,
            type: type,
            message: message
        });
        toastEvent.fire();
        //$A.get("e.force:refreshView").fire();
    }
})