*** Settings ***
Documentation    Templates for FACE VIDE form page
Resource         FACE_VIDE_Keywords.resource


*** Keywords ***
ST: Verify Form Fields Displayed Per Service Classification
    [Documentation]    https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=entityrecord&etn=incident&id=22502065-524d-ee11-be6f-000d3a07e905
    [Arguments]    ${service_classification}
    Given The User Is On The Solution Tracker
    When The User Selects A Service Classification    ${service_classification}
    Then The Form Display Should Vary Depending On The Selected Service Classification    ${service_classification}
