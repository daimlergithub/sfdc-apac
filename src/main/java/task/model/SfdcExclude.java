package task.model;

import org.apache.tools.ant.taskdefs.Typedef;


/**
 * SfdcExclude
 *
 * @author  xlehmf
 */
public class SfdcExclude extends Typedef {
  
  private String name;

  public void setName(String name)
  {
    this.name = name;
  }

  public String getName()
  {
    return name;
  }
  
}
