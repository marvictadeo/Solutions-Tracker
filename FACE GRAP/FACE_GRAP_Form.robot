*** Settings ***
Documentation        Testing New forms for FACE GRAP
Test Setup           Navigate To Site    http://10.224.57.5:8080/    chrome
# Test Setup           Navigate To Site    https://customer.musictribe.com/    chrome
Test Teardown        Quit Browser
Resource             ./FACE_GRAP_Form_Keywords.resource


*** Test Cases ***
Verify Ticket Creation - FACE GRAP
    [Documentation]    Verifies Solution Tracker tickets creation using the new form of FACE GRAP
    Verify Ticket Creation Using Master Data - FACE GRAP

Verify Ticket Creation With CRM Checking
    [Documentation]    Verifies Solution Tracker tickets creation using the new form of FACE GRAP
    Verify Ticket Creation Using Master Data With CRM Checking - FACE GRAP
