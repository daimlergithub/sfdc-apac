/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.codec.binary.Base64OutputStream;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.types.LogLevel;

import deployer.DeploymentUnit;

/**
 * ZipFileHandler
 *
 * @author  XLEHMF
 */
public class ZipFileHandler
{

  public class InputStreamWrapper
    extends InputStream
  {

    private InputStream is;
    
    InputStreamWrapper(InputStream is) {
      this.is = is;
    }
    
    @Override
    public int available()
      throws IOException
    {
      return is.available();
    }

    @Override
    public void close()
      throws IOException
    {
      // just ignore close
      // is.close();
    }

    @Override
    public synchronized void mark(int readlimit)
    {
      is.mark(readlimit);
    }

    @Override
    public boolean markSupported()
    {
      return is.markSupported();
    }

    @Override
    public int read()
      throws IOException
    {
      return is.read();
    }

    @Override
    public int read(byte[] b, int off, int len)
      throws IOException
    {
      return is.read(b, off, len);
    }

    @Override
    public int read(byte[] b)
      throws IOException
    {
      return is.read(b);
    }

    @Override
    public synchronized void reset()
      throws IOException
    {
      is.reset();
    }

    @Override
    public long skip(long n)
      throws IOException
    {
      return is.skip(n);
    }
  }

  private static final String ZIP_BASE_DIR = "unpackaged";
  private LogWrapper logWrapper;
  private boolean debug;
  private TransformationHandler transformationHandler;

  public void initialize(LogWrapper logWrapper, boolean debug, TransformationHandler transformationHandler)
  {
    this.logWrapper = logWrapper;
    this.debug = debug;
    this.transformationHandler = transformationHandler;
    
    validate();
  }

  private void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("ZipFileHandler (logWrapper) is not initialized.");
    }
    if (null == transformationHandler) {
      throw new BuildException("ZipFileHandler (transformationHandler) is not initialized.");
    }
  }

  public void saveZipFile(String prefix, ByteArrayOutputStream zipFile)
  {
    // debugging
    if (debug) {
      String fileName = prefix + "-" + System.currentTimeMillis() + ".zip";

      logWrapper.log(String.format("Save ZIP file to %s.", fileName));

      try {
        File tmpDir = new File("tmp");
        tmpDir.mkdirs();
        File tmp = new File(tmpDir, fileName);
        FileOutputStream fos = new FileOutputStream(tmp);
        fos.write(zipFile.toByteArray());
        fos.close();
      }
      catch (IOException e) {
        logWrapper.log(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()),
                       e,
                       LogLevel.WARN.getLevel());
      }
    }
  }

  public ByteArrayOutputStream prepareZipFile(List<DeploymentInfo> deploymentInfos, byte[] packageXML)
  {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    Base64OutputStream b64os = new Base64OutputStream(baos);

    try {
      ZipOutputStream zos = new ZipOutputStream(baos);

      for (DeploymentInfo info : deploymentInfos) {
        DeploymentUnit du = info.getDeploymentUnit();

        String type = du.getTypeName();

        logWrapper.log(String.format("Handle type %s for ZIP file.", type));

//        byte[] buffer = new byte[512];

        for (File file : info.getFileList()) {
          logWrapper.log(String.format("Add %s.", file.getName()));

          String zipEntryName = createZipEntryName(du, file);

          try {
            zos.putNextEntry(new ZipEntry(zipEntryName));

//            FileInputStream fis = new FileInputStream(file);

            transformationHandler.transformDeploy(file, zos);
//            int read = 0;
//            do {
//              read = fis.read(buffer);
//              if (-1 != read) {
//                zos.write(buffer, 0, read);
//              }
//            }
//            while (-1 != read);

//            fis.close();
            zos.closeEntry();
          }
          catch (Exception e) {
            throw new BuildException(String.format("Error reading metadata for type %s and file %s: %s",
                                                   type,
                                                   file.getName(),
                                                   e.getMessage()), e);
          }
        }
      }

      zos.putNextEntry(new ZipEntry("unpackaged/package.xml"));
      zos.write(packageXML);
      zos.closeEntry();

      zos.close();
      b64os.close();
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()), e);
    }

    return baos;
  }

  private String createZipEntryName(DeploymentUnit du, File file)
  {
    StringBuilder sb = new StringBuilder();

    String filePart = null;
    do {
      filePart = file.getName();

      if (0 < sb.length()) {
        sb.insert(0, "/");
      }
      sb.insert(0, filePart);

      file = file.getParentFile();
    }
    while (null != file && !filePart.equals(du.getSubDir()));

    sb.insert(0, "/");
    sb.insert(0, ZIP_BASE_DIR);

    return sb.toString();
  }

  public void extractZipFile(String retrieveRoot, ByteArrayOutputStream zipFile)
  {
    logWrapper.log("Extract ZIP file.");

    ByteArrayInputStream bais = new ByteArrayInputStream(zipFile.toByteArray());

    try (ZipInputStream zis = new ZipInputStream(bais)) {

      ZipEntry entry = null;
      do {
        entry = zis.getNextEntry();
        if (null != entry) {
          String fileName = entry.getName();

          if (fileName.startsWith(ZIP_BASE_DIR)) {
            fileName = fileName.substring(1 + ZIP_BASE_DIR.length());
          }

          File file = new File(retrieveRoot, fileName);

          File parentFile = file.getParentFile();
          if (!parentFile.exists() && !parentFile.mkdirs()) {
            throw new BuildException(String.format("Error creating directories while extracting file: %s.", fileName));
          }

          InputStreamWrapper isw = new InputStreamWrapper(zis);
          
          transformationHandler.transformRetrieve(isw, file);
          
//          FileOutputStream fos = new FileOutputStream(file);
//          try (BufferedOutputStream bos = new BufferedOutputStream(fos, buffer.length))
//          {
//            int read = 0;
//            do {
//              read = zis.read(buffer);
//              if (0 < read) {
//                bos.write(buffer, 0, read);
//              }
//            }
//            while (-1 != read);
//          }
        }
      }
      while (null != entry);
      
      logWrapper.log("Extracted ZIP file successfully.");
    }
    catch (IOException ioe) {
      throw new BuildException(String.format("Error handling ZIP file: %s.", ioe.getMessage()), ioe);
    }
  }

}
