public  class CMap {
    private Map<String, List<String>> coreMap = new Map<String, List<String>>();
    private Set<String> coreValue = new Set<String>();

    public CMap() {
        
    }

    public void add(String key, String value){
        if (this.coreMap.containsKey(key)){
            List<String> tmpids = this.coreMap.get(key);
            tmpids.add(value);
            this.coreMap.put(key, tmpids);
        }else{
            List<String> tmpids = new List<String>();
            tmpids.add(value);
            this.coreMap.put(key, tmpids);
        }

        if (!this.coreValue.contains(value)){
            this.coreValue.add(value);
        }
    }

    public void addAll(String key, List<String> value){
        if (this.coreMap.containsKey(key)){
            List<String> tmpids = this.coreMap.get(key);
            tmpids.addAll(value);
            this.coreMap.put(key, tmpids);
        }else{
            List<String> tmpids = new List<String>();
            tmpids.addAll(value);
            this.coreMap.put(key, tmpids);
        }

        for(String s: value){
            if (!this.coreValue.contains(s)){
                this.coreValue.add(s);
            }
        }
    }

    public List<String> get(String key){
        return this.coreMap.get(key);
    }

    public Set<String> KeySet(){
        return this.coreMap.keySet();
    }

    public List<List<String>> value(){
        return this.coreMap.values();
    }

    public Set<String> values2(){
        return this.coreValue;
    }
    
    public void cleanLessThanTwoList(){
        for(String key : coreMap.keySet()){
            if(coreMap.get(key).size()<2){
                coreValue.removeAll(coreMap.get(key));
                coreMap.remove(key);
            }
        }
    }
}