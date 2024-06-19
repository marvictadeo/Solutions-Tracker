*** Settings ***
Documentation        Global Keywords for Test Cases.
Library              Collections
Library              String
Library              Dialogs
Library              DateTime
Library              SeleniumLibrary
Library              RPA.Excel.Files
Library              FakerLibrary
Library              RPA.Tables

Resource             FACE_VIDE_Variables.resource


*** Keywords ***
Navigate To Site
    [Documentation]    The user opens a browser and navigates to the site.
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    # Pause Execution

Quit Browser
    [Documentation]    Closes browser after delay
    Sleep    0.5s
    Close All Browsers

Select A Worksheet
    [Documentation]    Keyword to open an excel file and select an active Worksheet
    [Arguments]    ${sheet_name}
    ${table}   Read Worksheet As Table    ${sheet_name}   header=True
    RETURN    ${table}

The User Clicks The "${element}"
    [Documentation]    Verify any clickable element before clicking it: buttons, icons, links, etc.
    Wait Until Page Contains Element    ${element}    30s
    TRY
        Click Element    ${element}
    EXCEPT
        Log    Catches any exception when clicking through an element.
    END

Restore Default Run On Failure
    [Documentation]    Keyword to restore function of run_on_failure in its original state
    Register Keyword To Run On Failure    Capture Page Screenshot

Wait Until All Elements Are Visible
    [Documentation]    Keyword to Verify if All the elements are visible
    ...    Use if to many elements on to be checked on the page
    [Arguments]    ${list_of_elements}
    FOR    ${element}    IN    @{list_of_elements}
     Wait Until Element Is Visible    ${element}    20s
    END

Scroll And Click The Element
    [Documentation]    Keyword to scroll and click on the element.
    ...    To avoid errors such as MoveTargetOutOfBoundsException and ElementClickInterceptedException which is caused by the heavy load of images, the action was put inside the try/except.
    [Arguments]    ${element}
    # Wait Until Element Is Visible    ${element}    30s
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

Scroll To Element And Get Text
    [Documentation]    Keyword to scroll to element and get text
    [Arguments]    ${locator}
    Scroll "${locator}" Into Center
    Wait Until Page Contains Element    ${locator}    20s
    ${locator}    Get Text    ${locator}
    RETURN    ${locator}

Scroll To Element And Get Element Attribute
    [Documentation]    Keyword to scroll to element and get text
    [Arguments]    ${locator}    ${attribute}
    Scroll "${locator}" Into Center
    Wait Until Page Contains Element    ${locator}    200s
    ${value}    Get Element Attribute    ${locator}    ${attribute}
    RETURN    ${value}

Get Random Integer Range ${start_int} And ${end_int}
    [Documentation]    Get Random Integer Range ${start_int} and ${end_int}. range(${start_int}, ${end_int})
    ${result}    Evaluate              random.sample(range(${start_int}, ${end_int}), 1)    random
    ${number}    Get From List         ${result}    0
    ${number}    Convert To Integer    ${number}
    RETURN       ${number}

Generate A Random Number
    [Documentation]    Keyword to generate a random number using the Evaluate function
    [Arguments]    ${min_range}    ${max_range}
    ${get_random_num}    Evaluate    random.sample(range(${min_range}, ${max_range}), 1)    random
    RETURN    ${get_random_num}

Clear Text Field
    [Documentation]    Keyword to clear the text field using Press Keys function. Can be used as a workaround if Clear Element Text is not working.
    [Arguments]  ${locator}
    SeleniumLibrary.Press Keys    ${locator}    CTRL+a+BACKSPACE

Set Implicit Wait Time
    [Documentation]    Sets an implicit wait time on specific elements.
    ...                To return to its original state, use "Set Implicit Wait Time" without entering a value
    [Arguments]    ${implicit_wait_time}=0
    Set Selenium Implicit Wait    ${implicit_wait_time}

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

Get CSS Property Value
    [Documentation]    This keyword retrieves the CSS property value of an element.
    ...                The element is retrieved using the XPath Locator.
    [Arguments]    ${locator}    ${attribute_name}
    Wait Until Page Contains Element    ${locator}    30s
    ${css}    Get WebElement    ${locator}
    ${prop_val}    Call Method    ${css}    value_of_css_property    ${attribute_name}
    RETURN    ${prop_val}

Get CSS Prop Val With Pseudo Using JS
    [Documentation]    This keyword retrieves the CSS property value of an element using Javascript.
    ...                The element is retrieved using the CSS Query Selector.
    ...                ${css_locator}        =    querySelector
    ...                ${css_pseudo}         =    :before, :after, :hover, :active, :focus, etc.
    ...                ${css_attribute}      =    background-image, content, margin, top, etc.
    [Arguments]    ${css_locator}    ${css_pseudo}    ${css_attribute}
    ${css_prop_val}    Execute Javascript    return window.getComputedStyle(document.querySelector
    ...    (${css_locator}),'${css_pseudo}').getPropertyValue('${css_attribute}')
    RETURN     ${css_prop_val}

Wait Until CSS Property Of Element Is True
    [Documentation]    Waits until the given element contains the specified css property value
    [Arguments]    ${locator}    ${property}    ${value}    ${pseudo}=:null
    IF    "${pseudo}" == ":null"
        Wait Until Keyword Succeeds    5x    5s    CSS Property Should Contain    ${locator}    ${property}    ${value}
    ELSE
        Wait Until Keyword Succeeds    2x    0s    CSS Property Should Contain    ${locator}    ${property}    ${value}    xpath    # with a timeout of 30s per retry
    END

CSS Property Should Contain
    [Documentation]    Checks if the given locator contains the specified property value.
    [Arguments]    ${locator}    ${property}    ${value}    ${selector_type}=css
    IF   "${selector_type}" == "css"
        ${css_prop}    Get CSS Prop Val With Pseudo Using JS    ${locator}    :null    ${property}
    ELSE  # locator is xpath
        ${css_prop}    Get CSS Property Value    ${locator}    ${property}    # with Wait Until Page Contains Element (30s)
    END
    Should Contain    ${css_prop}    ${value}    ignore_case=True

