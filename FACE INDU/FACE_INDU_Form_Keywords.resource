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
Resource         FACE_INDU_Form_Variables.resource
Resource         Solution_Tracker_Portal_Keywords.resource


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

The User Clicks The "${element}"
    [Documentation]    Verify any clickable element before clicking it: buttons, icons, links, etc.
    Wait Until Page Contains Element    ${element}    30s
    TRY
        Click Element    ${element}
    EXCEPT
        Log    Catches any exception when clicking through an element.
    END

Clear Text Field
    [Documentation]    Keyword to clear the text field using Press Keys function. Can be used as a workaround if Clear Element Text is not working.
    [Arguments]  ${locator}
    SeleniumLibrary.Press Keys    ${locator}    CTRL+a+BACKSPACE

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
    Get Excel Data    ${SHEET_NAME}
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Set Variable    ${count}
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        Set Test Variable    ${SC_ITEM}

        Check Create Page
        Run Keyword And Continue On Failure    Complete FACE INDU Form    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        ${row}    Evaluate    ${count} + 2

        Run Keyword And Continue On Failure    Submit Ticket
        Update Excel With Case Number    ${row}    I
        IF    "${CASE_NUM}" != "Failed"    Run Keyword And Continue On Failure    Verify Ticket Summary Data
    END

Verify Ticket Creation Using Master Data With CRM Checking - FACE INDU
    [Documentation]    Creates and verifies tickets for FACE INDU with CRM Checking
    # ----------- Change Excel Sheet Name ----------- #
    Check Create Page
    Get Excel Data    ${SHEET_NAME}
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Set Variable    ${count}
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        Set Test Variable    ${SC_ITEM}

        Check Create Page
        Run Keyword And Continue On Failure    Complete FACE INDU Form    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        ${row}    Evaluate    ${count} + 2

        Run Keyword And Continue On Failure    Submit Ticket
        Update Excel With Case Number    ${row}    I
        IF    "${CASE_NUM}" != "Failed"
            Run Keyword And Continue On Failure    Verify Ticket Title In The "Ticket Viewer"    ${expected_title}
            Run Keyword And Continue On Failure    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
            # -------- CRM Checking --------#
            Run Keyword And Continue On Failure    Get ST Ticket Number In Ticket Summary
            Verify The Ticket In Solution Tracker Portal    ${URL_ALL_CASES_FACE}    ${CASE_NUM}
            # ----- Removed for now -------#
            # Verify The Automated Ticket Title     ${CASE_NUM}   ${sr_item}    ${st_item}    ${sc_item}
            Go Back And Switch To ST Form Page
        END
    END

Update Excel With Case Number
    [Documentation]    Appends the case number of the created ticket to the excel file.
    ...                If ticket creation failed, "Failed" will be appended
    [Arguments]    ${row}    ${column}
    Set Cell Value     ${row}    ${column}    ${CASE_NUM}
    Save Workbook

Get The Case Ticket Number In Ticket Viewer
    [Documentation]    Keyword to get the case ticket number in the ticket viewer details
    ${data_table_title}    Set Variable    //div[@class="datatable-body-cell-label"]/a[text()=" ${expected_title}"]
    Wait Until Page Contains Element    ${data_table_title}    120s
    ${data_table_title}    Get Variable Value    ${data_table_title}
    ${data_table_case}    Set Variable    ${data_table_title}/preceding::datatable-body-cell[3]/div/a
    ${case_num}    Get Text    ${data_table_case}
    Set Suite Variable    ${CASE_NUM}

Complete FACE INDU Form
    [Documentation]    Fills in the Solution Tracker form for FACE INDU
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Select Solution Tracker Division    ${INPUT_DIVISION}
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" Service Classification
    Select "${st_item}" Service Type
    Select "${sr_item}" Service Requirement
    Enter Requestor's Information
    Enter Generic Request Info    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Enter Service Classification-Specific Info

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
            Wait Until Element Is Enabled    ${DDL_ST}    15s
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
            Wait Until Element Is Enabled    ${DDL_SR}    15s
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
    Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE INDU ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
    Select Random Option From "Priority" Dropdown

