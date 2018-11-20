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
                            //event to send data from lightning component to vf page
                            var vfBaseURL = component.get("v.vfHost");
                            var vf = component.find("vfFrame").getElement().contentWindow;
                            //alert('2 '+vf);
                            var message = {
                                topic: "com.mycompany.message",
                                selectedRecordId : component.get("v.selectedRecordId"),
                                objAccount :JSON.stringify(component.get("v.objAccount")),
                                firstsave:component.get("v.firstsave"),
                                userMarket:component.get("v.userMarket"),
                                objAddress:JSON.stringify(component.get("v.objAddress")),
                                isCommunity:component.get("v.isCommunity")
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
                                if(component.get("v.isCommunity")=='true'){
                                    window.open(component.get("v.communityName")+'/'+accountId, "_parent");
                                }else{
                                    window.open('/' + accountId, "_parent");
                                }
                                	
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
        component.set('v.zState','abort');                
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
        //alert('entered change layout');
        //alert(component.get('v.zState'));
        // 3 calls again
        helper.addRemoteCall(3, helper);
        
        component.set('v.zState','init');
        component.set("v.selectedRecordId",event.getParam("recordTypeName"));
        component.set("v.userMarket",event.getParam("selectedMarket"));
        debugger;

        var selectRecordtype = component.get("c.getRecTypeId");
        selectRecordtype.setParams({"recordTypeLabel":component.get("v.selectedRecordId")});
        selectRecordtype.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    var respVal = resp.getReturnValue();
                    if (respVal) {
                        component.set("v.selectedRecordtype",respVal);
                        component.set("v.objAccount.RecordTypeId",respVal);
                    }else if(respVal==null){
                        component.set("v.selectedRecordtype",respVal);
                        component.set("v.objAccount.RecordTypeId",respVal);
                    }
                    helper.updateState('recordType',component, helper,true);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
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
        var actualMarket = component.get("v.userMarket");
        var selRecId = component.get("v.selectedRecordId");
        
        fetchFields.setParams({
            "market": actualMarket,
            "recordType": selRecId,
            "componentName":'AddressSearchValidation'
        });
        
        fetchFields.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    //alert('111');
                    var respVal = resp.getReturnValue();
                    //alert('2222');
                    if (respVal) {
                        //alert('entered display list'+JSON.stringify(respVal));
                        component.set("v.displayListAccount",respVal['accountInputFields']);
                        component.set("v.accountDefaultValues",respVal['defaults']);
                        component.set("v.displayListAddress",respVal['addressInputFields']);                   
                        component.set("v.addressDefaultValues",respVal['defaults']);
                        component.set("v.buttons",respVal['buttons']);
                    }
                    helper.updateState('fetchFields',component, helper, true);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
                }
            } catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                console.log(errMsg);
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(fetchFields);
        
        //callback function to get the columns of table showing Duplicate Accounts after clicking OnlineDeduplication Button
       var fetchTableColumns = component.get("c.getDataTableColumns");
       fetchTableColumns.setParams({
           "strObjectName":'Account',
           "market": actualMarket,
           "recordType": selRecId,
           "componentName": "AddressSearchValidation"
        });
        
        fetchTableColumns.setCallback(this, function(resp) {
            var state = resp.getState();
            try{
                if (state === "SUCCESS") {
                    var respVal = resp.getReturnValue();
                    if (respVal){
                        component.set("v.colList",respVal);
                    }
                    helper.updateState('fetchTable',component, helper,true);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
                }
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                component.set("v.hasError",false);
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(fetchTableColumns);
    },
    //Show all toast messages
    showToast: function(mode, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                mode: mode,
                type: type,
                message: message
            });
            toastEvent.fire();
        } else {
            // For environments where toast isn't supported
            alert(message);
        }
    },
    
    remoteCallsCompleted: function(helper) {
        return helper.CallRegister < 1 ;
    },
    
    completeRemoteCall: function(callname, helper) {
        helper.CallRegister = helper.CallRegister || 0;
        helper.CallRegister--;
    },
    
    
    addRemoteCall: function(count, helper) {    
        helper.CallRegister = helper.CallRegister || 0;
        helper.CallRegister += count;
    
    },
    
    dealWithFailure: function(component, helper, resp, state) {
        // Common error handler for remote calls
        if (state === "ERROR") {
            component.set('v.zState','error');
            var errors = resp.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    var errorList=errors[0].message.split('-');
                    for(var key in errorList){
                        if(errorList[key]!='Error' && errorList[key]!=null){
                            var errMsg ='Factory Response Error : '    +errorList[key];
                            helper.showToast('sticky', 'Error', errMsg);
                        }
                    } 
                }
            } else {
                var errMsg ='Remote call resulted in an unknown error, we are sooo sorry';
                helper.showToast('sticky', 'Error', errMsg);
                component.set('v.zState','error');
            }
        } else {
            //No action taken yet
        }
    },
    
    updateState: function(callname,component, helper, isSecond) {
        helper.completeRemoteCall(callname, helper);
        if (isSecond) {
            if (helper.remoteCallsCompleted(helper)) {
                component.set('v.zState','enterdata');
            }
        } else {
            if (helper.remoteCallsCompleted(helper)) {
                component.set('v.zState','pickrecordtype');
            }
        }
    }   
})