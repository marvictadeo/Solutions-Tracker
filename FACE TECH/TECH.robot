*** Settings ***
Documentation    Ticketing Data Comparison
Library              Collections
Library              String
Library              DateTime
Library              SeleniumLibrary
Library              RPA.Excel.Files
Library              RPA.Tables
Library              FakerLibrary
Test Setup           Navigate To Site    http://10.224.57.5:8080/    chrome
Resource             Tech_Form_Keywords.resource
Resource             Solution_Tracker_Portal_Keywords.resource


*** Test Cases ***
Verify Ticket Creation : FACE TECH
    [Documentation]    Test Case to Verify FACE TECH Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    Verify Master Data And Ticket Submission : FACE TECH

Verify Ticket Creation With CRM Checking : FACE TECH
    [Documentation]    Test Case to Verify FACE TECH Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    ...    Created Ticket In The Solution Ticket Portal
    ...    Automated Ticket Title
    Verify Master Data And Ticket Submission With CRM Checking : FACE TECH

Test
    [Documentation]     Draft Test
    Check Create Page
    # Change Excel Sheet Name
    Get Excel Data - FACE TECH    TECH
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        Check Create Page
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}

        Change Division    Face Tribes (FACE)
        Select Sub-Division    ${subdiv_item}
        Select "${sc_item}" As Service Classification
        Select "${st_item}" As Service Type
        Select "${sr_item}" As Service Requirement
        Fill In Requestor's Info [Requestor's Name, Division, Sub-division, Location]
        Fill In Request Info [Description, Priority, Date Needed]
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        #    Select "${brand_item}" As Brand
        #    Run Keyword And Continue On Failure
        #    ...    Fill In Other Info And Submit The Ticket
        #    ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
        #    Run Keyword And Continue On Failure
        #    ...    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
        Run Keyword And Continue On Failure
        ...    Verify The Ticket In Solution Tracker Portal    ${URL_ALL_CASES_FACE}    CAS-21806-Y1Q2K7
        Run Keyword And Continue On Failure
        ...    Verify The Automated Ticket Title     CAS-21806-Y1Q2K7   Internal QA    Test    FACE QUAL
        Wait Until Element Is Visible    //div/button[@title='Go back']
        Click Element    //div/button[@title='Go back']
        Wait Until Element Is Visible    ${SEARCH_BOX}    30s
        Clear Text Field    ${SEARCH_BOX}
        Switch Window    title:MT Solutions Tracker
    END

Test - Random Select
    [Documentation]     Draft Test
    Check Create Page
    Fill In Requestor's Info [Requestor's Name, Division, Sub-division, Location]
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    Pause Execution

Get Ticket Number
    [Documentation]
    Wait Until Page Contains Element    //app-card-button[@title='View']
    Click Element    //div[@class="card-button__wrapper"]//div[text()='View']
    ${table}    Set Variable
    ...    //div[@class="datatable-body-cell-label"]/a[text()=" (Internal QA Test) Inno Mech Ticket 2"]
    Wait Until Page Contains Element    ${table}    30s
    Click Element    ${table}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    Get ST Ticket Number In Ticket Summary

Ticket Title
    Wait Until Page Contains Element    //app-card-button[@title='View']
    Click Element    //div[@class="card-button__wrapper"]//div[text()='View']
    Verify Ticket Title In The "Ticket Viewer"    (Internal QA Test) Inno Mech Ticket 2

    ${table}    Set Variable
    ...    //div[@class="datatable-body-cell-label"]/a[text()=" (Internal QA Test) Inno Mech Ticket 2"]
    Wait Until Page Contains Element    ${table}    30s
    Click Element    ${table}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    Verify Ticket Title In The "Ticket Details"
    ...    (Internal QA Test) Inno Mech Ticket 2
