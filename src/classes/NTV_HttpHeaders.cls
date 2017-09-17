public with sharing class NTV_HttpHeaders {
  
    private final String SKY_OTT_PLATFORM_PREFIX = 'x-skyott';
    private Map<String, String> headersMap = new Map<String, String>();
    List<String> headerList = new String[] {};
 
    
    public NTV_HttpHeaders(Map<String, String> headersMap) {
        this.headersMap = headersMap;
    }


    public boolean isIncludedInSignature(String headerKey) {
        return headerKey.toLowerCase()
               .startsWith(SKY_OTT_PLATFORM_PREFIX);
    }

    public String createStringToSign() {
        if ( headersMap.size() == 0) {
            return '';
        }

        List<String> fillers;
        for (String headerKey : headersMap.keySet()) {
            if (isIncludedInSignature(headerKey)) {
                fillers = new String[] {headerKey.toLowerCase(), headersMap.get(headerKey)};
                headerList.add(String.format('{0}: {1}', fillers));
            }
        }

        if ( headerList.size() == 0) {
            return '';
        }
        headerList.sort();
        return String.join(headerList, '\n') + '\n';
    }
}