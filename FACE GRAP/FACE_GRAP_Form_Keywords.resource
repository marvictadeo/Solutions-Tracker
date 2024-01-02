*** Settings ***
Documentation    Keywords for FACE GRAP Form
Library          Collections
Library          String
Library          DateTime
Library          Dialogs
Library          SeleniumLibrary
Library          FakerLibrary
Library          RPA.Tables
Library          RPA.Excel.Files
Resource         ./FACE_GRAP_Form_Variables.resource


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

Verify Ticket Creation Using Master Data - FACE GRAP
    [Documentation]    Creates and verifies tickets for FACE GRAP
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
        Run Keyword And Continue On Failure    Complete FACE GRAP Form    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        Run Keyword And Continue On Failure    Submit Ticket
        ${row}    Evaluate    ${count} + 2
        Update Excel With Case Number    ${row}    I
        IF    "${CASE_NUM}" == "Failed"
            Go To    http://10.224.57.5:8080/
        ELSE
            Scroll "${BTN_CREATE_A_TICKET}" Into Center
            Click Element    ${BTN_CREATE_A_TICKET}
        END
        # Run Keyword And Continue On Failure    Verify Ticket Summary      ${subdiv_item}    ${sc_item}    ${sr_item}
    END

Update Excel With Case Number
    [Documentation]    Appends the case number of the created ticket to the excel file.
    ...                If ticket creation failed, "Failed" will be appended
    [Arguments]    ${row}    ${column}
    ${case_num}    Get The Case Ticket Number In Ticket Viewer
    Set Cell Value     ${row}    ${column}    ${case_num}
    Save Workbook

Get The Case Ticket Number In Ticket Viewer
    [Documentation]    Keyword to get the case ticket number in the ticket viewer details
    ${data_table_title}    Set Variable    //div[@class="datatable-body-cell-label"]/a[text()=" ${expected_title}"]
    ${stat}    Run Keyword And Return Status    Wait Until Page Contains Element    ${data_table_title}    120s
    IF    "${stat}" == "False"
        Set Test Variable    ${CASE_NUM}    Failed
        Capture Page Screenshot
    ELSE
       ${data_table_case}    Set Variable    ${data_table_title}/preceding::datatable-body-cell[3]/div/a
       ${case_num}    Get Text    ${data_table_case}
       Set Test Variable    ${CASE_NUM}
    END
    RETURN    ${CASE_NUM}

Complete FACE GRAP Form
    [Documentation]    Fills in the Solution Tracker form for FACE GRAP
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Select Solution Tracker Division        ${INPUT_DIVISION}
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" Service Classification
    Select "${st_item}" Service Type
    Select "${sr_item}" Service Requirement
    Enter Requestor's Information
    Select Random Option From "Priority" Dropdown
    Enter Service Type-Specific Info    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}

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
    Select Random Option From "Customer Division And Sub-Division" Dropdown
    Select Random Option From "Customer Location" Dropdown

Enter Service Type-Specific Info
    [Documentation]    Fills in the Request Information unique to certain Service Classifications
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    IF    "${sc_item}" == "Web and Social Media Asset Design"
        Select Random Option From "Brand" Dropdown
        IF    "${st_item}" == "Product Launch Asset"
            Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE GRAP ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
            Fill Out Product Launch Asset Form
        ELSE IF    "${st_item}" == "Banner Asset Design"
            Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE GRAP ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
            Fill Out Banner Asset Design Form
        ELSE IF    "${st_item}" == "Newsletter"
            Fill Out Newsletter Form
        END
    ELSE IF    "${sc_item}" == "Graphics Design"
        Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE GRAP ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
        Fill Out Graphics Design Form
    ELSE IF    "${sc_item}" == "3D Architectural Design"
        Input Text    ${TXT_DESCRIPTION}    [QA Test] FACE GRAP ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
        IF    "${st_item}" == "Office Design" or "${st_item}" == "Booth Design"
            Fill Out Office/Booth Design Form
        ELSE IF    "${st_item}" == "Signage" or "${st_item}" == "Wall Graphics"
            Fill Out Signage/Wall Graphics Form
        END
    END

Select Asset Format
    [Documentation]    Selects a random asset format for the form
    ${selected_asset_format}    Random Elements    ${LIST_ASSET_FORMATS}
    FOR    ${format}    IN    @{selected_asset_format}
        Input Text    ${TXT_ASSET_FORMATS}    ${format}
        Press Keys    ${TXT_ASSET_FORMATS}    ENTER
    END
    Press Keys    ${TXT_ASSET_FORMATS}    ESC

