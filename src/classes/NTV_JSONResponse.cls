public virtual without sharing class NTV_JSONResponse extends NTV_HttpResponse {

    /**
     * Returns the Response's body as a parsed Map.
     * 
     * @return Object
     */
    public virtual Object deserialize() {
        String body = getBody();
        if(String.isNotEmpty(body)) {
            return JSON.deserializeUntyped(body);
        }

        return null;
    }

    /**
     * Returns the Response's body as an object based upon the given class type.
     * 
     * @param  classType   the type of class to deserialize into
     * @return Object
     */
    public virtual Object deserialize(Type classType) {
        String body = getBody();
        if(String.isNotEmpty(body)) {
            return JSON.deserialize(body, classType);
        }
        return null;
    }
}