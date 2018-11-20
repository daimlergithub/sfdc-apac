({
    retriveCardTableFields : function(component,helper) {
        //call retrieveAdddressRecords apex class method which retrieves all the address recs
        console.log('enter call out');
        var retriveFields = component.get("c.fetchCardFields");
        retriveFields.setParams({
            recordId: component.get("v.recordId"),
            componentName:'createRetailCopyLC'
        });
        retriveFields.setCallback(this, function(response) { 
            helper.actionResponseHandler(component, response, helper, function(resObject,helper){
                try {
                    if (resObject!=null)
                    { 
                        console.log(JSON.stringify(resObject));
                        component.set("v.fieldLabelMap", resObject.apiLabelMap);
                        component.set("v.addressList", resObject.addList);
                        component.set("v.showAddRecs", resObject.showAddRecs);
                    }
                }
                catch (e) {
                    var errMsg ='Something is wrong : '    + e ;
                    helper.showToast('sticky', 'Error', errMsg);
                }
            })         
        });
        $A.enqueueAction(retriveFields);	
    },
    retriveDataTableFields : function(component,helper) {
        //call retrieveAdddressRecords apex class method which retrieves all the address recs
        var retriveFields = component.get("c.fetchLDTFields");
        retriveFields.setParams({
            recordId: component.get("v.recordId"),
            componentName:'createRetailCopyLC'
        });
        retriveFields.setCallback(this, function(response) { 
            helper.actionResponseHandler(component, response, helper, function(resObject,helper){
                try {
                    if (resObject!=null)
                    {    
                        console.log(JSON.stringify(resObject));
                        component.set("v.LDTcolumns", resObject.lstDataTableColumns);
                        component.set("v.LDTdata", resObject.lstDataTableData );
                        component.set("v.LDTallColumns", resObject.lstAllColumns);
                    }
                }
                catch (e) {
                    var errMsg ='Something is wrong : '    + e ;
                    helper.showToast('sticky', 'Error', errMsg);
                }
            })         
        });
        $A.enqueueAction(retriveFields);	
    },
    
    createRetail: function(component, helper) {
        
        var addS = component.get("v.selectedAddRec");
        if(component.get("v.showAddRecs") && addS==null ){    
            console.log('address is null');
            var nHeader = "Oops! You missed something.";
            var nVariant = "error";
            var nWarMsg = "Please Select atleast one address";
            helper.handleShowNotice(component, nHeader, nVariant, nWarMsg);
        }
        else 
        {
            var commitRetailCopy = component.get("c.createRetailCopyRecord");
            
            //var userR = component.get("v.userRec");
            //userR.sObjectType = 'User';
            if(addS!=null)
            {      
                addS.sObjectType = 'Address__c';
            }    
            commitRetailCopy.setParams({
                accountId: component.get("v.recordId"),
                selectedAdd: addS,
                dealerId: component.get("v.accRec.Main_Dealer__c"),
                componentName:'createRetailCopyLC'
            });  
            commitRetailCopy.setCallback(this,function(response){
                helper.actionResponseHandler(component, response, helper, function(resObject,helper){
                    try {
                        if (resObject!=null && resObject!='' && resObject == "Success") {	
                            console.log("came to sucess");
                            var sucessLabel = $A.get("$Label.c.Sucessfully_Created_Retail_Copy");
                            helper.showToast('sticky', 'Success', sucessLabel); 
                            helper.gotoURL('/'+component.get("v.recordId"),event);
                        }
                }
                    catch (e) {
                        var errMsg ='Something is wrong : '    + e ;
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                })         
            });
            $A.enqueueAction(commitRetailCopy);
        }
    },
    // generic action method response handler - carries out error checking
    // and assuming successful invokes the supplied callback, including the
    // callback data
    actionResponseHandler : function (component, response, helper, callback) {
        try
        { 
            var resObject = response.getReturnValue();
            //store response state 
            var state = response.getState();
            if (state === "SUCCESS") {
                if (resObject) {
                    callback(resObject,helper);
                } else {
                    throw new Error('Call to SFDC returned an empty response');
                }
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var errMsg = errors[0].message;
                        helper.showToast('sticky', 'Error', errMsg);
                    } else {
                        var errMsg = JSON.stringify(errors);
                        helper.showToast('sticky', 'Error', errMsg);
                    }
                } else {
                    throw new Error('Call to SFDC returned an empty error');
                }
            } else {
                // Neither success nor error
                console.log('Call ended with status:' + state);
                helper.showToast('sticky', 'Warning', state);
            }
        } catch (e) {
            var errMsg = 'Operation failed, please file a support request : ' + e;
            helper.showToast('sticky', 'Error', errMsg);
        }
    },
    showDetails : function(component, row) { 
        console.log('row' +row.Id);
        console.log('all cold:' +'['+component.get("v.LDTallColumns")+']'),
            $A.createComponent("c:RecordFormLC",
                               {recordId : row.Id,
                                myFields:component.get("v.LDTallColumns"),
                                objectType:"Address__c",
                                numberOfColumns:"3" ,
                                modeofRecordForm:"readonly"
                               },
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       var modalBody = content;
                                       component.find('modalLib').showCustomModal({
                                           body: modalBody, 
                                           showCloseButton: true,
                                           cssClass: "mymodal",
                                       })
                                   }  
                               });
    },
    
    showToast: function(mode, type, message) {
        console.log("entered into toast");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: mode,
            type: type,
            message: message
        });
        toastEvent.fire();
        $A.get("e.force:refreshView").fire();
    },
    
    handleShowNotice: function(component, nHeader, nVariant, syserr) {
        component.find("notifLib").showNotice({
            header: nHeader,
            variant: nVariant,
            message: syserr
        });
    },
    
    gotoURL : function (urlParam,event) {
        console.log('<<came to navigation');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlParam,
            "isredirect": "true"
        });
        urlEvent.fire();
    },
    
    toggleHelper : function(component,event) {
        var toggleText = component.find("tooltipdiv");
        console.log('<<came ere not display sow');
        //$A.util.toggleClass(toggleText, "toggle");
        $A.util.toggleClass(toggleText, 'slds-hide');
    },
    
    selectedRecordIdhelper : function(component,event) {
        var indexOfSelectedRow = event.getSource().get("v.label");
        console.log("indexOfSelectedRow:::" + indexOfSelectedRow);
        var addList = component.get("v.addressList");
        console.log("addList:::" + addList);
        var selectedRec = addList[indexOfSelectedRow];
        console.log("selectedRec:::" + selectedRec);
        component.set("v.selectedAddRec", selectedRec);
        console.log("v.selectedAddRec:::" + component.get("v.selectedAddRec"));
    },
    
    selectedRecordIdhelperFromButtonClick : function(component,event) {
        var indexOfSelectedRow = event.target.id;
        console.log("indexOfSelectedRow:::" + indexOfSelectedRow);
        var addList = component.get("v.addressList");
        console.log("addList:::" + addList);
        var selectedRec = addList[indexOfSelectedRow];
        console.log("selectedRec:::" + selectedRec);
        component.set("v.selectedAddRec", selectedRec);
        console.log("v.selectedAddRec:::" + component.get("v.selectedAddRec"));
    },
    
    toggleHelperdisplay : function(component,event) {
        var toggleText = component.find("tooltipdiv");
        console.log('<<came ere sow display');
        //$A.util.toggleClass(toggleText, "toggledisplay");
        $A.util.toggleClass(toggleText, 'slds-show');
    },
})