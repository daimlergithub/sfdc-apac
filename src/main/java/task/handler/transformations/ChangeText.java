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
  private Token token;
  
  public String getXpath()
  {
    return xpath;
  }

  public void setXpath(String xpath)
  {
    this.xpath = xpath;
  }

  public Token getToken()
  {
    return token;
  }

  public void setToken(Token token)
  {
    this.token = token;
  }
  
  public void validate()
  {
    super.validate();
    
    if (StringUtils.isEmpty(xpath)) {
      throw new BuildException("The xpath of the transformation changetext must be set.");
    }
    if (null == token) {
      throw new BuildException("The token of the transformation changetext must be set.");
    }
    
    token.validate();
  }

  @Override
  public void applyForDeploy(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    XPath xPath = XPathFactory.newInstance().newXPath();
    
    String replacement = tokenMappings.get(token.getText());
    
    try {
      NodeList nodes = (NodeList)xPath.evaluate(xpath, document.getDocumentElement(), XPathConstants.NODESET);
      for (int i = 0; i < nodes.getLength(); ++i) {
        Node n = nodes.item(i);
        
        if (Node.TEXT_NODE != n.getNodeType()) {
          throw new BuildException(String.format("The node type selected by xpath %s is not a text node.", xpath));
        }
        
        String txt = n.getTextContent();
        
        String newValue = null;
        if (token.isTokenOnly()) {
          newValue = txt.replace(token.getText(), replacement);
          
          logWrapper.log(String.format("Replace token %s with %s.", token.getText(), replacement));
        } else {
          newValue = replacement;
          
          logWrapper.log(String.format("Change text from %s to %s.", txt, replacement));
        }
        
        n.setNodeValue(newValue);
      }
    }
    catch (XPathExpressionException e) {
      // TODO
      e.printStackTrace();
      
      throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
    }
  }

  @Override
  public void applyForRetrieve(LogWrapper logWrapper, Document document, Map<String, String> tokenMappings)
  {
    XPath xPath = XPathFactory.newInstance().newXPath();
    
    String replacement = tokenMappings.get(token.getText());
    
    try {
      NodeList nodes = (NodeList)xPath.evaluate(xpath, document.getDocumentElement(), XPathConstants.NODESET);
      for (int i = 0; i < nodes.getLength(); ++i) {
        Node n = nodes.item(i);
        
        String txt = n.getTextContent();
        
        String newValue = null;
        if (token.isTokenOnly()) {
          String tokenText = String.format("${%s}", token.getText());
          newValue = txt.replace(tokenText, replacement);
          
          logWrapper.log(String.format("Replace token %s with %s.", tokenText, replacement));
        } else {
          newValue = token.getText();
          
          logWrapper.log(String.format("Change text from %s to %s.", txt, replacement));
        }
        
        n.setNodeValue(newValue);
      }
    }
    catch (XPathExpressionException e) {
      // TODO
      e.printStackTrace();
      
      throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
    }
  }
  
}
