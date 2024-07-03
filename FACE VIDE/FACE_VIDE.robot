*** Settings ***
Documentation    Test Scripts for FACE VIDE - New Form
Resource         Resources/FACE_VIDE_Keywords.resource
Resource         Resources/FACE_VIDE_Templates.resource
Test Setup       Navigate To Site    ${LINK_CRM}    ${BROWSER}
Test Teardown    Quit Browser


*** Test Cases ***
# ST: Verify Form Fields Displayed Per Service Classification
#     [Documentation]    Verification of form fields displayed per service classification
#     ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=22502065-524d-ee11-be6f-000d3a07e905
#     [Template]    ST: Verify Form Fields Displayed Per Service Classification
#     Products
#     Non Products
#     Graphics
#     Employee Banners

# ST: Verify Ticket Creation For FACE VIDE
#     [Documentation]    Verification of Ticket Creation, Ticket Viewer, and Ticket Summary for FACE VIDE
#     ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=22502065-524d-ee11-be6f-000d3a07e905
#     Verify Ticket Creation For FACE VIDE

ST: Verify Case Ticket Summary In CRM For FACE VIDE
    [Documentation]    Verification of one of the created FACE VIDE case in CRM
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=22502065-524d-ee11-be6f-000d3a07e905
    Verify CRM Details Of FACE VIDE
