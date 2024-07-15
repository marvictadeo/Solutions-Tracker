*** Settings ***
Documentation        Testing New forms for FACE INDU
Test Setup           Navigate To Site    http://10.224.57.5:8080/    chrome
# Test Setup           Navigate To Site    https://customer.musictribe.com/    chrome
Test Teardown        Quit Browser
Resource             ./FACE_INDU_Form_Keywords.resource


*** Test Cases ***
Verify Ticket Creation - FACE INDU
    [Documentation]    Verifies Solution Tracker tickets creation using the new form of FACE INDU
    Verify Ticket Creation Using Master Data - FACE INDU

Verify Ticket Creation With CRM Checking
    [Documentation]    Verifies Solution Tracker tickets creation using the new form of FACE INDU
    Verify Ticket Creation Using Master Data With CRM Checking - FACE INDU
