*** Settings ***
Documentation    Keywords for FACE INDU Form
Library          Collections
Library          String
Library          DateTime
Library          Dialogs
Library          SeleniumLibrary
Library          FakerLibrary
Library          RPA.Tables
Library          RPA.Excel.Files
Resource         ./FACE_INDU_Form_Variables.resource


*** Keywords ***
# Global Keywords
Navigate To Site
    [Documentation]    The user opens a browser and navigates to the site.
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window

Select A Worksheet
    [Documentation]    Keyword to open an excel file and select an active Worksheet
    [Arguments]    ${sheet_name}
    ${table}   Read Worksheet As Table    ${sheet_name}   header=True
    RETURN    ${table}

Quit Browser
    [Documentation]    Closes browser after delay
    Sleep    0.5s
    Close All Browsers

Scroll And Click The Element
    [Documentation]    Keyword to scroll and click on the element.
    ...    To avoid errors such as MoveTargetOutOfBoundsException and ElementClickInterceptedException which is caused by the heavy load of images, the action was put inside the try/except.
    [Arguments]    ${element}
    TRY
        Scroll Element Into View    ${element}
    EXCEPT
        Log    Catches any exception when scrolling through an element.
    END
    Wait Until Element Is Visible    ${element}    30s
    TRY
        The User Clicks The "${element}"
    EXCEPT
        Log    Catches any exception when clicking through an element.
    END

# ==========================================================================================#
# ---------------------- KEYWORDS THAT USE JAVASCRIPTS (JS) - START ----------------------- #
# ==========================================================================================#

Click "${element}" Using Javascript
    [Documentation]    JS Click if an element is not clickable or interactable.
    Execute Javascript    document.evaluate('${element}',document.body,null,9,null).singleNodeValue.click()

Scroll "${element}" Into Center
    [Documentation]    Scroll the Element into Center View
    Wait Until Element Is Visible    ${element}    30s
    ${locator}    Get WebElement    ${element}
    Execute Javascript    arguments[0].scrollIntoView({block: "center"});    ARGUMENTS    ${locator}

# ==========================================================================================#
# ---------------------- KEYWORDS THAT USE JAVASCRIPTS (JS) - END ------------------------- #
# ==========================================================================================#

# End of GLobal Keywords

Verify Ticket Creation Using Master Data - FACE INDU
    [Documentation]    Creates and verifies tickets for FACE INDU
    # ----------- Change Excel Sheet Name ----------- #
    Check Create Page
    Get Excel Data    INDU
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}

        Check Create Page
        Run Keyword And Continue On Failure    Complete FACE INDU Form    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        Pause Execution
        # Run Keyword And Continue On Failure    Submit Ticket
        # Run Keyword And Continue On Failure    Verify Ticket Summary      ${subdiv_item}    ${sc_item}    ${sr_item}
    END

Complete FACE INDU Form
    [Documentation]    Fills in the Solution Tracker form for FACE INDU
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Select Solution Tracker Division    Face Tribes (FACE)
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" Service Classification
    Select "${st_item}" Service Type
    Select "${sr_item}" Service Requirement
    Enter Requestor's Information
    Enter Generic Request Info    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Enter Service Classification-Specific Info    ${sc_item}

Select Sub-Division
    [Documentation]    Selects the specified Sub-Division
    [Arguments]    ${subdiv_item}
    Set Test Variable    ${SUBDIV_VALUE}    ${DDL_SUBDIVISION}\[text()="${SPACE}${subdiv_item}${SPACE}"]
    Wait Until Element Is Enabled    ${DDL_SUBDIVISION}    30s
    Select From List By Label    ${DDL_SUBDIVISION}    ${subdiv_item}

Select "${sc_item}" Service Classification
    [Documentation]    Selects the specified Service Classification
    ${stat}    Run Keyword And Return Status    Click Element    ${SC_VALUE}
    IF    "${stat}" == "False"
        Set Test Variable    ${SC_VALUE}    ${DDL_SC}\[contains(text(),"${SPACE}${sc_item}${SPACE}${SPACE}")]
        Wait Until Element Is Enabled    ${DDL_SC}
        Run Keyword And Continue On Failure    Select SC VALUE    ${sc_item}
    END

