({
    flattenStructure : function (topObject, prefix, toBeFlattened,helper) {
        for (const prop in toBeFlattened) {
            const curVal = toBeFlattened[prop];
            if (curVal != 'RecordType' && typeof curVal === 'object') {
                helper.flattenStructure(topObject, prefix + prop + '.', curVal);
            } else {
                if(prop == 'Id'){
                    topObject[prefix + prop] = '/'+curVal;
                }
                else{
                    topObject[prefix + prop] = curVal;
                }
            }
        }
    }
})