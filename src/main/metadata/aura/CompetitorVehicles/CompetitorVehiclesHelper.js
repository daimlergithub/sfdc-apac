({
    retrieverecords : function(component, event, helper) {
		//call retrievevehicleListInfo apex class method which retrieves all the vehicle info and pass it as wrapper
	     if(component.get("v.recId") != null)
        {
        var retriveAddress = component.get("c.retrievevehicleListInfo");
        retriveAddress.setParams({
            recId: component.get("v.recId")
        });
        console.log('<<entered here');
        retriveAddress.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!= null)
                {
                const carlist = response.getReturnValue().compVehicleList;
                carlist.forEach(l => {
                 if(l.Car_Model_Competitor__c != null)
                    {
                     l.RModel = l.Car_Model_Competitor__r.Name;  
                    }
                 });
                 component.set("v.compVehiclesList",carlist);
                }
               }
            else{
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
	},
   carModelChangeSC: function(component, event, helper) {
        var checkDuplicate = false;
        component.set("v.isDuplicate",false);
        var rowindex;      
        var action = component.get("v.tableAction"); 
        var tempVehicles = component.get("v.compVehiclesList");
        var vehicles =  tempVehicles.slice();       
        var dispType = component.get("v.displayType");
		 //for Edit action : set index according to row selected  
       if(action == "Edit")
       {
          var target = component.get("v.tempValue");
          var list= component.get("v.compVehiclesList");
          if(dispType == "Card")
          {
            rowindex = event.getSource().get("v.alternativeText");
            var row= component.get("v.compVehiclesList")[rowindex];
          }else if(dispType == "Table")
          { 
           var row = event.getParam('row');
           var a= row['Car_Model_Competitor__c'];
           var index; 
           for (var i = 0; i < list.length; i++) {
            if(list[i].Car_Model_Competitor__c== a)
             {
               index=i;     
               break;
             }
            }
           //debugger; 
           rowindex = index;
          }     
          component.set("v.tableAction",'EditAgain'); 
          component.set("v.Index",rowindex); 
       }
       else if(action == "New")
       {  component.set("v.isDuplicate",false); 
          checkDuplicate = true; 
          var target = event.getParam("selectedValue"); 
           //for New action : set index as list.length+1  
          rowindex = vehicles.length-1;
       }
       else{ component.set("v.isDuplicate",false); 
             checkDuplicate = true; 
             var target = event.getParam("selectedValue");   
             rowindex = component.get("v.Index");
        }
       
         // check for duplicate model selection
            vehicles.forEach( l =>{
            if(l.Car_Model_Competitor__c != null && l.Car_Model_Competitor__c == target && checkDuplicate)
            { 
             component.set("v.isDuplicate",true);
             component.set("v.message","This model is already added. Please select some other model to submit record.");
            }
          });

       if(!component.get("v.isDuplicate"))
       {
	   // if not selected duplicate , then hide error msg & invoke server method  
        var dgaction = component.get('c.cardmodelParametersSC');
        component.set(('v.currentrecord'),('[ ' + JSON.stringify(vehicles[rowindex]) + ' ]'));
        dgaction.setParams({
            "carModelId": target,
            "intVehicle": component.get('v.currentrecord')
        });
        
		dgaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var updatedgood = response.getReturnValue();
                console.log('<<response'+response.getReturnValue()+JSON.stringify(response.getReturnValue()));
                if (updatedgood != undefined) {
                    vehicles[rowindex] = updatedgood;
                }
                
                const carlist = vehicles;
               //debugger; 
               for (var i = 0; i < carlist.length; i++) {
           		if(i == rowindex)
           		{
                 if(carlist[i].Trim__c != null && carlist[i].Trim__c.includes("||"))
                 {
                  //carlist[i].Preferred__c=true;
  				  carlist[i].RModel = carlist[i].Trim__c.split('||')[1];     
                 }
                }
          	  }
               
                component.set('v.carmodellist',carlist);
                if(updatedgood != null)
                {
                component.set("v.brand", updatedgood.Brand__c);
                component.set("v.color", updatedgood.Color__c);
                component.set("v.class", updatedgood.Class__c);
                component.set("v.Preferred",updatedgood.Preferred__c);
                }
                var intList=component.get("v.compVehiclesList");
             }
            else{
                var nVariant = "error";
                var nErrmsg = "An Error Occured. Kindly refresh or contact your Salesforce administrator.";
                helper.handleShowNotice(component, "Error !", nVariant, nErrmsg);	
                console.log('<<vehicles4'+vehicles+JSON.stringify(vehicles[rowindex]));
            }
		});
        $A.enqueueAction(dgaction);
      }
    }, 
    
    selectedRecordIdhelper : function(component,event) {
         //for new record:
        var action = component.get("v.tableAction"); 
        var vehicles = component.get("v.compVehiclesList");
        if(action == "New"){
          var rowindex = vehicles.length-1;    
        }//for edit record-- set index
        else if(action == "EditAgain"){
          var rowindex = component.get("v.Index");  
        }
        component.set("v.preferredrowindex", rowindex);
        console.log("v.preferredrowindex:::" + component.get("v.preferredrowindex"));
    },
    commitIntVehicles: function(component,event,helper) {
        var addS = component.get("v.compVehiclesList");
        var commitintVeh = component.get('c.savecompVehicles');
        var vehstr = JSON.stringify(addS);
        console.log('<<vehstr'+vehstr);
        commitintVeh.setParams({
            compVehicle : vehstr,
            recid: component.get("v.recId"),
            preferredindex: component.get("v.preferredrowindex")
        });  
        commitintVeh.setCallback(this,function(response){
            var state = response.getState();
            var resultMsg = response.getReturnValue();
            component.set('v.responsewrapper',resultMsg);
            console.log("state"+state+"<<resultMsg"+resultMsg);
            debugger;
            if (state === "SUCCESS") {
                if (resultMsg.response!=null && resultMsg.response == "Success") {	
                    console.log("came to sucess");
                    var sucessLabel = 'Competitor Vehicles added succesfully';
                    helper.showToast('dismissible', 'Success', sucessLabel); 
                    component.set('v.editableMode', false);
                    component.set('v.compVehiclesList', resultMsg.vehicleList);
                }else if(resultMsg.response!=null && resultMsg.response != "Success"){
                    console.log("came to  error inside succ");
                    var nVariant = "error";
                    var nErrmsg = resultMsg.response;
                    helper.handleShowNotice(component, nErrmsg, nVariant, nErrmsg);	   
                }
            }else if(state === "ERROR"){
                console.log("came to  error");
                var nVariant = "error";
                var nErrmsg = resultMsg;
                helper.handleShowNotice(component, nErrmsg, nVariant, nErrmsg);	    
            }
        });
        $A.enqueueAction(commitintVeh);
        helper.retrieverecords(component, event, helper); 
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
    cancel: function(component, event, helper) {
        component.set("v.isOpen","false");
        component.set('v.editableMode',false);
        component.set('v.compVehiclesList', component.get("v.compVehiclesListForCancel"));    
        helper.retrieverecords(component, event, helper);       
    },
})