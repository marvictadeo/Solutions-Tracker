*** Settings ***
Documentation        Global Keywords for Test Cases.
Library              Collections
Library              String
Library              DateTime
Library              Dialogs
Library              SeleniumLibrary
Library              FakerLibrary
Library              RPA.Excel.Files
Library              RPA.Tables
Resource             BA_Form_Variables.resource
Resource             Solution_Tracker_Portal_Keywords.resource


*** Keywords ***
Fill In Attachment And Project Owner And Stakeholders Fields
    [Documentation]    Fill In Attachment And Project Owner And Stakeholders Fields
    [Arguments]    ${sc_item}
    IF    "${sc_item}" == "Master Data" or "${sc_item}" == "User Acceptance Test (UAT) Verification" or "${sc_item}" == "User Testing"
        Wait Until Element Is Enabled    ${ATTACHMENT}    30s
        Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    ELSE IF    "${sc_item}" != "Templates"
        IF    "${sc_item}" == "Requirement Documentation" or "${sc_item}" == "Vision Document"
            Element Should Be Visible     //label[@for='attachment']/span[contains(text(),"*")]
        END
        Input Project Owner And Stakeholders Field
        Wait Until Element Is Enabled    ${ATTACHMENT}    30s
        Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    END

Input Project Owner And Stakeholders Field
    [Documentation]    Input Project Owner And Stakeholders Field
    Wait Until Element Is Visible    ${LBL_PROJECT_STAKEHOLDERS}    30s
    Input Text    ${TXT_PROJECT_STAKEHOLDERS}    Project Owner and Stakeholders CE

Fill In Requestor's Info [Requestor's Name, Division, Sub-division, Location]
    [Documentation]    Random Selection in Requestor's Info
    Input Text    ${REQUESTOR_NAME}    FACE BA Form Testing [INTERNAL QA]
    Select Random Option For "Customer Division And Sub-Division" Dropdown
    Select Random Option For "Customer Location" Dropdown

Fill In Request Info [Description, Priority]
    [Documentation]    Fill In Request Info [Description, Priority]
    [Arguments]    ${subdiv_item}    ${sc_item}    ${sr_item}
    # ${random_string}    Generate Random String
    # ${expected_title}    Set Variable    Internal QA Test BA - ${random_string}
    ${expected_title}    Set Variable    ${sc_item}
    # Input Text    ${SUBJECT}    ${expected_title}
    Input Text    ${DESCRIPTION}
    ...    Internal QA - FACE BA ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Requirement - ${sr_item}
    Select Random Option For "Priority" Dropdown
    Set Suite Variable    ${EXPECTED_TITLE}

Submit The Ticket
    [Documentation]    Submit The Ticket
    ${stat}    Run Keyword And Return Status
    ...    Wait Until Element Is Enabled    //button[@class="btn btn-primary"]    30s
    Retrieve All Entered Data In The Form
    IF    "${stat}" == "True"
        Click Element    //button[@class="btn btn-primary"]
        Wait Until Page Contains Element    //div[@class="datatable-body-cell-label"]    200s
        # Wait Until Page Contains Element    ${DATA_TABLE}    120s
        Get The Case Ticket Number In Ticket Viewer
    ELSE
        Set Test Variable    ${STR_CASE_NUM}    Failed
        Capture Page Screenshot
        Fail    Submit Button is Disabled
    END

Change Division
    [Arguments]    ${division}
    [Documentation]    Keyword to Change the Division
    Scroll "${DDL_DIVISION}" Into Center
    Wait Until Element Is Enabled    ${DDL_DIVISION}
    Wait Until Keyword Succeeds    3x    10s    Select From List By Label    ${DDL_DIVISION}    ${division}

Select Sub-Division
    [Arguments]    ${subdiv_item}
    [Documentation]    Keyword to Change Sub-division
    Set Test Variable    ${SUBDIV_VALUE}    ${DDL_SUBDIVISION}\[text()="${SPACE}${subdiv_item}${SPACE}"]
    Wait Until Element Is Enabled    ${DDL_SUBDIVISION}    120s
    Wait Until Keyword Succeeds    3x    10s    Select From List By Label    ${DDL_SUBDIVISION}    ${subdiv_item}