CSS Property Value Should Be
    [Documentation]    Validates CSS Property Value of an element
    [Arguments]    ${locator}    ${property}    ${value}    ${pseudo}=:null
    IF    "${pseudo}" != ":null"
        Wait Until CSS Property Of Element Is True    ${locator}    ${property}    ${value}    :none
        ${css_prop}    Get CSS Property Value    ${locator}    ${property}
        Run Keyword And Return Status    Should Contain    ${css_prop}    ${value}    ignore_case=True
    ELSE
        Wait Until CSS Property Of Element Is True    ${locator}    ${property}    ${value}
        ${css_prop}    Get CSS Prop Val With Pseudo Using JS    ${locator}    ${pseudo}    ${property}
        Run Keyword And Return Status    Should Contain    ${css_prop}    ${value}    ignore_case=True
    END

Verify CSS Property Value
    [Documentation]    Keyword to verify CSS Property Value
    [Arguments]    ${locator}    ${property}    ${value}
    ${css_prop}    Get CSS Property Value    ${locator}    ${property}
    Should Contain    ${css_prop}    ${value}    ${property}

# ==========================================================================================#
# ---------------------- KEYWORDS THAT USE JAVASCRIPTS (JS) - END ------------------------- #
# ==========================================================================================#

The User Is On The Solution Tracker
    [Documentation]    Verification if user is on the Solution Tracker
    ${stat}    Run Keyword And Return Status    Page Should Contain Element    ${DDL_DIVISION}
    IF    "${stat}" == "False"
        The User Clicks The "${BTN_CREATE}"
        Wait Until Page Contains Element    ${DDL_DIVISION}    10s
    END

Select A Division
    [Documentation]    Keyword to select a Division
    [Arguments]    ${division}
    Scroll And Click The Element    ${DDL_DIVISION}
    Set Test Variable    ${DDL_SELECTED_DIV}    ${DDL_DIVISION}/option[text()='${SPACE}${division}${SPACE}']
    Scroll And Click The Element    ${DDL_SELECTED_DIV}

Select A Sub-Division
    [Documentation]    Keyword to select a Sub-Division
    [Arguments]    ${subdivision}
    Wait Until Element Is Enabled    ${DDL_SUBDIVISION}    10s
    Select From List By Label    ${DDL_SUBDIVISION}    ${subdivision}

Select A Service Classification
    [Documentation]    Keyword to select a Service Classification
    [Arguments]    ${sc_item}
    Wait Until Element Is Enabled    ${DDL_SC}    10s
    TRY
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SC}    ${sc_item}
        Set Test Variable    ${SC_ITEM}
    EXCEPT
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SC}    ${sc_item}
        Set Test Variable    ${SC_ITEM}
    END

Select A Service Type
    [Documentation]    Select the service type
    [Arguments]    ${st_item}
    IF    "${st_item}" != "EMPTY"
        Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[text()="${SPACE}${st_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${ST_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[text()="${SPACE}${st_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_ST}   30s
            Run Keyword And Continue On Failure    Select Service Type Value    ${st_item}
        END
    END

Select Service Type Value
    [Documentation]    Keyword to Select Service Type Value
    [Arguments]    ${st_item}
    TRY
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_ST}    ${st_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_ST}    ${st_item}
    END

Select A Service Requirement
    [Documentation]    Select the service requirement
    [Arguments]    ${sr_item}
    IF    "${sr_item}" != "EMPTY"
        Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${SR_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_SR}   30s
            Run Keyword And Continue On Failure    Select Service Requirement Value    ${sr_item}
        END
    END

Select Service Requirement Value
    [Arguments]    ${sr_item}
    [Documentation]    Keyword to Select Service Requirement Value
    TRY
        Wait Until Element Is Visible    ${DDL_SR}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SR}    ${sr_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_SR}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SR}    ${sr_item}
    END

Select A Brand
    [Documentation]    Keyword to select a Brand
    [Arguments]    ${brand}
    Scroll And Click The Element    ${DDL_BRAND}
    Set Test Variable    ${DDL_SELECTED_BRAND}    ${DDL_BRAND}/option[text()='${SPACE}${brand}${SPACE}']
    Scroll And Click The Element    ${DDL_SELECTED_BRAND}

Select A Model Code
    [Documentation]    Keyword to select a Model Code
    Wait Until Element Is Enabled    ${DDL_MODEL_CODE}    120s
    Scroll And Click The Element    ${DDL_MODEL_CODE}
    Scroll And Click The Element    ${DDL_SELECTED_MODEL_CODE}

Select Required Elements For This Video
    [Documentation]    Keyword to select a required element
    [Arguments]    ${req_elements_item}
    Wait Until Element Is Enabled    ${DDL_REQ_ELEMENTS}    30s
    # Scroll "${ATTACHMENT}" Into Center
    Scroll And Click The Element    ${DDL_REQ_ELEMENTS}
    Set Focus To Element    ${DDL_REQ_ELEMENTS}
    Input Text    ${INPUT_REQ_ELEMENTS}    ${req_elements_item}
    Press Keys    ${INPUT_REQ_ELEMENTS}    ENTER

Select Required Video For Posting
    [Documentation]    Select required video posting
    [Arguments]    ${vid_posting_item}
    Wait Until Element Is Enabled    ${DDL_VID_POSTING}    30s
    Scroll "${DDL_PRIORITY} " Into Center
    Scroll And Click The Element    ${DDL_VID_POSTING}
    Set Focus To Element    ${DDL_VID_POSTING}
    Input Text    ${INPUT_VID_POSTING}    ${vid_posting_item}
    Press Keys    ${INPUT_VID_POSTING}    ENTER

The User Selects A Service Classification
    [Documentation]    Select a service classification
    [Arguments]    ${service_classification}
    Select A Division   ${DIV_VALUE}
    Select A Sub-Division    ${SUBDIV_VALUE}
    Select A Service Classification   ${service_classification}

