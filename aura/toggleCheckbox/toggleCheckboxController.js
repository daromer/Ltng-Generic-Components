({
	onValueChangedHandler : function(component, event, helper) {
        var value = component.get('v.value');
        if(typeof(value)=='undefined'){
            component.set('v.value', false);
        }
	}
})