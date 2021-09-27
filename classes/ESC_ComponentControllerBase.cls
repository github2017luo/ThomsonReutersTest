public with sharing virtual class ESC_ComponentControllerBase {

    public String key{ 
        get;
        set{
            if(value != null){
                Key  = value;
                if(pageController != null)
                    pageController.setComponentControllerMap(Key, this);
            }
        }
    }
    
    public ESC_PageControllerBase pageController { 
        get; 
        set {
            if (value != null) {
                pageController = value;
            }
        }
    }
    
    public virtual void saveComponent(){
        
    }
}