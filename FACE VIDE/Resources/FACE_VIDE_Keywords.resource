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

Verify Ticket Creation For FACE VIDE
    [Documentation]    Ticket Creation - FACE VIDE
    The User Is On The Solution Tracker
    FACE VIDE: Ticket Submission

The User Accessed The FACE VIDE Data
    [Documentation]    Keyword to open the about page workbook
    [Arguments]    ${sheet_name}
    Open Workbook       ${FACE_VIDE_DATA}    read_only=True
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}

FACE VIDE: Ticket Submission
    [Documentation]    Keyword to fill in details and submit ticket using the master data
    FACE VIDE: Get Excel Data
    ${length}    Get Length    ${SUB_DIVISION}
    # FOR    ${count}    IN RANGE    ${length}
    FOR    ${count}    IN RANGE    1    2
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        #    ------- Fill In FACE VIDE Form -------
        Run Keyword And Continue On Failure    FACE VIDE: Fill In Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        #    ------- Verify Ticket Viewer -------
        Run Keyword And Continue On Failure    Verify Ticket Viewer Details
        #    ------- Verify Ticket Summary -------
        Run Keyword And Continue On Failure    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
        Scroll "${BTN_CREATE_A_TICKET}" Into Center
        Click Element    ${BTN_CREATE_A_TICKET}
    END

FACE VIDE: Get Excel Data
    [Documentation]    Keyword to get excel data for FACE VIDE
    The User Accessed The FACE VIDE Data    ${SHEET_FACE_VIDE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    ${CO_SUB_DIVISION}
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    ${CO_SERVICE_CLASSIFICATION}
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    ${CO_SERVICE_TYPE}
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    ${CO_SERVICE_REQUIREMENT}
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}

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
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_CUST_DIVISION}    ${selected_cust_div}

        ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        Scroll "${DDL_CUST_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_SUB_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_CUST_SUB_DIVISION}    ${selected_cust_subdiv}
        Set Test Variable    ${SELECTED_CUST_SUBDIV}
    ELSE IF    "${field}" == "Customer Location"
        ${selected_location}    Random Element    ${LIST_LOCATION}
        Scroll "${DDL_CUST_LOCATION}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_CUST_LOCATION}    ${selected_location}
        Set Test Variable    ${SELECTED_LOCATION}
    ELSE IF    "${field}" == "Priority"
        ${selected_priority}    Random Element    ${LIST_PRIORITY}
        Scroll "${DDL_PRIORITY}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_PRIORITY}    ${selected_priority}
        Set Test Variable    ${SELECTED_PRIORITY}
    END

Fill In Request Information
    [Documentation]    Fill In Request Info [Subject, Description, Priority, Type of Output, Library Upload, Attachment, File Link]
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    #    --- Subject ---
    ${get_current_date_and_time}    Get Current Date    result_format=%m-%d-%Y %H:%M:%S
    ${INPUT_SUBJ}    Catenate    ${INPUT_SUBJECT}${SPACE}${get_current_date_and_time}
    Set Test Variable    ${INPUT_SUBJ}
    Input Text    ${SUBJECT}    ${INPUT_SUBJ}
    #    --- Description ---
    Input Text    ${DESCRIPTION}
    ...    ${INPUT_SUBJ} ${\n}Sub-Division - ${subdiv_item} ${\n}Service Classification - ${sc_item}${\n}${\n}Service Type - ${st_item} ${\n}Service Requirement - ${sr_item}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    #    --- Attachment(s) ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}

FACE VIDE: Fill In Solution Tracker Form
    [Documentation]    Keyword to fill in FACE VIDE Solution Tracker Form
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Select A Division   ${DIV_VALUE}
    Select A Sub-Division    ${subdiv_item}
    Select A Service Classification    ${sc_item}
    Select A Service Type    ${st_item}
    Select A Service Requirement    ${sr_item}
    Fill In Customer's Info [Division, Sub-division, Location]
    Fill In Request Information   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}

Submit The Ticket
    [Documentation]    Submit The Ticket
    ${expected_title}    Get Variable Value    ${INPUT_SUBJ}
    ${stat}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[contains(text(),'Submit')]
    IF    "${stat}" == "True"    Scroll And Click The Element    ${BTN_SUBMIT}

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

Verify Case Ticket Summary In CRM For FACE VIDE
    [Documentation]    Keyword to verify ticket creation and CRM Details for FACE VIDE
    ${ticket_info_details}    FACE VIDE: Get Ticket Info Summary
    Verify Ticket Details In Agent Portal   ${ticket_info_details}
    # FACE VIDE: Ticket Submission With CRM Checking

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

Go To Agent Portal
    [Documentation]    Keyword to redirect the user to Agent Portal
    Scroll And Click The Element    ${BTN_AGENT_PORTAL}
    ${get_stat_1}    Run Keyword And Return Status    Switch Window    title=${TAB_NAME_LOGIN}    timeout=2s
    IF    "${get_stat_1}" != "True"
        ${get_stat_2}    Run Keyword And Return Status    Switch Window    title=${UAT_TAB_NAME_AGENT_PORTAL}    timeout=2s
        IF    "${get_stat_2}" != "True"
            ${get_stat_2}    Run Keyword And Return Status    Switch Window    title=${PROD_TAB_NAME_AGENT_PORTAL}    timeout=2s
        END
    END

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
