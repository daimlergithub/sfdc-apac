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
public class DeploymentUnit4Layout extends DeploymentUnit {
  
  public DeploymentUnit4Layout(String type, boolean ignoreUndeploy) {
    super(type, ignoreUndeploy);
  }
  
  public DeploymentUnit4Layout(String type) {
    this(type, false);
  }
  
  public boolean deleteMetadata(final MetadataConnection mConnection, final String type, List<String> fullNames) throws ConnectionException
  {
    if (null == fullNames || 0 == fullNames.size()) {
      return false;
    }
    
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
              if (1 == dr.getErrors().length && "Cannot delete the only layout".equals(dr.getErrors()[0].getMessage())) {
                System.out.println(String.format("Could not delete the only layout %s.", dr.getFullName()));
                
                // TODO empty layout -> remove quickactions
              }
              else {
                System.err.println(String.format("%s deleting %s.%s.", dr.isSuccess() ? "Success" : "Failed", type, dr.getFullName()));
                for (com.sforce.soap.metadata.Error err : dr.getErrors()) {
                  System.err.println(err.getMessage());
                }
                setResult(false);
              }
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
}
