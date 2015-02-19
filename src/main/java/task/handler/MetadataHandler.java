/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.types.LogLevel;

import task.handler.UpdateStampHandler.Action;
import task.model.SfdcExclude;
import task.model.SfdcInclude;
import task.model.SfdcTypeSet;
import deployer.DeploymentConfiguration;
import deployer.DeploymentUnit;

/**
 * MetadataHandler
 *
 * @author  XLEHMF
 */
public class MetadataHandler
{

  private LogWrapper logWrapper;
  private String metadataRoot;
  private boolean debug;
  private BaseUpdateHandler<?> updateStampHandler;

  public void initialize(LogWrapper logWrapper, String metadataRoot, boolean debug, BaseUpdateHandler<?> updateStampHandler)
  {
    this.logWrapper = logWrapper;
    this.metadataRoot = metadataRoot;
    this.debug = debug;
    this.updateStampHandler = updateStampHandler;
    
    validate();
  }

  private void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("MetadataHandler (logWrapper) not properly initialized.");
    }
    if (null == metadataRoot) {
      throw new BuildException("MetadataHandler (metadataRoot) not properly initialized.");
    }
    if (null == updateStampHandler) {
      throw new BuildException("MetadataHandler (updateStampHandler) not properly initialized.");
    }
  }

  public List<DeploymentInfo> compileDeploymentInfos(List<SfdcTypeSet> typeSets)
  {
    List<DeploymentUnit> duList = new DeploymentConfiguration().getConfigurations();

    List<DeploymentInfo> deploymentInfos = new ArrayList<>();
    for (SfdcTypeSet typeSet : typeSets) {
      DeploymentUnit du = findDeploymentUnitBySubDir(duList, typeSet.getName());

      List<File> fileList = compileFileList(du, typeSet);
      if (fileList.isEmpty()) {
        continue;
      }

      List<String> entityNames = compileEntityNames(du, fileList);

      deploymentInfos.add(new DeploymentInfo(du, fileList, entityNames));
    }

    return deploymentInfos;
  }

  private DeploymentUnit findDeploymentUnitBySubDir(List<DeploymentUnit> duList, String subDir)
  {
    for (DeploymentUnit du : duList) {
      if (subDir.equals(du.getSubDir())) {
        return du;
      }
    }

    throw new BuildException(String.format("Could not find deployment unit for directory %s.", subDir));
  }
  
  private DeploymentUnit findDeploymentUnitByName(List<DeploymentUnit> duList, String objectName)
  {
    for (DeploymentUnit du : duList) {
      if (du.getTypeName().equals(objectName) || du.isChild(objectName)) {
        return du;
      }
    }

    throw new BuildException(String.format("Could not find deployment unit for object name %s.", objectName));
  }

  private List<File> compileFileList(DeploymentUnit du, SfdcTypeSet typeSet)
  {
    String type = du.getTypeName();

    logWrapper.log(String.format("Collect files to deploy for type %s.", type));

    File baseDir = new File(metadataRoot);

    List<File> fileList = du.getFiles(baseDir);

    // process includes
    List<File> filteredFileList = new ArrayList<>();
    if (typeSet.getIncludes().isEmpty()) {
      filteredFileList.addAll(fileList);
    }
    else {
      for (SfdcInclude include : typeSet.getIncludes()) {
        for (File file : fileList) {
          String fileName = StringUtils.substringBefore(file.getName(), ".");
          if (fileName.matches(include.getName())) {
            filteredFileList.add(file);
          }
        }
      }
    }

    // process excludes
    if (!typeSet.getExcludes().isEmpty()) {
      for (SfdcExclude exclude : typeSet.getExcludes()) {
        Iterator<File> fileItr = filteredFileList.iterator();
        while (fileItr.hasNext()) {
          File file = fileItr.next();
          String fileName = StringUtils.substringBefore(file.getName(), ".");
          if (fileName.matches(exclude.getName())) {
            fileItr.remove();
          }
        }
      }
    }

    // check timestamps
    Set<String> entitiesToUpdate = new HashSet<String>();
    for (File file : filteredFileList) {
      if (updateStampHandler.isUpdateRequired(du, file)) {
        entitiesToUpdate.add(du.getEntityName(file));
      }
    }
    Iterator<File> fileItr = filteredFileList.iterator();
    while (fileItr.hasNext()) {
      File file = fileItr.next();
      String entityName = du.getEntityName(file);
      if (!entitiesToUpdate.contains(entityName)) {
        fileItr.remove();
      }
    }

    if (filteredFileList.isEmpty()) {
      logWrapper.log(String.format("Nothing to include for %s.", type));
    }

    return filteredFileList;
  }

  private List<String> compileEntityNames(DeploymentUnit du, List<File> fileList)
  {
    // we need the list to keep the order of the files
    Set<String> entitySet = new HashSet<>();
    List<String> entityNames = new ArrayList<>();
    for (File file : fileList) {
      String entityName = du.getEntityName(file);

      if (null == entityName) {
        throw new BuildException(String.format("Error getting entity name for file %s.", file.getName()));
      }

      if (!entitySet.contains(entityName)) {
        entitySet.add(entityName);
        entityNames.add(entityName);
      }
    }

    return entityNames;
  }

  public byte[] createPackageXml(List<DeploymentInfo> deploymentInfos)
  {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    
    try {
      writeHeader(baos);

      for (DeploymentInfo info : deploymentInfos) {
        DeploymentUnit du = info.getDeploymentUnit();

        String type = du.getTypeName();

        writeEntity(baos, type, info.getEntityNames());
      }
      writeFooter(baos);
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error creating package.xml: %s.", e.getMessage()), e);
    }

    return baos.toByteArray();
  }
  
  public byte[] createPackageXml(Map<String, List<String>> metadata)
  {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    
    try {
      writeHeader(baos);
      
      for (Map.Entry<String, List<String>> entry : metadata.entrySet()) {
        List<String> fullNames = entry.getValue();
        if (!fullNames.isEmpty()) {
          Collections.sort(fullNames);
        
          String type = entry.getKey();
          
          writeEntity(baos, type, fullNames);
        }
      }
      writeFooter(baos);
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error creating package.xml: %s.", e.getMessage()), e);
    }
    
    return baos.toByteArray();
  }
  
  public void savePackageXml(byte[] packageXml)
  {
    // debugging
    if (debug) {
      String fileName = "metadata-" + System.currentTimeMillis() + ".xml";
      
      logWrapper.log(String.format("Save metadata."));
  
      try {
        File tmpDir = new File("tmp");
        tmpDir.mkdirs();
        File metadataXml = new File(tmpDir, fileName);
        FileOutputStream fos = new FileOutputStream(metadataXml);
        fos.write(packageXml);
        fos.close();
      }
      catch (IOException e) {
        logWrapper.log(String.format("Error preparing metadata.xml for retrieval: %s.", e.getMessage()), e, LogLevel.WARN.getLevel());
      }
    }
  }

  private void writeEntity(ByteArrayOutputStream baos, String type, List<String> entityNames)
    throws IOException, UnsupportedEncodingException
  {
    baos.write("<types>\n".getBytes("UTF-8"));
    for (String entityName : entityNames) {
      baos.write(("<members>" + entityName + "</members>\n").getBytes("UTF-8"));
    }
    baos.write(("<name>" + type + "</name>\n").getBytes("UTF-8"));
    baos.write("</types>\n".getBytes("UTF-8"));
  }

  private void writeFooter(ByteArrayOutputStream baos)
    throws IOException, UnsupportedEncodingException
  {
    baos.write("<version>32.0</version>\n".getBytes("UTF-8"));
    baos.write("</Package>\n".getBytes("UTF-8"));
  }

  private void writeHeader(ByteArrayOutputStream baos)
    throws IOException, UnsupportedEncodingException
  {
    baos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes("UTF-8"));
    baos.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n".getBytes("UTF-8"));
    //baos.write("<fullName>cleanup</fullName>".getBytes("UTF-8"));
  }

  public Map<String, List<String>> collectMetadataToUpdate(Map<String, Action> differences)
  {
    Map<String, List<String>> metadata = new HashMap<>();
    
    for (Map.Entry<String, UpdateStampHandler.Action> entry : differences.entrySet()) {
      switch (entry.getValue()) {
        case ADD:
        case CHANGE:
          String key = entry.getKey();
          String entity = StringUtils.substringBefore(key, "/");
          List<String> entities = metadata.get(entity);
          if (null == entities) {
            entities = new ArrayList<>();
            metadata.put(entity, entities);
          }
          entities.add(StringUtils.substringAfter(key, "/"));
          break;
        default:
          //nothing do to
      }
    }

    return metadata;
  }

  public void removeMetadataToDelete(Set<String> objects, Map<String, Action> differences)
  {
    Map<String, List<String>> metadata = new HashMap<>();
    
    for (Map.Entry<String, UpdateStampHandler.Action> entry : differences.entrySet()) {
      switch (entry.getValue()) {
        case DELETE:
          String key = entry.getKey();
          String entity = StringUtils.substringBefore(key, "/");
          List<String> entities = metadata.get(entity);
          if (null == entities) {
            entities = new ArrayList<>();
            metadata.put(entity, entities);
          }
          entities.add(StringUtils.substringAfter(key, "/"));
          break;
        default:
          //nothing do to
      }
    }

    List<DeploymentUnit> configurations = new DeploymentConfiguration().getConfigurations();
    
    // delete files for objects to be considered only
    for (Map.Entry<String, List<String>> entry : metadata.entrySet()) {
      String key = entry.getKey();
      Set<String> entities = new HashSet<>(entry.getValue());
      
      DeploymentUnit du = findDeploymentUnitByName(configurations, key);
      if (objects.contains(du.getTypeName())) {
        File baseDir = new File(metadataRoot);
        
        List<File> files = du.getFiles(baseDir);
        
        Collections.reverse(files);
        
        for (File file : files) {
          String entityName = du.getEntityName(file);
          if (entities.contains(entityName)) {
            logWrapper.log(String.format("Delete file %s for entity %s.", file.getName(), entityName));
            if (!file.delete()) {
              throw new BuildException(String.format("File %s of type %s could not be deleted.", file.getName(), key));
            }
          }
        }
      }
    }
    
  }

  public void removeNotcontainedMetadata(final Map<String, List<String>> metadata, final Set<String> objects, final boolean cleanupOther)
  {
    // delete everything which was not retrieved
    File baseDir = new File(metadataRoot);
    
    final List<DeploymentUnit> configurations = new DeploymentConfiguration().getConfigurations();

    // TODO remove
//    for (String key : metadata.keySet()) {
//      logWrapper.log(String.format("%s: [%s]", key, StringUtils.join(metadata.get(key), ",")));
//    }
    
    // iterate over base directory and delete everything not in metadata
    File[] dirs = baseDir.listFiles(new FileFilter() {
      
      @Override
      public boolean accept(File pathname)
      {
        if (pathname.isDirectory()) {
          DeploymentUnit du = findDeploymentUnitBySubDir(configurations, pathname.getName());
          
          // TODO remove
//          if (null != du) {
//            logWrapper.log(String.format("du: %s -> [%s]", du.getTypeName(), StringUtils.join(du.getChildNames(), ",")));
//          } else {
//            logWrapper.log(String.format("No du for path: %s", pathname.getName()));
//          }
          
          if (null == du || ((cleanupOther || typeOrChildrenInObjects(objects, du)) && !typeOrChildrenInObjects(metadata.keySet(), du))) {
            try {
              logWrapper.log(String.format("Delete directory: %s.", pathname.getName()));
              
              FileUtils.deleteDirectory(pathname);
            }
            catch (IOException e) {
              // TODO 
              e.printStackTrace();
              
              throw new BuildException(String.format("Error deleting directory: %s.", e.getMessage()), e);
            }
            
            return false;
          } else {
            return typeOrChildrenInObjects(objects, du);
          }
        } else if (pathname.isFile()) {
          if (!"package.xml".equals(pathname.getName())) {
            logWrapper.log(String.format("Delete file: %s.", pathname.getName()));
            
            pathname.delete();
          }
          return false;
        } 
        return true;
      }
    });
    
    // TODO remove
//    for (String key : metadata.keySet()) {
//      logWrapper.log(String.format("%s: [%s]", key, StringUtils.join(metadata.get(key), ",")));
//    }
    
    for (File dir : dirs) {
      DeploymentUnit du = findDeploymentUnitBySubDir(configurations, dir.getName());
      
      // TODO remove
//      logWrapper.log(String.format("%s - %s", du.getSubDir(), du.getTypeName()));
      
      Set<String> metaEntities = getEntitiesFromMetadata(metadata, du);
      
//      logWrapper.log(String.format("metas: %s", StringUtils.substring(StringUtils.join(metaEntities, ","), 0,  50)));
      
      List<File> files = du.getFiles(baseDir);
      for (File file : files) {
        String name = du.getEntityName(file);
        if (!metaEntities.contains(name)) {
          logWrapper.log(String.format("Delete file: %s (entity %s).", file.getName(), name));
          
          file.delete();
        }
      }
    }
  }

  private Set<String> getEntitiesFromMetadata(final Map<String, List<String>> metadata, DeploymentUnit du)
  {
    Set<String> metas = new HashSet<>();
    
    List<String> any = new ArrayList<>(du.getChildNames());
    any.add(du.getTypeName());
    
    for (String name : any) {
      if (metadata.keySet().contains(name)) {
        metas.addAll(metadata.get(name));
      }
    }
    
    Set<String> entities = new HashSet<>();
    for (String meta : metas) {
      entities.add(du.getEntityName(meta));
    }
    
    return entities;
  }

  private boolean typeOrChildrenInObjects(Set<String> objects, DeploymentUnit du)
  {
    List<String> any = new ArrayList<>(du.getChildNames());
    any.add(du.getTypeName());
    
    for (String name : any) {
      if (objects.contains(name)) {
        return true;
      }
    }
    return false;
  }
  
}
