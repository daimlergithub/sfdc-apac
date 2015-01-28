global class DeploymentUtil
{

    private static final Double VERSION = 32;
    
    private static final Set<String> NO_CHILD_HANDLING = new Set<String>();
    static {
    	NO_CHILD_HANDLING.add('CustomObject');
    	NO_CHILD_HANDLING.add('Workflow');
  	}
    
    webservice static List<String> refreshUpdateStamps(List<String> resources)
    {
        List<String> result = new List<String>();
        
        MetadataService.MetadataPort service = createService();
        
        Set<String> objects = new Set<String>(resources);
        
        MetadataService.DescribeMetadataResult mdResult = service.describeMetadata(VERSION);
        for (MetadataService.DescribeMetadataObject mdObject : mdResult.metadataObjects) {
            // only consider specified objects
            if (!objects.contains(mdObject.xmlName)) {
              	continue;
            }
            Map<String, List<MetadataService.FileProperties>> filePropertiesMap = listMetadata(service, mdObject);

            for (String name : filePropertiesMap.keySet()) {
              	List<MetadataService.FileProperties> propertiesList = filePropertiesMap.get(name);
                if (null != propertiesList) {
                    for (MetadataService.FileProperties properties : propertiesList) {
                        Long timestamp = properties.lastModifiedDate.getTime();
                        List<String> params = new String[]{name, properties.fullName, String.valueOf(timestamp)};
                            result.add(String.format('{0}/{1}:{2}', params));
                    }
                }
            }
        }
        
        saveInStaticResource(service, result);
        
        return result;
    }
    
    private static void saveInStaticResource(MetadataService.MetadataPort service,
                                             List<String> updateStamps)
    {
        String csv = String.join(updateStamps, '\n');
        
		MetadataService.StaticResource sr = new MetadataService.StaticResource();
		sr.fullName  = 'UpdateStamps';
        sr.content = EncodingUtil.base64Encode(Blob.valueOf(csv));
        sr.cacheControl = 'Private';
        sr.contentType = 'text/plain';
        sr.description = 'Deployment metadata.';
        
		List<MetadataService.UpsertResult> results = 		
			service.upsertMetadata(
				new MetadataService.Metadata[] { sr });
        
        // TODO result handling
    }
    
    private static Map<String, List<MetadataService.FileProperties>> listMetadata(MetadataService.MetadataPort service,
                                                                                  MetadataService.DescribeMetadataObject mdObject)
  	{
    	Map<String, List<MetadataService.FileProperties>> result = new Map<String, List<MetadataService.FileProperties>>();
        
        String name = mdObject.xmlName;
    	
        System.debug('Object: ' + name);
        
	    if (null != mdObject.childXmlNames && 0 < mdObject.childXmlNames.size() && !NO_CHILD_HANDLING.contains(name)) {
            
            System.debug('Children: ' + String.join(mdObject.childXmlNames, ','));
            
            for (String child : mdObject.childXmlNames) {
                List<MetadataService.FileProperties> metadata = listMetadata(service, child, null);
                
                result.put(child, metadata);
            }
        }
        else {
          	if (mdObject.inFolder) {
                System.debug('Folder object');
                
                // folder objects
                Map<String, String> replacements = new Map<String, String>();
                replacements.put('Document', 'DocumentFolder');
                replacements.put('EmailTemplate', 'EmailFolder');
                replacements.put('Dashboard', 'DashboardFolder');
                replacements.put('Report', 'ReportFolder');

                // get the folders first
				List<MetadataService.FileProperties> metadata = listMetadata(service, replacements.get(mdObject.xmlName), null);
              
                if (null != metadata && 0 < metadata.size()) {
                    // add the folders itself first
                    List<MetadataService.FileProperties> fileList = new List<MetadataService.FileProperties>(metadata);
                    
                    for (MetadataService.FileProperties properties : metadata) {
                    	List<MetadataService.FileProperties> folderMetadata = listMetadata(service, name, properties.fullName);
                        
                        fileList.addAll(folderMetadata);
                    }
                    
                	result.put(name, fileList);
                }
      		}
      		else {
                System.debug('Regular object');
                
                // regular metadata category
                result.put(name, listMetadata(service, name, null));
    		}
    	}
    	return result;
	}
    
    private static MetadataService.FileProperties[] listMetadata(MetadataService.MetadataPort service, String type, String folder)
    {
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        
        System.debug('ListMetadata: ' + type + ',' + folder);
        
        MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
        query.type_x = type;
        if (null != folder) {
            query.folder = folder;
        }
        queries.add(query);     
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, VERSION);
        
        return fileProperties;
    }
    
    private static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}