The Form Display Should Vary Depending On The Selected Service Classification
    [Documentation]    Keyword to validate the displayed forms depending on service classification
    [Arguments]     ${service_classification}
    The User Accessed The FACE VIDE Data   ${SHEET_SC}
    IF    "${service_classification}" == "Products"
        Verify List Of Fields Based On Service Classification    ${SC_PRODUCT_VIDEO}
    ELSE IF    "${service_classification}" == "Non Products"
        Verify List Of Fields Based On Service Classification    ${SC_NON_PRODUCT_VIDEO}
    ELSE IF    "${service_classification}" == "Graphics"
        Verify List Of Fields Based On Service Classification    ${SC_GRAPHICS}
    ELSE IF    "${service_classification}" == "Employee Banners"
        Verify List Of Fields Based On Service Classification    ${SC_EMPLOYEE_BANNER}
    END

Verify List Of Fields Based On Service Classification
    [Documentation]    Keyword to validate list of fields based on service classification
    [Arguments]    ${service_classification}
    Filter Table By Column    ${table}    ${service_classification}    !=    N/A
    ${FACE_DOC_DESC}    Get Table Column    ${table}    ${service_classification}
    FOR    ${doc_desc}    IN    @{FACE_DOC_DESC}
        Log To Console    ${doc_desc}
        Set Test Variable    ${FIELDS_FACE_VIDE}    //*[text() = '${doc_desc}${SPACE}']
        # Run Keyword And Continue On Failure    Scroll "${FIELDS_FACE_VIDE}" Into Center
        # Run Keyword And Continue On Failure    Page Should Contain Element    ${FIELDS_FACE_VIDE}
    END

    # Verify Ticket Creation For FACE VIDE
    #     [Documentation]    Ticket Creation - FACE VIDE
    #     The User Is On The Solution Tracker
    #     FACE VIDE: Ticket Submission

The User Accessed The FACE VIDE Data
    [Documentation]    Keyword to open the about page workbook
    [Arguments]    ${sheet_name}
    Open Workbook       ${FACE_VIDE_DATA}    read_only=True
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}

# FACE VIDE: Ticket Submission
#     [Documentation]    Keyword to fill in details and submit ticket using the master data
#     FACE VIDE: Get Excel Data
#     ${length}    Get Length    ${SUB_DIVISION}
#     # FOR    ${count}    IN RANGE    ${length}
#     FOR    ${count}    IN RANGE    1    2
#         ${index}    Evaluate    ${count} - 1
#         ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
#         ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
#         ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
#         ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
#         #    ------- Fill In FACE VIDE Form -------
#         Run Keyword And Continue On Failure    FACE VIDE: Fill In Solution Tracker Form
#         ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
#         #    ------- Submit The Ticket -------
#         Run Keyword And Continue On Failure    Submit The Ticket
#         #    ------- Verify Ticket Viewer -------
#         Run Keyword And Continue On Failure    Verify Ticket Viewer Details
#         #    ------- Verify Ticket Summary -------
#         Run Keyword And Continue On Failure    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
#         Scroll "${BTN_CREATE_A_TICKET}" Into Center
#         Click Element    ${BTN_CREATE_A_TICKET}
#     END

FACE VIDE: Ticket Submission With CRM Checking
    [Documentation]    Keyword to fill in details and submit ticket using the master data
    FACE VIDE: Get Excel Data
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        # FOR    ${count}    IN RANGE    1    2
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${brand_item}    Get From List    ${BRAND}    ${index}
        ${req_elements_item}    Get From List    ${REQ_ELEMENTS}    ${index}
        ${vid_posting_item}    Get From List    ${VID_POSTING}    ${index}
        #    ------- Fill In FACE VIDE Form -------
        Run Keyword And Continue On Failure    FACE VIDE: Fill In Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}   ${sr_item}    ${brand_item}    ${req_elements_item}    ${vid_posting_item}
        IF    "${sc_item}" == "${SC_PRODUCT_VIDEO}"
            Run Keyword And Continue On Failure    Fill In Other Information (Product Video)    ${brand_item}    ${req_elements_item}    ${vid_posting_item}
        ELSE IF    "${sc_item}" == "${SC_NON_PRODUCT_VIDEO}"
            Run Keyword And Continue On Failure    Fill In Other Information (Non Product Video)    ${req_elements_item}    ${vid_posting_item}
        ELSE IF    "${sc_item}" == "${SC_GRAPHICS}"
            Run Keyword And Continue On Failure    Fill In Other Information (Graphics)
        ELSE IF    "${sc_item}" == "${SC_EMPLOYEE_BANNER}"
            Run Keyword And Continue On Failure    Fill In Other Information (Employee Banner)
        END
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        ${get_stat}    Run Keyword And Return Status   Wait Until Page Contains Element    ${TICKET_VIEWER_SEARCH}    500s
        IF    "${get_stat}" == "True"
            #     ------- Verify Ticket Details -------
            Run Keyword And Continue On Failure    Verify Case Ticket Details In CRM For FACE VIDE
            ...        subdivision=${subdiv_item}    service_classification=${sc_item}    service_type=${st_item}    service_requirement=${sr_item}    # Default fields
            ...        description=${EMPTY}    priority=${SELECTED_PRIORITY}    cust_division=${SELECTED_CUST_DIV}    cust_subdivision=${SELECTED_CUST_SUBDIV}    cust_location=${SELECTED_LOCATION}    # Default fields
            ...        brand=${brand_item}    	pfi=${JPG_NAME}
            ...        req_elements=${req_elements_item}     vid_posting=${vid_posting_item}
            Run Keyword And Continue On Failure    Go Back And Switch To ST Form Page
            Run Keyword And Continue On Failure    Scroll "${BTN_CREATE_A_TICKET}" Into Center
            Run Keyword And Continue On Failure    Click Element    ${BTN_CREATE_A_TICKET}
        ELSE
            CONTINUE
        END
    END

Go Back And Switch To ST Form Page
    [Documentation]    Go Back And Switch To ST Form Page
    Switch Window    title=${ST_TAB_PAGE}
    Wait Until Element Is Visible    ${TICKET_VIEWER_SEARCH}    30s

