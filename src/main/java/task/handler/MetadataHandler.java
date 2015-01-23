/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.types.LogLevel;

import com.sforce.soap.metadata.Package;

import task.SfdcExclude;
import task.SfdcInclude;
import task.SfdcTypeSet;
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
  private UpdateStampHandler updateStampHandler;

  public void initialize(LogWrapper logWrapper, String metadataRoot, boolean debug, UpdateStampHandler updateStampHandler)
  {
    this.logWrapper = logWrapper;
    this.metadataRoot = metadataRoot;
    this.debug = debug;
    this.updateStampHandler = updateStampHandler;
  }

  public void validate()
  {
    if (null == logWrapper || null == metadataRoot || null == updateStampHandler) {
      throw new BuildException("MetadataHandler not properly initialized.");
    }
  }

  public List<DeploymentInfo> compileDeploymentInfos(List<SfdcTypeSet> typeSets)
  {
    List<DeploymentUnit> duList = new DeploymentConfiguration().getConfigurations();

    List<DeploymentInfo> deploymentInfos = new ArrayList<>();
    for (SfdcTypeSet typeSet : typeSets) {
      DeploymentUnit du = findDeploymentUnit(duList, typeSet);

      List<File> fileList = compileFileList(du, typeSet);
      if (fileList.isEmpty()) {
        continue;
      }

      List<String> entityNames = compileEntityNames(du, fileList);

      deploymentInfos.add(new DeploymentInfo(du, fileList, entityNames));
    }

    return deploymentInfos;
  }

  private DeploymentUnit findDeploymentUnit(List<DeploymentUnit> duList, SfdcTypeSet typeSet)
  {
    for (DeploymentUnit du : duList) {
      // if (typeSet.getName().equals(du.getSubDir()) && ((!typeSet.isFolder() && !Folder.class.isAssignableFrom(du.getType())) || (typeSet.isFolder() && Folder.class.isAssignableFrom(du.getType())))) {
      if (typeSet.getName().equals(du.getSubDir())) {
        logWrapper.log(String.format("Found deployment information for type %s.", typeSet.getName()));
        return du;
      }
    }

    throw new BuildException(String.format("Could not find deployment unit for fileset %s.", typeSet.getName()));
  }

  private List<File> compileFileList(DeploymentUnit du, SfdcTypeSet typeSet)
  {
    String type = du.getType().getSimpleName();

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

        String type = du.getType().getSimpleName();

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
      logWrapper.log(String.format("Save metadata."));
  
      try {
        File metadataXml = new File("tmp", "metadata-" + System.currentTimeMillis() + ".xml");
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

  
}
