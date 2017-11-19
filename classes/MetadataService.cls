public class MetadataService {
    static final string soapUrl = 'http://soap.sforce.com/2006/04/metadata';
      
     public class RemoteSiteSetting extends Metadata {
        public String type = 'RemoteSiteSetting';
        public String fullName;
        public String description;
        public Boolean disableProtocolSecurity;
        public Boolean isActive;
        public String url;
        public String[] type_att_info = new String[]{'xsi:type'};
        public String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] description_type_info = new String[]{'description','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] isActive_type_info = new String[]{'isActive','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] url_type_info = new String[]{'url','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'fullName','description','disableProtocolSecurity','isActive','url'};
    }
     
    public class CreateResponse_Element {
        public MetadataService.AsyncResult[] result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public CreateResponse_Element() {}
    }
           
    public class MetadataPort {
        public String endpoint_x;
        {
            // Workaround to platform bug (?) where the following method returns a none HTTPS URL in a Batch Apex context
            URL baseUrl = URL.getSalesforceBaseUrl();
            
            if(baseUrl.getProtocol() == 'http')
                baseUrl = new URL('https', baseUrl.getHost(), baseUrl.getPort(), baseUrl.getFile()); // Switch to https protocol
            endpoint_x = baseUrl.toExternalForm() + '/services/Soap/m/27.0';          
        }
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_Element SessionHeader;
        public MetadataService.DebuggingInfo_Element DebuggingInfo;
        public MetadataService.CallOptions_Element CallOptions;
        public MetadataService.DebuggingHeader_Element DebuggingHeader;
        public String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        public String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        public String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        public String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        public String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataService'};
        
        public MetadataService.AsyncResult[] create(MetadataService.Metadata[] metadata) {
            MetadataService.Create_Element request_x = new MetadataService.Create_Element();
            MetadataService.CreateResponse_Element response_x;
            request_x.metadata = metadata;
            Map<String, MetadataService.CreateResponse_Element> response_map_x = new Map<String, MetadataService.CreateResponse_Element>();
            response_map_x.put('response_x', response_x);
            
            if(!Test.isRunningTest()) {
            	WebServiceCallout.invoke(
	              this,
	              request_x,
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'http://soap.sforce.com/2006/04/metadata',
	              'create',
	              'http://soap.sforce.com/2006/04/metadata',
	              'createResponse',
	              'MetadataService.CreateResponse_Element'}
	            );
	            
	            response_x = response_map_x.get('response_x');
            	
            	return response_x.result;
            } else {	
            	return null;
            }
        }
       
        public MetadataService.AsyncResult[] checkStatus(String[] asyncProcessId) {
            MetadataService.CheckStatus_Element request_x = new MetadataService.CheckStatus_Element();
            MetadataService.CheckStatusResponse_Element response_x;
            request_x.asyncProcessId = asyncProcessId;
            Map<String, MetadataService.CheckStatusResponse_Element> response_map_x = new Map<String, MetadataService.CheckStatusResponse_Element>();
            response_map_x.put('response_x', response_x);
            
            if(!Test.isRunningTest()) {
            	
            	WebServiceCallout.invoke(
	              this,
	              request_x, 
	              response_map_x,
	              new String[]{endpoint_x,
	              '',
	              'http://soap.sforce.com/2006/04/metadata', 
	              'checkStatus',
	              'http://soap.sforce.com/2006/04/metadata',
	              'checkStatusResponse',
	              'MetadataService.CheckStatusResponse_Element'}
	            );
	            
	            response_x = response_map_x.get('response_x');
            	
            	return response_x.result;
            } else {	
            	return null;
            }   
        }
        
        public MetadataService.IReadResult readMetadata(String type_x,String[] fullNames) {
            MetadataService.readMetadata_element request_x = new MetadataService.readMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.IReadResponseElement response_x;
            Map<String, MetadataService.IReadResponseElement> response_map_x = new Map<String, MetadataService.IReadResponseElement>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                    '',
                    'http://soap.sforce.com/2006/04/metadata',
                    'readMetadata',
                    'http://soap.sforce.com/2006/04/metadata',
                    'readMetadataResponse',
                    'MetadataService.read' + type_x + 'Response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getResult();
        }
    }    
    
    public class AsyncResult {
        public Boolean checkOnly;
        public Boolean done;
        public String id;
        public String message;
        public Integer numberComponentErrors;
        public Integer numberComponentsDeployed;
        public Integer numberComponentsTotal;
        public Integer numberTestErrors;
        public Integer numberTestsCompleted;
        public Integer numberTestsTotal;
        public String state;
        public String stateDetail;
        public DateTime stateDetailLastModifiedDate;
        public String statusCode;
        public String[] checkOnly_type_info = new String[]{'checkOnly','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
        public String[] done_type_info = new String[]{'done','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        public String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
        public String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] numberComponentErrors_type_info = new String[]{'numberComponentErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberComponentsDeployed_type_info = new String[]{'numberComponentsDeployed','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberComponentsTotal_type_info = new String[]{'numberComponentsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestErrors_type_info = new String[]{'numberTestErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestsCompleted_type_info = new String[]{'numberTestsCompleted','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] numberTestsTotal_type_info = new String[]{'numberTestsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
        public String[] state_type_info = new String[]{'state','http://soap.sforce.com/2006/04/metadata','AsyncRequestState','1','1','false'};
        public String[] stateDetail_type_info = new String[]{'stateDetail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] stateDetailLastModifiedDate_type_info = new String[]{'stateDetailLastModifiedDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
        public String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata','StatusCode','0','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'checkOnly','done','id','message','numberComponentErrors','numberComponentsDeployed','numberComponentsTotal','numberTestErrors','numberTestsCompleted','numberTestsTotal','state','stateDetail','stateDetailLastModifiedDate','statusCode'};
    
    	public AsyncResult() {}
    }    
    
    public class CheckStatus_Element {
        public String[] asyncProcessId;
        public String[] asyncProcessId_type_info = new String[]{'asyncProcessId','http://soap.sforce.com/2006/04/metadata','ID','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'asyncProcessId'};
        
        public CheckStatus_Element() {}
    }
    
    public class CheckStatusResponse_Element {
        public MetadataService.AsyncResult[] result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public CheckStatusResponse_Element() {}
    }
    
    public class PackageTypeMembers {
        public String[] members;
        public String name;
        public String[] members_type_info = new String[]{'members','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
        public String[] name_type_info = new String[]{'name','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'members','name'};
        
        public PackageTypeMembers() {}
    }
    
    public class DebuggingHeader_Element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        public String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/2006/04/metadata','LogInfo','0','-1','false'};
        public String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/2006/04/metadata','LogType','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'categories','debugLevel'};
        
        public DebuggingHeader_Element() {}
    }
    
    public class LogInfo {
        public String category;
        public String level;
        public String[] category_type_info = new String[]{'category','http://soap.sforce.com/2006/04/metadata','LogCategory','1','1','false'};
        public String[] level_type_info = new String[]{'level','http://soap.sforce.com/2006/04/metadata','LogCategoryLevel','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'category','level'};
        
        public LogInfo() {}
    }
    
    public virtual class Metadata {
        public String fullName;
        public String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'fullName'};
    	
    	public Metadata() {}
    }
    
    public class SessionHeader_Element {
        public String sessionId;
        public String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'sessionId'};
        
        public SessionHeader_Element() {}
    }
   
    public class RetrieveResponse_Element {
        public MetadataService.AsyncResult result;
        public String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'result'};
        
        public RetrieveResponse_Element() {}
    }
 
    public class DebuggingInfo_Element {
        public String debugLog;
        public String[] debugLog_type_info = new String[]{'debugLog','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'debugLog'};
        
        public DebuggingInfo_Element() {}
    }
    
    public class CallOptions_Element {
        public String client;
        public String[] client_type_info = new String[]{'client','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'client'};
        
        public CallOptions_Element() {}
    }
    
    public class CheckDeployStatus_Element {
        public String asyncProcessId;
        public String[] asyncProcessId_type_info = new String[]{'asyncProcessId','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'asyncProcessId'};
        
        public CheckDeployStatus_Element() {}
    }
    
     public class Create_Element {
        public MetadataService.Metadata[] metadata;
        public String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata','Metadata','0','-1','false'};
        public String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        public String[] field_order_type_info = new String[]{'metadata'};
        
        public Create_Element() {}
    }   
    
    public class CustomField extends Metadata {
        public String type = 'CustomField';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public Boolean caseSensitive;
        public String customDataType;
        public String defaultValue;
        public String deleteConstraint;
        public Boolean deprecated;
        public String description;
        public String displayFormat;
        public Boolean encrypted;
        public Boolean escapeMarkup;
        public String externalDeveloperName;
        public Boolean externalId;
        public String fieldManageability;
        public String formula;
        public String formulaTreatBlanksAs;
        public String inlineHelpText;
        public Boolean isConvertLeadDisabled;
        public Boolean isFilteringDisabled;
        public Boolean isNameField;
        public Boolean isSortingDisabled;
        public String label;
        public Integer length;
        //public MetadataService.LookupFilter lookupFilter;
        public String maskChar;
        public String maskType;
        public MetadataService.Picklist picklist;
        public Boolean populateExistingRows;
        public Integer precision;
        public String referenceTargetField;
        public String referenceTo;
        public String relationshipLabel;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean reparentableMasterDetail;
        public Boolean required;
        public Boolean restrictedAdminField;
        public Integer scale;
        public Integer startingNumber;
        public Boolean stripMarkup;
        public String summarizedField;
        //public MetadataService.FilterItem[] summaryFilterItems;
        public String summaryForeignKey;
        public String summaryOperation;
        public Boolean trackFeedHistory;
        public Boolean trackHistory;
        public Boolean trackTrending;
        public String type_x;
        public Boolean unique;
        public MetadataService.ValueSet valueSet;
        public Integer visibleLines;
        public Boolean writeRequiresMasterRead;
        public Boolean displayLocationInDecimal;
        private String[] caseSensitive_type_info = new String[]{'caseSensitive','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] customDataType_type_info = new String[]{'customDataType','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] defaultValue_type_info = new String[]{'defaultValue','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deleteConstraint_type_info = new String[]{'deleteConstraint','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] deprecated_type_info = new String[]{'deprecated','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayFormat_type_info = new String[]{'displayFormat','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] encrypted_type_info = new String[]{'encrypted','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] escapeMarkup_type_info = new String[]{'escapeMarkup','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalDeveloperName_type_info = new String[]{'externalDeveloperName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] externalId_type_info = new String[]{'externalId','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] fieldManageability_type_info = new String[]{'fieldManageability','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formula_type_info = new String[]{'formula','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] formulaTreatBlanksAs_type_info = new String[]{'formulaTreatBlanksAs','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] inlineHelpText_type_info = new String[]{'inlineHelpText','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isConvertLeadDisabled_type_info = new String[]{'isConvertLeadDisabled','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isFilteringDisabled_type_info = new String[]{'isFilteringDisabled','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isNameField_type_info = new String[]{'isNameField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isSortingDisabled_type_info = new String[]{'isSortingDisabled','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] length_type_info = new String[]{'length','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] lookupFilter_type_info = new String[]{'lookupFilter','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maskChar_type_info = new String[]{'maskChar','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] maskType_type_info = new String[]{'maskType','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] picklist_type_info = new String[]{'picklist','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] populateExistingRows_type_info = new String[]{'populateExistingRows','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] precision_type_info = new String[]{'precision','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] referenceTargetField_type_info = new String[]{'referenceTargetField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] referenceTo_type_info = new String[]{'referenceTo','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipLabel_type_info = new String[]{'relationshipLabel','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipName_type_info = new String[]{'relationshipName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] relationshipOrder_type_info = new String[]{'relationshipOrder','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reparentableMasterDetail_type_info = new String[]{'reparentableMasterDetail','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] required_type_info = new String[]{'required','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] restrictedAdminField_type_info = new String[]{'restrictedAdminField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] scale_type_info = new String[]{'scale','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] startingNumber_type_info = new String[]{'startingNumber','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] stripMarkup_type_info = new String[]{'stripMarkup','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summarizedField_type_info = new String[]{'summarizedField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryFilterItems_type_info = new String[]{'summaryFilterItems','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] summaryForeignKey_type_info = new String[]{'summaryForeignKey','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] summaryOperation_type_info = new String[]{'summaryOperation','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackFeedHistory_type_info = new String[]{'trackFeedHistory','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackHistory_type_info = new String[]{'trackHistory','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] trackTrending_type_info = new String[]{'trackTrending','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] unique_type_info = new String[]{'unique','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueSet_type_info = new String[]{'valueSet','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] visibleLines_type_info = new String[]{'visibleLines','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] writeRequiresMasterRead_type_info = new String[]{'writeRequiresMasterRead','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] displayLocationInDecimal_type_info = new String[]{'displayLocationInDecimal','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'caseSensitive','customDataType','defaultValue','deleteConstraint','deprecated','description','displayFormat','encrypted','escapeMarkup','externalDeveloperName','externalId','fieldManageability','formula','formulaTreatBlanksAs','inlineHelpText','isConvertLeadDisabled','isFilteringDisabled','isNameField','isSortingDisabled','label','length','lookupFilter','maskChar','maskType','picklist','populateExistingRows','precision','referenceTargetField','referenceTo','relationshipLabel','relationshipName','relationshipOrder','reparentableMasterDetail','required','restrictedAdminField','scale','startingNumber','stripMarkup','summarizedField','summaryFilterItems','summaryForeignKey','summaryOperation','trackFeedHistory','trackHistory','trackTrending','type_x','unique','valueSet','visibleLines','writeRequiresMasterRead','displayLocationInDecimal'};
    }
    
    public class Picklist {
        public String controllingField;
        public MetadataService.PicklistValue[] picklistValues;
        public Boolean restrictedPicklist;
        public Boolean sorted;
        private String[] controllingField_type_info = new String[]{'controllingField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] restrictedPicklist_type_info = new String[]{'restrictedPicklist','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] sorted_type_info = new String[]{'sorted','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'controllingField','picklistValues','restrictedPicklist','sorted'};
    }
    
    
    public class PicklistValue extends GlobalPicklistValue {
        public String type = 'PicklistValue';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String color;
        public Boolean default_x;
        public String description;
        public Boolean isActive;
        private String[] color_type_info = new String[]{'color','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] default_x_type_info = new String[]{'default','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public Boolean allowEmail;
        public Boolean closed;
        public String[] controllingFieldValues;
        public Boolean converted;
        public Boolean cssExposed;
        public String forecastCategory;
        public Boolean highPriority;
        public Integer probability;
        public String reverseRole;
        public Boolean reviewed;
        public Boolean won;
        private String[] allowEmail_type_info = new String[]{'allowEmail','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] closed_type_info = new String[]{'closed','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] controllingFieldValues_type_info = new String[]{'controllingFieldValues','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] converted_type_info = new String[]{'converted','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] cssExposed_type_info = new String[]{'cssExposed','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] forecastCategory_type_info = new String[]{'forecastCategory','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] highPriority_type_info = new String[]{'highPriority','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] probability_type_info = new String[]{'probability','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reverseRole_type_info = new String[]{'reverseRole','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] reviewed_type_info = new String[]{'reviewed','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] won_type_info = new String[]{'won','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName','color','default_x','description','isActive', 'allowEmail','closed','controllingFieldValues','converted','cssExposed','forecastCategory','highPriority','probability','reverseRole','reviewed','won'};
    }
    
    public virtual class GlobalPicklistValue extends Metadata {
        public String color;
        public Boolean default_x;
        public String description;
        public Boolean isActive;
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] color_type_info = new String[]{'color','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] default_x_type_info = new String[]{'default','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'color','default_x','description','isActive','fullName'};
    }
    
    public class ValueSet {
        public String controllingField;
        public Boolean restricted;
        public MetadataService.ValueSetValuesDefinition valueSetDefinition;
        public String valueSetName;
        public MetadataService.ValueSettings[] valueSettings;
        private String[] controllingField_type_info = new String[]{'controllingField','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] restricted_type_info = new String[]{'restricted','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueSetDefinition_type_info = new String[]{'valueSetDefinition','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueSetName_type_info = new String[]{'valueSetName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] valueSettings_type_info = new String[]{'valueSettings','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'controllingField','restricted','valueSetDefinition','valueSetName','valueSettings'};
    }
    
    public class ValueSetValuesDefinition {
        public Boolean sorted;
        public MetadataService.CustomValue[] value;
        private String[] sorted_type_info = new String[]{'sorted','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] value_type_info = new String[]{'value','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sorted','value'};
    }
    
    public virtual class CustomValue extends Metadata {
        public String color;
        public Boolean default_x;
        public String description;
        public Boolean isActive;
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] color_type_info = new String[]{'color','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] default_x_type_info = new String[]{'default','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'color','default_x','description','isActive','fullName'};
    }
    
    public class ValueSettings {
        public String[] controllingFieldValue;
        public String valueName;
        private String[] controllingFieldValue_type_info = new String[]{'controllingFieldValue',MetadataService.soapUrl,null,'0','-1','false'};
        private String[] valueName_type_info = new String[]{'valueName',MetadataService.soapUrl,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{MetadataService.soapUrl,'true','false'};
        private String[] field_order_type_info = new String[]{'controllingFieldValue','valueName'};
    }
    
    
    
    public interface IReadResult {
        MetadataService.Metadata[] getRecords();
    }
    public interface IReadResponseElement {
        IReadResult getResult();
    }
    
    public class readMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }
    
    
    public class RecordType extends Metadata {
        public String type = 'RecordType';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public Boolean active;
        public String businessProcess;
        public String compactLayoutAssignment;
        public String description;
        public String label;
        public MetadataService.RecordTypePicklistValue[] picklistValues;
        private String[] active_type_info = new String[]{'active','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] businessProcess_type_info = new String[]{'businessProcess','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] compactLayoutAssignment_type_info = new String[]{'compactLayoutAssignment','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] label_type_info = new String[]{'label','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] picklistValues_type_info = new String[]{'picklistValues','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'active','businessProcess','compactLayoutAssignment','description','label','picklistValues'};
    }
    
    public class RecordTypePicklistValue {
        public String picklist;
        public MetadataService.PicklistValue[] values;
        private String[] picklist_type_info = new String[]{'picklist','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] values_type_info = new String[]{'values','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'picklist','values'};
    }
    
    public class readRecordTypeResponse_element implements IReadResponseElement {
        public MetadataService.ReadRecordTypeResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class ReadRecordTypeResult implements IReadResult {
        public MetadataService.RecordType[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
}