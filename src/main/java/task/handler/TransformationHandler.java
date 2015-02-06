/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.zip.ZipOutputStream;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import task.handler.transformations.ChangeAttribute;
import task.handler.transformations.ChangeText;
import task.handler.transformations.Token;
import task.handler.transformations.Transformation;
import task.handler.transformations.Transformations;

/**
 * TransformationHandler
 *
 * @author  XLEHMF
 */
public class TransformationHandler
{

  private LogWrapper logWrapper;
  private String userName;
  private String transformationsRoot;
  private String deployRoot;
  // private boolean debug;

  private List<Transformation> transformations;
  private Map<String, String> tokenMappings;

  public void initialize(LogWrapper logWrapper, String userName, String transformationsRoot, String deployRoot)
  {
    this.logWrapper = logWrapper;
    this.userName = userName;
    this.transformationsRoot = transformationsRoot;
    this.deployRoot = deployRoot;
    //    this.debug = debug;

    validate();
    initialize();
  }

  private void initialize()
  {
    String environment = getEnvironmentMapping();
    tokenMappings = readEnvironmentConfiguration(environment);
    
    // global
    transformations = readTransformations(null);
    // TODO add environment-specific transformations
    transformations.addAll(readTransformations(environment));

    // TODO fix logging
//    logWrapper.log(String.format("Use environment %s.", result));
//    logWrapper.log(String.format("Found %d transformations.", result.size()));
//    logWrapper.log(String.format("Found %d token mappings.", result.size()));
    
    checkTransformationConfiguration();
  }

  private void checkTransformationConfiguration()
  {
    Set<String> tokens = new HashSet<>();
    for (Transformation transformation : transformations) {
      transformation.validate();
      
      if (transformation instanceof ChangeText) {
        tokens.add(((ChangeText)transformation).getToken().getText());
      } else if (transformation instanceof ChangeAttribute) {
        tokens.add(((ChangeAttribute)transformation).getToken().getText());
      }
    }

    if (tokenMappings.size() != tokens.size()) {
      throw new BuildException(String.format("The number of tokens %d does not equal the number of token transformations %d.",
                                             tokenMappings.size(),
                                             tokens.size()));
    }
  }

  private Map<String, String> readEnvironmentConfiguration(String environment)
  {
    File envDir = new File(transformationsRoot, environment);
    File tokenFile = new File(envDir, "token.properties");

    try (FileInputStream fis = new FileInputStream(tokenFile);
        InputStreamReader isr = new InputStreamReader(fis, "UTF-8")) {
      Properties properties = new Properties();
      properties.load(isr);

      Map<String, String> result = new HashMap<>();
      for (String key : properties.stringPropertyNames()) {
        String value = properties.getProperty(key);

        result.put(key, value);
      }

      return result;
    }
    catch (IOException e) {
      // TODO
      e.printStackTrace();

      throw new BuildException(String.format("Error reading file token.properties for environmet %s: %s.",
                                             environment,
                                             e.getMessage()), e);
    }
  }

  private String getEnvironmentMapping()
  {
    File file = new File(transformationsRoot, "environment.mappings");

    try (FileInputStream fis = new FileInputStream(file); InputStreamReader isr = new InputStreamReader(fis, "UTF-8")) {
      Properties properties = new Properties();
      properties.load(isr);

      String result = null;
      for (String key : properties.stringPropertyNames()) {
        String value = properties.getProperty(key);
        String[] tokens = StringUtils.split(value, ",");
        if (ArrayUtils.contains(tokens, userName)) {
          result = key;
          break;
        }
      }

      if (null == result) {
        throw new BuildException(String.format("Environment for user %s not found. Please check file environment.mappings.",
                                               userName));
      }

      return result;
    }
    catch (IOException e) {
      // TODO
      e.printStackTrace();

      throw new BuildException(String.format("Error reading environment mappings: %s.", e.getMessage()), e);
    }
  }

