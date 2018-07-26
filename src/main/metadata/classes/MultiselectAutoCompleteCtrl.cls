/*------------------------------------------------------------
Author:         Mukul Goel
Company:        UST-Global
Description:    This class is controller for the Multipicklist object
Inputs:         n/a
Test Class:     MultiselectAutoCompleteCtrl_Test
History
<Date>      <Authors Name>      <Brief Description of Change>
21-Oct-16   Mukul Goel    		Created
------------------------------------------------------------*/

public with sharing class MultiselectAutoCompleteCtrl 
{
    public SelectOption[] leftOptions   { get; set; }
    public SelectOption[] rightOptions  { get; set; }
    public SelectOption[] prePopulateOptions { get; set; }
    public String strSelectedOptions    { get; set; }

	/*------------------------------------------------------------
    Author:         Mukul Goel
    Company:        UST Global Inc.
    Description:    Class Constructor
    Inputs:         
    Returns:        
    History
    <Date>      <Authors Name>      <Brief Description of Change>
    21-Oct-16   Mukul Goel    		Created
    ------------------------------------------------------------*/    
    public MultiselectAutoCompleteCtrl()
    {
        rightOptions = new List<SelectOption>();
        prePopulateOptions = new List<SelectOption>();
        leftOptions = new List<SelectOption>();
        strSelectedOptions = '';
    }
   
    public void assignToSelectedOption()
    {
        System.debug('Value of Selected' + strSelectedOptions);
        set<String> setString = new set<String>();
        for(String strValue: strSelectedOptions.split(' '))
            setString.add(strValue.trim());
        
        rightOptions.clear();
        
        for(SelectOption objOption: leftOptions)
        {
            if(setString.contains(objOption.getValue()))
                rightOptions.add(objOption);
        }
        system.debug('Value of Right Options' + rightOptions);
        system.debug('Value of Right Options' + rightOptions.size());
    }
    public string getMultiselectOptions()
    {
        String strJSON = '[';
        for(SelectOption objOption: leftOptions)
        {
            List<String> dispVal = objOption.getLabel().split(';');          
            strJSON += ',{\"id\":"' + objOption.getValue() + '", \"name\":"' + objOption.getLabel()+ '" , \"dispVal\":"' + dispVal[0]+ '"}';
        }        
        strJSON = strJSON.replaceFirst(',', '') + ']';
        system.debug('StrJSON' + strJSON );
        return strJSON;
    }
    public String getPrepopulatedData()
    {
        String strJSON = '[';        
    	if(prePopulateOptions != null && prePopulateOptions.size() >0 )
        {
            for(SelectOption objOption: prePopulateOptions)
            {
                strSelectedOptions += ObjOption.getValue() + ' ';
                List<String> dispVal = objOption.getLabel().split(';');  
            	strJSON += ',{\"id\":"' + objOption.getValue() + '", \"name\":"' + 
                    			objOption.getLabel()+ '" , \"dispVal\":"' + dispVal[1]+ '"}';
            }
        }
        strJSON = strJSON.replaceFirst(',', '') + ']';
        system.debug('StrJSON' + strJSON );
        assignToSelectedOption();
        return strJSON;
    }
}