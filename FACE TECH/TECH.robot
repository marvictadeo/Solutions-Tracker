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
Verify Master Data, Ticket Submission And Ticket Summary : FACE TECH
    [Documentation]    Test Case to Verify FACE TECH Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    Verify Master Data, Ticket Submission And Ticket Summary : FACE TECH

Verify Ticket Creation With CRM Checking : FACE TECH
    [Documentation]    Test Case to Verify FACE TECH Form Master Data
    ...    Ticket Submission
    ...    Ticket Summary
    ...    Created Ticket In The Solution Ticket Portal
    ...    Automated Ticket Title
    Verify Master Data And Ticket Submission With CRM Checking : FACE TECH

Verify TECH DATA AND FIELD VALIDATION : FACE TECH
    [Documentation]    Test Case to Verify FACE TECH Form Master Data
    Verify Master Data And Field Validation : FACE TECH