Enter Service Classification-Specific Info
    [Documentation]    Fills in the Request Information unique to certain Service Classifications
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
    ELSE
        Select Random Model Code Option From Dropdown
    END
    Select Random Option From "Development Classification" Dropdown
    IF    "${SELECTED_DEV_CLASSIFICATION}" == "External OEM"    Choose File    ${IMG_PRODUCT_3D}     ${JPG_IMAGE_SAMPLE}

    Choose File    ${IMG_ROADMAP}        ${JPG_IMAGE_SAMPLE}
    Choose File    ${IMG_REQUIREMENT}    ${JPG_IMAGE_SAMPLE}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Select Random Model Code Option From Dropdown
    [Documentation]    Waits until the Model Code dropdown is enabled and loaded then randomly selects an option
    Scroll "${DDL_MODEL_CODE}" Into Center
    Wait Until Element Is Enabled    ${DDL_MODEL_CODE}
    Wait Until Element Is Visible    ${DDL_MODEL_CODE_OPTION}    ${MAX_TIMEOUT}
    ${model_code_items}    Get List Items    ${DDL_MODEL_CODE}
    Remove Values From List    ${model_code_items}    - - -
    ${selected_model_code}    Random Element    ${model_code_items}
    The User Clicks The "${DDL_MODEL_CODE}"
    Set Test Variable    ${DDL_SELECTED_MODEL_CODE}    ${DDL_MODEL_CODE}/option[text()='${SPACE}${selected_model_code}${SPACE}']
    Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_MODEL_CODE}

Fill Out ID/PDI Artwork Text Fields
    [Documentation]    Fills Out Text fields for ID/PDI Artwork Form
    Scroll "${TXT_BRAND_CATEGORY_LEAD}" Into Center
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    ${INPUT_BRAND_CATEGORY_LEAD}
    Input Text    ${TXT_SERIES_NAME}    ${INPUT_SERIES_NAME}
    Input Text    ${TXT_PRODUCT_FEATURE_LIST}    ${INPUT_PRODUCT_FEATURE_LIST}
    # Input Text    ${TXT_PRODUCT_3D}    ${INPUT_PRODUCT_3D}
    # Input Text    ${TXT_ROADMAP}    ${INPUT_ROADMAP}
    Input Text    ${TXT_DESIGN_REQUIREMENT}    ${INPUT_DESIGN_REQUIREMENT}
    Input Text    ${TXTA_COMPETITOR1}    ${INPUT_COMPETITOR1}
    Input Text    ${TXTA_COMPETITOR2}    ${INPUT_COMPETITOR2}
    Input Text    ${TXTA_COMPETITOR3}    ${INPUT_COMPETITOR3}

Fill Out Model Text Fields
    [Documentation]    Enters model code and model name
    Scroll "${TXT_MODEL_CODE}" Into Center
    Input Text    ${TXT_MODEL_CODE}    ${INPUT_MODEL_CODE}
    Input Text    ${TXT_MODEL_NAME}    ${INPUT_MODEL_NAME}

Fill Out Design Style Guide Form
    [Documentation]    Enters the details needed for Design Style Guide
    Fill Out Design Style Guide Text Fields
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Design Style Guide Text Fields
    [Documentation]    Fills Out Text fields for Design Style Guide Form
    Scroll "${TXT_BRAND_CATEGORY_LEAD}" Into Center
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    ${INPUT_BRAND_CATEGORY_LEAD}
    Input Text    ${TXT_SERIES_NAME}    ${INPUT_SERIES_NAME}
    Input Text    ${TXT_COMPETITOR1}    ${INPUT_COMPETITOR1}
    Input Text    ${TXT_COMPETITOR2}    ${INPUT_COMPETITOR2}
    Input Text    ${TXT_COMPETITOR3}    ${INPUT_COMPETITOR3}

