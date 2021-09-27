public with sharing virtual class ESC_PageControllerBase {
  
    private ESC_ComponentControllerBase myComponentController;
    private Map<String, ESC_ComponentControllerBase> componentControllerMap;
    
     public virtual ESC_ComponentControllerBase getMyComponentController() {
    return myComponentController;
  }
  
    public virtual Map<String, ESC_ComponentControllerBase> getComponentControllerMap(){
      return componentControllerMap;
    }  
    
    public virtual void setComponentControllerMap(String key, ESC_ComponentControllerBase compController){
        if(componentControllerMap == null)
            componentControllerMap = new Map<String, ESC_ComponentControllerBase>();
        componentControllerMap.put(key,compController); 
    }
    
     public virtual void setComponentController(ESC_ComponentControllerBase compController) {
    myComponentController = compController;
  }
  

    public ESC_PageControllerBase getThis() {
        return this;
    }
}