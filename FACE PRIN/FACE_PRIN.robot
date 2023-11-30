*** Settings ***
Documentation    Test Scripts for FACE PRIN - New Form
Resource         Resources/FACE_PRIN_Keywords.resource
Resource         Resources/FACE_PRIN_Templates.resource
Test Setup       Navigate To Site    ${LINK_CRM}    ${BROWSER}
Test Teardown    Quit Browser


*** Test Cases ***
ST: Verify Form Fields Displayed Per Service Type (Documents)
    [Documentation]    Verification of form fields displayed per service classification
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    [Template]    ST: Verify Form Fields Displayed Per Service Type (Documents)
    # PDI 0
    # PDI 1
    # PDI 2
    # PLD
    QSG
    Manual
    Data Sheet
    Release Notes
    Service Bulletin
    # Service Support Document
    # Battle Card

ST: Verify Form Fields Displayed Per Service Type (Packaging)
    [Documentation]    Verification of form fields displayed per service classification
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    [Template]    ST: Verify Form Fields Displayed Per Service Type (Packaging)
    # GIBO
    # MACA
    GIBO and MACA
    # Label

ST: Verify Ticket Creation For FACE PRIN
    [Documentation]    Verification of Ticket Creation, Ticket Viewer, and Ticket Summary for FACE PRIN
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    Verify Ticket Creation For FACE PRIN

ST: Verify Case Ticket Summary In CRM For FACE PRIN
    [Documentation]    Verification of one of the created FACE PRIN case in CRM
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    Verify Case Ticket Summary In CRM For FACE PRIN