Select "${sc_item}" As Service Classification
    [Documentation]    Select the service classification
    ${stat}    Run Keyword And Return Status    Click Element    ${SC_VALUE}
    IF    "${stat}" == "False"
        Set Test Variable    ${SC_VALUE}    ${DDL_SC}\[text()="${SPACE}${sc_item}${SPACE}${SPACE}"]
        Wait Until Element Is Enabled    ${DDL_SC}    30s
        Run Keyword And Continue On Failure    Select Service Classification Value    ${sc_item}
    END

Select "${sr_item}" As Service Requirement
    [Documentation]    Select the service requirement
    IF    "${sr_item}" != "EMPTY"
        Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${SR_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_SR}   30s
            Run Keyword And Continue On Failure    Select Service Requirement Value    ${sr_item}
        END
    END

Select Service Classification Value
    [Arguments]    ${sc_item}
    [Documentation]    Keyword to Select Service Classification Value
    TRY
        Wait Until Element Is Enabled   ${DDL_SC}     30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SC}    ${sc_item}
    EXCEPT
        Wait Until Element Is Enabled   ${DDL_SC}     30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SC}    ${sc_item}
    END

Select Service Requirement Value
    [Arguments]    ${sr_item}
    [Documentation]    Keyword to Select Service Requirement Value
    TRY
        Wait Until Element Is Enabled    ${DDL_SR}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SR}    ${sr_item}
    EXCEPT
        Wait Until Element Is Enabled    ${DDL_SR}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SR}    ${sr_item}
    END

Check Create Page
    [Documentation]    Check Create Page
    ${stat}    Run Keyword And Return Status    Page Should Contain Element    ${DDL_DIVISION}
    IF    "${stat}" == "False"
        Click Element    //img[@class="header__logo-img"]
        Wait Until Page Contains Element    ${CREATE}
        Click Element    ${CREATE}
        Wait Until Page Contains Element    ${DDL_DIVISION}    60s
    END

Verify Master Data, Ticket Submission And Ticket Summary : FACE BA
    [Documentation]    Verify Ticket Creation And Master Data : FACE BA
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE BA    BA
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}

        #    ------- Fill In FACE BA Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE BA Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}   ${sr_item}
        ${excel_index}    Evaluate    ${count} + 2
        #    ------- Submit The Ticket -------
        Submit The Ticket
        Set Cell Value    ${excel_index}    4    ${STR_CASE_NUM}
        Save Workbook
        #    ------- VerifY Ticket Summary -------
        Run Keyword And Continue On Failure    Verify Ticket Summary Data
    END

Verify Master Data And Field Validation : FACE BA
    [Documentation]    Verify Ticket Creation And Master Data : FACE BA
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE BA    BA
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        #    ------- Fill In FACE BA Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE BA Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}   ${sr_item}
        ${excel_index}    Evaluate    ${count} + 2
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        Set Cell Value    ${excel_index}    4    ${STR_CASE_NUM}
        Save Workbook
    END

Verify Master Data And Ticket Submission With CRM Checking : FACE BA
    [Documentation]    Verify Master Data And Ticket Submission With CRM Checking : FACE BA
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE BA    BA
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}

        #    ------- Fill In FACE BA Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE BA Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}      ${sr_item}
        ${excel_index}    Evaluate    ${count} + 2
        #    ------- Submit The Ticket -------
        Submit The Ticket
        Open Workbook    ${MASTER_DATA}
        ${table}    Select A Worksheet    BA
        Set Cell Value    ${excel_index}    4    ${STR_CASE_NUM}
        Save Workbook
        #    ------- VerifY Ticket Summary -------
        Run Keyword And Continue On Failure
        ...    Verify Ticket Summary    ${subdiv_item}    ${sc_item}   ${sr_item}
        #    ------ Solution Tracker Portal Verifications ------
        Run Keyword And Continue On Failure    Get ST Ticket Number In Ticket Summary
        Verify The Ticket In Solution Tracker Portal    ${URL_ALL_CASES_FACE}    ${STR_CASE_NUM}
        Go Back And Switch To ST Form Page
    END

