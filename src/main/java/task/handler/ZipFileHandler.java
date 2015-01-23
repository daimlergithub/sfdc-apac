/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
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

  private static final String ZIP_BASE_DIR = "unpackaged";
  private LogWrapper logWrapper;
  private boolean debug;

  public void initialize(LogWrapper logWrapper, boolean debug)
  {
    this.logWrapper = logWrapper;
    this.debug = debug;
  }

  public void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("ZipFileHandler is not initialized.");
    }
  }

  public void saveZipFile(String prefix, ByteArrayOutputStream zipFile)
  {
    // debugging
    if (debug) {
      String fileName = prefix + "-" + System.currentTimeMillis() + ".zip";

      logWrapper.log(String.format("Save ZIP file to %s.", fileName));

      try {
        File tmp = new File("tmp", fileName);
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

        String type = du.getType().getSimpleName();

        logWrapper.log(String.format("Handle type %s for ZIP file.", type));

        byte[] buffer = new byte[512];

        for (File file : info.getFileList()) {
          logWrapper.log(String.format("Add %s.", file.getName()));

          String zipEntryName = createZipEntryName(du, file);

          try {
            zos.putNextEntry(new ZipEntry(zipEntryName));

            FileInputStream fis = new FileInputStream(file);

            int read = 0;
            do {
              read = fis.read(buffer);
              if (-1 != read) {
                zos.write(buffer, 0, read);
              }
            }
            while (-1 != read);

            fis.close();
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
    byte[] buffer = new byte[2048];

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

          FileOutputStream fos = new FileOutputStream(file);
          BufferedOutputStream bos = new BufferedOutputStream(fos, buffer.length);

          int read = 0;
          do {
            read = zis.read(buffer);
            if (0 < read) {
              bos.write(buffer, 0, read);
            }
          }
          while (-1 != read);
          bos.close();

          // TODO consider lastModified
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
