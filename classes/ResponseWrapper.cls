global class ResponseWrapper {
    global class Error{
        global string message{get;set;}
        global string staticTrace{get;set;}
        global string[] fields{get;set;}
        
        public Error(){}
        public Error(string message, string staticTrace, string[] fields){this.message = message; this.staticTrace = staticTrace; this.fields = fields;}
        public Error(Database.Error ex){
            this.message = ex.getMessage();            
            this.fields = ex.getFields();
            this.staticTrace = string.valueOf(ex.getStatusCode());
        }
    }
    
    global Boolean success {get;set;}
    global object data {get;set;}
    global Error[] errors {get;set;}
    
    public ResponseWrapper(){success = true; errors = new list<Error>();}
    public ResponseWrapper(boolean success, object data, Error[] errors){this.success = success;this.data = data; this.errors = errors;}

    public void addException(Exception ex){
        this.success = false;
		this.errors.add(new ResponseWrapper.Error(ex.getMessage(), ex.getStackTraceString(), null));        
    }
    public void addDatabaseErrorIfExists(Database.Error[] errorList){
        if (errorList != null && errorList.size() > 0){
            this.success = false;
            for(Database.Error de : errorList){
                this.errors.add(new ResponseWrapper.Error(de));                    
            }
        }
    }  
}