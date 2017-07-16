({
	search : function(component) {
        var helper = this;
		var searchString = component.get('v.searchString');
        var type = component.get('v.type');
        var selectedType = component.get('v.selectedType');
        var searchStringInput = component.find("searchStringInput");
        
        var params = {            
            searchString: searchStringInput.getElement().value,
            sobjectType : selectedType.value
        };        
        helper.callServer(component, 'c.getSearchResults', params, function(r,json){
            if (json && json.success){                
                component.set('v.searchResults',json.data.records);
            }
        });
	}
})