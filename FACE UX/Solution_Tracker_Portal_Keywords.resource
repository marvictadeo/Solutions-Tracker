*** Settings ***
Documentation        Global Keywords for Test Cases.
Library              Collections
Library              String
Library              DateTime
Library              Dialogs
Library              SeleniumLibrary
Library              FakerLibrary
Library              RPA.Excel.Files
Library              RPA.Tables
Resource             UX_Form_Variables.resource
Resource             UX_Form_Keywords.resource


*** Keywords ***
Verify The Ticket In Solution Tracker Portal
    [Documentation]    Verify The Ticket In Solution Tracker Portal
    [Arguments]    ${url}    ${case_number}
    TRY
        Switch Window    title:Cases All Cases (FACE) - Dynamics 365
    EXCEPT
        The User Navigate To CRM Site And Login    ${url}
    END
    Input Text    ${SEARCH_BOX}     ${case_number}
    Press Keys    ${SEARCH_BOX}    ENTER
    Wait Until Element Is Visible     //label[@aria-label='${case_number}']    120s

The User Navigate To CRM Site And Login
    [Documentation]    Navigate To CRM Side And Login
    [Arguments]    ${url}
    Open Link In New Tab    ${url}
    ${signed_in}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    //img[@title='Music Tribe CRM']    3s
    IF    ${signed_in}    RETURN
    Wait Until Element Is Visible    ${TXT_EMAIL}    120s
    Input Text    ${TXT_EMAIL}    ${EMAIL}
    Click Element    ${BTN_SUBMIT}
    Wait Until Element Is Visible    ${TXT_PASSWORD}    120s
    Input Text    ${TXT_PASSWORD}    ${PASSWORD}
    Click Element    ${BTN_SUBMIT}
    Pause Execution    #    Input verification here

Verify The Automated Ticket Title
    [Documentation]     The ticket subject/title will be based on the following:
    ...    Service Requirement + Service Type + Service Classification
    [Arguments]    ${case_number}   ${sr_item}    ${st_item}    ${sc_item}
    IF    "${st_item}" != "EMPTY"
        ${expected_title}    Catenate    ${sr_item}    ${st_item}    ${sc_item}
    ELSE
        ${expected_title}    Catenate    ${sr_item}   ${sc_item}
    END
    Wait Until Keyword Succeeds    3x    1s    View The Specific Case Number    ${case_number}
    Scroll "${LBL_SUBJECT}" Into Center
    Element Should Be Visible    //input[@title="${expected_title}"]

View The Specific Case Number
    [Documentation]    View The Specific Case Number Under User's Queue
    [Arguments]    ${case_number}
    Wait Until Element Is Visible    //label[@aria-label='${case_number}']    30s
    Click Element    //div[@col-id='ticketnumber']//*[@aria-label='${case_number}']
    Double Click Element    //div[@col-id='ticketnumber']//*[@aria-label='${case_number}']
    Wait Until Element Is Visible    //div[@data-id='form-header']//h1[contains(text(),'${case_number}')]    30s

Go Back And Switch To ST Form Page
    [Documentation]    View The Specific Case Number
    Wait Until Element Is Visible    //div/button[@title='Go back']
    Click Element    //div/button[@title='Go back']
    Wait Until Element Is Visible    ${SEARCH_BOX}    30s
    Clear Text Field    ${SEARCH_BOX}
    Switch Window    title:MT Solutions Tracker