Fill Out Competitive Analysis Form
    [Documentation]    Enters the details needed for Competitive Analysis
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    ${INPUT_BRAND_CATEGORY_LEAD}
    Input Text    ${TXT_SERIES_NAME}    ${INPUT_SERIES_NAME}
    Fill Out Model Text Fields
    Input Text    ${TXT_COMPETITOR1}    ${INPUT_COMPETITOR1}
    Input Text    ${TXT_COMPETITOR2}    ${INPUT_COMPETITOR2}
    Input Text    ${TXT_COMPETITOR3}    ${INPUT_COMPETITOR3}
    Input Text    ${TXT_PLM_PFI}        ${INPUT_PLM_PFI}
    Select Random Option From "Material Category L1" Dropdown
    Select Random Option From "Material Category L2" Dropdown
    Select Random Option From "Material Category L3" Dropdown
    Scroll "${CBX_ARTWORK_APPROVED}" Into Center
    Click Element    ${CBX_ARTWORK_APPROVED}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Artwork Release Form
    [Documentation]    Enters the details needed for Artwork Release
    Input Text    ${TXT_BRAND_CATEGORY_LEAD}    ${INPUT_BRAND_CATEGORY_LEAD}
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    ${INPUT_PERFORMANCE_PRODUCT_SPECIALIST}
    Select Random Model Code Option From Dropdown
    Select Random Option From "Development Classification" Dropdown
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Logo Design Form
    [Documentation]    Enters the details needed for Logo Design
    Select Random Model Code Option From Dropdown
    Input Text    ${TXT_LOGO_TEXT}    ${INPUT_LOGO_TEXT}
    Choose File   ${IMG_REFERENCES}    ${JPG_IMAGE_SAMPLE}
    Input Text    ${TXT_FILE_LINK}    ${INPUT_FILE_LINK}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Design Specification Form
    [Documentation]    Enters the details needed for Design Specification
    Select Random Model Code Option From Dropdown
    Select Random Option From "Development Classification" Dropdown
    Scroll "${TXT_PERFORMANCE_PRODUCT_SPECIALIST}" Into Center
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    ${INPUT_PERFORMANCE_PRODUCT_SPECIALIST}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Sample Color Evaluation Form
    [Documentation]    Enters the details needed for Sample Color Evaluation
    Select Random Model Code Option From Dropdown
    Input Text    ${TXT_PERFORMANCE_PRODUCT_SPECIALIST}    ${INPUT_PERFORMANCE_PRODUCT_SPECIALIST}
    Input Text    ${TXT_PANTONE_COLOR}    ${INPUT_PANTONE}
#    Scroll "${IMG_REQUIREMENT}" Into Center
    Choose File    ${IMG_REQUIREMENT}    ${JPG_IMAGE_SAMPLE}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

Fill Out Product Artwork Colors Form
    [Documentation]    Enters the details needed for Product Artwork Colors
    Select Random Model Code Option From Dropdown
    Choose File    ${IMG_IMAGE_REFERENCE}    ${JPG_IMAGE_SAMPLE}
    Set Test Variable    ${EXPECTED_TITLE}    ${SC_ITEM}

# End of fill out keywords

Select Solution Tracker Division
    [Documentation]    Selects the specified Division from the Solution Tracker Dropdown
    [Arguments]    ${division}
    Scroll And Click The Element    ${DDL_DIVISION}
    Wait Until Element Is Enabled    ${DDL_DIVISION}
    # Change to text()= once fixed
    Set Test Variable    ${DDL_SELECTED_DIV}    ${DDL_DIVISION}/option[contains(text(),'${SPACE}${division}${SPACE}')]
    Scroll And Click The Element    ${DDL_SELECTED_DIV}

Get Excel Data
    [Documentation]    Retrieves data from the excel file's specified sheet
    [Arguments]    ${sheet_name}
    Open Workbook       ${MASTER_DATA}
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    ${COL_SUB_DIVISION}
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    ${COL_SERVICE_CLASSIFICATION}
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    ${COL_SERVICE_TYPE}
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    ${COL_SERVICE_REQUIREMENT}
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
        Wait Until Page Contains Element    ${DDL_DIVISION}    60s
    END