Select "${st_item}" Service Type
    [Documentation]    Selects the specified Service Type
    IF    "${st_item}" != "EMPTY"
        Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[contains(text(),"${SPACE}${st_item}${SPACE}${SPACE}")]
        ${stat}    Run Keyword And Return Status    Click Element    ${ST_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[contains(text(),"${SPACE}${st_item}${SPACE}${SPACE}")]
            Wait Until Element Is Enabled    ${DDL_ST}
            Run Keyword And Continue On Failure    Select ST VALUE    ${st_item}
        END
    END

Select "${sr_item}" Service Requirement
    [Documentation]    Selects the specified Service Requirement
    IF    "${sr_item}" != "EMPTY"
        Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[contains(text(),"${SPACE}${sr_item}${SPACE}${SPACE}")]
        ${stat}    Run Keyword And Return Status    Click Element    ${SR_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[contains(text(),"${SPACE}${sr_item}${SPACE}${SPACE}")]
            Wait Until Element Is Enabled    ${DDL_SR}
            Run Keyword And Continue On Failure    Select SR VALUE    ${sr_item}
        END
    END

Enter Requestor's Information
    [Documentation]    Fills in Requestor's Information
    Input Text    ${TXT_REQUESTOR_NAME}    [QA Test] FACE INDU Form Testing
    Select Random Option From "Customer Division And Sub-Division" Dropdown
    Select Random Option From "Customer Location" Dropdown

 ############## Might need to edit result format ##########

Enter Generic Request Info
    [Documentation]    Fills in the Request Information: Description, Priority
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Select Random Option From "Brand" Dropdown
    Input Text    ${TXT_SUBJECT}    Internal QA Test INDU
    Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE INDU ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
    Select Random Option From "Priority" Dropdown

Enter Service Classification-Specific Info
    [Documentation]    Fills in the Request Information unique to certain Service Classifications
    [Arguments]    ${sc_item}
    IF    "${sc_item}" == "ID/PDI Artwork"
        Fill Out ID/PDI Artwork Form
    ELSE IF    "${sc_item}" == "Design Style Guide"
        Fill Out Design Style Guide Form
    ELSE IF    "${sc_item}" == "Competitive Analysis"
        Fill Out Competitive Analysis Form
    ELSE IF    "${sc_item}" == "Artwork Release"
        Fill Out Artwork Release Form
    ELSE IF    "${sc_item}" == "Logo Design"
        Fill Out Logo Design Form
    ELSE IF    "${sc_item}" == "Design Specification"
        Fill Out Design Specification Form
    ELSE IF    "${sc_item}" == "Sample Color Evaluation"
        Fill Out Sample Color Evaluation Form
    ELSE IF    "${sc_item}" == "Product Artwork Colors"
        Fill Out Product Artwork Colors Form
    END

Fill Out ID/PDI Artwork Form
    [Documentation]    Enters the details needed for ID/PDI Artwork
    Select Random Option From "PDI Type" Dropdown
    Fill Out ID/PDI Artwork Text Fields
    IF    "${SELECTED_PDI_TYPE}" == "PDI 0"
        Fill Out Model Text Fields
        Select Random Option From "Material Category L1" Dropdown
        Select Random Option From "Material Category L2" Dropdown
        Select Random Option From "Material Category L3" Dropdown
    END
    Select Random Option From "Development Classification" Dropdown
    Choose File    ${IMG_PRODUCT_3D}     ${JPG_IMAGE_SAMPLE}
    Choose File    ${IMG_ROADMAP}        ${JPG_IMAGE_SAMPLE}
    Choose File    ${IMG_REQUIREMENT}    ${JPG_IMAGE_SAMPLE}

Fill Out ID/PDI Artwork Text Fields
    [Documentation]    Fills Out Text fields for ID/PDI Artwork Form
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Input Text    ${TXT_PRODUCT_FEATURE_LIST}    Sample features
    Input Text    ${TXT_PRODUCT_3D}    Sample 3D Link
    Input Text    ${TXT_ROADMAP}    Sample Roadmap
    Input Text    ${TXT_DESIGN_REQUIREMENT}    Sample Requirement and Parameters
    Input Text    ${TXT_COMPETITOR1}    Sample Competitor 1
    Input Text    ${TXT_COMPETITOR2}    Sample Competitor 2
    Input Text    ${TXT_COMPETITOR3}    Sample Competitor 3

Fill Out Model Text Fields
    [Documentation]    Enters model code and model name
    Input Text    ${TXT_MODEL_CODE}    Sample Model Code
    Input Text    ${TXT_MODEL_NAME}    Sample Model Name

Fill Out Design Style Guide Form
    [Documentation]    Enters the details needed for Design Style Guide
    Fill Out Design Style Guide Text Fields
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown
    Select Checkbox    ${CBX_ARTWORK_APPROVED}

Fill Out Design Style Guide Text Fields
    [Documentation]    Fills Out Text fields for Design Style Guide Form
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Input Text    ${TXT_COMPETITOR1}    Sample Competitor 1
    Input Text    ${TXT_COMPETITOR2}    Sample Competitor 2
    Input Text    ${TXT_COMPETITOR3}    Sample Competitor 3
    Input Text    ${TXT_PLM_PFI}        Sample PLM/PFI

Fill Out Competitive Analysis Form
    [Documentation]    Enters the details needed for Competitive Analysis
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Input Text    ${TXT_COMPETITOR1}    Sample Competitor 1
    Input Text    ${TXT_COMPETITOR2}    Sample Competitor 2
    Input Text    ${TXT_COMPETITOR3}    Sample Competitor 3
    Input Text    ${TXT_PLM_PFI}        Sample PLM/PFI
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown

Fill Out Artwork Release Form
    [Documentation]    Enters the details needed for Artwork Release
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    Sample Leader
    Select Random Option From "Development Classification" Dropdown
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown

Fill Out Logo Design Form
    [Documentation]    Enters the details needed for Logo Design
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Input Text    ${TXT_LOGO_TEXT}    Sample Logo Text
    Choose File   ${IMG_REFERENCE}    ${JPG_IMAGE_SAMPLE}
    Input Text    ${TXT_FILE_LINK}    https://file-examples.com/index.php/sample-images-download/sample-jpg-download/
    Input Text    ${TXT_PANTONE_COLOR}    15-3920
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown

Fill Out Design Specification Form
    [Documentation]    Enters the details needed for Design Specification
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Select Random Option From "Development Classification" Dropdown
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    Sample Leader
    Input Text    ${TXT_PANTONE_COLOR}    15-3920
    Choose File    ${IMG_REFERENCE}    ${JPG_IMAGE_SAMPLE}

Fill Out Sample Color Evaluation Form
    [Documentation]    Enters the details needed for Sample Color Evaluation
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    Sample Leader
    Choose File    ${IMG_REQUIREMENT}    ${JPG_IMAGE_SAMPLE}

Fill Out Product Artwork Colors Form
    [Documentation]    Enters the details needed for Product Artwork Colors
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    Internal QA Test
    Input Text    ${TXT_SERIES_NAME}    New Series Test
    Fill Out Model Text Fields
    Choose File    ${IMG_REFERENCE}    ${JPG_IMAGE_SAMPLE}

# End of fill out keywords

Select Solution Tracker Division
    [Documentation]    Selects the specified Division from the Solution Tracker Dropdown
    [Arguments]    ${division}
    Scroll Element Into View    ${DDL_DIVISION}
    Wait Until Element Is Enabled    ${DDL_DIVISION}
    Select From List By Label    ${DDL_DIVISION}    ${division}

Get Excel Data
    [Documentation]    Retrieves data from the excel file's specified sheet
    [Arguments]    ${sheet_name}
    Open Workbook       ${MASTER_DATA}    read_only=True
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    Sub-Division
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    Service Classification
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    Service Type
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    Service Requirement
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}

Check Create Page
    [Documentation]    Verifies if the Ticket Creation page has loaded
    ${stat}    Run Keyword And Return Status    Page Should Contain Element    ${DDL_DIVISION}
    IF    "${stat}" == "False"
        Click Element    //img[@class="header__logo-img"]
        Wait Until Page Contains Element    ${BTN_CREATE}
        Click Element    ${BTN_CREATE}
        Wait Until Page Contains Element    ${DDL_DIVISION}    240s
    END

Select SC VALUE
    [Documentation]    Selects Service Classification
    [Arguments]    ${sc_item}
    TRY
        Wait Until Element Is Visible    ${DDL_SC}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SC}    ${sc_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_SC}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SC}    ${sc_item}
    END

