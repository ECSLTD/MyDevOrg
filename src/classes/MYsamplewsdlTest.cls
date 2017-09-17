@isTest
private class MYsamplewsdlTest {

public static testMethod void MytestMethod()
{
sampleintegration.Apex ap = new sampleintegration.Apex();
ap.SessionHeader = new sampleintegration.SessionHeader_element ();
// This is important, give session id, to let the call work.
ap.SessionHeader.sessionId = UserInfo.getSessionId();
sampleintegration.RunTestsRequest  rtr = new sampleintegration.RunTestsRequest();
// Run All Tests
rtr.allTests = true;
rtr.Namespace = '';
// Execute the Tests
sampleintegration.RunTestsResult testResults = ap.runTests(rtr);
System.debug('Failures >' + testResults.numFailures);
}



}