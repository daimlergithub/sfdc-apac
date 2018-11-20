/* File Name   : strike_lookupController -->
<!-- Description : strike_lookupController Apex controller -->
<!-- Copyright   : Infosys Limited Copyright (c) 2018  -->
<!-- @author     : Sarath -->
<!-- Author Modification & Ver.Date : Sarath & 23-June-2018  */

public with sharing class strike_lookupController {
	public static Boolean conFNL=FALSE;
    public static String searchField ;
    public static String searchTerm;
    public static List<String> conIDS = new List<String>();
    @AuraEnabled
    public static String getRecentRecords(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        try {
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            Map<Id, RecentlyViewed> recentlyViewedMap = new Map<Id, RecentlyViewed>([SELECT Id
                                                                                     FROM RecentlyViewed
                                                                                     WHERE Type = :((String)jsonMap.get('object'))]);
            List<Id> idList = new List<Id>(recentlyViewedMap.keySet());

            if (idList.size() > 0) {
                String filter = 'Id IN (\'' + String.join(idList, '\',\'') + '\')';

                if (strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
                    filter += ' AND (' + jsonMap.get('filter') + ')';
                }

                jsonMap.put('filter', filter);

                responseData.results = strike_lookupController.getData(jsonMap);
            } else {
                responseData.results = new Map<String, Object>{
                    'data' => new List<String>(),
                    'searchTerm' => ''
                };
            }
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }

    @AuraEnabled
    public static String getRecordLabel(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        try {
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            String obj = (String)jsonMap.get('object');
            String objectLabel = Schema.describeSObjects(new List<String>{obj})[0].getLabel();

            responseData.results.put('objectLabel', objectLabel);
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }
    @AuraEnabled
    public static String ValueLabel(String recordId) {
        List<Product2> prod = new List<Product2>();
        try {
            if (recordId != null) {
                prod = [select id, name from Product2 where id = :recordId];
                return prod[0].name;
            }
        } catch (Exception e) {
        }
        return null;
    }

    @AuraEnabled
    public static String getRecords(String jsonString) {
        strike_responseData responseData = new strike_responseData();

        
        try {
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            responseData.results = strike_lookupController.getData(jsonMap);
        } catch (Exception e) {
            responseData.addError(e.getMessage());
        }

        return responseData.getJsonString();
    }

    private static Map<String, Object> getData(Map<String, Object> jsonMap) {
        List<Map<String, Object>> data = new List<Map<String, Object>>();

        String objType = String.escapeSingleQuotes((String)jsonMap.get('object'));
        String query = strike_lookupController.getQuery(jsonMap);
        String searchField = String.escapeSingleQuotes((String)jsonMap.get('searchField'));
        String searchTerm = '';
        String subtitleField;
        String subsubtitleField;
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subtitleField')) {
            subtitleField = String.escapeSingleQuotes((String)jsonMap.get('subtitleField'));
        }
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subsubtitleField')) {
            subsubtitleField = String.escapeSingleQuotes((String)jsonMap.get('subsubtitleField'));
        }
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchTerm')) {
            searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));
        }

        if (String.isEmpty(subtitleField)) {
            for (sObject obj : Database.query(query)) {
                data.add(new Map<String, Object>{
                    'label' => strike_lookupController.getValue(obj, objType, searchField),
                    'value' => obj.get('Id')
                });
            }
        } else {
            for (sObject obj : Database.query(query)) {
                data.add(new Map<String, Object>{
                    'label' => strike_lookupController.getValue(obj, objType, searchField),
                    'sublabel' => strike_lookupController.getValue(obj, objType, subtitleField),
                    'value' => obj.get('Id')
                });
            }
        }

        return new Map<String, Object>{
                   'data' => data,
                   'searchTerm' => searchTerm
        };
    }

    private static String getQuery(Map<String, Object> jsonMap) {
        Set<String> queryFields = new Set<String>{'Id'};
        List<String> filters = new List<String>();
        List<String> orders = new List<String>();

        String query;
        String obj = String.escapeSingleQuotes((String)jsonMap.get('object'));
        String subtitleField;
        String subsubtitleField;
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subtitleField')) {
            subtitleField = String.escapeSingleQuotes((String)jsonMap.get('subtitleField'));
            queryFields.add(subtitleField);
        }
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'subsubtitleField')) {
            subsubtitleField = String.escapeSingleQuotes((String)jsonMap.get('subsubtitleField'));
            queryFields.add(subsubtitleField);
        }
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchField')) {
            queryFields.add(String.escapeSingleQuotes((String)jsonMap.get('searchField')));

            if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchTerm')) {
                String searchField = String.escapeSingleQuotes((String)jsonMap.get('searchField'));
                String searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));

                filters.add(searchField + ' LIKE \'%' + searchTerm + '%\'');
            }
        }
        //Add and filter
        String filterAnd = strike_lookupController.fieldNotEmpty(jsonMap, 'filterAnd')
                           ? String.escapeSingleQuotes((String)jsonMap.get('filterAnd'))
                           : null;
        if (strike_lookupController.fieldNotEmpty(jsonMap, 'multiColSearch')) {
            //queryFields.add(String.escapeSingleQuotes((String)jsonMap.get('multiColSearch')));
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'searchTerm')) {
                String multiColSearch = String.escapeSingleQuotes((String)jsonMap.get('multiColSearch'));
                searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));
                String searchvalue = '';
                Boolean result = multiColSearch.contains(',');
                if (result) {
                    list<String> searchvalues = multiColSearch.split(',');
                    for (Integer i = 0; i < searchvalues.size(); i++) {
                        if (i == searchvalues.size() - 1) {
                            searchvalue = searchvalue + searchvalues[i] + getLikeClause(searchTerm, CONSTANTS.STRING_WILDCARD);
                            //searchvalue = searchvalue+searchvalues[i] + ' LIKE \'%' + searchTerm + '%\'';
                            queryFields.add(String.escapeSingleQuotes(searchvalues[i]));
                        } else {
                            queryFields.add(String.escapeSingleQuotes(searchvalues[i]));
                            //String[] searchvalues = searchField.split(',');
                            //searchvalue = searchvalue+searchvalues[i] + ' LIKE \'%' + searchTerm + '%\''+ ' OR ';
                            searchvalue = searchvalue + searchvalues[i] + getLikeClause(searchTerm, CONSTANTS.STRING_WILDCARD) + ' OR ';
                        }
                    }
                    filters.add(searchvalue);
                } else {
                    filters.add(multiColSearch + getLikeClause(searchTerm, CONSTANTS.STRING_WILDCARD));
                    //filters.add(multiColSearch + ' LIKE \'%' + searchTerm + '%\'');
                }
				System.debug('----searchTerm 242----'+searchTerm+'jsonMap 242: ' +  JSON.serialize(jsonMap));
            }
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
                filters.add('(' + (String)jsonMap.get('filter') + ')');
            }
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'order')) {
                orders.add(String.escapeSingleQuotes((String)jsonMap.get('order')));
            }
            query = 'SELECT ' + String.join(new list<String>(queryFields), ', ');
            query += ' FROM ' + obj;
            //Girish P : Added open close braces as AND and OR does not work without braces
            if (filters.size() > 0) {
                query += ' WHERE ' + CONSTANTS.STRING_OPEN_BRACES + String.join(filters, ' OR ') + CONSTANTS.STRING_CLOSE_BRACES;
            }
            //Girish P: add FilterAnd
            if (!String.isEmpty(filterAnd)) {
                query += CONSTANTS.SPACE + filterAnd;
            }
            //Ends here
            /*if (orders.size() > 0) {
                query += ' ORDER BY ' + String.join(orders, ', ');
            }
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
                query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
            }*/
			
			/**/if(obj == 'Contact'){ // added this complete if as a part of TCR 2115
				if(conFNL==FALSE){
					System.debug('----contact FALSE----'+obj+'----filters FALSE----'+filters+'----searchTerm----'+searchTerm);
					String searchField = String.escapeSingleQuotes((String)jsonMap.get('searchField'));
                    String searchTerm;
					System.debug('jsonMap : ' +  JSON.serialize(jsonMap));
                        if(jsonMap.containsKey('searchTerm')){
							filters.clear();
							searchTerm = String.escapeSingleQuotes((String)jsonMap.get('searchTerm'));
							filters.add(searchField + getLikeClause(searchTerm, CONSTANTS.STRING_WILDCARD));
							query = 'SELECT ' + String.join(new list<String>(queryFields), ', ');
						}
						else{
							query = 'SELECT ID, Name, FirstName, Email, Phone ';
						}
                        query += ' FROM ' + obj;
                        if (filters.size() > 0) {
                            query += ' WHERE ' + String.join(filters, ' OR ');
                        }
                        if (orders.size() > 0) {
                            query += ' ORDER BY ' + String.join(orders, ', ');
                        }
                        if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
                            query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
                        }
                    
					System.debug('----first name query----'+query);
				}
				else if(conFNL==TRUE){
					System.debug('----contact TRUE----'+obj+'----filters TRUE----'+filters+'----[0]----'+filters[0]+'----1----'+filters[0]);	
					System.debug('----filters----'+filters);
					filters.remove(0);
					query = 'SELECT ' + String.join(new list<String>(queryFields), ', ');
					query += ' FROM ' + obj;
					if (filters.size() > 0) {
						query += ' WHERE ( ' + String.join(filters, ' OR ') + ')';
					}   
                    if(conIDS.size() > 0){
                       query += ' AND ( ID NOT IN :conIDS )'; 
                    }
					if (orders.size() > 0) {
						query += ' ORDER BY ' + String.join(orders, ', ');
					}
					if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
						query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
					}
					System.debug('----without firstname----'+query);
				}
			}
			
			else{
				query = 'SELECT ' + String.join(new list<String>(queryFields), ', ');
				query += ' FROM ' + obj;
				if (filters.size() > 0) {
					query += ' WHERE ' + String.join(filters, ' OR ');
				}
				if (orders.size() > 0) {
					query += ' ORDER BY ' + String.join(orders, ', ');
				}
				if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
					query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
				}
			}/**/			
			
            system.debug('----query 305----' + query);
            return query;
        } else {
            //Adding SOSL only here for Address, As Address search should not happen on Multicoumns, performance impact
            String sLimit = '';
            String sWhere = '';
            String sOrder = '';
            String sFields = String.join(new list<String>(queryFields), ', ');
            query = 'SELECT ' + sFields;
            query += ' FROM ' + obj;
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'filter')) {
                filters.add('(' + (String)jsonMap.get('filter') + ')');
            }
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'order')) {
                orders.add(String.escapeSingleQuotes((String)jsonMap.get('order')));
            }
            if (filters.size() > 0) {
                query += ' WHERE ' + String.join(filters, ' And ');
                sWhere += ' WHERE ' + String.join(filters, ' And ');
            }
            //Girish P: add FilterAnd
            if (!String.isEmpty(filterAnd)) {
                query += CONSTANTS.SPACE + filterAnd;
            }
            //Ends here
            if (orders.size() > 0) {
                sOrder += ' ORDER BY ' + String.join(orders, ', ');
                query += ' ORDER BY ' + String.join(orders, ', ');
            }
            if (strike_lookupController.fieldNotEmpty(jsonMap, 'limit')) {
                query += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
                sLimit += ' LIMIT ' + String.escapeSingleQuotes((String)jsonMap.get('limit'));
            }
            //Girish P: Address Search Optimization, can be extended for other objects if needed.
            if (!String.isEmpty(searchTerm) && 'Address__c'.equalsIgnoreCase(obj)) {
				//searchTerm = searchTerm.contains('-').replace('-','\-');
				searchTerm = searchTerm.replace('-','\\-');
				system.debug('----obj 343----' +obj);
                query = 'FIND {"' + searchTerm + '"} IN ALL FIELDS RETURNING ' + obj + '(Name,' + sFields + sOrder + ')' + sLimit;
            }
            system.debug('----query 343----' +query);
            return query;
        }
    }

    private static Boolean fieldNotEmpty(Map<String, Object> jsonMap, String field) {
        return jsonMap.containsKey(field) && !String.isEmpty((String)jsonMap.get(field));
    }

    private static String getValue(SObject obj, String objectType, String field) {
        List<String> fieldPath = field.split('[.]');
        Object label = strike_utilities.convertObjectToMap(obj);
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectType).getDescribe().fields.getMap();

        for (String fieldName : fieldPath) {
            fieldName = fieldName.replaceAll('__r$', '__c');

            label = ((Map<String, Object>)label).get(fieldName);

            if (label == null) {
                return '';
            }

            if (fieldMap.containsKey(fieldName + 'Id')) {
                fieldName = fieldName + 'Id';
            }

            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
            String fieldType = String.valueOf(fieldDescribe.getType()).toUpperCase();

            if (fieldType == 'REFERENCE') {
                fieldMap = Schema.getGlobalDescribe().get(String.valueOf(fieldDescribe.getReferenceTo().get(0))).getDescribe().fields.getMap();
            } else if (fieldType == 'ADDRESS') {
                List<String> addressComponents = new List<String>();
                Map<String, Object> addr = (Map<String, Object>)label;

                if (addr.containsKey('street') && addr.get('street') != null) {
                    addressComponents.add((String)addr.get('street'));
                }

                if (addr.containsKey('city') && addr.get('city') != null) {
                    addressComponents.add((String)addr.get('city'));
                }

                if (addr.containsKey('state') && addr.get('state') != null) {
                    addressComponents.add((String)addr.get('state'));
                }

                if (addr.containsKey('country') && addr.get('country') != null) {
                    addressComponents.add((String)addr.get('country'));
                }

                if (addr.containsKey('postalCode') &&addr.get('postalCode') != null) {
                    addressComponents.add((String)addr.get('postalCode'));
                }

                // change later for user formatting?
                label = String.join(addressComponents, ', ');
            }
        }

        return String.valueOf(label);
    }
    
    public static String getLikeClause(String searchTerm, String searchType) {
        String likeClause = ' LIKE ';
        if (CONSTANTS.STRING_WILDCARD.equalsIgnoreCase(searchType)) {
            likeClause += '\'%' + searchTerm + '%\'';
        } else
            if (CONSTANTS.STRING_STARTS_WITH.equalsIgnoreCase(searchType)) {
                likeClause += '\'' + searchTerm + '%\'';
            }
        return likeClause;
    }
}