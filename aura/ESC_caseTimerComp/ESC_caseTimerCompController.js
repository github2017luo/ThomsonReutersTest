({ 
    doInit : function(component, event, helper) { 
        
        helper.getFocusedTab(component, event);
        helper.showTimerComp(component, event);
        helper.getCaseDetails(component, event);
        var clsStopwatch = function() { 
            var startAt = startAt || 0; 
            var lapTime = lapTime || 0; 
            var now = function() { 
                return (new Date()).getTime();
            }; 
            this.start = function() {
                startAt = startAt ? startAt : now();
            };
            this.stop = function() { 
                lapTime = startAt ? lapTime + now() - startAt : lapTime; startAt = 0;
            }; 
            this.reset = function() {
                lapTime = startAt = 0;
            }; 
            this.time = function() { 
                return lapTime + (startAt ? now() - startAt : 0);
            }; 
        }; 
        
        var stopwatch = component.get("v.stopwatch"); 
        var x = stopwatch || new clsStopwatch(); 
        if(!stopwatch){
            component.set("v.stopwatch", x);
        } 
        
        var clocktimer = setInterval(function(){
            helper.updateStatus(component, event);
            
        }, 1);
        x.start(); 
        component.set('v.playing',true);
        //window.onbeforeunload = confirmExit;
        function confirmExit(e){
            //console.log('Inside confirmExit'+component.get("v.stime"));
            //e.returnValue = "Are you sure you want to leave? All changes will be lost!";
            var caseId = component.get("v.recordId");
            var stime = component.get("v.stime");
            var workspaceAPI = component.find("workspace");
            var TabIds = workspaceAPI.getAllTabInfo();
            console.log('TabIds:' + TabIds);
            console.log('TabIds:' + TabIds=='[object Promise]');
            var flag1 = component.get("v.showTimer");
            //console.log('showtimer100'+flag1);
            if(flag1 == 'true'){
                helper.createSession(component,event);
            }
        }
        
    },
    onClick:function(component, event, helper) {
        var clocktimer;
        var id = event.getSource().get("v.label");
        console.log('ID**'+id);
        //var id  = event.target.id;    
        var x = component.get("v.stopwatch");
        
        switch(id){
            case "Start":
                component.set('v.playing',true);
                component.set('v.recording',true);
                component.set('v.showStartBtn',false);
                component.set('v.showStopBtn',true);
                
                clocktimer = setInterval(function() {
                    helper.updateStatus(component,event);
                }, 1);
                x.start();
                
                break;
            case "Stop":
                // $A.util.toggleClass(component.find("Stop"), "slds-hide");
                //$A.util.toggleClass(component.find("Start"), "slds-show");
                component.set('v.showStartBtn',true);
                component.set('v.showStopBtn',false);
                component.set('v.playing',false);
                helper.createSession(component,event);
                x.reset();
                helper.getCaseDetails(component, event);
                //x.stop();
                clearInterval(clocktimer);
                break;
            default:
                stop();
                break;
        }
        
    },
    createSession : function(component,event,helper){
        component.set("v.isOpen", true)
    },
    
    onTabFocused : function(component, event, helper) {
        console.log('on Tab change');
        if(component.get('v.playing')) {
            
            var x = component.get("v.stopwatch");
            var focusedTabId = event.getParam('currentTabId');
            console.log('tab change event');
            if(focusedTabId == component.get('v.tabId')) {
                var clocktimer = setInterval(function() {
                    helper.updateStatus(component,event);
                }, 1);
                x.start();
            } else{
                if(component.get('v.Override')){
                    var clocktimer = setInterval(function() {
                        helper.updateStatus(component,event);
                    }, 1);
                    x.start();
                }else{
                    helper.createSession(component,event);
                    x.reset();
                    helper.getCaseDetails(component, event);
                }
            }
        }
    },
    onTabClosed :function(component, event, helper) {
        console.log('Tab Close');
        var tabId = event.getParam('tabId');
        if(tabId == component.get('v.tabId')) {
            console.log('create record');
            helper.createSession(component,event);
        }
    },
    onTabRefreshed :function(component, event, helper) {
        console.log('Tab Refresh');
        
        var tabId = event.getParam('tabId');
        if(tabId == component.get('v.tabId')) {
            component.set('v.Override',false);
            //console.log('create record');
            //console.log('showtimer1'+component.get("v.showTimer"));
            var flag = component.get("v.showTimer");
            //console.log('showtimer14'+flag);
            if(flag == 'true'){
                //console.log('insideshowtimer for record creation');
                helper.createSession(component,event);
                //helper.showTimerComp(component, event);
            }
            helper.getCaseDetails(component, event);
            helper.showTimerComp(component, event);
            //console.log('showtimer2'+component.get("v.showTimer"));
            //component.set('v.stime','00:00:00');
            
            var x = component.get("v.stopwatch");
            //console.log('hellostop'+component.get("v.showStopBtn"));
            //console.log('hellostart'+component.get("v.showStartBtn"));
            if(!component.get("v.showStopBtn") && component.get("v.showStartBtn")){
                component.set('v.playing',true);
                component.set('v.recording',true);
                component.set('v.showStartBtn',false);
                component.set('v.showStopBtn',true);
            }
            //x.stop();
            x.reset();
            helper.updateStatus(component,event);
            var clocktimer = setInterval(function() {
                helper.updateStatus(component,event);
            }, 1);
            x.start();
            console.log('v.stime'+component.get('v.stime'));
        }
    }
    
})