package cleaner;
/*
 *  Daimler CRM - Extension Platform
 */

import java.util.Arrays;
import java.util.List;

import com.sforce.soap.metadata.DeleteResult;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.ws.ConnectionException;

/**
 * TODO document class DeploymentUnit
 *
 * @author  xlehmf
 */
public class DeploymentUnit {
  private String type;
  private boolean ignoreUndeploy;
  
  public DeploymentUnit(String type, boolean ignoreUndeploy) {
    this.type = type;
    this.ignoreUndeploy = ignoreUndeploy;
  }
  
  public DeploymentUnit(String type) {
    this(type, false);
  }

  
  public boolean deleteMetadata(final MetadataConnection mConnection, final String type, List<String> fullNames) throws ConnectionException
  {
    if (null == fullNames || 0 == fullNames.size()) {
      return false;
    }
    
    fullNames = sortFullNames(fullNames);
    
    System.out.println(String.format("Deleting %s with %s...", type, Arrays.toString(fullNames.toArray(new String[fullNames.size()]))));
    
    ChunkedExecutor<String, Boolean, ConnectionException> ce = new ChunkedExecutor<String, Boolean, ConnectionException>(fullNames, 10, true) {

      @Override
      public void chunky(List<String> chunk) throws ConnectionException
      {
        DeleteResult[] deleteResults = mConnection.deleteMetadata(type, chunk.toArray(new String[chunk.size()]));
        if (null != deleteResults) {
          for (DeleteResult dr : deleteResults) {
            if (dr.isSuccess()) {
              System.out.println(String.format("Success deleting %s.%s.", type, dr.getFullName()));
            } else {
              System.err.println(String.format("Failed deleting %s.%s.", type, dr.getFullName()));
              for (com.sforce.soap.metadata.Error err : dr.getErrors()) {
                System.err.println(err.getMessage());
              }
              setResult(false);
            }
          }
        } else {
          System.err.println("Result when deleting metadata must not be null!");
          setResult(false);
        }
      }
      
    };
    ce.execute();
    
    return !ce.getResult();
  }
  
  public List<String> sortFullNames(List<String> fullNames)
  {
    return fullNames;
  }

  public String getType()
  {
    return type;
  }

  public boolean hasChild() {
    return -1 != type.indexOf(".");
  }
  
  public String getChild() {
    return hasChild() ? type.substring(1 + type.indexOf(".")) : null;
  }
  
  public boolean include(String name) {
    return true;
  }
  
  

  public boolean isIgnoreUndeploy()
  {
    return ignoreUndeploy;
  }
}
