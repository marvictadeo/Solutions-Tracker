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
Resource             UX_Form_Keywords.resource
Resource             Solution_Tracker_Portal_Keywords.resource


*** Test Cases ***
Verify FACE UXUI New Form
    [Documentation]    Test Case to Verify FACE UXUI Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    Verify Ticket Submission And Correctness Of Data : FACE UXUI

#Verify Ticket Creation With CRM Checking : FACE UX
#    [Documentation]    Test Case to Verify FACE UX Form Master Data
#    ...    Ticket Submission
#    ...    Ticket Summary
#    ...    Created Ticket In The Solution Ticket Portal
#    ...    Automated Ticket Title
#    Verify Master Data And Ticket Submission With CRM Checking : FACE UX

#Verify UX DATA AND FIELD VALIDATION : FACE UX
#    [Documentation]    Test Case to Verify FACE UX Form Master Data
#   Verify Master Data And Field Validation : FACE UX
