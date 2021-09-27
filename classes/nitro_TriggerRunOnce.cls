public class nitro_TriggerRunOnce {
    private static Set <Id> idSet = new Set <Id>();
// has this Id been processed? 
    public static boolean isAlreadyDone(Id objectId) {
        if (idSet.contains(objectId)) {
            return true;
        }
        else {
            return false;
        }
    }
// set that this Id has been processed.
    public static void setAlreadyDone(Id objectId) {
        idSet.add(objectId);
    }
// empty set if we need to for some reason. 
    public static void resetAlreadyDone() {
        idSet.clear();
    }
    
    public static list<integer> getMonthYear (string FiscalMonth) {
    list<string> MthYr = FiscalMonth.split(' ',0);
    integer MonthNum = (MthYr[0]=='Jan')? 1 : (MthYr[0]=='Feb')? 2 : (MthYr[0]=='Mar')? 3 : 
                       (MthYr[0]=='Apr')? 4 : (MthYr[0]=='May')? 5 : (MthYr[0]=='Jun')? 6 : 
                       (MthYr[0]=='Jul')? 7 : (MthYr[0]=='Aug')? 8 : (MthYr[0]=='Sep')? 9 : 
                       (MthYr[0]=='Oct')? 10 : (MthYr[0]=='Nov')? 11 : 12;
    integer YearNum = integer.valueOf(MthYr[1]);
    return new list<integer> {MonthNum,YearNum};
  }
  
  
}