Select ST VALUE
    [Documentation]    Selects Service Type
    [Arguments]    ${st_item}
    TRY
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_ST}    ${st_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_ST}    ${st_item}
    END

Select SR VALUE
    [Documentation]    Selects Service Requirement
    [Arguments]    ${sr_item}
    TRY
        Wait Until Element Is Visible    ${DDL_SR}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SR}    ${sr_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_SR}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SR}    ${sr_item}
    END

Select Random Option From "${field}" Dropdown
    [Documentation]    Selects a random option for the specified field
    IF    "${field}" == "Customer Division And Sub-Division"
        ${selected_cust_div}    Random Element    ${LIST_FACE_DIVISION}
        Scroll "${DDL_CUSTOMER_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUSTOMER_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_CUSTOMER_DIVISION}    ${selected_cust_div}
        ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        Scroll "${DDL_CUSTOMER_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUSTOMER_SUB_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_CUSTOMER_SUB_DIVISION}    ${selected_cust_subdiv}
    ELSE IF    "${field}" == "Customer Location"
        ${selected_location}    Random Element    ${LIST_LOCATION}
        Scroll "${DDL_CUSTOMER_LOCATION}" Into Center
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_CUSTOMER_LOCATION}    ${selected_location}
    ELSE IF    "${field}" == "Priority"
        ${selected_priority}    Random Element    ${LIST_PRIORITY}
        Scroll "${DDL_PRIORITY}" Into Center
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_PRIORITY}    ${selected_priority}
    ELSE IF    "${field}" == "Brand"
        ${selected_brand}    Random Element    ${LIST_BRANDS}
        Scroll "${DDL_BRAND}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_BRAND}    ${selected_brand}
    ELSE IF    "${field}" == "Development Classification"
        ${selected_dev_classification}    Random Element    ${LIST_DEVELOPMENT_CLASSIFICATION}
        Scroll "${DDL_DEVELOPMENT_CLASSIFICATION}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_DEVELOPMENT_CLASSIFICATION}    ${selected_dev_classification}
    ELSE IF    "${field}" == "PDI Type"
        ${selected_pdi_type}    Random Element    ${LIST_PDI_TYPE}
        Scroll "${DDL_PDI_TYPE}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_PDI_TYPE}    ${selected_pdi_type}
        Set Test Variable    ${SELECTED_PDI_TYPE}
    ELSE IF    "${field}" == "Material Category L1"
        ${selected_material_l1}    Random Element    ${LIST_MATERIAL_CATEGORY_L1}
        Scroll "${DDL_MATERIAL_CATEGORY_L1}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_MATERIAL_CATEGORY_L1}    ${selected_material_l1}
        Set Test Variable    ${SELECTED_MATERIAL_L1}
    ELSE IF    "${field}" == "Material Category L2"
        ${selected_material_l2}    Random Element    ${LIST_${SELECTED_MATERIAL_L1}_MATERIAL_CATEGORY_L2}
        Scroll "${DDL_MATERIAL_CATEGORY_L2}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_MATERIAL_CATEGORY_L2}    ${selected_material_l2}
        Set Test Variable    ${SELECTED_MATERIAL_L2}
    ELSE IF    "${field}" == "Material Category L2"
        ${selected_material_l2}    Random Element    ${LIST_${SELECTED_MATERIAL_L1}_MATERIAL_CATEGORY_L3}
        Scroll "${DDL_MATERIAL_CATEGORY_L2}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_MATERIAL_CATEGORY_L2}    ${selected_material_l2}
        Set Test Variable    ${SELECTED_MATERIAL_L2}
    END

