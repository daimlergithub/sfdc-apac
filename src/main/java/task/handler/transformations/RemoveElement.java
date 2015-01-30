package task.handler.transformations;

import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;

import task.handler.LogWrapper;

/**
 * RemoveElement
 *
 * @author  xlehmf
 */
@XmlRootElement(name="removeelement")
public class RemoveElement extends Transformation {
  
  private String xpath;
  
  public String getXpath()
  {
    return xpath;
  }

  public void setXpath(String xpath)
  {
    this.xpath = xpath;
  }

  public void validate()
  {
    super.validate();
    
    if (StringUtils.isEmpty(xpath)) {
      throw new BuildException("The xpath of the transformation removeelement must be set.");
    }
  }

  @Override
  public void apply(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    throw new BuildException(String.format("Transformation %s not supported yet.", getClass().getSimpleName()));    
  }
}
