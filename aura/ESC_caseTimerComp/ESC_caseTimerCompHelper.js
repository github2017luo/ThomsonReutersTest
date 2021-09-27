({
    "showTimerComp": function(component,event){
        //console.log('showtimer3helper1'+component.get("v.showTimer"));
        component.set('v.showTimer',false);
        //console.log('showtimer3helper2'+component.get("v.showTimer"));
        var action = component.get("c.isCaseOwner");
        action.setParams({
            "casId": component.get("v.recordId"), 
        });
        action.setCallback(this, function(result){
            //console.log('results@@@'+result);
            //console.log('results1@@@'+result.getReturnValue());
            component.set("v.showTimer",result.getReturnValue());
            //console.log('showtimer3helper3'+component.get("v.showTimer"));
            
        });
        $A.enqueueAction(action);
    },
    "getCaseDetails":function(component, event) {
        var action = component.get("c.getCaseRec");
        action.setParams({
            "casId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(a) {
            var case_temp = a.getReturnValue();
            component.set('v.time1',Number(case_temp[0].ESC_Total_Time_Spent__c).toFixed(2));
            component.set('v.time2',Number(case_temp[0].ESC_Billable_Time__c).toFixed(2));
            
        });
        $A.enqueueAction(action);
    },
    "updateStatus":function(component, event) {
        var x = component.get("v.stopwatch");
        //window.addEventListener('unload',helper.addListeners(component,event));
        if(x != null) {
            component.set('v.stime',this.formatTime(x.time()));
        } 
    },
    "formatTime":function(time) {
        var h, m, s = 0;
        var newTime = '';
        
        h = Math.floor( time / (60 * 60 * 1000) );
        time = time % (60 * 60 * 1000);
        m = Math.floor( time / (60 * 1000) );
        time = time % (60 * 1000);
        s = Math.floor( time / 1000 );
        
        newTime = this.pad(h, 2) + ':' + this.pad(m, 2) + ':' + this.pad(s, 2);
        return newTime;
    },
    "pad":function(num, size) {
        var s = "0000" + num;
        return s.substr(s.length - size);
    },
    "getFocusedTab" : function(component, event) {
        console.log("Tab Focused");
        //var focusedTabId = event.getParam('currentTabId');
        var workspaceAPI = component.find("workspace");        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            component.set("v.tabId",focusedTabId);
            console.log('casetab'+focusedTabId+component.get("v.recordId"));
        });
    },
    "createSession":function(component, event) {
        //  alert('stime: ' + component.get('v.stime'));
        //console.log('hello 50'+component.get('v.stime'));
        var flagtimer = component.get('v.showTimer');
        console.log('showtimerforowner'+flagtimer);
        if(component.get('v.stime') != '00:00:00' && flagtimer == 'true') {
            console.log('hello if 72'); 
            var action = component.get('c.newSession');
            //console.log('hello 53'); 
            action.setParams({
                casId : component.get('v.recordId'),
                duration : component.get('v.stime')
            });
            action.setCallback(this, function(result) {
                var state = result.getState();
                if(state === 'SUCCESS') {
                    console.log('Success to grab Sessions');
                    component.set('v.stime','00:00:00');
                } else {
                    console.log('Failed to grab Sessions');
                }
            });
            $A.enqueueAction(action);
        }
    },
    addListeners : function(component,event) {
        // alert('stime:'+ component.get("v.stime"));
        //alert('refresh');
        document.addEventListener("beforeunload",this.createSession(component,event));
    }
    
})