Fill In FACE BA Solution Tracker Form
    [Documentation]    Fill In FACE BA Solution Tracker form
    [Arguments]    ${subdiv_item}    ${sc_item}    ${sr_item}
    Change Division    Face Tribes (FACE)
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" As Service Classification
    #    Select "${st_item}" As Service Type
    Select "${sr_item}" As Service Requirement
    Fill In Requestor's Info [Requestor's Name, Division, Sub-division, Location]
    Fill In Request Info [Description, Priority]
    ...    ${subdiv_item}    ${sc_item}    ${sr_item}
    Fill In Attachment And Project Owner And Stakeholders Fields    ${sc_item}

Get Excel Data - FACE BA
    [Documentation]    Get Excel Data - FACE BA
    [Arguments]    ${sheet_name}
    Open Workbook       ${MASTER_DATA}
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    Sub-Division
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    Service Classification
#    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    Service Type
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    Service Requirement
#    ${BRAND}    Get Table Column    ${TABLE}    Brand
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
#    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}

Verify Ticket Summary
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

Retrieve All Entered Data In The Form
    [Documentation]    Get the information entered by the user in the form
    ${DICT_RETRIEVED_VALUES}    Create Dictionary
    FOR    ${field}    IN    @{LIST_TECH_ALL_FIELDS}
        IF    "${field}"=="Attachment" or "${field}"=="Subject"
            ${str_value}    Set Variable    Download
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
    [Documentation]    The information provided by the user in the ticket form should match the ticket summary details.
    Click Element    ${DATA_TABLE}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    FOR    ${field}    IN    @{LIST_TECH_ALL_FIELDS}
        ${field_exist}    Run Keyword And Return Status    Element Should Be Visible    ${DETAIL_${field}}
        IF    ${field_exist}==${False}
            Log    N/A
        ELSE
            ${actual_value}    Get Text    ${DETAIL_${field}}
            Run Keyword And Continue On Failure    Should Be Equal As Strings     ${DICT_RETRIEVED_VALUES}[${field}]    ${actual_value}
        END
    END

Navigate To Site
    [Documentation]    The user opens a browser and navigates to the site.
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window

Quit Browser
    [Documentation]    Closes browser after delay
    Sleep    0.5s
    Close All Browsers

Select A Worksheet
    [Documentation]    Keyword to open an excel file and select an active Worksheet
    [Arguments]    ${sheet_name}
    ${table}   Read Worksheet As Table    ${sheet_name}   header=True
    RETURN    ${table}

Restore Default Run On Failure
    [Documentation]    Keyword to restore function of run_on_failure in its original state
    Register Keyword To Run On Failure    Capture Page Screenshot

Wait Until Preloader Is Not Visible
    [Documentation]    Keyword to verify if preloader is not visible
    Register Keyword To Run On Failure   NONE
    ${get_stat}    Run Keyword And Return Status    Wait Until Page Contains Element    ${ICON_PRELOADER}
    IF    ${get_stat} == True
        FOR    ${counter}    IN RANGE    1    3
            ${loader_attr}    Get Element Attribute    ${ICON_PRELOADER}    ${ICON_PRELOADER_ATTR}
            ${get_loader_attr_stat}    Run Keyword And Return Status    Wait Until Page Does Not Contain Element    ${ICON_PRELOADER_ACTIVE}    30s
            ${get_loader_display}    Run Keyword And Return Status    Should Not Contain    ${loader_attr}    ${ICON_PRELOADER_VERIFY_ATTR}
            IF    ${get_loader_attr_stat} == True and ${get_loader_display} == True
                Restore Default Run On Failure
                BREAK
            END
        END
    END
    Restore Default Run On Failure

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
    Wait Until Preloader Is Not Visible
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
    Wait Until Preloader Is Not Visible
    TRY
        Click Element    ${element}
    EXCEPT
        Log    Catches any exception when clicking through an element.
    END
    Wait Until Preloader Is Not Visible

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

