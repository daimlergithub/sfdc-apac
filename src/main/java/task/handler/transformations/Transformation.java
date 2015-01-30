package task.handler.transformations;

import java.util.Map;

import javax.xml.bind.annotation.XmlSeeAlso;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;

import task.handler.LogWrapper;


/**
 * Transformation
 *
 * @author  xlehmf
 */
@XmlSeeAlso({ChangeText.class, ChangeAttribute.class, RemoveElement.class, RenameFile.class})
public abstract class Transformation {

  private String filename;
  
  public String getFilename()
  {
    return filename;
  }

  public void setFilename(String filename)
  {
    this.filename = filename;
  }

  public void validate()
  {
    if (StringUtils.isEmpty(filename)) {
      throw new BuildException("The filename of the transformation changetext must be set.");
    }
  }

  public abstract void apply(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings);
  
}
