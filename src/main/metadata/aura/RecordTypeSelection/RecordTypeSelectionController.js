({
    doInit: function(component, event, helper) {
        var rawMarketsCandidate = component.get("v.availableMarkets");
        var rawDefault = component.get('v.userMarket');
        var checkANZFlag = component.get('v.ANZCheckValue');
        var rawPrevious = null;
        var rawMarkets = (rawMarketsCandidate) ? rawMarketsCandidate.split(',') : [rawDefault];
        
        try {
            // Local Storage retrievals
            var previousSelection = localStorage.getItem("lastRecordType");
            if (previousSelection) {
                component.set('v.value',previousSelection);
            }
            var previousMarket = localStorage.getItem("lastMarketUsed");
            if (previousMarket) {
                var isActualMarket = false;
                for (var i=0;i<rawMarkets.length;i++) {
                    if (previousMarket == rawMarkets[i]) {
                        isActualMarket = true;
                        break;
                    }
                }
                if (isActualMarket) {
                    rawPrevious = previousMarket;
                }          
            }
        } catch (e) {
            // Nice try
            console.log(e);
        }
        //alert(rawDefault);
        var defaultSelect = rawDefault || localStorage.getItem("lastMarketUsed"); // TODO: read from local storage     
        var marketSelect = [];
        var defaultFound = false;
        for (var i=0;i<rawMarkets.length;i++) {
            marketSelect.push({'label': rawMarkets[i], 'value' : rawMarkets[i]});
            if (rawMarkets[i] == defaultSelect) {
                defaultFound = true;
            }
        }
        if (!defaultFound) {
            marketSelect.push({'label': defaultSelect, 'value' : defaultSelect});
        }
     
        component.set('v.selectedMarket',(rawPrevious || defaultSelect));
        component.set("v.availableMarketList", marketSelect);
        // Now Render
        component.set("v.componentReady",true);
    },
    
    onChangeRec :function(component, event, helper) {
        var radioGrpValue = component.get("v.value");
        var selMarket = component.get("v.selectedMarket");
        var getevent =  component.getEvent("RecordTypeSelected");
        try {
            localStorage.setItem("lastRecordType",radioGrpValue);
            localStorage.setItem("lastMarketUsed", selMarket);
        } catch (e) {
            console.log(e);
        } 
        getevent.setParams({
            recordTypeName : radioGrpValue,
            selectedMarket : selMarket,
            isCancel       : false  
        });
        getevent.fire();    
    },
     
    cancelNewMethod:function(component, event, helper) { 
       var getevent =   component.getEvent("RecordTypeSelected"); 
        getevent.setParams({
          isCancel : true 
        });
       getevent.fire();          
    }
})