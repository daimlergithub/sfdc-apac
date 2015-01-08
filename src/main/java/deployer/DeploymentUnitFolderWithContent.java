package deployer;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.sforce.soap.metadata.Metadata;

/**
 * DeploymentUnitFolderWithContent
 *
 * Assumptions:
 * -there is a meta file for the folder itself
 * -all documents must be within folders
 * -each document has a meta file
 * 
 * @author  xlehmf
 */
public class DeploymentUnitFolderWithContent extends DeploymentUnitFolder {
  
  public DeploymentUnitFolderWithContent(Class<? extends Metadata> type, String subDir, String extension) {
    super(type, subDir, extension);
  }

  /**
   * Extract the full name from the file. This method returns the same value for the meta file and the entity file.
   */
  @Override
  public String getEntityName(File file)
  {
    String name = file.getName();
    
    String parent = file.getParentFile().getName();
    if (name.endsWith("-meta.xml") && getSubDir().equals(parent)) {
      // meta file for folder
      return StringUtils.removeEnd(name, "-meta.xml");
    } else {
      if (name.endsWith("-meta.xml")) {
        name = StringUtils.remove(name, "-meta.xml");
      }
      if (null != getExtension()) {
        name = StringUtils.removeEnd(name, "." + getExtension());
      }
      return name;
    }
  }

  @Override
  public List<File> getFiles(File baseDir)
  {
    List<File> result = new ArrayList<>();
    
    File subDir = new File(baseDir, getSubDir());
    
    File[] files = subDir.listFiles(new FileFilter() {

      @Override
      public boolean accept(File pathname)
      {
        // meta files for folders
        return pathname.isFile() && pathname.getName().endsWith("-meta.xml");
      }
      
    });
    
    for (File file : files) {
      String name = file.getName();
      
      // add meta file itself
      result.add(file);

      // meta file describes a subfolder
      File subFolder = new File(subDir, StringUtils.removeEnd(name, "-meta.xml"));
      File[] subFiles = subFolder.listFiles(new FileFilter() {

        @Override
        public boolean accept(File pathname)
        {
          return pathname.isFile();
        }
        
      });
      result.addAll(Arrays.asList(subFiles));
    }
    
    return result;
  }
  
}
