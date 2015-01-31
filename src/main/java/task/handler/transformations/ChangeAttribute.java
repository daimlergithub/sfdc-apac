package task.handler.transformations;

import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;

import task.handler.LogWrapper;

/**
 * ChangeAttribute
 *
 * @author  xlehmf
 */
@XmlRootElement(name="changeattribute")
public class ChangeAttribute extends Transformation {
  
  private String xpath;
  private String token;
  
  public String getXpath()
  {
    return xpath;
  }

  public void setXpath(String xpath)
  {
    this.xpath = xpath;
  }

  public String getToken()
  {
    return token;
  }

  public void setToken(String token)
  {
    this.token = token;
  }
  
  public void validate()
  {
    super.validate();
    
    if (StringUtils.isEmpty(xpath)) {
      throw new BuildException("The xpath of the transformation changeattribute must be set.");
    }
    if (StringUtils.isEmpty(token)) {
      throw new BuildException("The token of the transformation changeattribute must be set.");
    }
  }

  @Override
  public void applyForDeploy(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    throw new BuildException(String.format("Transformation %s not supported yet.", getClass().getSimpleName()));    
  }

  @Override
  public void applyForRetrieve(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    throw new BuildException("Not implemted yet.");
  }

}
