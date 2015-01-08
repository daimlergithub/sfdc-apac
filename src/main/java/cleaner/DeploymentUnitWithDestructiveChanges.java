package cleaner;
/*
 *  Daimler CRM - Extension Platform
 */

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.codec.binary.Base64OutputStream;

import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.ws.ConnectionException;

/**
 * TODO document class DeploymentUnit
 *
 * @author  xlehmf
 */
public class DeploymentUnitWithDestructiveChanges extends DeploymentUnit {
  
  public DeploymentUnitWithDestructiveChanges(String type, boolean ignoreUndeploy) {
    super(type, ignoreUndeploy);
  }
  
  public DeploymentUnitWithDestructiveChanges(String type) {
    this(type, false);
  }

  
  public boolean deleteMetadata(final MetadataConnection mConnection, final String type, List<String> fullNames) throws ConnectionException
  {
    if (null == fullNames || 0 == fullNames.size()) {
      return false;
    }
    
    System.out.println(String.format("Deleting %s with %s...", type, Arrays.toString(fullNames.toArray(new String[fullNames.size()]))));
    
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    
    Base64OutputStream b64os = new Base64OutputStream(baos);
    
    try {
      ZipOutputStream zos = new ZipOutputStream(baos);
      
      zos.putNextEntry(new ZipEntry("unpackaged/package.xml"));
      zos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes("UTF-8"));
      zos.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n".getBytes("UTF-8"));
      //zos.write("<fullName>cleanup</fullName>".getBytes("UTF-8"));
      zos.write("<version>32.0</version>\n".getBytes("UTF-8"));
      zos.write("</Package>\n".getBytes("UTF-8"));
      zos.closeEntry();
      
      zos.putNextEntry(new ZipEntry("unpackaged/destructiveChanges.xml"));
      zos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes("UTF-8"));
      zos.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n".getBytes("UTF-8"));
      // zos.write("<fullName>cleanup</fullName>".getBytes("UTF-8"));
      zos.write("<types>\n".getBytes("UTF-8"));
      for (String fullName : fullNames) {
        zos.write(("<members>" + fullName + "</members>\n").getBytes("UTF-8"));
      }
      zos.write(("<name>" + type + "</name>\n").getBytes("UTF-8"));
      zos.write("</types>\n".getBytes("UTF-8"));
      zos.write("<version>32.0</version>\n".getBytes("UTF-8"));
      zos.write("</Package>\n".getBytes("UTF-8"));
      zos.closeEntry();
      
      zos.close();
      b64os.close();
    }
    catch (IOException e) {
      System.err.println(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()));
      
      // stop processing
      return true;
    }
    
    DeployOptions options = new DeployOptions();
    options.setPerformRetrieve(false);
    options.setRollbackOnError(true);
    
    AsyncResult ar = mConnection.deploy(baos.toByteArray(), options);
    
    // debugging
//    try {
//      File tmp = File.createTempFile("tmp" + System.currentTimeMillis(), ".zip");
//      FileOutputStream fos = new FileOutputStream(tmp);
//      fos.write(baos.toByteArray());
//      fos.close();
//    }
//    catch (IOException e) {
//      System.err.println(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()));
//    }
    
    int count = 0;
    DeployResult status = null;
    do {
      
      System.out.println(String.format("Wating for job %s to finish...", ar.getId()));
      
      try {
        Thread.sleep(3000);
      }
      catch (InterruptedException e) {
        System.err.println(String.format("Got interrupted while sleeping for deployment result: %s.", e.getMessage()));
      }
      status = mConnection.checkDeployStatus(ar.getId(), true);
      
      count++;
    } while (!status.isDone() && count < 100);
    
    if (status.isDone()) {
      if (status.isSuccess()) {
        System.out.println(String.format("Undeploy of %s and %s successful.", type, Arrays.toString(fullNames.toArray(new String[fullNames.size()]))));
      } else {
        System.err.println(String.format("Undeploy of %s and %s not successful.", type, Arrays.toString(fullNames.toArray(new String[fullNames.size()]))));
        System.err.println(String.format("Error %s: %s.", status.getErrorStatusCode().toString(), status.getErrorMessage()));
        
        // stop processing
        return true;
      }
    }
    
    return false;
  }
  
}
