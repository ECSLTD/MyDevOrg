public with sharing class NTV_SHmacSignature {
    
    private final String SKY_OTT_PLATFORM = 'SkyOTT';
    private final String SKY_OTT_PLATFORM_VERSION = '1.0';

    private String httpMethod;
    private String httpPath;
    private String httpStatus;
    private String client;
    private String secret;
    private String md5HexedHeaderString;
    private String md5HexedBodyString;
    private String timestampInSeconds;

    @TestVisible private String errorMsg;
    @TestVisible private class NTV_SHmacSignatureException extends Exception {}

    public NTV_SHmacSignature(final String client, final String secret, final NTV_HttpRequestBuilder httpRequestBuilder, final String timestampInSeconds) {
        if (String.isBlank(client) || String.isBlank(secret) || String.isBlank(timestampInSeconds) ){
            throw new NTV_SHmacSignatureException('arguments cannont be null: [client , secret , timestampInSeconds]');
        }
        this.client = client;
        this.secret = secret;
        this.httpStatus = '';
        this.timestampInSeconds = timestampInSeconds;

        HttpRequest httpRequest =  httpRequestBuilder.getHttpRequest();
        httpMethod = httpRequest.getMethod();
        httpPath = httpRequestBuilder.getPath();       
        md5HexedHeaderString = createHash('MD5', new NTV_HttpHeaders(httpRequestBuilder.getHeaders()).createStringToSign());
        md5HexedBodyString = createHash('MD5', httpRequest.getBody());
    }

    public Boolean doesResponseContainValidSHmac(final HttpResponse httpResponse) {
        ValidateSHmacStructure(httpResponse);
        Map<String, String> responseHeadersMap = new Map<String, String>();
        for (String key : HttpResponse.getHeaderKeys()) {
            responseHeadersMap.put(key, HttpResponse.getHeader(key));
        }

        md5HexedHeaderString =  createHash('MD5',new NTV_HttpHeaders(responseHeadersMap).createStringToSign());
        md5HexedBodyString = createHash('MD5', HttpResponse.getBody());
        timestampInSeconds = convertSHmacSignatureToMap(HttpResponse.getHeader('X-Sky-Signature')).get('timestamp');
        httpStatus = httpResponse.getStatus();

        return generateSHmacSignature(generateSHmac()).equals(HttpResponse.getHeader('X-Sky-Signature'));
    }

    public String generateSHmac() {
        String[] fillers = new String[] {httpMethod,
                                         httpPath,
                                         httpStatus,
                                         client,
                                         SKY_OTT_PLATFORM_VERSION,
                                         md5HexedHeaderString,
                                         timestampInSeconds,
                                         md5HexedBodyString};

        String stringToSign = String.format('{0}\n{1}\n{2}\n{3}\n{4}\n{5}\n{6}\n{7}\n', fillers);
        Blob HmacBlob = Crypto.generateMac('HmacSha1', Blob.valueOf(stringToSign), Blob.valueOf(secret));
        return EncodingUtil.base64Encode(HmacBlob);
    }

    private void ValidateSHmacStructure(final HttpResponse response) {
        String[] expectedEntries = new String[] {'SkyOTT client' , 'signature', 'timestamp', 'version'};

        if (response.getHeader('X-Sky-Signature') == null) {
            errorMsg = 'X-Sky-Signature not present in response header';
            throw new NTV_SHmacSignatureException(errorMsg);
        }

        Set<String> responseSHmacKeys = convertSHmacSignatureToMap(response.getHeader('X-Sky-Signature')).keySet();
        for (String key : expectedEntries) {
            if (!responseSHmacKeys.contains(key)) {
                errorMsg = key + ' not present in SHmac Signature';
                throw new NTV_SHmacSignatureException(errorMsg);
            }
        }
    }

    private Map<String, String> convertSHmacSignatureToMap(final String sHmacSignatureStructure) {
        Map<String, String> SHmacSignatureToMap = new Map<String, String>();
        String[] sHmacSignatureStructureList = sHmacSignatureStructure.split(',');
        for (String entry : sHmacSignatureStructureList) {
            String[] assignmentList = entry.split('=');
            SHmacSignatureToMap.put(assignmentList.get(0), assignmentList.get(1).replace('"', ''));
        }
        return SHmacSignatureToMap;
    }

    public String generateSHmacSignature() {
        return generateSHmacSignature(generateSHmac());
    }

    public String generateSHmacSignature(final String sHmac) {
        return String.format('{0} client="{1}",signature="{2}",timestamp="{3}",version="{4}"',
                             new String[] {SKY_OTT_PLATFORM, client, sHmac, timestampInSeconds, SKY_OTT_PLATFORM_VERSION});
    }

    public String createHash(final String hashAlgorithm, final String stringValue) {
        return EncodingUtil.convertToHex(Crypto.generateDigest(hashAlgorithm, Blob.valueOf(stringValue)));
    }
}