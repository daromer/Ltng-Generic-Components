({
	doRequestCall : function(component, event) {
        var eventParams = event? event.getParams() : null;        
        var recordId = event? (eventParams.expression? eventParams.value[eventParams.expression] : eventParams.value) : component.get('v.recordId');
        console.info('DOREQUESTCALL ===> recordId:', recordId, event );
		var action = component.get("c.getRecordData");        
        if (recordId){
            action.setParams({ recordId: recordId });      
            action.setCallback(this, function(response) {
                var state = response.getState();                      
                if (state == 'SUCCESS'){                
                    var raw = response.getReturnValue();                    
                    var json;
                    try{ json = JSON.parse(raw); }catch(e){}                    
                    console.info('RESULT FROM SERVER==>	',json);
                    if (json && json.success){
                        component.set("v.record", json.data);
                    }else if (json){
                        console.info("Errors found in Server", json.errors);
                    }else{
                        console.info("NOT ABLE TO PARSE TO JSON", raw);
                    }
                }else if (state == 'ERROR'){
                    var errors = response.getError();
                    console.info("*** errors ****", response.getError());
                    component.set("v.errors", errors);
                } 
            });
            $A.enqueueAction(action); 	
        }
	}
})