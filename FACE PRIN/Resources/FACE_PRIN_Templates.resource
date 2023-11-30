*** Settings ***
Documentation    Templates for FACE PRIN form page
Resource         FACE_PRIN_Keywords.resource


*** Keywords ***
ST: Verify Form Fields Displayed Per Service Type (Documents)
    [Documentation]    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    [Arguments]    ${service_type}
    Given The User Is On The Solution Tracker
    When The User Selects A Service Type (Documents)    ${service_type}
    Then The Form Display Should Vary Depending On The Selected Service Type    ${service_type}

ST: Verify Form Fields Displayed Per Service Type (Packaging)
    [Documentation]    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=ee649073-554d-ee11-be6f-000d3aa14877
    [Arguments]    ${service_type}
    Given The User Is On The Solution Tracker
    When The User Selects A Service Type (Packaging)    ${service_type}
    Then The Form Display Should Vary Depending On The Selected Service Type    ${service_type}
