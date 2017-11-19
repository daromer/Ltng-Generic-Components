({
	handleInit:function(component, event, helper){        
        helper.doRequestCall(component);
    },
    handleIdChange:function(component, event, helper){
		helper.doRequestCall(component, event);
    }
})