Select SC VALUE
    [Documentation]    Selects Service Classification
    [Arguments]    ${sc_item}
    Sleep    5s
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
    Sleep    5s
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
    Sleep    5s
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
        The User Clicks The "${DDL_CUSTOMER_DIVISION}"
        Set Test Variable    ${DDL_SELECTED_DIV}    ${DDL_CUSTOMER_DIVISION}/option[contains(text(),'${selected_cust_div}')]
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_DIV}

        ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        Scroll "${DDL_CUSTOMER_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUSTOMER_SUB_DIVISION}    30s
        The User Clicks The "${DDL_CUSTOMER_SUB_DIVISION}"
        Set Test Variable    ${DDL_SELECTED_CUST_SUBDIV}    ${DDL_CUSTOMER_SUB_DIVISION}/option[contains(text(),'${selected_cust_subdiv}')]
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_CUST_SUBDIV}
    ELSE IF    "${field}" == "Customer Location"
        ${selected_location}    Random Element    ${LIST_LOCATION}
        Set Test Variable    ${SELECTED_LOCATION}
        Scroll "${DDL_CUSTOMER_LOCATION}" Into Center
        The User Clicks The "${DDL_CUSTOMER_LOCATION}"
        Set Test Variable    ${DDL_SELECTED_CUST_LOC}    ${DDL_CUSTOMER_LOCATION}/option[contains(text(),'${selected_location}')]
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_CUST_LOC}
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
        The User Clicks The "${DDL_DEVELOPMENT_CLASSIFICATION}"
        Set Test Variable    ${DDL_SELECTED_DEVELOPMENT_CLASSIFICATION}    ${DDL_DEVELOPMENT_CLASSIFICATION}/option[contains(text(),'${selected_dev_classification}')]
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_DEVELOPMENT_CLASSIFICATION}
        Set Test Variable    ${SELECTED_DEV_CLASSIFICATION}
    ELSE IF    "${field}" == "PDI Type"
        ${selected_pdi_type}    Random Element    ${LIST_PDI_TYPE}
        Scroll "${DDL_PDI_TYPE}" Into Center
        The User Clicks The "${DDL_PDI_TYPE}"
        Set Test Variable    ${DDL_SELECTED_PDI_TYPE}    ${DDL_PDI_TYPE}/option[contains(text(),'${selected_pdi_type}')]
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_PDI_TYPE}
        Set Test Variable    ${SELECTED_PDI_TYPE}
    ELSE IF    "${field}" == "Material Category L1"
        Scroll "${DDL_MATERIAL_CATEGORY_L1}" Into Center
        Wait Until Element Is Visible    ${DDL_MATERIAL_CATEGORY_L1_OPTION}    ${MAX_TIMEOUT}
        ${material_category_l1_items}    Get List Items    ${DDL_MATERIAL_CATEGORY_L1}
        Remove Values From List    ${material_category_l1_items}    - - -
        ${selected_material_l1}    Random Element    ${material_category_l1_items}
        The User Clicks The "${DDL_MATERIAL_CATEGORY_L1}"
        Set Test Variable    ${DDL_SELECTED_MATERIAL_CATEGORY_L1}    ${DDL_MATERIAL_CATEGORY_L1}/option[text()='${selected_material_l1}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_MATERIAL_CATEGORY_L1}
        Set Test Variable    ${SELECTED_MATERIAL_L1}
    ELSE IF    "${field}" == "Material Category L2"
        Scroll "${DDL_MATERIAL_CATEGORY_L2}" Into Center
        Wait Until Element Is Enabled    ${DDL_MATERIAL_CATEGORY_L2}    ${MAX_TIMEOUT}
        Wait Until Element Is Visible    ${DDL_MATERIAL_CATEGORY_L2_OPTION}    ${MAX_TIMEOUT}
        ${material_category_l2_items}    Get List Items    ${DDL_MATERIAL_CATEGORY_L2}
        Remove Values From List    ${material_category_l2_items}    - - -
        ${selected_material_l2}    Random Element    ${material_category_l2_items}
        The User Clicks The "${DDL_MATERIAL_CATEGORY_L2}"
        Set Test Variable    ${DDL_SELECTED_MATERIAL_CATEGORY_L2}    ${DDL_MATERIAL_CATEGORY_L2}/option[text()='${selected_material_l2}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_MATERIAL_CATEGORY_L2}
        Set Test Variable    ${SELECTED_MATERIAL_L2}
    ELSE IF    "${field}" == "Material Category L3"
        Scroll "${DDL_MATERIAL_CATEGORY_L3}" Into Center
        Wait Until Element Is Enabled    ${DDL_MATERIAL_CATEGORY_L3}    ${MAX_TIMEOUT}
        Wait Until Element Is Visible    ${DDL_MATERIAL_CATEGORY_L3_OPTION}    ${MAX_TIMEOUT}
        ${material_category_l3_items}    Get List Items    ${DDL_MATERIAL_CATEGORY_L3}
        Remove Values From List    ${material_category_l3_items}    - - -
        ${selected_material_l3}    Random Element    ${material_category_l3_items}
        The User Clicks The "${DDL_MATERIAL_CATEGORY_L3}"
        Set Test Variable    ${DDL_SELECTED_MATERIAL_CATEGORY_L3}    ${DDL_MATERIAL_CATEGORY_L3}/option[text()='${selected_material_l3}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_MATERIAL_CATEGORY_L3}
        Set Test Variable    ${SELECTED_MATERIAL_L3}
    END

# Add other fields here

Submit Ticket
    [Documentation]    Submits the ticket created
    ${stat}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[contains(text(),'Submit')]
    Retrieve All Entered Data In The Form
    IF    "${stat}" == "True"
        Click Element    //button[@class="btn btn-primary"]
        Wait Until Page Contains Element    //div[@class="datatable-body-cell-label"]    120s
        Get The Case Ticket Number In Ticket Viewer
    ELSE
        Set Test Variable    ${CASE_NUM}    Failed
        Capture Page Screenshot
        Fail    Submit Button is Disabled
    END

Retrieve All Entered Data In The Form
    [Documentation]    Get the information entered by the user in the form
    ${DICT_RETRIEVED_VALUES}    Create Dictionary
    FOR    ${field}    IN    @{LIST_INDU_ALL_FIELDS}
        IF    "${field}"=="Attachment"
            ${str_value}    Set Variable    Download
            Set To Dictionary    ${DICT_RETRIEVED_VALUES}    ${field}=${str_value}
        END
        IF    "${field}"=="Subject"
            ${str_value}    Set Variable    ${sc_item}
            Set To Dictionary    ${DICT_RETRIEVED_VALUES}    ${field}=${str_value}
        END
        ${field_exist}    Run Keyword And Return Status    Element Should Be Visible    ${DICT_FORM_FIELDS_LOCATORS}[${field}]
        IF    ${field_exist}==${False}
            Log    N/A
        ELSE
            TRY
                ${str_value}    Get Selected List Label   ${DICT_FORM_FIELDS_LOCATORS}[${field}]
            EXCEPT
                ${str_value}    Get Value   ${DICT_FORM_FIELDS_LOCATORS}[${field}]
            END
            Set To Dictionary    ${DICT_RETRIEVED_VALUES}    ${field}=${str_value}
        END
    END
    Set Suite Variable    ${DICT_RETRIEVED_VALUES}

Verify Ticket Summary Data
    [Documentation]    Verifies the ticket created on the Ticket Summary screen
    Wait Until Element Is Visible    ${DATA_TABLE}    120s
    Click Element    ${DATA_TABLE}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    FOR    ${field}    IN    @{LIST_INDU_ALL_FIELDS}
        ${field_exist}    Run Keyword And Return Status    Element Should Be Visible    ${DETAIL_${field}}
        IF    ${field_exist}==${False}
            Log    N/A
        ELSE
            ${actual_value}    Get Text    ${DETAIL_${field}}
            Run Keyword And Continue On Failure    Should Be Equal As Strings     ${DICT_RETRIEVED_VALUES}[${field}]    ${actual_value}
        END
    END

# ---- CRM Checking ----#

Open Link In New Tab
    [Documentation]    Opens the Link In New Tab
    [Arguments]    ${link}
    ${valid_link}    Run Keyword And Return Status    Should Contain    ${link}    http
    IF    ${valid_link}
        Execute Javascript   window.open('${link}');
    ELSE
        Execute Javascript   window.open('https://${link}');
    END
    Switch Window    NEW

Verify Ticket Summary
    [Documentation]    Verify Ticket Summary
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Click Element    ${DATA_TABLE}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    ${SD_RESULT}    Set Variable    //span[contains(text(),'Sub-Division:')]//following-sibling::strong[contains(text(),"${subdiv_item.strip()}")]
    Run Keyword And Continue On Failure    Page Should Contain Element    ${SD_RESULT}
    ${SC_RESULT}    Set Variable    //span[contains(text(),'Service Classification:')]//following-sibling::strong[contains(text(),"${sc_item.strip()}")]
    Run Keyword And Continue On Failure    Page Should Contain Element    ${SC_RESULT}
    IF    "${st_item}" != "EMPTY"
        ${ST_RESULT}    Set Variable    //span[contains(text(),'Service Type:')]//following-sibling::strong[contains(text(),"${st_item.strip()}")]
        Run Keyword And Continue On Failure    Page Should Contain Element    ${ST_RESULT}
    END
    IF    "${sr_item}" != "EMPTY"
        ${SR_RESULT}    Set Variable    //span[contains(text(),'Service Requirement:')]//following-sibling::strong[contains(text(),"${sr_item.strip()}")]
        Run Keyword And Continue On Failure    Page Should Contain Element    ${SR_RESULT}
    END

Verify Ticket Title In The "${page}"
    [Documentation]    Verify Ticket Title/Subject
    [Arguments]    ${expected_title}
    IF    "${page}" == "Ticket Details"
        Wait Until Element Is Visible    //div[@class='ticket-details__header']
        Element Should Be Visible    //div[@class='ticket-details__header']/p[contains(text(),'${expected_title}')]
    ELSE
        ${ticket_title}    Set Variable
        ...    //div[@class="datatable-body-cell-label"]/a[text()=" ${expected_title}"]
        Wait Until Element Is Visible    //div[@class="datatable-tickets"]    120s
        Element Should Be Visible    ${ticket_title}
    END

Get ST Ticket Number In Ticket Summary
    [Documentation]    Get The Ticket Number
    Wait Until Element Is Visible    //div[@class='ticket-details__header']/h4
    ${case_number}    Get Text    //div[@class='ticket-details__header']/h4
    ${case_num}    Remove String    ${case_number}    Ticket Number:${SPACE}
    Set Suite Variable    ${CASE_NUM}
