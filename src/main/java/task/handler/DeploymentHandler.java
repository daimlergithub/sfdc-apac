/*
 *  Daimler CRM - Extension Platform
 */
package task.handler;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.apache.tools.ant.BuildException;

import com.sforce.soap.DeploymentUtil.Connector;
import com.sforce.soap.DeploymentUtil.SoapConnection;
import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

/**
 * DeploymentHandler
 *
 * @author  XLEHMF
 */
public class DeploymentHandler
{

  private LogWrapper logWrapper;
  private String serverurl;
  private String username;
  private String password;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  
  public void initialize(LogWrapper logWrapper,
                         String serverurl,
                         String username,
                         String password,
                         boolean useProxy,
                         String proxyHost,
                         int proxyPort)
  {
    this.logWrapper = logWrapper;
    this.serverurl = serverurl;
    this.username = username;
    this.password = password;
    this.useProxy = useProxy;
    this.proxyHost = proxyHost;
    this.proxyPort = proxyPort;
  }

  public void validate()
  {
    if (null == logWrapper || null == serverurl || null == username || null == password) {
      throw new BuildException("DeploymentHandler is not properly initialized.");
    }
  }

  public Map<String, Long> triggerUpdatestampsRefresh(Set<String> objects)
  {
    ConnectorConfig eConfig = new ConnectorConfig();
    eConfig.setAuthEndpoint(serverurl + "/services/Soap/c/32.0");
    eConfig.setServiceEndpoint(eConfig.getAuthEndpoint());
    eConfig.setUsername(username);
    eConfig.setPassword(password);
    if (useProxy) {
      eConfig.setProxy(proxyHost, proxyPort);
    }
    eConfig.setManualLogin(true);

    try {
      EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);

      LoginResult loginResult = login(eConnection, eConfig);

      URL serviceEndpointUrl = new URL(loginResult.getServerUrl());

      serviceEndpointUrl =
          new URL(serviceEndpointUrl.getProtocol(),
                  serviceEndpointUrl.getHost(),
                  serviceEndpointUrl.getPort(),
                  "/services/Soap/class/oliverkoethap1/DeploymentUtil");
      String serviceEndPoint = serviceEndpointUrl.toExternalForm();
      
      eConfig.setServiceEndpoint(serviceEndPoint);
      eConfig.setSessionId(loginResult.getSessionId());

      SoapConnection soapConnection = Connector.newConnection(eConfig);
      
      String[] refreshUpdateStamps = soapConnection.refreshUpdateStamps(objects.toArray(new String[objects.size()]));
      
      Map<String, Long> result = new HashMap<>();
      for (String updateStamp : refreshUpdateStamps) {
        String[] parts = updateStamp.split(":");
        if (2 == parts.length) {
          result.put(parts[0], Long.parseLong(parts[1]));
        }
      }
      
      eConfig.setServiceEndpoint(loginResult.getServerUrl());
      eConnection.logout();
      
      return result;
    }
    catch (ConnectionException | MalformedURLException | NumberFormatException e) {
      
      e.printStackTrace();
      
      throw new BuildException(String.format("Error Connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  private LoginResult login(EnterpriseConnection eConnection, ConnectorConfig eConfig)
      throws ConnectionException
    {
      LoginResult loginResult = eConnection.login(eConfig.getUsername(), eConfig.getPassword());
      eConfig.setServiceEndpoint(loginResult.getServerUrl());

      eConnection.setSessionHeader(loginResult.getSessionId());

      return loginResult;
    }
  
}

