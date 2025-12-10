*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn
Resource       ../resources/keywordBaseApi.robot

*** Test Cases ***
Get Data And Verify Data Type
    [Tags]  test-api1
    Create API Session And Get Request
    Validate Data Item Types

Create Post And Validate Response
    [Tags]  test-api2
    Create API Session And Post Request
    Validate Response Matches Input