  private List<Transformation> readTransformations(String environment)
  {
    List<Transformation> result = new ArrayList<>();
    
    File basePath = StringUtils.isNotEmpty(environment) ? new File(transformationsRoot, environment) : new File(transformationsRoot);
    
    File transConfigFile = new File(basePath, "transformations.xml");
    if (!transConfigFile.exists())
    {
      return result;
    }
    
    try (FileReader fileReader = new FileReader(transConfigFile)) {
      JAXBContext context = JAXBContext.newInstance(Transformations.class);
      Unmarshaller um = context.createUnmarshaller();
      Transformations ts = (Transformations)um.unmarshal(fileReader);

      // TODO remove
//      Marshaller m = context.createMarshaller();
//      m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
//      m.marshal(ts,  System.out);
      
      if (null != ts && null != ts.getTransformations()) {
        for (Transformation t : ts.getTransformations()) {
          normalizeFile(t);
          result.add(t);
        }
      }
      
      return result;
    }
    catch (JAXBException | IOException e) {
      // TODO
      e.printStackTrace();

      throw new BuildException(String.format("Error reading transformations.xml in %s: %s.", basePath.getName(), e.getMessage()), e);
    }
  }

  private void normalizeFile(Transformation transformation)
  {
    transformation.setFilename(transformation.getFilename().replaceAll("\\\\", "/"));
  }

  private void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("TransformationHandler (logWrapper) not properly initialized.");
    }
    if (null == transformationsRoot) {
      throw new BuildException("TransformationHandler (transformationsRoot) not properly initialized.");
    }
    if (null == deployRoot) {
      throw new BuildException("TransformationHandler (deployRoot) not properly initialized.");
    }
    if (null == userName) {
      throw new BuildException("TransformationHandler (userName) not properly initialized.");
    }
  }

  public void transform(File file, ZipOutputStream zos)
  {
    List<Transformation> fileTransformations = getTransformationsForFile(file);
    if (fileTransformations.isEmpty()) {
      copyFile(file, zos);
    }
    else {
      byte[] transformedFile = applyTransformations(file, fileTransformations);
      try {
        zos.write(transformedFile);
      }
      catch (IOException e) {
        // TODO
        e.printStackTrace();

        throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
      }
    }
  }

  private byte[] applyTransformations(File file, List<Transformation> fileTransformations)
  {
    try {
      DocumentBuilder b = DocumentBuilderFactory.newInstance().newDocumentBuilder();
      Document doc = b.parse(new FileInputStream(file));
      
      for (Transformation transformation : fileTransformations) {
//        try {
          transformation.applyForDeploy(logWrapper, doc, tokenMappings);
//        } catch (BuildException be) {
//          // TODO ignore for now
//        }
      }
      
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      Transformer transformer = TransformerFactory.newInstance().newTransformer();
      transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
      StreamResult result = new StreamResult(baos);
      DOMSource source = new DOMSource(doc);
      transformer.transform(source, result);
      return baos.toByteArray();
    }
    catch (ParserConfigurationException | SAXException | IOException | TransformerFactoryConfigurationError | TransformerException e) {
      // TODO
      e.printStackTrace();

      throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
    }
  }

  private void copyFile(File file, ZipOutputStream zos)
  {
    try (FileInputStream fis = new FileInputStream(file);) {
      byte[] buffer = new byte[512];
      int read = 0;
      do {
        read = fis.read(buffer);
        if (-1 != read) {
          zos.write(buffer, 0, read);
        }
      }
      while (-1 != read);
    }
    catch (IOException e) {
      // TODO
      e.printStackTrace();

      throw new BuildException(String.format("Error reading transformations.xml: %s.", e.getMessage()), e);
    }
  }

  private List<Transformation> getTransformationsForFile(File file)
  {
    String fileName = file.getAbsolutePath().replaceAll("\\\\", "/");

    List<Transformation> result = new ArrayList<>();
    for (Transformation transformation : transformations) {
      if (fileName.endsWith(transformation.getFilename())) {
        result.add(transformation);
      }
    }

    if (!result.isEmpty()) {
      logWrapper.log(String.format("Found %d transformations for %s.", result.size(), file.getName()));
    }
    
 // TODO validate only one rename file for each file
    
    return result;
  }

}
