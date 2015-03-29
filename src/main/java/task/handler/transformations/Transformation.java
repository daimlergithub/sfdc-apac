package task.handler.transformations;

import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;

import task.handler.LogWrapper;


/**
 * Transformation
 *
 * @author  xlehmf
 */
public abstract class Transformation {

  private String filename;
  private boolean deploy;
  private boolean retrieve;
  
  public Transformation() {
    // by default a transformation is applied in both directions - deploy and retrieve
    deploy = true;
    retrieve = true;
  }
  
  public String getFilename()
  {
    return filename;
  }

  public void setFilename(String filename)
  {
    this.filename = filename;
  }

  public boolean isDeploy()
  {
    return deploy;
  }

  @XmlAttribute
  public void setDeploy(boolean deploy)
  {
    this.deploy = deploy;
  }

  public boolean isRetrieve()
  {
    return retrieve;
  }

  @XmlAttribute
  public void setRetrieve(boolean retrieve)
  {
    this.retrieve = retrieve;
  }

  public void validate()
  {
    if (StringUtils.isEmpty(filename)) {
      throw new BuildException("The filename of the transformation changetext must be set.");
    }
  }

  public abstract boolean applyForDeploy(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings);
  
  public abstract boolean applyForRetrieve(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings);
  
}
