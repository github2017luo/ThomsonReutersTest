//extend base controller ESC_ComponentControllerBase

public class USL_chargeCancellationController extends ESC_ComponentControllerBase{
    public list<SelectOption> reasonCodelist;
    public list<SelectOption> rootCauselist ;
    public string reasonCode{get;set;}
    public string rootCause{get;set;}
    public USL_chargeCancellationController(){
        
        
        
        
    }
    public List<Selectoption> getreasonCodelist(){
        List<selectOption> options = new List<selectOption>();        
        options.add(new selectoption('test','test'));
        options.add(new selectoption('test1','test1'));
        options.add(new selectoption('test3','test3'));
        options.add(new selectoption('tes2','test2'));
        return options;
    }
    public List<Selectoption> getrootCauselist (){
        List<selectOption> options = new List<selectOption>();
        options.add(new selectoption('test','test'));
        options.add(new selectoption('test1','test1'));
        options.add(new selectoption('test2','test2'));
        options.add(new selectoption('test3','test3'));
        return options;
    }
}