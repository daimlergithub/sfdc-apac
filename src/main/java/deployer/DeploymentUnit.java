package deployer;

import java.io.File;
import java.io.FileFilter;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.sforce.soap.metadata.Metadata;

/**
 * TODO document class DeploymentUnit
 *
 * @author  xlehmf
 */
public class DeploymentUnit {
  private Class<? extends Metadata> type;
  private String subDir;
  private String extension;
  
  public DeploymentUnit(Class<? extends Metadata> type, String subDir, String extension) {
    this.type = type;
    this.subDir = subDir;
    this.extension = extension;
  }
  
  public DeploymentUnit(Class<? extends Metadata> type, String subDir) {
    this(type, subDir, StringUtils.uncapitalize(type.getSimpleName()));
  }
  
  public DeploymentUnit(Class<? extends Metadata> type) {
    this(type, StringUtils.uncapitalize(type.getSimpleName()), StringUtils.uncapitalize(type.getSimpleName()));
  }

  public Class<? extends Metadata> getType()
  {
    return type;
  }

  public String getSubDir()
  {
    return subDir;
  }

  protected String getExtension()
  {
    return extension;
  }

  /**
   * Extract the entity name from the file. This method returns the same value for the meta file and the entity file.
   */
  public String getEntityName(File file)
  {
    String name = file.getName();
    return name.substring(0, name.lastIndexOf("."));
  }

  /**
   * Gets a list of files to include in the ZIP file for the deployment.
   */
  public List<File> getFiles(File baseDir)
  {
    File dir = new File(baseDir, subDir);
    
    File[] mainFiles = dir.listFiles(new FileFilter() {
      
      @Override
      public boolean accept(File pathname)
      {
        return pathname.isFile() && pathname.getName().endsWith("." + extension);
      }
    });
    
    return Arrays.asList(mainFiles);
  }
  
}