FACE VIDE: Get Excel Data
    [Documentation]    Keyword to get excel data for FACE VIDE
    The User Accessed The FACE VIDE Data    ${SHEET_FACE_VIDE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    ${CO_SUB_DIVISION}
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    ${CO_SERVICE_CLASSIFICATION}
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    ${CO_SERVICE_TYPE}
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    ${CO_SERVICE_REQUIREMENT}
    ${BRAND}    Get Table Column    ${TABLE}    ${CO_BRAND}
    ${REQ_ELEMENTS}    Get Table Column    ${TABLE}    ${CO_REQ_ELEMENTS}
    ${VID_POSTING}    Get Table Column    ${TABLE}    ${CO_VID_POSTING}
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}
    Set Test Variable    ${BRAND}
    Set Test Variable    ${REQ_ELEMENTS}
    Set Test Variable    ${VID_POSTING}

Fill In Customer's Info [Division, Sub-division, Location]
    [Documentation]    Random Selection in Customer's Info
    Select Random Option For "Customer Division And Sub-Division" Dropdown
    Select Random Option For "Customer Location" Dropdown

Select Random Option For "${field}" Dropdown
    [Documentation]    Select Random Option
    IF    "${field}" == "Customer Division And Sub-Division"
        ${selected_cust_div}    Random Element    ${LIST_FACE_DIVISION}
        Set Test Variable    ${SELECTED_CUST_DIV}
        Scroll "${DDL_CUST_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_DIVISION}    30s
        The User Clicks The "${DDL_CUST_DIVISION}"
        Set Test Variable    ${DDL_SELECTED_DIV}    ${DDL_CUST_DIVISION}/option[text()='${SPACE}${selected_cust_div}${SPACE}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_DIV}

        # ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        ${selected_cust_subdiv}    Select A Customer Sub Division    ${selected_cust_div}
        Set Test Variable    ${SELECTED_CUST_SUBDIV}
        Scroll "${DDL_CUST_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_SUB_DIVISION}    30s
        The User Clicks The "${DDL_CUST_SUB_DIVISION}"
        Set Test Variable    ${DDL_SELECTED_CUST_SUBDIV}    ${DDL_CUST_SUB_DIVISION}/option[text()='${SPACE}${selected_cust_subdiv}${SPACE}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_CUST_SUBDIV}
    ELSE IF    "${field}" == "Customer Location"
        ${selected_location}    Random Element    ${LIST_LOCATION}
        Set Test Variable    ${SELECTED_LOCATION}
        Scroll "${DDL_CUST_LOCATION}" Into Center
        The User Clicks The "${DDL_CUST_LOCATION}"
        Set Test Variable    ${DDL_SELECTED_CUST_LOC}    ${DDL_CUST_LOCATION}/option[text()='${SPACE}${selected_location}${SPACE}']
        Wait Until Keyword Succeeds    3x    1s    Scroll And Click The Element    ${DDL_SELECTED_CUST_LOC}
    ELSE IF    "${field}" == "Priority"
        ${selected_priority}    Random Element    ${LIST_PRIORITY}
        Scroll "${DDL_PRIORITY}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_PRIORITY}    ${selected_priority}
        Set Test Variable    ${SELECTED_PRIORITY}
    END

Select A Customer Sub Division
    [Documentation]    Select a customer sub div
    [Arguments]    ${selected_cust_div}
    IF    "${selected_cust_div}" == "Availability Tribes (AVAI)"
        ${selected_cust_subdiv}    Random Element    ${LIST_AVAI_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Digital Tribes (DIGI)"
        ${selected_cust_subdiv}    Random Element    ${LIST_DIGI_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Face Tribes${SPACE}${SPACE}(FACE)"
        ${selected_cust_subdiv}    Random Element    ${LIST_FACE_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Heart Tribes (HEAR)"
        ${selected_cust_subdiv}    Random Element    ${LIST_HEAR_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Horizon Tribe (HORIZON)"
        ${selected_cust_subdiv}    Random Element    ${LIST_AVAI_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Hospitality Tribes (HOSP)"
        ${selected_cust_subdiv}    Random Element    ${LIST_HOSP_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Innovation Tribes (INNO)"
        ${selected_cust_subdiv}    Random Element    ${LIST_INNO_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Legal Tribes (LEGA)"
        ${selected_cust_subdiv}    Random Element    ${LIST_LEGA_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Performance Tribes (PERF)"
        ${selected_cust_subdiv}    Random Element    ${LIST_AVAI_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Research Tribes (RESE)"
        ${selected_cust_subdiv}    Random Element    ${LIST_RESE_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Transformation Tribes (TRAN)"
        ${selected_cust_subdiv}    Random Element    ${LIST_TRAN_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Treasure Tribes (TREA)"
        ${selected_cust_subdiv}    Random Element    ${LIST_TREA_SUB_DIV}
    ELSE IF    "${selected_cust_div}" == "Value Tribes (VALU)"
        ${selected_cust_subdiv}    Random Element    ${LIST_VALU_SUB_DIV}
    END
    RETURN    ${selected_cust_subdiv}

Fill In Request Information
    [Documentation]    Fill In Request Info [Subject, Description, Priority, Type of Output, Library Upload, Attachment, File Link]
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}    ${req_elements_item}    ${vid_posting_item}
    #    --- Subject ---
    # ${get_current_date_and_time}    Get Current Date    result_format=%m-%d-%Y %H:%M:%S
    # ${INPUT_SUBJ}    Catenate    ${INPUT_SUBJECT}${SPACE}${get_current_date_and_time}
    # Set Test Variable    ${INPUT_SUBJ}
    # Input Text    ${SUBJECT}    ${INPUT_SUBJ}
    #    --- Description ---
    Input Text    ${DESCRIPTION}
    ...    Sub-Division - ${subdiv_item}${\n}Service Classification - ${sc_item}${\n}Service Type - ${st_item}${\n}Service Requirement - ${sr_item}${\n}

Fill In Other Information (Product Video)
    [Documentation]    Fill In Product Video Fields
    [Arguments]   ${brand_item}    ${req_elements_item}    ${vid_posting_item}
    #    --- Brand ---
    Select A Brand    ${brand_item}
    #    --- Model Code ---
    Select A Model Code
    #    --- Required Elements For This Video ---
    Select Required Elements For This Video    ${req_elements_item}
    #    --- PFI/Script/Storyboard/Images ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    #    --- Video for Posting on the Following  ---
    Select Required Video For Posting    ${vid_posting_item}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    #    --- Requestor's Name ---
    Input Text    ${INPUT_REQ_NAME}    ${VALUE_REQ_NAME}
    #    --- Date Needed ---
    Click Element    ${INPUT_DATE_PICKER}
    Input Text    ${INPUT_DATE_PICKER}     ${VALUE_SAMPLE_DATE}
    Press Keys    ${INPUT_DATE_PICKER}    ENTER

Fill In Other Information (Non Product Video)
    [Documentation]    Fill In Non Product Video Fields
    [Arguments]   ${req_elements_item}    ${vid_posting_item}
    #    --- Required Elements For This Video ---
    Select Required Elements For This Video    ${req_elements_item}
    #    --- Script/Storyboard ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    #    --- Reference Link(s)  ---
    Input Text    ${INPUT_REF_LINKS}    ${VALUE_REF_LINK}
    #    --- Video for Posting on the Following  ---
    Select Required Video For Posting    ${vid_posting_item}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    #    --- Requestor's Name ---
    Input Text    ${INPUT_REQ_NAME}    ${VALUE_REQ_NAME}
    #    --- Date Needed ---
    Click Element    ${INPUT_DATE_PICKER}
    Input Text    ${INPUT_DATE_PICKER}     ${VALUE_SAMPLE_DATE}
    Press Keys    ${INPUT_DATE_PICKER}    ENTER

Fill In Other Information (Graphics)
    [Documentation]    Fill In Graphic Fields
    #    --- Specific Images to Use ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    #    --- Reference Link(s)  ---
    Input Text    ${INPUT_REF_LINKS}    ${VALUE_REF_LINK}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    #    --- Requestor's Name ---
    Input Text    ${INPUT_REQ_NAME}    ${VALUE_REQ_NAME}
    #    --- Date Needed ---
    Click Element    ${INPUT_DATE_PICKER}
    Input Text    ${INPUT_DATE_PICKER}     ${VALUE_SAMPLE_DATE}
    Press Keys    ${INPUT_DATE_PICKER}    ENTER

Fill In Other Information (Employee Banner)
    [Documentation]    Fill In Employee Banner Fields
    #    --- Attachments ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    #    --- Requestor's Name ---
    Input Text    ${INPUT_REQ_NAME}    ${VALUE_REQ_NAME}
    #    --- Date Needed ---
    Click Element    ${INPUT_DATE_PICKER}
    Input Text    ${INPUT_DATE_PICKER}     ${VALUE_SAMPLE_DATE}
    Press Keys    ${INPUT_DATE_PICKER}    ENTER

FACE VIDE: Fill In Solution Tracker Form
    [Documentation]    Keyword to fill in FACE VIDE Solution Tracker Form
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}    ${req_elements_item}    ${vid_posting_item}
    Select A Division   ${DIV_VALUE}
    Select A Sub-Division    ${subdiv_item}
    Select A Service Classification    ${sc_item}
    Select A Service Type    ${st_item}
    Select A Service Requirement    ${sr_item}
    Fill In Customer's Info [Division, Sub-division, Location]
    Fill In Request Information   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}    ${req_elements_item}    ${vid_posting_item}

Submit The Ticket
    [Documentation]    Submit The Ticket
    ${expected_title}    Get Variable Value    ${INPUT_SUBJ}
    ${stat}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[contains(text(),'Submit')]
    IF    "${stat}" == "True"    Scroll And Click The Element    ${BTN_SUBMIT}

# ============ CRM Verification V2 - START ============ #

Go To Agent Portal
    [Documentation]    Keyword to redirect the user to Agent Portal
    Scroll And Click The Element    ${BTN_AGENT_PORTAL}
    ${get_stat_1}    Run Keyword And Return Status    Switch Window    title=${TAB_NAME_LOGIN}    timeout=2s
    Go To    ${UAT_CRM_V2}
    # IF    "${get_stat_1}" != "True"
    #     ${get_stat_2}    Run Keyword And Return Status    Switch Window    title=${UAT_TAB_NAME_AGENT_PORTAL}    timeout=2s
    #     IF    "${get_stat_2}" != "True"
    #         ${get_stat_2}    Run Keyword And Return Status    Switch Window    title=${PROD_TAB_NAME_AGENT_PORTAL}    timeout=2s
    #     END
    # END

Login To Agent Portal
    [Documentation]    Keyword to login on Agent Portal
    ${login_status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOGO_CRM}
    IF    "${login_status}" == "True"
        Log    Already logged in.
    ELSE
        Wait Until Element Is Visible    ${TXT_EMAIL}    120s
        Input Text    ${TXT_EMAIL}    ${EMAIL}
        Click Element    ${BTN_LOGIN_SUBMIT}
        Wait Until Element Is Visible    ${TXT_PASSWORD}    120s
        Input Text    ${TXT_PASSWORD}    ${PASSWORD}
        Click Element    ${BTN_LOGIN_SUBMIT}
        Pause Execution    #    Input verification code, Press OK on the dialog once done
    END

Go To Agent Portal Ticket Details
    [Documentation]    Keyword to get the agent portal ticket details
    [Arguments]    ${case_num}
    Wait Until Page Contains Element    ${UAT_SEARCH_ICON}    10s
    Click Element    ${UAT_SEARCH_ICON}
    Wait Until Page Contains Element    ${SEARCH_BOX}    10s
    Input Text    ${SEARCH_BOX}    ${case_num}
    Click Element    ${SEARCH_BOX_ICON}
    Set Test Variable    ${SEARCHED_CASE_NUM}    //span[text()='${case_num}'][1]
    Wait Until Page Contains Element    ${SEARCHED_CASE_NUM}    10s
    Click Element    ${SEARCHED_CASE_NUM}

Get CRM Details
    [Documentation]    Get CRM Details
    [Arguments]    ${DIV}
    FOR    ${key}    IN    @{DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}
        IF    "${key}" == "NUM"
            Run Keyword And Continue On Failure    Wait Until Page Contains Element    ${CASE_SUMMARY_${key}}    60s
            ${text}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute    ${CASE_SUMMARY_${key}}    value
            Run Keyword And Continue On Failure    Set To Dictionary    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}    ${key}=${text}
        ELSE IF    "${key}" == "SR" or "${key}" == "CL"
            ${text}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute        ${CASE_SUMMARY_${key}}    title
            Run Keyword And Continue On Failure    Set To Dictionary    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}    ${key}=${text}
        ELSE IF    "${key}" == "REQ_NAME" or "${key}" == "PFI" or "${key}" == "REQ_ELEMENTS" or "${key}" == "VID_POSTING" or "${key}" == "REF_LINK" or "${key}" == "STORYBOARD" or "${key}" == "SPECIFIC_IMG" or "${key}" == "ATTACHMENT"
            Run Keyword And Continue On Failure    The User Clicks The "${TAB_DETAILED_INFO}"
            Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${CASE_SUMMARY_${key}}    60s
            ${text}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute    ${CASE_SUMMARY_${key}}    value
            Run Keyword And Continue On Failure    Set To Dictionary    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}   ${key}=${text}
        ELSE IF    "${key}" == "BRAND" or "${key}" == "DATE_NEEDED"
            Run Keyword And Continue On Failure    The User Clicks The "${TAB_DETAILED_INFO}"
            Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${CASE_SUMMARY_${key}}    30s
            ${text}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute        ${CASE_SUMMARY_${key}}    title
            Run Keyword And Continue On Failure    Set To Dictionary    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}    ${key}=${text}
        ELSE
            Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${CASE_SUMMARY_${key}}    60s
            ${text}    Run Keyword And Continue On Failure    Scroll To Element And Get Text    ${CASE_SUMMARY_${key}}
            Run Keyword And Continue On Failure    Set To Dictionary    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}    ${key}=${text}
        END
    END
    RETURN    ${DIC_CRM_CASE_SUMMARY_${DIV}_FIELDS}

Get Subject
    [Documentation]    Get Subj
    [Arguments]    ${service_classification}
    ${expected_title}    Get Variable Value    ${service_classification}
    ${data_table_title}    Set Variable    (//div[@class="datatable-body-cell-label"]/a[text()="${SPACE}${expected_title}"])[1]
    Wait Until Page Contains Element    ${data_table_title}    120s
    Set Test Variable    ${DATA_TABLE_TITLE}

Verify CRM Details Of FACE VIDE
    [Documentation]    Verify CRM Details For FACE VIDE
    The User Is On The Solution Tracker
    FACE VIDE: Ticket Submission With CRM Checking

Go Back To CRM Search Page
    [Documentation]    Go Back And Switch To ST Form Page
    Wait Until Element Is Visible    //div/button[@title='Go back']
    Click Element    //div/button[@title='Go back']
    Wait Until Element Is Visible    ${SEARCH_BOX}    30s

Verify Case Ticket Details In CRM For FACE VIDE
    [Documentation]    Verify CRM Details
    [Arguments]    ${subdivision}=${EMPTY}    ${service_classification}=${EMPTY}    ${service_type}=${EMPTY}    ${service_requirement}=${EMPTY}    # Default fields
    ...            ${description}=${EMPTY}    ${priority}=${EMPTY}    ${cust_division}=${EMPTY}    ${cust_subdivision}=${EMPTY}    ${cust_location}=${EMPTY}    # Default fields
    ...            ${pfi}=${EMPTY}   ${req_elements}=${EMPTY}     ${vid_posting}=${EMPTY}
    ...            ${brand}=${EMPTY}
    Get Subject    ${service_classification}
    ${case_num}    Get The Case Ticket Number In Ticket Viewer
    ${get_stat}    Run Keyword And Return Status    Switch Window    title=Search - Dynamics 365
    IF    "${get_stat}" == "False"
        Go To Agent Portal
    ELSE
        Log    Switched to CRM Page.
    END
    Login To Agent Portal
    Go To Agent Portal Ticket Details    ${case_num}

    # --- Compare Case Ticket Details vs CRM ---
    IF    "${service_classification}" == "${SC_PRODUCT_VIDEO}"
        @{list_site_details}    Create List    ${case_num}    ${subdivision}     ${service_classification}    ${service_type}    ${service_requirement}
        ...                                    ${priority}    ${cust_division}    ${cust_subdivision}    ${cust_location}
        ...                                    ${brand}    ${pfi}    ${VALUE_REQ_NAME}
        ...                                    ${req_elements}     ${vid_posting}    ${CRM_VALUE_SAMPLE_DATE}

        ${crm_vide_details}    Get CRM Details    PRODUCT_VID
    ELSE IF    "${service_classification}" == "${SC_NON_PRODUCT_VIDEO}"
        @{list_site_details}    Create List    ${case_num}    ${subdivision}     ${service_classification}    ${service_type}    ${service_requirement}
        ...                                    ${priority}    ${cust_division}    ${cust_subdivision}    ${cust_location}
        ...                                    ${VALUE_REF_LINK}    ${pfi}    ${VALUE_REQ_NAME}
        ...                                    ${req_elements}     ${vid_posting}    ${CRM_VALUE_SAMPLE_DATE}

        ${crm_vide_details}    Get CRM Details    NON_PRODUCT_VID
    ELSE IF    "${service_classification}" == "${SC_GRAPHICS}"
        @{list_site_details}    Create List    ${case_num}    ${subdivision}     ${service_classification}    ${service_type}    ${service_requirement}
        ...                                    ${priority}    ${cust_division}    ${cust_subdivision}    ${cust_location}
        ...                                    ${VALUE_REF_LINK}    ${pfi}    ${VALUE_REQ_NAME}
        ...                                    ${CRM_VALUE_SAMPLE_DATE}

        ${crm_vide_details}    Get CRM Details    GRAPHICS
    ELSE IF    "${service_classification}" == "${SC_EMPLOYEE_BANNER}"
        @{list_site_details}    Create List    ${case_num}    ${subdivision}     ${service_classification}    ${service_type}    ${service_requirement}
        ...                                    ${priority}    ${cust_division}    ${cust_subdivision}    ${cust_location}
        ...                                    ${pfi}    ${VALUE_REQ_NAME}
        ...                                    ${CRM_VALUE_SAMPLE_DATE}

        ${crm_vide_details}    Get CRM Details    EMPLOYEE_BANNER
    END

    FOR    ${crm_data}    ${site_data}    IN ZIP    ${crm_vide_details}   ${list_site_details}
        IF    "${crm_data}" == "PFI" or "${crm_data}" == "STORYBOARD" or "${crm_data}" == "SPECIFIC_IMG" or "${crm_data}" == "ATTACHMENT"
            Run Keyword And Continue On Failure    Should Contain    ${crm_vide_details['${crm_data}']}    ${site_data}
        ELSE IF    "${service_classification}" == "${SC_PRODUCT_VIDEO}" and "${crm_data}" == "REQ_ELEMENTS" and "${site_data}" == "Select All"
            Run Keyword And Continue On Failure    Should Be Equal    ${crm_vide_details['${crm_data}']}    ${REQ_ELEMENTS_SELECT_ALL}
        ELSE IF    "${service_classification}" == "${SC_NON_PRODUCT_VIDEO}" and "${crm_data}" == "REQ_ELEMENTS" and "${site_data}" == "Select All"
            Run Keyword And Continue On Failure    Should Be Equal    ${crm_vide_details['${crm_data}']}    ${NON_PROD_REQ_ELEMENTS_SELECT_ALL}
        ELSE IF    "${crm_data}" == "VID_POSTING" and "${site_data}" == "Select All"
            Run Keyword And Continue On Failure    Should Be Equal    ${crm_vide_details['${crm_data}']}    ${VID_POSTING_SELECT_ALL}
        ELSE
            Run Keyword And Continue On Failure    Should Be Equal    ${crm_vide_details['${crm_data}']}    ${site_data}
        END
    END

    Go Back To CRM Search Page
    # ============ CRM Verification V2 - END ============ #

    # --- TICKET VIEWER VERIFICATION ---#

Verify Ticket Viewer Details
    [Documentation]    Keyword to verify ticket viewer details [Status, Priority, Subject, Service Classification]
    # SUBJECT
    ${expected_title}    Get Variable Value    ${INPUT_SUBJ}
    ${data_table_title}    Set Variable    //div[@class="datatable-body-cell-label"]/a[text()=" ${expected_title}"]
    Wait Until Page Contains Element    ${data_table_title}    120s
    Set Test Variable    ${DATA_TABLE_TITLE}

    # STATUS
    ${data_table_status}    Set Variable    ${data_table_title}/preceding::a[text()=" Open"]
    Wait Until Page Contains Element    ${data_table_status}    120s

    # PRIORITY
    ${expected_priority}    Get Variable Value    ${SELECTED_PRIORITY}
    ${data_table_priority}    Set Variable    ${data_table_title}/preceding::a[text()=" ${expected_priority}"]
    Wait Until Page Contains Element    ${data_table_priority}    120s

    # SERVICE CLASSIFICATION
    ${expected_sc}    Get Variable Value    ${SC_ITEM}
    ${data_table_sc}    Set Variable    ${data_table_title}/following::datatable-body-cell[1]/div/a
    Wait Until Page Contains Element    ${data_table_sc}    120s

Get The Case Ticket Number In Ticket Viewer
    [Documentation]    Keyword to get the case ticket number in the ticket viewer details
    ${data_table_title}    Get Variable Value    ${DATA_TABLE_TITLE}
    ${data_table_case}    Set Variable    ${data_table_title}/preceding::datatable-body-cell[3]/div/a
    ${case_num}    Get Text    ${data_table_case}
    Set Test Variable    ${CASE_NUM}
    RETURN    ${CASE_NUM}

Verify Ticket Summary
    [Documentation]    Keyword to verify ticket summary
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    ${case_num}    Get The Case Ticket Number In Ticket Viewer
    Click Element    ${DATA_TABLE_TITLE}

    # VERIFY CASE NUMBER
    Wait Until Page Contains Element    ${TICKET_INFO}    120s
    ${ticket_info_case}    Set Variable    //h4[contains(text(),'Ticket Number:${SPACE}${case_num}')]
    Page Should Contain Element    ${ticket_info_case}

    # VERIFY TICKET INFO
    ${ticket_info_details}    Get Ticket Info Details
    ${form_ticket_info}    Ticket Info: Get Variable Values    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    FOR    ${form_info}    ${ticket_summary_info}    IN ZIP    ${form_ticket_info}    ${TICKET_INFO_TO_VERIFY}
        Run Keyword And Continue On Failure    Should Be Equal    ${form_info}   ${ticket_info_details['${ticket_summary_info}']}
    END

Ticket Info: Get Variable Values
    [Documentation]    Keyword to get the ticket info
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    ${selected_priority}    Get Variable Value    ${SELECTED_PRIORITY}
    ${selected_cust_div}    Get Variable Value    ${SELECTED_CUST_DIV}
    ${selected_cust_subdiv}    Get Variable Value    ${SELECTED_CUST_SUBDIV}
    ${selected_location}    Get Variable Value    ${SELECTED_LOCATION}
    @{FORM_TICKET_INFO}    Create List    ${DIV_VALUE}   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${selected_priority}    ${selected_cust_div}    ${selected_cust_subdiv}    ${selected_location}
    Set Test Variable    ${FORM_TICKET_INFO}
    RETURN    ${FORM_TICKET_INFO}

Get Ticket Info Details
    [Documentation]    Retrieves the value of the product details
    FOR    ${element}    ${key}    IN ZIP    ${TICKET_INFO_DETAILS_FIELDS}    ${TICKET_INFO_DETAILS_LIST.keys()}
        IF    "${element}" == "${INFO_CASE_NUM}"
        ${str_case_num}    Get ST Ticket Number In Ticket Summary
        Set To Dictionary    ${TICKET_INFO_DETAILS_LIST}   ${key}=${str_case_num}
        ELSE
        ${details}    Scroll To Element And Get Text    ${element}
        Set To Dictionary    ${TICKET_INFO_DETAILS_LIST}   ${key}=${details}
        END
    END
    RETURN    ${TICKET_INFO_DETAILS_LIST}

Get ST Ticket Number In Ticket Summary
    [Documentation]    Get The Ticket Number
    Wait Until Element Is Visible    ${INFO_CASE_NUM}
    ${case_number}    Get Text    ${INFO_CASE_NUM}
    ${str_case_num}    Remove String    ${case_number}    Ticket Number:${SPACE}
    Set Suite Variable    ${STR_CASE_NUM}
    RETURN    ${STR_CASE_NUM}

# ============ CRM Verification - START ============ #

# Verify Case Ticket Summary In CRM For FACE VIDE
#     [Documentation]    Keyword to verify ticket creation and CRM Details for FACE VIDE
#     ${ticket_info_details}    FACE VIDE: Get Ticket Info Summary
#     Verify Ticket Details In Agent Portal   ${ticket_info_details}
#     # FACE VIDE: Ticket Submission With CRM Checking

# FACE VIDE: Ticket Submission With CRM Checking
    # [Documentation]    Keyword to fill in details and submit ticket using the master data
    # FACE VIDE: Get Excel Data
    # ${length}    Get Length    ${SUB_DIVISION}
    # # FOR    ${count}    IN RANGE    ${length}
    # FOR    ${count}    IN RANGE    1    2
    #     ${index}    Evaluate    ${count} - 1
    #     ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
    #     ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
    #     ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
    #     ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
    #     #    ------- Fill In FACE VIDE Form -------
    #     Run Keyword And Continue On Failure    FACE VIDE: Fill In Solution Tracker Form
    #     ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    #     #    ------- Submit The Ticket -------
    #     Run Keyword And Continue On Failure    Submit The Ticket
    #     #    ------- Verify Ticket Viewer -------
    #     Run Keyword And Continue On Failure    Verify Ticket Viewer Details
    #     #    ------- Verify Ticket Summary -------
    #     Run Keyword And Continue On Failure    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    #    ------ Verify Ticket In ST Portal ------
        # Run Keyword And Continue On Failure    Verify Ticket Details In Agent Portal
    # END

Ticket Viewer: Search A Case
    [Documentation]    Keyword to search a case in the ticket viewer details
    [Arguments]    ${keyword}
    Wait Until Page Contains Element    ${BTN_VIEW}    10s
    Scroll And Click The Element    ${BTN_VIEW}
    Wait Until Page Contains Element    ${TICKET_VIEWER_SEARCH}    30s
    Input Text    ${TICKET_VIEWER_SEARCH}    ${keyword}
    Click Element    ${TICKET_VIEWER_SEARCH_ICON}

FACE VIDE: Get Ticket Info Summary
    [Documentation]    Keyword to get the ticket info summary
    # Ticket Viewer: Search A Case    ${INPUT_SUBJECT}    # --- To be uncommented once all cases are available on sandbox --- #
    Ticket Viewer: Search A Case    CAS-24568-Y3H5L0
    Set Test Variable    ${TICKET_VIEWER_CASES}    //a[contains(text(),'${INPUT_SUBJECT}')]
    ${count}    Get Element Count    ${TICKET_VIEWER_CASES}
    Set Test Variable    ${SPECIFIC CASE}    (${TICKET_VIEWER_CASES})[${count}]
    # --- To be uncommented once all cases are available on sandbox --- #
    # ${random_num}    Get Random Integer Range 1 And ${count}
    # Set Test Variable    ${SPECIFIC CASE}    (${TICKET_VIEWER_CASES})[${random_num}]
    Scroll And Click The Element    ${SPECIFIC CASE}
    Wait Until Page Contains Element    ${TICKET_INFO}    120s
    ${ticket_info_details}    Get Ticket Info Details
    RETURN    ${ticket_info_details}

Verify Ticket Details In Agent Portal
    [Documentation]    Keyword to verify ticket details in Agent Portal
    [Arguments]    ${ticket_info_details}
    Go To Agent Portal
    Login To Agent Portal
    Go To Agent Portal Ticket Details   ${ticket_info_details['Case_Num']}
    Verify Agent Portal CRM Details    ${ticket_info_details}

# Go To Agent Portal Ticket Details
#     [Documentation]    Keyword to get the agent portal ticket details
#     [Arguments]    ${case_num}
#     Wait Until Page Contains Element    ${UAT_SEARCH_ICON}    10s
#     Click Element    ${UAT_SEARCH_ICON}
#     Wait Until Page Contains Element    ${SEARCH_BOX}    10s
#     Input Text    ${SEARCH_BOX}    ${case_num}
#     Click Element    ${SEARCH_BOX_ICON}
#     Set Test Variable    ${SEARCHED_CASE_NUM}    //span[text()='${case_num}'][1]
#     Wait Until Page Contains Element    ${SEARCHED_CASE_NUM}    10s
#     Click Element    ${SEARCHED_CASE_NUM}

Verify Agent Portal CRM Details
    [Documentation]    Keyword to verify agent portal details
    [Arguments]    ${ticket_info_details}
    FOR    ${site_data}    ${crm_element}    IN ZIP   ${CASE_TICKET_INFO_TO_VERIFY}    ${CRM_CASE_SUMMARY_FIELDS}
        IF  "${site_data}" == "Priority"
        Set Test Variable    ${CASE_SUMMARY_PRIORITY}    //div[contains(text(),'${ticket_info_details['${site_data}']}')]
        Scroll "${CASE_SUMMARY_PRIORITY}" Into Center
        Page Should Contain Element    ${CASE_SUMMARY_PRIORITY}
        ELSE
        Wait Until Page Contains Element    ${crm_element}    30s
        Scroll "${crm_element}" Into Center
        ${agent_portal_data}    Get Element Attribute    ${crm_element}    title
            IF    "${site_data}" == "Division"
            Run Keyword And Continue On Failure    Should Be Equal    ${ticket_info_details['${site_data}']}    ${agent_portal_data}    collapse_spaces=true
            ELSE
            Run Keyword And Continue On Failure    Should Be Equal    ${ticket_info_details['${site_data}']}    ${agent_portal_data}
            END
        END
    END
# ============ CRM Verification - END ============ #
