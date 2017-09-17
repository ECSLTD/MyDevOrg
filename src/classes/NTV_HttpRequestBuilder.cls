/**
 * @class NTV_HttpRequestBuilder
 *   Help class for building http requests
 */
public with sharing class NTV_HttpRequestBuilder {

    private HttpRequest httpRequest;
    private String baseUrl;
    private String path = '';
    private Map<String, String> headers = new Map<String, String>();
    private String body = '';
    private String namedCredential;

    public NTV_HttpRequestBuilder() {
        httpRequest = new HttpRequest();
    }

    public Map<String, String> getHeaders() {
        return headers;
    }

    public HttpRequest getHttpRequest() {
        return httpRequest;
    }

    public String getPath() {
        return path;
    }
    
    /**
     * @param Integer timeout 
     * sets request timeout
    **/
    public NTV_HttpRequestBuilder setTimeout(final Integer timeout){
        httpRequest.setTimeout(timeout);
        return this;
    }
    
    /**
     * @param String url 
     *   sets request base url
     */
    public NTV_HttpRequestBuilder baseUrl(final String url) {
        this.baseUrl = url;
        return this;
    }

    /**
     * @param String uri 
     *   sets request path
     */
    public NTV_HttpRequestBuilder path(final String uri) {
        path = uri;
        return this;
    }

    /**
     * @param Map<String, String> header 
     *   sets request headers from a map
     */
    public NTV_HttpRequestBuilder header(final Map<String, String> headers ) {
        this.headers = headers;
        for (String headerKey : this.headers.keySet()) {
            httpRequest.setHeader(headerKey, this.headers.get(headerKey));
        }
        return this;
    }

    /**
     * @param String headerKey 
     * @param String headerValue 
     *   Sets single header 
     */
    public NTV_HttpRequestBuilder header(final String headerKey, final String headerValue) {
        headers.put(headerKey, headerValue);
        httpRequest.setHeader(headerKey, headerValue);
        return this;
    }

    /**
     * @param String httpMethod
     *   Sets http method
     */
    public NTV_HttpRequestBuilder setMethod(final String httpMethod) {
        httpRequest.setMethod(httpMethod);
        return this;
    }

    /**
     * @param String body
     *   Sets http request body
     */
    public NTV_HttpRequestBuilder body(final String body) {
        this.body = body;
        if(!String.isBlank(this.body)) {
            httpRequest.setBody(body);
        }
        return this;
    }

    /**
     *   @return build HttpRequest
     */    
    public HttpRequest build() {
        if(String.isBlank(namedCredential)) {
            List<String> filters = new String[] {baseUrl, path};
            String url = String.format('{0}{1}', filters);
            httpRequest.setEndpoint(url);
        }else{
            List<String> filters = new String[] {namedCredential, path};
            String url = String.format('callout:{0}{1}', filters);
            httpRequest.setEndpoint(url);
        }
        return httpRequest;
    }

    /**
     *  @param String namedCredential - named Credential name
     *     Sets named credential http request
     */
    public NTV_HttpRequestBuilder namedCredential(final String namedCredential) {   
        this.namedCredential = namedCredential;
        return this;
    }

     /**
     *  @param String userName - Nowtv CRM Api basic auth username
     *  @param String Password - Nowtv CRM Api basic auth password
     *     Sets Basic Auth Header
     */
    public NTV_HttpRequestBuilder basicAuth(final String userName, final String Password) {
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        headers.put('Authorization', authorizationHeader);
        httpRequest.setHeader('Authorization', authorizationHeader);
        return this;
    }

     /**
     *  @param String client - Nowtv CRM Api client name
     *  @param String secret - Nowtv CRM Api client secret
     *  @param String timestampInSeconds - Epoch timeStamp in Seconds
     *     Generates `SHMac` and set X-Sky-Signature header
     */
    public NTV_HttpRequestBuilder sHmacSignature(final String client, final String secret, final String timestampInSeconds) {
        NTV_SHmacSignature sHmacSignature = new NTV_SHmacSignature(client, secret, this, timestampInSeconds);

        String hmacSignature = sHmacSignature.generateSHMacSignature();

        httpRequest.setHeader('X-Sky-Signature', hmacSignature);
        headers.put('X-Sky-Signature', hmacSignature); 
        return this;
    }
}