*** Settings ***
Documentation    Test Scripts for FACE REND - New Form
Resource         Resources/FACE_REND_Keywords.resource
Resource         Resources/FACE_REND_Templates.resource
Test Setup       Navigate To Site    ${LINK_CRM}    ${BROWSER}
Test Teardown    Quit Browser


*** Test Cases ***
# ST: Verify Form Fields Displayed Per Service Type
#     [Documentation]    Verification of form fields displayed per service type
#     ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=49af1bd1-534d-ee11-be6f-000d3aa148af
#     [Template]    ST: Verify Form Fields Displayed Per Service Type
#     Product Image Rendering
#     Product Rendering on Lifestyle Photo
#     Product Image Assets
#     VST Image Asset for Development

# ST: Verify Ticket Creation For FACE REND
#     [Documentation]    Verification of Ticket Creation, Ticket Viewer, and Ticket Summary for FACE REND
#     ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=49af1bd1-534d-ee11-be6f-000d3aa148af
#     Verify Ticket Creation For FACE REND

ST: Verify Case Ticket Details In CRM For FACE REND
    [Documentation]    Verification of one of the created FACE REND case in CRM
    ...    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=49af1bd1-534d-ee11-be6f-000d3aa148af
    Verify CRM Details Of FACE REND
