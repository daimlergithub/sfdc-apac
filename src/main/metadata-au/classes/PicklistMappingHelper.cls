public class PicklistMappingHelper {

    private static Integer extractId(String externalKey)
    {
        return Integer.valueOf(externalKey.substringAfter('-'));
    }
    
    public static void updateExternalKey(List<SObject> newSObjects, String prefix)
    {
        // PM-{000000} / IP-{000000} / EP-{000000}
        Pattern p = Pattern.compile(prefix + '-\\d{6}+');

        // check that incoming external keys match the pattern and extract the maximum external key
        Integer maxInt = 0;
        for (SObject sObj : newSObjects)
        {
            String extKey = (String)sObj.get('External_Key__c');
            if (String.isNotEmpty(extKey))
            {
                if (p.matcher(extKey).matches())
                {
                    maxInt = Math.max(maxInt, Integer.valueOf(extractId(extKey)));
                }
                else
                {                    
                    System.debug(LoggingLevel.INFO, String.format('External Key {0} does not match the expected format and will be discarded.', new List<String>{extKey}));
                    sObj.put('External_Key__c', null);   
                }
            }
        }
        
        // get the maximum external key of existing records
        String sObjectName = newSObjects[0].getSObjectType().getDescribe().getName();
        
        String query = 'SELECT MAX(External_Key__c) max FROM ' + sObjectName;
        AggregateResult[] results = Database.query(query);
        
        if (results !=null && !results.IsEmpty())
        {
            String maxStr = (String)results[0].get('max');
            if (null != maxStr)
            {
                maxInt = Math.max(maxInt, Integer.valueOf(extractId(maxStr)));
            }
        }
        
        // assign external key to new records if not set
        for (SObject sObj : newSObjects)
        {
            if (String.isEmpty((String)sObj.get('External_Key__c')))
            {
                maxInt++;
                String maxIntStr = String.valueOf(maxInt);
                sObj.put('External_Key__c', String.format('{0}-{1}{2}', new List<String>{prefix, '000000'.substring(maxIntStr.length()), maxIntStr}));
            }
        }
    }
}