/*
 *  Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import task.handler.configuration.DeploymentUnit;


/**
 * UpdateStampHandler
 *
 * @author  XLEHMF
 */
public class UpdateStampHandler extends BaseUpdateHandler<Long>
{
  public enum Action {
    ADD, CHANGE, SAME, DELETE;
  }
  
  @Override
  protected Long decodeValueToken(String token)
  {
    Long timestamp = Long.valueOf(token);
    return timestamp;
  }
  
  @Override
  protected String encodeValueToken(Long value)
  {
    return value.toString();
  }
  
  @Override
  protected Long getValueFromFile(File file)
  {
    long lastModified = file.lastModified();
    return lastModified;
  }

  @Override
  public boolean isUpdateRequired(DeploymentUnit du, File file)
  {
    long timestamp = file.lastModified();
    
    String key = getKey(du, file);
    
    Long updateStamp = getUpdateStamps().get(key);
    
    return (null == updateStamp) || (timestamp > updateStamp.longValue());
  }

  public void updateTimestamps(Map<String, Map<String, Long>> metadataUpdatestamps, boolean replace)
  {
    if (replace) {
      getUpdateStamps().clear();
    }
    for (Map.Entry<String, Map<String, Long>> entry : metadataUpdatestamps.entrySet()) {
      for (Map.Entry<String, Long> entityEntry : entry.getValue().entrySet()) {
        getUpdateStamps().put(getKey(entry.getKey(), entityEntry.getKey()), entityEntry.getValue());
      }
    }
    writeUpdateStampes();
  }

  public Map<String, Action> calculateDifferences(Map<String, Map<String, Long>> metadataUpdatestamps)
  {
    Map<String, Action> result = new HashMap<>();
    
    // build current map first
    Map<String, Long> currentMap = buildUpdatestampsMap(metadataUpdatestamps);
    
    // work on copies
    Set<String> lastKeys = new HashSet<>(getUpdateStamps().keySet());
    Set<String> currentKeys = new HashSet<>(currentMap.keySet());
    
    for (String currentKey : currentKeys) {
      if (lastKeys.remove(currentKey)) {
        // check for update
        if (0 == Long.compare(currentMap.get(currentKey), getUpdateStamps().get(currentKey))) {
          result.put(currentKey, Action.SAME);
        } else {
          result.put(currentKey, Action.CHANGE);
        }
      } else {
        // new
        result.put(currentKey, Action.ADD);
      }
    }
    for (String lastKey : lastKeys) {
      result.put(lastKey, Action.DELETE);
    }
    
    return result;
  }
  
  private Map<String, Long> buildUpdatestampsMap(Map<String, Map<String, Long>> metadataUpdatestamps)
  {
    Map<String, Long> result = new HashMap<>();
    for (Map.Entry<String, Map<String, Long>> entry : metadataUpdatestamps.entrySet()) {
      for (Map.Entry<String, Long> entityEntry : entry.getValue().entrySet()) {
        result.put(getKey(entry.getKey(), entityEntry.getKey()), entityEntry.getValue());
      }
    }
    return result;
  }
  
  public Map<String, List<String>> buildEntityList(Map<String, Map<String, Long>> metadataUpdatestamps)
  {
    Map<String, List<String>> result = new HashMap<>();
    
    for (Map.Entry<String, Map<String, Long>> entry : metadataUpdatestamps.entrySet()) {
      List<String> entries = new ArrayList<>();
      for (Map.Entry<String, Long> entityEntry : entry.getValue().entrySet()) {
        entries.add(entityEntry.getKey());
      }
      result.put(entry.getKey(), entries);
    }
    return result;
  }
}