# Add other fields here

Submit Ticket
    [Documentation]    Submits the ticket created
    ${stat}    Run Keyword And Return Status    Element Should Be Enabled    //button[@class="btn btn-primary"]
    IF    "${stat}" == "True"
        Click Element    //button[@class="btn btn-primary"]
        Wait Until Page Contains Element    ${DATA_TABLE}    120s
    END

Verify Ticket Summary
    [Documentation]    Verifies the ticket created on the Ticket Summary screen
    [Arguments]     ${subdiv_item}    ${sc_item}    ${sr_item}
    Click Element    ${DATA_TABLE}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    ${SD_RESULT}    Set Variable    //span[contains(text(),'Sub-Division:')]//following-sibling::strong[contains(text(),"${subdiv_item.strip()}")]
    Run Keyword And Continue On Failure    Page Should Contain Element    ${SD_RESULT}
    ${SC_RESULT}    Set Variable    //span[contains(text(),'Service Classification:')]//following-sibling::strong[contains(text(),"${sc_item.strip()}")]
    Run Keyword And Continue On Failure    Page Should Contain Element    ${SC_RESULT}
    IF    "${sr_item}" != "EMPTY"
            ${SR_RESULT}    Set Variable    //span[contains(text(),'Service Requirement:')]//following-sibling::strong[contains(text(),"${sr_item.strip()}")]
            Run Keyword And Continue On Failure    Page Should Contain Element    ${SR_RESULT}
    END
