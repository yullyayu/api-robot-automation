*** Settings ***
Library    RequestsLibrary
Library    BuiltIn
Library    Collections
Library    OperatingSystem
Library    String
Variables   ../ENV.py

*** Keywords ***
Loging
    [Arguments]       ${message}
    Log               ${message}
    Log To Console    ${message}\n

Create API Session And Get Request
    Create Session    json_api    ${BASE_URL}
    ${response}=    GET On Session    json_api    /posts
    Loging  ${response}
    Should Be Equal As Integers    ${response.status_code}    200
    Set Global Variable    ${response}

Create API Session And Post Request
    &{payload}=    Create Dictionary
    ...    title=recommendation
    ...    body=motorcycle
    ...    userId=12
    Create Session    api    ${BASE_URL}
    ${resp}=    POST On Session    api    /posts    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    Set Global Variable     ${resp}
    Set Global Variable     ${payload}

Validate Data Item Types
    ${data}=    Set Variable    ${response.json()}
    Loging  ${data}
    FOR    ${item}    IN    @{data}
        ${userId}=    Set Variable    ${item["userId"]}
        ${id}=        Set Variable    ${item["id"]}
        ${title}=     Set Variable    ${item["title"]}
        ${body}=      Set Variable    ${item["body"]}

        Type Should Be    ${userId}    int    userId
        Type Should Be    ${id}        int    id
        Type Should Be    ${title}     str    title
        Type Should Be    ${body}      str    body
    END

Type Should Be
    [Arguments]    ${value}    ${expected_type}    ${field_name}
    ${actual}=    Set Variable    ${value.__class__.__name__}
    Should Be Equal    ${actual}    ${expected_type}    ${field_name} must be type ${expected_type}

Validate Response Matches Input
    ${resp_json}=    Set Variable    ${resp.json()}
    Should Be Equal    ${resp_json["title"]}     ${payload["title"]}
    Should Be Equal    ${resp_json["body"]}      ${payload["body"]}
    Should Be Equal As Integers    ${resp_json["userId"]}    ${payload["userId"]}
    Dictionary Should Contain Key    ${resp_json}    id