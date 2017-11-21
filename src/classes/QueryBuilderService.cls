/**
* @author Debasmita Kundu
* @date 08/02/2017
* @description This class provides generic SObject services including generating and/or executing database queries
*/

public with sharing class QueryBuilderService {	
	/** Constant representing the max records to be retrieved by a single SOQL query */
	public static final Integer MAX_ROWS = 10000;
	/** Constant representing the governor limit for SOQL rows returned in a single execution context */
	public static final Integer SOQL_ROW_GOV_LIMIT = 50000;
	/** Constant representing the SOQL query syntax for returning results in ascending order */
	public static final String ASC_DIR_ORDER = 'ASC';
	/** Constant representing the SOQL query syntax for returning results in descending order */
	public static final String DESC_DIR_ORDER = 'DESC';
	/** Constant representing the default sort order to use for SOQL queries */
	public static final String DEFAULT_DIR_ORDER = ASC_DIR_ORDER;
    /** Constant instance of inner WithoutSharing class */
	private static final WithoutSharing WithoutSharingInstance = new WithoutSharing();
	
	
    
    public static GlobalUtilityDFW gu = GlobalUtilityDFW.getInstance(); 
    
	
	/**
	
	* @date 12/17/2015
	* @description This method takes an iterable string list and a text field and returns a filter string for a dyanmic soql query
	* @param List A list of string values to be used in creating the filter
	* @param String The API name of the field to be querying against in the filter
	* @param Boolean Determines if the relationship filter is inclusive (default) or exclusive
	* @return String A filter string to be used in a dynamic SOQL query
	*/
	public static String BuildRelationshipFilter(list<String> valueList, String queryIdField, Boolean inclusive){
		gu.Push('QueryBuilderService.BuildRelationshipFilter');
		set<String> valueSet = new set<String>();
		for(Integer i=0; i<valueList.size(); i++){
			valueSet.add('\'' + String.escapeSingleQuotes(valueList[i]) + '\'');
		}
		if (valueSet.isEmpty()){
			valueSet.add('\'\'');
		}
		String modifier = inclusive ? '' : ' NOT';
		gu.Pop();
		return queryIdField + modifier + ' IN (' + String.join(new list<String>(valueSet),',') + ')';
	}
  	/**
	* @date 08/02/2017
	* @description This method takes an object name and returns its corresponding field map
	* @param String The API name of the object that needs its field map returned
	* @return Map A map of the given object's field API names to their corresponding Schema.SObjectField info
	*/
	private static map<String, Schema.SObjectField> FieldMap(String objectName){
		gu.Push('QueryBuilderService.FieldMap');
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
		gu.Pop();
		return sObjectType!=null ? new Map<String,Schema.SObjectField>(sObjectType.getdescribe().fields.getMap()) : new Map<String,Schema.SObjectField>();		
	}

	/**
	* @date 08/02/2017
	* @description Retrieves a list of fields accessible by the running user for an SObject from the database schema 
	* @param String SObject API name
	* @param Boolean Determines if text area fields should be included in the returned field list
	* @return List A list of fields accessible by the running user for the SObject
	*/
	public static list<String> FieldList(String objectAPIName, Boolean includeTextAreaFields){
		gu.Push('QueryBuilderService.FieldList');
		set<String> fieldSet = new set<String>();
		Map<String, Schema.SobjectField> fields = FieldMap(objectAPIName);
        system.debug('fields from fieldMap():::::::' + fields);
		if (!fields.isEmpty()){
			for (String s : new list<String>(fields.keyset())){
				// Ensure all fields are stored in lowercase
				s = s.toLowerCase();
				Schema.DescribeFieldResult dfr = fields.get(s).getDescribe();
                
				if ( Test.isRunningTest() && dfr.getName().contains('__c') && dfr.getLocalName() == dfr.getName() ){
					// Don't include custom fields that live outside the package in queries during testing
					continue;
				}
				if ( dfr.isAccessible() && (dfr.getType()!=Schema.DisplayType.TEXTAREA || includeTextAreaFields) ){
					fieldSet.add(s);
					
				}
                fieldSet.add(s);
			}
		}
		 gu.Pop();
		return new list<String>(fieldSet);
	}

	/**
	* @date 08/02/2017
	* @description Retrieves from a specified field list those accessible by the running user for a given SObject
	* @param String SObject API name
	* @param List A specific list of fields to be included in field list
	* @return List A list of fields accessible by the running user for the SObject
	*/
	public static list<String> FieldList(String objectAPIName, list<String> fieldList){
		gu.Push('QueryBuilderService.FieldList');
		// Prevent null reference error in case of null field list
		system.debug('fieldlist inside fieldList method::::' + fieldList);
		if (fieldList==null || fieldList.isEmpty()){
			//gu.Pop();
			return null;
		}
		Set<String> accessibleFields = new Set<String>(FieldList(objectAPIName, true));
		// Return fields from given list that exist in the accessible field set 
		system.debug('accessibleFields inside fieldList method::::' + accessibleFields);
        
        set<String> fieldSet = new set<String>();
		for (String field : fieldList){
			// Convert to safe API name
			field = SafeName(field);
			if (accessibleFields.contains(field)) fieldSet.add(field);
		}
		gu.Pop();
        system.debug('new fieldset::::::' + new list<String>(fieldSet));
		return new list<String>(fieldSet);
	}

	/**
    * 08/02/2017
    * @description Generates a safe, properly escaped dynamic SOQL query filter from given, potentially unsafe clause
    * @param String Potentially unsafe filter clause for dynamic SOQL query
    * @return String Safe, properly single-quote escaped dyanmic SOQL query filter clause
    */
    private static String CleanseSoqlFilter(String filter){
        gu.Push('QueryBuilderService.CleanseSoqlFilter');
        // First and foremost, escape all single quotes to prevent SOQL injection
        filter = String.escapeSingleQuotes(filter);
        // Correct any redundancies (in case filter clause was already properly escaped) using replace method, which doesnt utilize RegEx
        filter = filter.replace('\\\\\\\'','\\\''); // <-- Replaces instances of "\\\'" with "\'"
        // Filters on strings should now have their literal values properly escaped, but the condition expression boundaries may not be right
        // Example: "LIKE \' \' Example \' \'" should actually be "LIKE ' \' Example \' '"
        // This can be corrected by using RegEx and the Pattern/Matcher classes to find instances of string filters and then adjusting the boundaries
        Pattern valuePattern = Pattern.compile('(?im)(\\slike\\s\\\\\'|=\\s\\\\\'|\\sin\\s)[\\s\\S]+?(?=\\sand\\s|\\sor\\s|$)'); // <-- Double escaping necessary for "\" character first for string literal, and then for RegEx
        Matcher valueMatcher = valuePattern.matcher(filter);
        Integer indexCtr = 0;
        String cleansedFilter = '';
        while (valueMatcher.find()){
            cleansedFilter += filter.substring(indexCtr,valueMatcher.start());
            String tempMatch = valueMatcher.group();
            // Correct first boundary using replaceFirst method, which relies on RegEx
            tempMatch = tempMatch.replaceFirst('\\\\\'','\''); // <-- Double-escaping necessary for "\" character first for string literal, and then for RegEx: Replaces instances of "\'" with "'"
            // Correct other boundary using lastIndexOf method, which does not utilize RegEx
            Integer lastQuoteIndex = tempMatch.lastIndexOf('\\\''); // <-- "\" character need only be single-escaped: Replaces instances of "\'" with "'"
            // Append additional characters after other boundary if needed
            if (lastQuoteIndex+2 < tempMatch.length())
                tempMatch = tempMatch.substring(0,lastQuoteIndex) + '\'' + tempMatch.substring(lastQuoteIndex+2);
            else
                tempMatch = tempMatch.substring(0,lastQuoteIndex) + '\'';
            // Relationship filters utilizing the IN clause will have additional inner, comma-delimited boundaries that must be corrected
            if (tempMatch.startsWithIgnoreCase(' in '))
                tempMatch = tempMatch.replace('\\\',\\\'','\',\'');
            cleansedFilter += tempMatch;
            indexCtr = valueMatcher.end();
        }
        cleansedFilter += filter.substring(indexCtr);
         gu.Pop();
        return cleansedFilter;
    }

	/**
	* @date 08/02/2017
	* @description Generates a dynamic SOQL query based on a given object, field list, and other parameters
	* @param String SObject name
	* @param Set A set of fields from the given SObject that should be included within the query
	* @param Set A set of any relationship fields, such as those from parent records, that should be included in the query
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param String The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return String A dyanmic SOQL query
	*/
	private static String BuildSoqlString(String objectAPIName, set<String> objectFieldList, set<String> relationshipFields, String filter, set<String> orderByFieldSet, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.BuildSoqlString');
		String soql = 'SELECT ' + String.escapeSingleQuotes(String.join(new list<String>(objectFieldList),','));
		if (relationshipFields!=null && !relationshipFields.isEmpty()){
			soql += ', ' + String.escapeSingleQuotes(String.join(new list<String>(relationshipFields),',')); 
		}
		soql += ' FROM ' + String.escapeSingleQuotes(objectAPIName);
		if (filter!=null && filter!=''){
			soql += ' WHERE ' + CleanseSoqlFilter(filter);
		}
		if (orderByFieldSet!=null && !orderByFieldSet.isEmpty()) {
			if (lockRows==null || !lockRows){ // ORDER BY clause is not allowed in row locking SOQL statements
				soql += ' ORDER BY ' + String.escapeSingleQuotes(String.join(new list<String>(orderByFieldSet),','));
				if (!ASC_DIR_ORDER.equalsIgnoreCase(orderDirection) && !DESC_DIR_ORDER.equalsIgnoreCase(orderDirection)){
					soql += ' ' + DEFAULT_DIR_ORDER;
				}
				else{
					soql += ' ' + String.escapeSingleQuotes(orderDirection.toUpperCase());
				}
			}				
		}
		if (limitTo!=null && limitTo>0){
			if (limitTo > SOQL_ROW_GOV_LIMIT){
				limitTo = SOQL_ROW_GOV_LIMIT;
			}
			soql += ' LIMIT ' + String.escapeSingleQuotes(String.valueOf(limitTo));
		}
		if (lockRows!=null && lockRows){
			soql += ' FOR UPDATE';
		}
        system.debug('soql:::' + soql);
		gu.Pop();		
		return soql;
	}
		
  	/**
	* @date 08/02/2017
	* @description Builds a dynamic SOQL query of all accessible fields for a given SObject
	* @param String SObject name
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param Boolean Determines if text area fields should be included in query, which can greatly impact processing time and heap size
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param String The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return String A dyanmic SOQL query
	*/
	private static String BuildQuery(String objectAPIName, list<String> relationshipFields, Boolean includeTextAreaFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.BuildQuery');
		// Determine all accessible orderBy fields
		list<String> orderByFieldList = FieldList(objectAPIName, orderBy);
		// Generate Dynamic SOQL Query for all accessible fields for the object
		list<String> objectFieldList = FieldList(objectAPIName, includeTextAreaFields);
		gu.Pop();
		return BuildSoqlString(objectAPIName,
			objectFieldList!=null ? new Set<String>(objectFieldList) : null,
			relationshipFields!=null ? new Set<String>(relationshipFields) : null,
			filter,
			orderByFieldList!=null ? new Set<String>(orderByFieldList) : null,
			orderDirection,
			limitTo,
			lockRows);
	}

	/**
	* @date 08/02/2017
	* @description Executes a dynamic SOQL query of all accessible fields for a given SObject
	* @param String SObject API name
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param Boolean Determines if text area fields should be included in query, which can impact processing time and heap size
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param Integer The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return List A list of SObjects returned by the query
	*/
	public static list<SObject> RunQuery(String objectAPIName, list<String> relationshipFields, Boolean includeTextAreaFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.RunQuery');
		// Execute Dynamic SOQL Query
		gu.Pop();
		return Database.query( BuildQuery(objectAPIName, relationshipFields, includeTextAreaFields, filter, orderBy, orderDirection, limitTo, lockRows) );
	}
    
    /**	
	* @date 6/20/2016
	* @description Executes a dynamic SOQL query of all accessible fields for a given SObject, ignores sharing permissions
	* @param String SObject API name
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param Boolean Determines if text area fields should be included in query, which can impact processing time and heap size
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param Integer The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return List A list of SObjects returned by the query
	*/
	public static list<SObject> RunQueryWithoutSharing(String objectAPIName, list<String> relationshipFields, Boolean includeTextAreaFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.WithoutSharing.RunQueryWithoutSharing');
		// Execute Dynamic SOQL Query, ignoring sharing permissions
		gu.Pop();
		return WithoutSharingInstance.RunWithoutSharingQuery(objectAPIName, relationshipFields, includeTextAreaFields, filter, orderBy, orderDirection, limitTo, lockRows);
	}

	
	/**
	* 08/02/2017
	* @description Builds a dynamic SOQL query of the accessible fields from a specified list for a given SObject
	* @param String SObject name
	* @param List The specific list of fields from the given SObject that should be included within the query, if accessible
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param String The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return String A dyanmic SOQL query
	*/
	private  static String BuildQuery(String objectAPIName, list<String> fieldList, list<String> relationshipFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.BuildQuery');
		// Determine all accessible orderBy fields
		list<String> orderByFieldList = FieldList(objectAPIName, orderBy);
		// Add accessible orderBy fields to fieldList
		if (fieldList==null)
			fieldList = new List<String>();
		if (orderByFieldList!=null)
			fieldList.addAll(orderByFieldList);
		// Generate Dynamic SOQL Query for all accessible fields from the given field list and orderBy fields
		//system.debug('fieldlist:::::::::' + fieldList);
        list<String> objectFieldList = FieldList(objectAPIName, fieldList);
        //system.debug('objectFieldList:::::::::' + objectFieldList);
		gu.Pop();
        
		return BuildSoqlString(objectAPIName,
			objectFieldList!=null ? new Set<String>(objectFieldList) : null,
			relationshipFields!=null ? new Set<String>(relationshipFields) : null,
			filter,
			orderByFieldList!=null ? new Set<String>(orderByFieldList) : null,
			orderDirection,
			limitTo,
			lockRows);
	}

	/**
	* @date 08/02/2017
	* @description Executes a dynamic SOQL query of the accessible fields from a specified list for a given SObject
	* @param String SObject API name
	* @param List The specific list of fields from the given SObject that should be included within the query, if accessible
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param Integer The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return List A list of SObjects returned by the query
	*/
	public static list<SObject> RunQuery(String objectAPIName, list<String> fieldList, list<String> relationshipFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.RunQuery');
		// Execute Dynamic SOQL Query
		gu.Pop();
		return Database.query( BuildQuery(objectAPIName, fieldList, relationshipFields, filter, orderBy, orderDirection, limitTo, lockRows) );
	}
    
    /**
	* @date 08/02/2017
	* @description Executes a dynamic SOQL query of the accessible fields from a specified list for a given SObject, ignores sharing permissions
	* @param String SObject API name
	* @param List The specific list of fields from the given SObject that should be included within the query, if accessible
	* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
	* @param String The filter clause for the query
	* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
	* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
	* @param Integer The limit clause for the query
	* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
	* @return List A list of SObjects returned by the query
	*/
	public static list<SObject> RunQueryWithoutSharing(String objectAPIName, list<String> fieldList, list<String> relationshipFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
		gu.Push('QueryBuilderService.WithoutSharing.RunQueryWithoutSharing');
		// Execute Dynamic SOQL Query, ignoring sharing permissions
		gu.Pop();
		return WithoutSharingInstance.RunWithoutSharingQuery(objectAPIName, fieldList, relationshipFields, filter, orderBy, orderDirection, limitTo, lockRows);
	}
    
    
    /**
	* @date 12/17/2015
	* @description Retrieves the proper API name for a given field API name in case person accounts is enabled
	* @param String API name for an SObject field
	* @return String The proper API name of the SObject field
	*/
	private static String PersonAccountAlias(String fieldName){
		gu.Push('SObjectService.PersonAccountAlias');
		// Make logic case-insensitive
		fieldName = fieldName.toLowerCase();
		String safeFieldName;
		// Unchanged
		if ( Schema.SObjectType.Account.Fields.getMap().keySet().contains(fieldName) )
			safeFieldName = fieldName;			
		// Custom Contact Fields
		fieldName = fieldName.replace('__c','__pc');
		if ( Schema.SObjectType.Account.Fields.getMap().keySet().contains(fieldName) )
			safeFieldName = fieldName;
		// Standard Contact Fields
		if ( Schema.SObjectType.Account.Fields.getMap().keySet().contains('person' + fieldName) )
			safeFieldName = 'person' + fieldName;
    	gu.Pop();
    	return safeFieldName;
	}

    /**    
    * @date 12/17/2015
    * @description Returns the safe name for a given SObject/Field
    * @param String API name for an SObject/Field
    * @return String The safe API name for an SObject/Field
    */
    private static String SafeName(String genericApiName){
      		gu.Push('SObjectService.SafeName');    	
      		gu.Pop();
      	    return PersonAccountAlias(genericApiName)!=null ? PersonAccountAlias(genericApiName) : genericApiName.toLowerCase();
 }
    
    
    
    /**
	* @date 08/02/2017
	* @description Ignore class used for running queries that ignore sharing permissions
	*/
    private without sharing class WithoutSharing {

    	/**
		* @date 08/02/2017
		* @description Executes a dynamic SOQL query of all accessible fields for a given SObject, ignores sharing permissions
		* @param String SObject API name
		* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
		* @param Boolean Determines if text area fields should be included in query, which can impact processing time and heap size
		* @param String The filter clause for the query
		* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
		* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
		* @param Integer The limit clause for the query
		* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
		* @return List A list of SObjects returned by the query
		*/
		private list<SObject> RunWithoutSharingQuery(String objectAPIName, list<String> relationshipFields, Boolean includeTextAreaFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
			gu.Push('QueryBuilderService.WithoutSharing.RunWithoutSharingQuery');
			// Execute Dynamic SOQL Query
			gu.Pop();
			return Database.query( QueryBuilderService.BuildQuery(objectAPIName, relationshipFields, includeTextAreaFields, filter, orderBy, orderDirection, limitTo, lockRows) );
		}

    	/**
		* @date 08/02/2017
		* @description Executes a dynamic SOQL query of the accessible fields from a specified list for a given SObject, ignores sharing permissions
		* @param String SObject API name
		* @param List The specific list of fields from the given SObject that should be included within the query, if accessible
		* @param List A list of any relationship fields, such as those from parent records, that should be included in the query
		* @param String The filter clause for the query
		* @param Set A set of fields to be used in the order by clause for the query, ignored when locking rows
		* @param String The direction (ascending or descending) to use when ordering values, ignored when locking rows
		* @param Integer The limit clause for the query
		* @param Boolean Determines if the SOQL query should perform pessimistic row locking to prevent concurrency issues
		* @return List A list of SObjects returned by the query
		*/
		private list<SObject> RunWithoutSharingQuery(String objectAPIName, list<String> fieldList, list<String> relationshipFields, String filter, list<String> orderBy, String orderDirection, Integer limitTo, Boolean lockRows){
			gu.Push('QueryBuilderService.WithoutSharing.RunWithoutSharingQuery');
			// Execute Dynamic SOQL Query
			gu.Pop();
			return Database.query( QueryBuilderService.BuildQuery(objectAPIName, fieldList, relationshipFields, filter, orderBy, orderDirection, limitTo, lockRows) );
		}

    }
}