Fill Out Product Launch Asset Form
    [Documentation]    Enters the details needed for Product Launch Asset
    Choose File    ${IMG_SPECIFIC_IMAGE}    ${JPG_IMAGE_SAMPLE}
    Input Text    ${TXT_HEADLINE}    ${INPUT_HEADLINE}
    Input Text    ${TXT_SUB_HEADLINE}    ${INPUT_SUB_HEADLINE}
    Select Product Details
    Select Asset Format
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_PUBLIC_LAUNCH}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${sc_item}

Fill Out Banner Asset Design Form
    [Documentation]    Enters the details needed for Banner Asset Design
    Choose File    ${IMG_SPECIFIC_IMAGE}    ${JPG_IMAGE_SAMPLE}
    Input Text    ${TXT_HEADLINE}    ${INPUT_HEADLINE}
    Input Text    ${TXT_SUB_HEADLINE}    ${INPUT_SUB_HEADLINE}
    Select Asset Format
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_PUBLIC_LAUNCH}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${sc_item}

Select Product Details
    [Documentation]    Fills up the Product Details Section for Product Launch Asset
    @{product_category_items}    Get List Items    ${DDL_PRODUCT_CATEGORY}
    Remove Values From List    ${product_category_items}    - - -
    ${selected_product_category}    Random Element    ${product_category_items}
    The User Clicks The "${DDL_PRODUCT_CATEGORY}"
    Set Test Variable    ${DDL_SELECTED_CATEGORY}    ${DDL_PRODUCT_CATEGORY}/option[text()='${SPACE}${selected_product_category}${SPACE}']
    Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_CATEGORY}
    Wait Until Element Is Visible    ${DDL_MODEL_CODE_OPTION}    ${MAX_TIMEOUT}
    ${model_code_items}    Get List Items    ${DDL_MODEL_CODE}
    Remove Values From List    ${model_code_items}    - - -
    ${selected_model_code}    Random Element    ${model_code_items}
    The User Clicks The "${DDL_MODEL_CODE}"
    Set Test Variable    ${DDL_SELECTED_MODEL_CODE}    ${DDL_MODEL_CODE}/option[text()='${SPACE}${selected_model_code}${SPACE}']
    Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_MODEL_CODE}

Fill Out Newsletter Form
    [Documentation]    Enters the details needed Newsletter
    Input Text    ${TXT_SUBJECT}    ${INPUT_SUBJECT}
    Input Text    ${TXT_PROOFED_COPY}    ${INPUT_PROOFED_COPY}
    Choose File    ${IMG_HEADER_CONTENT}    ${JPG_IMAGE_SAMPLE}
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_POSTING}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${INPUT_SUBJECT}

Fill Out Graphics Design Form
    [Documentation]    Enters the details needed for Graphic Design
    Input Text    ${TXTA_HEADLINE}    ${INPUT_HEADLINE}
    Choose File    ${IMG_SPECIFIC_IMAGE}    ${JPG_IMAGE_SAMPLE}
    ${selected_format}    Random Elements    ${LIST_FORMAT}
    FOR    ${format}    IN    @{selected_format}
        Input Text    ${TXT_FORMAT}    ${format}
        Press Keys    ${TXT_FORMAT}    ENTER
    END
    Press Keys    ${TXT_FORMAT}    ESC
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_NEEDED}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${sc_item}

Fill Out Office/Booth Design Form
    [Documentation]    Enters the details needed for Office/Booth Design
    Choose File    ${IMG_FLOORPLAN}    ${JPG_IMAGE_SAMPLE}
    Choose File    ${IMG_PRODUCT_LIST}    ${JPG_IMAGE_SAMPLE}
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_NEEDED}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${sc_item}

Fill Out Signage/Wall Graphics Form
    [Documentation]    Enters the details needed for Signage/Wall Graphics
    Choose File    ${IMG_REFERENCE}    ${JPG_IMAGE_SAMPLE}
    ${next_date}    Get Current Date    result_format=%Y-%#m-%#d    increment=+1 day
    Click Element    ${DATE_NEEDED}
    Click Element    //div[@role='row']/div[@aria-label='${next_date}']
    Set Test Variable    ${EXPECTED_TITLE}    ${sc_item}

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
        Click Element    ${BTN_CREATE}
        Wait Until Page Contains Element    ${DDL_DIVISION}    120s
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
    END

# Add other fields here

Submit Ticket
    [Documentation]    Submits the ticket created
    ${stat}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[contains(text(),'Submit')]
    IF    "${stat}" == "True"    Click Element    //button[@class="btn btn-primary"]

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
