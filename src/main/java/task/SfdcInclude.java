package task;

import org.apache.tools.ant.taskdefs.Typedef;


/**
 * SfdcInclude
 *
 * @author  xlehmf
 */
public class SfdcInclude extends Typedef {
  
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
