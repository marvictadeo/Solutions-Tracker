*** Settings ***
Documentation    Templates for FACE REND form page
Resource         FACE_REND_Keywords.resource


*** Keywords ***
ST: Verify Form Fields Displayed Per Service Type
    [Documentation]    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=49af1bd1-534d-ee11-be6f-000d3aa148af
    [Arguments]    ${service_type}
    Given The User Is On The Solution Tracker
    When The User Selects A Service Type    ${service_type}
    Then The Form Display Should Vary Depending On The Selected Service Type   ${service_type}