Select Random Option For "${field}" Dropdown
    [Documentation]    Select Random Option
    IF    "${field}" == "Customer Division And Sub-Division"
        ${selected_cust_div}    Random Element    ${LIST_FACE_DIVISION}
        Scroll "${DDL_CUST_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_CUST_DIVISION}    Face Tribes (FACE)

        ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        Scroll "${DDL_CUST_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_SUB_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_CUST_SUB_DIVISION}    FACE QUAL
    ELSE IF    "${field}" == "Customer Location"
        ${selected_location}    Random Element    ${LIST_LOCATION}
        Scroll "${DDL_CUST_LOCATION}" Into Center
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_CUST_LOCATION}     ET-VG1 (Empower Tribe VG1 Ltd.)
    ELSE IF    "${field}" == "Priority"
        ${selected_priority}    Random Element    ${LIST_PRIORITY}
        Scroll "${DDL_PRIORITY}" Into Center
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_PRIORITY}    ${selected_priority}
    ELSE IF    "${field}" == "Brand"
        ${selected_brand}    Random Element    ${LIST_BRANDS}
        Scroll "${DDL_BRAND}" Into Center
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_BRAND}    ${selected_brand}
    ELSE IF    "${field}" == "Model Code"
        Wait Until Keyword Succeeds    3x    1s    Select Random Option    ${DDL_MODEL_CODE}          ${DDL_MODEL_CODE}/option
    END

Select Random Option
    [Documentation]    Selects Random Option from the given (select) locator.
    [Arguments]    ${locator}   ${options}    ${except_list}=${SPACE}
    Scroll "${locator}" Into Center
    Wait Until Element Is Enabled    ${locator}      30s
    Click Element                    ${locator}
    ${selected}    Wait Until Keyword Succeeds    10x    0s    Select Then Check Exception List    ${locator}    ${options}    ${except_list}
    Log    Selected "${selected}" from the options of "${locator}".
    Press Keys    ${locator}    ESCAPE
    RETURN    ${selected}

Select Then Check Exception List
    [Documentation]    Selects Then Checks Exception List if selected value is valid. Throws error when invalid.
    [Arguments]    ${locator}    ${options}    ${except_list}
    ${index}    Get Random Index From Options    ${options}
    ${option_locator}  Set Variable  (${options})[${index + 2}]
    Set Test Variable    ${RANDOM_OPTION_LOCATOR}    ${option_locator}
    ${selected}    Get Text    ${option_locator}
    Select From List By Index    ${locator}    ${index + 1}
    ${except_list_len}    Get Length    ${except_list}
    IF    ${except_list_len} == ${0}    RETURN    ${selected}
    ${except_list}    Convert To List If Not    ${except_list}
    FOR    ${each}    IN    @{except_list}
        IF    "${selected}" == "${each}"    Fail    Selected value "${each}" is included in the exception list ${except_list}.
    END
    RETURN    ${selected}

Convert To List If Not
    [Documentation]    Convert To List If Not
    [Arguments]        ${variable}
    ${datatype}        Evaluate                   type($variable).__name__
    IF                 "${datatype}" != "list"
        ${variable}    Create List                ${variable}
    END
    RETURN             ${variable}

Get Random Index From Options
    [Documentation]    Gets random index from the length of locator. starts with 0 ends with option's length - 1.
    [Arguments]            ${locator}
    ${element_count}       Get "${locator}" Length
    IF    ${element_count} <= ${1}
        Capture Page Screenshot
        Fail    "${locator}" should have more than 1 option.
    END
    ${index}               Get Random Integer Range ${0} And ${element_count - 1}
    RETURN                 ${index}

Get "${locator}" Length
    [Documentation]    Gets WebElement's Length.
    ${elements}         Get WebElements        ${locator}
    ${length}           Get Length             ${elements}
    RETURN              ${length}

Get ST Ticket Number In Ticket Summary
    [Documentation]    Get The Ticket Number
    Wait Until Element Is Visible    //div[@class='ticket-details__header']/h4
    ${case_number}    Get Text    //div[@class='ticket-details__header']/h4
    ${str_case_num}    Remove String    ${case_number}    Ticket Number:${SPACE}
    Set Suite Variable    ${STR_CASE_NUM}

Get The Case Ticket Number In Ticket Viewer
    [Documentation]    Keyword to get the case ticket number in the ticket viewer details
    ${data_table_title}    Set Variable
    ...    //div[@class="datatable-body-cell-label"]/a[text()="${SPACE}${EXPECTED_TITLE}"]
    Wait Until Page Contains Element    ${data_table_title}    120s
    ${data_table_title}    Get Variable Value    ${data_table_title}
    ${data_table_case}    Set Variable    ${data_table_title}/preceding::datatable-body-cell[3]/div/a
    ${str_case_num}    Get Text    ${data_table_case}
    Set Suite Variable    ${STR_CASE_NUM}

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
