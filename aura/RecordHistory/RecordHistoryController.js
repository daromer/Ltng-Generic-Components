({
	onInitHandler : function(component, event, helper) {
        try{
            var recordId = component.get('v.recordId');
			var action = component.get('c.InitializeComponent');
            action.setParams({recordId:recordId});            
            action.setCallback(this,function recordHistoryControllerCallback(resp){
                if (resp.getState() == 'SUCCESS'){
                    var r = JSON.parse( resp.getReturnValue() );
                    if (r.success){
                        component.set('v.results', r.results);
                    }else{
                        console.warn("Server Error", r.errors);
                    }
                }
            });
            $A.enqueueAction(action);
        }catch(ex){}
	}
})