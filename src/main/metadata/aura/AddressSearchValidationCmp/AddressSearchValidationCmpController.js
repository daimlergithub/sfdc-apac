({
    doInit : function(component, event, helper) { 
        component.set("v.accLabel", $A.get("$Label.c.New_Account_Information")); // Page Heading
        //component.set("v.vfHost", $A.get("$Label.c.vfHostAddressSearchValidation")); // Host URL for iFramed VF Page
        component.set("v.personAcct", $A.get("$Label.c.PersonAccountRecordTypeAccount")); // Person Account Record Type
        component.set("v.compAcct", $A.get("$Label.c.CompanyRecordTypeAccount")); // Company Account Record Type
        component.set("v.vfPage", $A.get("$Label.c.OnLineDeduplicationVFNameiFrame")); // URL for VF Page
		//component.set("v.vfHost", $A.get("$Setup.c.vfHostAddressSearchValidation__c.URL__c")); // Host URL for iFramed VF Page 
		//alert('1111122'+$A.get("$Setup.vfHostAddressSearchValidation__c.URL__c"));
        //callback function for fetching User market
        var hostURL = component.get("c.getvfHostURL");      
        hostURL.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    if(respVal!=null && respVal!='undefined'){
                        component.set("v.vfHost",respVal.URL__c);
                        //alert(component.get("v.vfHost"));
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            } 
                        }
                    }else{
                        var errMsg ='Factory Response Error : '    + errors[0].message;
                        helper.showToast('sticky', 'Error', errMsg);
                    }
            	}
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(hostURL);
        //callback function for fetching User market
        var marketAction = component.get("c.getUserMarket");
        marketAction.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    if (respVal!=null && respVal!='undefined') {
                        component.set("v.user",respVal);
                        component.set("v.userMarket",respVal.Market__c);
                        component.set("v.objAccount.Market__c",respVal.Market__c);
                        component.set("v.objAddress.Market__c",respVal.Market__c);  
                    }
                }else if (state === "ERROR") {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            var errorList=errors[0].message.split('-');
                            for(var key in errorList){
                                if(errorList[key]!='Error' && errorList[key]!=null){
                                	var errMsg ='Factory Response Error : '    +errorList[key];
                            		helper.showToast('sticky', 'Error', errorList[key]);
                                }
                            } 
                        }
                    }else{
                        var errMsg ='Factory Response Error : '    + errors[0].message;
                        helper.showToast('sticky', 'Error', errMsg);
                    }
            	}
            }catch (e) {
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });$A.enqueueAction(marketAction);
        component.set("v.objAccount.Allow_Data_Sharing2__c",'No');
        //event to store received duplicate accounts and show on UI
        var vfBaseURL = component.get("v.vfHost");
        window.addEventListener("message", function (event) {
            //alert(event.origin !== vfBaseURL);
            //alert(event.origin !== component.get("v.vfHost"));
            if (event.origin !== component.get("v.vfHost")){
                return;
            }
            // Only handle messages we are interested in
            if (event.data.topic === "com.mycompany.message") {
                component.set("v.hasSpinner",false);
                //alert(JSON.parse(event));
                debugger;
                //alert(event);
                var result = event.data.result;
                if(result!=null){
                    if(result.length>1 && result[0]=='Error'){
                        component.set("v.hasError",true);
                        component.set("v.lstErrorMsg",result);
                        component.set("v.deDuplicationAccounts", null);
                        component.set("v.result",null);
                        var errors=result;
                        for(var key in errors){
                            if(errors[key]!='Error'){
                            	helper.showToast('dismissible', 'Error', errors[key]);
                            }
                        }
                    }else{
                        component.set("v.result",'SUCCESS');
                        component.set("v.deDuplicationAccounts", result);
                    } 
                }
            }  
        }, false);
       /* window.addEventListener("error", function (e) {
            alert('2');
            alert(e.error);
        },false*/
        /*var marketAction = component.get("c.getRegionalList");
        marketAction.setCallback(this, function(resp) {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    console.log(JSON.stringify(respVal));
                    alert(JSON.stringify(respVal));
                }
        });$A.enqueueAction(marketAction);*/
    },
    //method to call helper functions based on button click
    viewButton:function(component, event, helper){
        var clickedButton=event.getSource();
        var buttonName=clickedButton.get("v.label");
        var buttonNameNew= buttonName.toString();
        //alert(buttonName+' buttonName '+$A.get("$Label.c.Cancel"));
        //alert(buttonName.toString()==$A.get("$Label.c.Cancel"));
        //alert(buttonNameNew==$A.get("$Label.c.Cancel"));
        //alert('Cancel'==$A.get("$Label.c.Cancel"));
        if(buttonName==$A.get("$Label.c.OnLine_Deduplication")){
            helper.onlineDeduplication(component, event, helper);
        }else if(buttonName==$A.get("$Label.c.Cancel")){
            //alert('entered');
            helper.closeModel(component, event, helper);
        }else if(buttonName==$A.get("$Label.c.Save_Button")){
            helper.saveAccount(component, event, helper);
        }else if(buttonName==$A.get("$Label.c.Validate")){
            helper.validateAddress(component, event, helper);
        }else{
            helper.closeModel(component, event, helper);
        }
    },
    
    //method to store company name of Account
    getAccountName:function(component,event,helper){
        component.set("v.objAccount.Name",component.get("v.companyName"));
    },
    //method to store full phone number from Reusable Component
    getFullNumber:function(component, event, helper) {
        var fieldName = event.getParam("phoneNumber");
        var fieldvalue = event.getParam("numberType");
    },
    //method to store Zip Code of Address
    getZip:function(component,event,helper){
        component.set("v.objAddress.ZipCode__c",component.get("v.Zip"));
    },
    //method to store the Account data entered in the fields
    getInputFieldData:function(component, event, helper) {            
        var fieldName = event.getParam("fieldAPINAME");
        var fieldvalue = event.getParam("fieldValue");
        console.log('<<fieldName'+fieldName+'<<fieldvalue'+fieldvalue);
        var acctValue = component.get("v.objAccount") || {};
        acctValue[fieldName] = fieldvalue;        
        component.set("v.objAccount", acctValue);
        console.log('accrecValue-->', JSON.stringify(component.get("v.objAccount")));
    },
    //method to store the Address data entered in the fields
    getInputFieldDataAddress:function(component, event, helper) {   
        var fieldName = event.getParam("fieldAPINAME");
        var fieldvalue = event.getParam("fieldValue");
        console.log('<<fieldName'+fieldName+'<<fieldvalue'+fieldvalue);
        var addValue = component.get("v.objAddress") || {};
        addValue[fieldName] = fieldvalue;        
        component.set("v.objAddress", addValue);
        console.log('addrecValue-->', JSON.stringify(component.get("v.objAddress")));
    }, 
    
    //method on recordtypeselection
    getRecType : function(component, event, helper) {
       //alert(event.getParam("recordTypeName")); 
       if(event.getParam("isCancel"))
       {
         helper.closeModel(component, event, helper);  
       }else{
         helper.changeLayout(component, event, helper);   
       }  
      },
    //method to toggle the sections
    toggleDiv:function(component, event, helper) {            
        var targetCmp = event.getSource();  
        var target = event.getParam("idToToggle");
        console.log('<<target'+target);
        var acc = component.find(target);
        console.log('<<acc'+acc);
        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }
    },
    //method to handle the actions in the data table
    handleRowAction: function (component, event, helper) {
        var result1=JSON.stringify(event.getParam('row'));
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'create_retail_copy':
                helper.createRetailCopy(component,row);
                break;
            case 'show_more':
                var navEvt = $A.get("event.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": row.id,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                break;
        }
    },
    
    viewData:function(component, event, helper){
        component.set("v.accountState",'Pending');
        debugger;
        component.find("createPersonAccount").submit();
    },
    
    locationChange : function (component, event, helper) {                
        //component.set("v.selectedRecordtype",null);
		$A.get("e.force:refreshView").fire();
    }
})