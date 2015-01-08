package cleaner;
/*
 *  Daimler CRM - Extension Platform
 */

import java.util.List;


/**
 * TODO document class ChunkedExecutor
 *
 * @author  xlehmf
 */
public abstract class ChunkedExecutor<T, U, X extends Exception> {
  
  private List<T> list;
  private int chunkSize;
  private U result;
  
  public ChunkedExecutor(List<T> list, int chunkSize, U result) {
    this.list = list;
    this.chunkSize = chunkSize;
    this.result = result;
  }
  
  public final void execute() throws X {
    int start = 0;
    do {
      chunky(list.subList(start, Math.min(start + chunkSize, list.size())));
      start += chunkSize;
    } while (start < list.size());
  }
  
  public abstract void chunky(List<T> chunk) throws X;
  
  public void setResult(U result)
  {
    this.result = result;
  }

  public final U getResult() {
    return result;
  }
}
