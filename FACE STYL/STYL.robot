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
Resource             Styl_Form_Keywords.resource
Resource             Solution_Tracker_Portal_Keywords.resource


*** Test Cases ***
Verify Ticket Creation : FACE STYL
    [Documentation]    Test Case to Verify FACE STYL Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    Verify Master Data And Ticket Submission : FACE STYL

Verify Ticket Creation With CRM Checking : FACE STYL
    [Documentation]    Test Case to Verify FACE STYL Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    ...    Created Ticket In The Solution Ticket Portal
    ...    Automated Ticket Title
    Verify Master Data And Ticket Submission With CRM Checking : FACE STYL

Test
    [Documentation]     Draft Test
    Check Create Page
    # Change Excel Sheet Name
    Get Excel Data - FACE STYL    STYL
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        Check Create Page
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        IF    "${st_item}" != "EMPTY"
            ${expected_title}    Catenate    ${sr_item}    ${st_item}    ${sc_item}
        ELSE
            ${expected_title}    Catenate    ${sr_item}   ${sc_item}
        END

        Change Division    Face Tribes (FACE)
        Select Sub-Division    ${subdiv_item}
        Select "${sc_item}" As Service Classification
        Select "${st_item}" As Service Type
        Select "${sr_item}" As Service Requirement
        Fill In Customer's Info [Division, Sub-division, Location]
        #    --- Description ---
        Input Text    ${DESCRIPTION}    Internal QA - FACE TECH ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item} ${\n}
        #    --- Priority ---
        Select Random Option For "Priority" Dropdown
        #    --- Attachment(s) ---
        Wait Until Element Is Enabled    ${ATTACHMENT}    30s
        Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
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