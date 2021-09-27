({
    selectRecord : function(cmp, event, helper){
        var getSelectRecord = cmp.get("v.oRecord");
        console.log('selected record-----'+ getSelectRecord );
        var compEvent = cmp.getEvent("selectedRecEvent");      
        compEvent.setParams({"selectedRecFromEvent" : getSelectRecord });
        compEvent.fire();
    },
})