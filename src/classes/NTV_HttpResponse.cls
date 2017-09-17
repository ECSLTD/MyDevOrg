public without sharing virtual class NTV_HttpResponse {
    protected Integer statusCode;
    protected String body;
    protected Map<String,String> headers;
    protected HTTPResponse response;

    /**
     * Default Contructor
     */
    public NTV_HttpResponse() { }

    /**
     * Default Contructor
     *
     * @param  response  A HTTP Response object
     */
    public NTV_HttpResponse(HTTPResponse response) {
        setResponse(response);
    }

    /**
     * Sets the response
     *
     * @param  response  A HTTP Response object
     */
    public void setResponse(HTTPResponse response) {
        this.statusCode = response.getStatusCode();
        this.body = response.getBody();
        this.headers = new Map<String,String>();
        this.response = response;

        for(String header : response.getHeaderKeys()) {
            if (String.isNotEmpty(header)) {
                String value = response.getHeader(header);
                this.headers.put(header, value);
            }   
        }
    }

    /**
     * Returns the value associated with the given header.
     *
     * @param  header  the name of the header
     * @return String
     */
    public String getHeader(String header) {
        if (this.headers == null) {
            return null;
        }
        return this.headers.get(header);
    }       

    /**
     * Returns the response status code.
     *
     * @return Integer
     */
    public Integer getStatusCode() {
        return this.statusCode;
    }

    /**
     * Returns the response body.
     *
     * @return String
     */
    public String getBody() {
        return this.body;
    }

    /** 
     * Returns the status as a string.
     *
     * @return String
     */
    public String getStatus() {
        return this.response.getStatus();
    }

    /**
     * Returns whether or not the response is successful.
     *
     * @return String
     */
    public Boolean isSuccessful() {
        return (getStatusCode() / 100) == 2;
    }

}