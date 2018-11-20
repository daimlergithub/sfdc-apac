({
    nextWizardPage: function(component, increment, helper) {
        const pageList = component.get("v.wizardStepNames");
        const curPageName = component.get("v.stage");
        const progressIndicator = component.get("v.progressIndicator");
        
        // Math magic - next page number and name
        const curPageNum = Math.max(0, pageList.indexOf(curPageName));
        const nextPageNum = Math.max(0, Math.min(curPageNum + increment, pageList.length - 1));
        const nextPageName = pageList[nextPageNum];
        
        // Update
        component.set("v.stage", nextPageName);
        progressIndicator.set("v.currentStep", nextPageName);
        helper.updateWizardNavigation(component, pageList, curPageName, nextPageName);
    },
    
    updateWizardNavigation: function(component, pageList, curPageName, nextPageName) {
        const totalPages = pageList.length - 1; // Index starts with 0
        const nextPageNum = Math.min(Math.max(0, pageList.indexOf(nextPageName)), totalPages);
        
        // Show and hide content blocks
        const curContent = document.getElementById(curPageName);
        if (curContent) {
            $A.util.addClass(curContent, "slds-hide");
            curContent.style.display = 'none';
        }
        var nextContent = document.getElementById(nextPageName);
        if (nextContent) {
            $A.util.removeClass(nextContent, "slds-hide");
            nextContent.style.display = 'block';
        }
        
        // Parameters that govern the visibility of previous/next pages
        component.set("v.showPrevious", (nextPageNum > 0));
        component.set("v.showNext", (nextPageNum < totalPages));
        
    },
    
    toggleShowAll: function(component, showAll, helper) {
        const stepsDataMap = component.get("v.wizardStepNames");
        const progressIndicator = component.get("v.progressIndicator");
        stepsDataMap.forEach(sdm => {
            const cmpTarget = document.getElementById(sdm);
            if (cmpTarget) {
            if (showAll) {
            $A.util.removeClass(cmpTarget, "slds-hide");
            cmpTarget.style.display = "block";
        } else {
                             $A.util.addClass(cmpTarget, "slds-hide");
        cmpTarget.style.display = "none";
    }
}
 });
if (showAll) {
    component.set("v.showPrevious", false);
    component.set("v.showNext", false);
    $A.util.addClass(progressIndicator, "slds-hide");
    
} else {
    // Show the wizzard page again
    $A.util.removeClass(progressIndicator, "slds-hide");
    helper.nextWizardPage(component, 0, helper);
}
component.set("v.showAll", showAll);
},
    
    controlNavigationBtns: function(component, event, currentPage) {
        var totalPages = component.get("v.totalPages");
        if (currentPage == 1) {
            component.set("v.isFirstPage", true);
            if (currentPage == totalPages) {
                component.set("v.isLastPage", true);
            } else {
                component.set("v.isLastPage", false);
            }
        } else if (currentPage < totalPages) {
            component.set("v.isFirstPage", false);
            component.set("v.isLastPage", false);
        } else if (currentPage == totalPages) {
            component.set("v.isFirstPage", false);
            component.set("v.isLastPage", true);
        }
    },
        showToast: function(mode, type, message) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: mode,
                type: type,
                message: message,
                duration: ' 5000'
            });
            toastEvent.fire();
            $A.get("e.force:refreshView").fire();
        },
            getDetails: function(component, event, helper) {
                var action1 = component.get("c.getFIeldSetForMkt");
                var recId = component.get("v.recordId");
                debugger;
                action1.setParams({
                    "recordId": recId,
                    "recordTypeName": component.get("v.recordTypeName")
                });
                action1.setCallback(this, function(response) {
                    const state = response.getState();
                    const returnVals = response.getReturnValue();
                    if (state === "SUCCESS" && returnVals != null) {
                        const wrapList = returnVals.wrapList;
                        component.set("v.FSWrapList", wrapList);
                        //component.set("v.totalPages",returnVals.wrapList.length);
                        //debugger;
                        const wizardStepNames = [];
                        const bodyComponents = [];
                        const stepsPreComponents = [
                            [
                                "lightning:progressIndicator", {
                                    "v.aura:Id": "progressIndicator"
                                }
                            ]
                        ];
                        // Add the steps
                        var componentnames = [];
                        
                        wrapList.forEach(function(step, index, wrap) {
                            const label = step.sectionName.split('!@');
                            const componentType = label[1];                    
                            var curStepName = label[0];
                            var fieldSize = '6';
                            if (curStepName.indexOf('~') > 0) {
                                const stepSplit = curStepName.split('~');
                                curStepName = stepSplit[0];
                                fieldSize = stepSplit[1];
                            }
                            
                            wizardStepNames.push(curStepName);
                            
                            // Ugly hack to get the first step name into the progressindicator
                            if (stepsPreComponents[0][1].currentStep) {
                                // No action, just use JavaScripts 'falsy'
                            } else {
                                stepsPreComponents[0][1].currentStep = curStepName;
                                component.set("v.stage", curStepName);
                            }
                            
                            stepsPreComponents.push([
                                "lightning:progressStep", {
                                    "label":curStepName,
                                    "value":curStepName
                                }
                            ]);
                            
                            const visibility = (index == 0);
                            var ParentAccountId = component.get("v.ParentAccountId");
                            //debugger;
                            const bodyComponentType = helper.getBodyComponent(componentType, curStepName, step.FieldMap, fieldSize, visibility, helper, ParentAccountId);
                            bodyComponents.push(bodyComponentType);
                        });
                        component.set('v.wizardStepNames', wizardStepNames);
                        const realComponents = stepsPreComponents.concat(bodyComponents).filter(rc => (rc != undefined));
                        $A.createComponents(
                            realComponents,
                            function(components, status, errorMessage) {
                                if (status === "SUCCESS") {
                                    var progressSteps = components.slice(1, stepsPreComponents.length - 1);
                                    // Remove the father
                                    var progressIndicator = components.shift();
                                    // Add the rest to the father
                                    progressIndicator.set('v.body', progressSteps);
                                    // Assign it to the view Attribute
                                    component.set('v.progressIndicator', progressIndicator);
                                    
                                    // Set the rest to body
                                    const bodycomp = components.slice(stepsPreComponents.length - 1);
                                    component.set('v.body', bodycomp);
                                    
                                    helper.nextWizardPage(component, 0, helper);
                                    
                                } else if (status === "INCOMPLETE") {
                                    //TODO: notify
                                    alert('Not Done');
                                } else {
                                    
                                    alert('Error');
                                }
                            }
                        );
                        
                        //Create Vehicle Picker Components
                        
                        
                        // if existing record
                        var RecordTypeName;
                        var RecTypeID;
                        if (recId != null && recId != "") {
                            RecordTypeName = response.getReturnValue().recTypeName;
                            RecTypeID = response.getReturnValue().RecTypeid;
                            component.set("v.RecordTypeID", RecTypeID);
                        } else {
                            // for new record
                            RecordTypeName = component.get("v.recordTypeName");
                            RecTypeID = component.get("v.RecordTypeID");
                        }
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: 'dismissible',
                            message: 'An Error Occured. Kindly refresh or contact your Salesforce administrator.',
                            type: 'error',
                            duration: '0.9',
                        });
                        toastEvent.fire();
                    }
                });
                $A.enqueueAction(action1);
            },
                setRecordTypeId: function(component, event, helper) {
                    // component.set("v.recordTypeName", component.find('selectRecType').get('v.value'));
                    var recordTypeName = event.getParam("recordTypeName");
                    component.set("v.recordTypeName",recordTypeName);
                    var action = component.get("c.getRecTypeId");
                    action.setParams({
                        "recordTypeLabel": recordTypeName
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS" && response.getReturnValue() != null) {
                            component.set("v.RecordTypeID", response.getReturnValue());
                        } else {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                mode: 'dismissible',
                                message: 'An Error Occured. Kindly refresh or contact your Salesforce administrator.',
                                type: 'error',
                                duration: '0.9',
                            });
                            toastEvent.fire();
                        }
                    })
                    $A.enqueueAction(action);
                },
                    
                    getBodyComponent: function(componentType, curStepName, itemMap, fieldSize, visibility, helper, ParentAccountId) {
                        switch (componentType) {
                            case 'Fieldset':
                                return helper.getInputFieldFormComponent(curStepName, itemMap, fieldSize, visibility, ParentAccountId);
                                break;
                                
                            case 'Component':
                                return helper.getWizardComponentWrapper(curStepName, Object.keys(itemMap) , fieldSize, visibility, ParentAccountId);
                                break;
                        }
                    },
                        
                        getInputFieldFormComponent: function(sectionName, fieldMap, size, visibility, ParentAccountId) {
                            console.log('fieldMap'+JSON.stringify(fieldMap));
                            const params = {
                                'sectionName': sectionName,
                                'fieldMap': fieldMap,
                                'size': size,
                                'AccId': ParentAccountId
                            };
                            if (visibility) {
                                params.style = "display : block";
                            }
                            return ['c:WizardFormSection', params];
                        },
                            
                            getWizardComponentWrapper: function(sectionName, componentList, size, visibility, ParentAccountId) {
                                //FIXME: We might have more that one component - need to handle aura:Id for that
                                const params = {
                                    
                                    'aura:id': 'WizardComponentSection',
                                    'sectionName': sectionName,
                                    'componentNameList': componentList,
                                    'size': size,
                                    'AccId': ParentAccountId
                                };
                                if (visibility) {
                                    params.style = "display : block";
                                }
                                return ['c:WizardComponentSection', params];        
                            },
                                normaliseSforceID: function (id) { // fluff up a 15 char id to return an 18 char id
                                    if (id == null) return id;
                                    id = id.replace('/\"/g', ''); // scrub quotes from this id
                                    if (id.length != 15) {
                                        //print('well, id is not 15, bye' + id + ' ' + id.length);
                                        return null;
                                    }
                                    var suffix = "";
                                    for (var i = 0; i < 3; i++) {
                                        var flags = 0;
                                        for (var j = 0; j < 5; j++) { 
                                            var c = id.charAt(i * 5 + j);
                                            if (c >= 'A' && c <= 'Z') {
                                                flags += 1 << j;
                                            }
                                        }
                                        if (flags <= 25) {
                                            suffix += "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(flags);
                                        }
                                        else {
                                            suffix += "012345".charAt(flags-26);
                                        }
                                    }
                                    return id + suffix;
                                },
                                    cancelNewMethod:function(component, event, helper) {
                                        component.set("v.isNew", false);
                                        var homeEvt = $A.get("e.force:navigateToObjectHome");
                                        homeEvt.setParams({
                                            "scope": "Opportunity"
                                        });
                                        homeEvt.fire(); 
                                    },       
})