package task.handler;
/*
 *  Daimler CRM - Extension Platform
 */

import java.util.List;


/**
 * ChunkedExecutor
 *
 * @author  xlehmf
 */
public abstract class ChunkedExecutor<T, U, X extends Exception> {
  
  public final U execute(List<T> list, int chunkSize, U result) throws X {
    int start = 0;
    while (start < list.size()) {
      result = chunky(list.subList(start, Math.min(start + chunkSize, list.size())), result);
      start += chunkSize;
    };
    
    return result;
  }
  
  public abstract U chunky(List<T> chunk, U result) throws X;
}
