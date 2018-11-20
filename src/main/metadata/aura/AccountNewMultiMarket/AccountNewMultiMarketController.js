({
    doInit : function(component, event, helper) {       
        component.set("v.accLabel", $A.get("$Label.c.New_Account_Information")); // Page Heading
        component.set("v.personAcct", $A.get("$Label.c.PersonAccountRecordTypeAccount")); // Person Account Record Type
        component.set("v.compAcct", $A.get("$Label.c.CompanyRecordTypeAccount")); // Company Account Record Type
        //component.set("v.vfPage", $A.get("$Label.c.OnLineDeduplicationVFNameiFrame")); // URL for VF Page
        
        // We conduct 4 callbacks
        helper.addRemoteCall(4, helper);
        
        //callback function for fetching User market
        var hostURL = component.get("c.getvfHostURL");      
        hostURL.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    if(respVal){
                        component.set("v.vfHost",respVal.hostURL);
                        component.set("v.isCommunity",respVal.isCommunity);
                        component.set("v.vfPage",respVal.vfPage);
                        component.set("v.communityName",respVal.comName);
                    }
                    helper.updateState('vfHost',component, helper);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
                }    
            }catch (e) {
                component.set('v.zState','error');
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(hostURL);
        
        //callback function for fetching User market
        var marketAction = component.get("c.getUserMarket");
        marketAction.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    if (respVal) {
                        var resMarket = respVal.Market__c;
                        component.set("v.user",respVal);
                        component.set("v.userMarket",resMarket);
                        component.set("v.objAccount.Market__c",resMarket);
                        component.set("v.objAddress.Market__c",resMarket);  
                    }
                    helper.updateState('userMarket',component, helper);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
                }    
 
            } catch (e) {
                component.set('v.zState','error');
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(marketAction);
        
        //callback function for fetching Users additional market permissions
        var userMarketAll = component.get("c.getUserAdditionalMarket");
        userMarketAll.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") {   
                    var respVal = resp.getReturnValue();
                    if (respVal) {
                        component.set("v.userMarketAll",respVal); 
                    }
                    helper.updateState('extraMarkets',component, helper);
                } else {
                    helper.dealWithFailure(component, helper, resp, state);
                }    
 
            } catch (e) {
                component.set('v.zState','error');
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(userMarketAll);
        
        //callback function for fetching Users cross market permissions
        var crossmarketPermission = component.get("c.getCheckBoolean");
        crossmarketPermission.setCallback(this, function(resp) {
            try {
                var state = resp.getState();
                if (state === "SUCCESS") 
                	{   
                    var respVal = resp.getReturnValue();
                    if (respVal!=null && respVal!='undefined')
                    			{
                        component.set("v.ANZUserwithCustomPermission",respVal); 
                    			}
                        helper.updateState('ANZUserwithCustomPermission',component, helper);
                    }
                else {
                    helper.dealWithFailure(component, helper, resp, state);
                	}    
 
            } catch (e) {
                component.set('v.zState','error');
                var errMsg ='Something is wrong : '    + e ;
                helper.showToast('dismissible', 'Error', errMsg);
            }
        });
        
        $A.enqueueAction(crossmarketPermission);
        
        component.set("v.objAccount.Allow_Data_Sharing2__c",'No');
        //event to store received duplicate accounts and show on UI
        var vfBaseURL = component.get("v.vfHost");
        window.addEventListener("message", function (event) {
            if (event.origin !== component.get("v.vfHost")){
                return;
            }
            // Only handle messages we are interested in
            if (event.data.topic === "com.mycompany.message") {
                component.set("v.hasSpinner",false);
                debugger;
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
    },
    
    //method to call helper functions based on button click
    viewButton:function(component, event, helper){
        var clickedButton=event.getSource();
        var buttonName=clickedButton.get("v.label");
        var buttonNameNew= buttonName.toString();
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
    //method to store Zip Code of Address
    getZip:function(component,event,helper){
        component.set("v.objAddress.ZipCode__c",component.get("v.Zip"));
    },
    //method to store the Account data entered in the fields
    getInputFieldData:function(component, event, helper) {            
        var fieldName = event.getParam("fieldAPINAME");
        var fieldvalue = event.getParam("fieldValue");
        
        console.table({'fieldName':fieldName,'fieldValue':fieldvalue});
        var acctValue = component.get("v.objAccount") || {};
        acctValue[fieldName] = fieldvalue;        
        component.set("v.objAccount", acctValue);
        console.table(JSON.parse(JSON.stringify(component.get("v.objAccount"))));
    },
    //method to store the Address data entered in the fields
    getInputFieldDataAddress:function(component, event, helper) {   
        var fieldName = event.getParam("fieldAPINAME");
        var fieldvalue = event.getParam("fieldValue");
        console.table({'fieldName':fieldName,'fieldValue':fieldvalue});
        var addValue = component.get("v.objAddress") || {};
        addValue[fieldName] = fieldvalue;        
        component.set("v.objAddress", addValue);
        console.table(JSON.parse(JSON.stringify(component.get("v.objAccount"))));
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
        //alert('test');
		$A.get("e.force:refreshView").fire();
    }
    
})