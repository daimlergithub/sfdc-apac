package task.handler.transformations;

import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import task.handler.LogWrapper;

/**
 * ChangeText
 *
 * @author  xlehmf
 */
@XmlRootElement(name="changetext")
public class ChangeText extends Transformation {
  
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
      throw new BuildException("The xpath of the transformation changetext must be set.");
    }
    if (StringUtils.isEmpty(token)) {
      throw new BuildException("The token of the transformation changetext must be set.");
    }
  }

  @Override
  public void applyForDeploy(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    XPath xPath = XPathFactory.newInstance().newXPath();
    
    String replacement = tokenMappings.get(token);
    
    try {
      NodeList nodes = (NodeList)xPath.evaluate(xpath, document.getDocumentElement(), XPathConstants.NODESET);
      for (int i = 0; i < nodes.getLength(); ++i) {
        Node n = nodes.item(i);
        
        logWrapper.log(String.format("Change text from %s to %s.", n.getTextContent(), replacement));
        
        n.setNodeValue(replacement);
      }
    }
    catch (XPathExpressionException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      
      throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
    }
  }

  @Override
  public void applyForRetrieve(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    throw new BuildException("Not implemted yet.");
  }
  
}
