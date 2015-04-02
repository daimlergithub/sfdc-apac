/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.output.FileWriterWithEncoding;
import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;

/**
 * DestructiveChangesHandler
 *
 * @author  XLEHMF
 */
public class DestructiveChangesHandler
{

  private LogWrapper logWrapper;
  private String destructiveRoot;
  private String destructiveFile;

  @SuppressWarnings("hiding")
  public void initialize(LogWrapper logWrapper, String destructiveRoot, String destructiveFile)
  {
    this.logWrapper = logWrapper;
    this.destructiveRoot = destructiveRoot;
    this.destructiveFile = destructiveFile;

    validate();
  }

  private void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("DestructiveChangesHandler (logWrapper) not properly initialized.");
    }
    if (null == destructiveRoot) {
      throw new BuildException("DestructiveChangesHandler (destructiveRoot) not properly initialized.");
    }
    if (null == destructiveFile) {
      throw new BuildException("DestructiveChangesHandler (destructiveFile) not properly initialized.");
    }
  }

  public Map<String, List<String>> readDestructiveChanges()
  {
    Map<String, List<String>> result = new HashMap<>();
    
    File file = new File(destructiveRoot, destructiveFile);

    try (FileInputStream fis = new FileInputStream(file); InputStreamReader isr = new InputStreamReader(fis, "UTF-8"); BufferedReader br = new BufferedReader(isr)) {
      String line = null;
      do {
        line = br.readLine();
        if (StringUtils.isNotEmpty(line)) {
          String trimmed = line.trim();
          if (!StringUtils.startsWith(trimmed, "#")) {
            String[] tokens = trimmed.split(":");
            if (2 == tokens.length) {
              List<String> names = result.get(tokens[0]);
              if (null == names) {
                names = new ArrayList<>();
                result.put(tokens[0], names);
              }
              names.add(tokens[1]);
            } else {
              throw new BuildException(String.format("Error reading destrive changes. File format error. The format is <type>:<name>."));
            }
          }
        }
      } while (line != null);
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error reading destrive changes: %s.", e.getMessage()), e);
    }

    return result;
  }

  public void resetDestructiveChanges()
  {
    File file = new File(destructiveRoot, destructiveFile);

    List<String> lines = new ArrayList<>();
    boolean containsOther = false;
    
    try (FileInputStream fis = new FileInputStream(file); InputStreamReader isr = new InputStreamReader(fis, "UTF-8"); BufferedReader br = new BufferedReader(isr)) {
      String line = null;
      do {
        line = br.readLine();
        if (StringUtils.isNotEmpty(line)) {
          String trimmed = line.trim();
          if (StringUtils.startsWith(trimmed, "#")) {
            lines.add(trimmed);
          } else {
            containsOther = true;
          }
        }
      } while (line != null);
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error reading destrive changes: %s.", e.getMessage()), e);
    }
    
    if (containsOther) {
      try (FileWriterWithEncoding fw = new FileWriterWithEncoding(file, "UTF-8"); BufferedWriter bw = new BufferedWriter(fw)) {
        for (String line : lines) {
          bw.write(line);
          bw.newLine();
        }
      }
      catch (IOException e) {
        throw new BuildException(String.format("Error resetting changes: %s.", e.getMessage()), e);
      }
    }
  }

}
