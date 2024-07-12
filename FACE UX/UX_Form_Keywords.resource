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
Resource             UX_Form_Variables.resource
Resource             Solution_Tracker_Portal_Keywords.resource


*** Keywords ***
Fill In Product Info And Other Fields
    [Documentation]    Fill In [BRAN and Attachment]
    #    -----    Upload Sample Attachment    ----
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}

Fill In Requestor's Info [Division, Sub-division, Location]
    [Documentation]    Random Selection in Requestor's Info
    Select Random Option For "Customer Division And Sub-Division" Dropdown
    Select Random Option For "Customer Location" Dropdown

Fill In Request Info [Description, Priority, Project Owner]
    [Documentation]    Fill In Request Info [Description, Priority, Project Owner]
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    #${random_text}    Generate Random String
    #${expected_title}    Set Variable    [Internal QA UX Form] - ${random_text}
    #Input Text    ${SUBJECT}    ${expected_title}
    ${expected_title}    Set Variable    ${sc_item}
    Input Text    ${DESCRIPTION}
    ...    Internal QA - FACE UXUI ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
    Select Random Option For "Priority" Dropdown
    Input Text    ${PROJECT_OWNER}    FACE UX Form Project Owner yjv
    Set Suite Variable    ${EXPECTED_TITLE}

Change Division
    [Arguments]    ${division}
    [Documentation]    Keyword to Change the Division
    Scroll "${DDL_DIVISION}" Into Center
    Wait Until Element Is Enabled    ${DDL_DIVISION}
    Wait Until Keyword Succeeds    3x    10s   Select From List By Label    ${DDL_DIVISION}    ${division}

Select Sub-Division
    [Arguments]    ${subdiv_item}
    [Documentation]    Keyword to Change Sub-division
    Set Test Variable    ${SUBDIV_VALUE}    ${DDL_SUBDIVISION}\[text()="${SPACE}${subdiv_item}${SPACE}"]
    Wait Until Element Is Enabled    ${DDL_SUBDIVISION}    30s
    Wait Until Keyword Succeeds    3x    10s    Select From List By Label    ${DDL_SUBDIVISION}    ${subdiv_item}

Select "${sc_item}" As Service Classification
    [Documentation]    Select the service classification
    ${stat}    Run Keyword And Return Status    Click Element    ${SC_VALUE}
    IF    "${stat}" == "False"
        Set Test Variable    ${SC_VALUE}    ${DDL_SC}\[text()="${SPACE}${sc_item}${SPACE}${SPACE}"]
        Wait Until Element Is Enabled    ${DDL_SC}    30s
        Run Keyword And Continue On Failure    Select Service Classification Value    ${sc_item}
    END

Select "${st_item}" As Service Type
    [Documentation]    Select the service type
    IF    "${st_item}" != "EMPTY"
        Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[text()="${SPACE}${st_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${ST_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${ST_VALUE}    ${DDL_ST}\[text()="${SPACE}${st_item}${SPACE}${SPACE}"]
            # Run Keyword And Continue On Failure    Click Element    ${ST_VALUE}
            Wait Until Element Is Enabled     ${DDL_ST}   30s
            Run Keyword And Continue On Failure    Select Service Type Value    ${st_item}
        END
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

Select "${brand_item}" As Brand
    [Documentation]    Select the service requirement
    IF    "${brand_item}" != "EMPTY"
        Set Test Variable    ${BRAND_VALUE}    ${DDL_BRAND}\[text()="${SPACE}${brand_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${BRAND_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${BRAND_VALUE}    ${DDL_BRAND}\[text()="${SPACE}${brand_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_BRAND}   30s
            Run Keyword And Continue On Failure    Select Brand Value    ${brand_item}
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

Select Service Type Value
    [Arguments]    ${st_item}
    [Documentation]    Keyword to Select Service Type Value
    TRY
        Wait Until Element Is Enabled    ${DDL_ST}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_ST}    ${st_item}
    EXCEPT
        Wait Until Element Is Enabled    ${DDL_ST}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_ST}    ${st_item}
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

Select Brand Value
    [Arguments]    ${brand_item}
    [Documentation]    Keyword to Select Brand Value
    TRY
        Wait Until Element Is Enabled    ${DDL_BRAND}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_BRAND}    ${brand_item}
    EXCEPT
        Wait Until Element Is Enabled    ${DDL_BRAND}    30s
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_BRAND}    ${brand_item}
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

Verify Ticket Submission And Correctness Of Data : FACE UXUI
    [Documentation]    Verify Ticket Creation And Master Data : FACE UXUI
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE UX    UXUI
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${brand_item}    Get From List    ${BRAND}    ${index}
        Set Test Variable    ${SC_ITEM}

        #    ------- Fill In FACE UXUI Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE UXUI Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
        ${excel_index}    Evaluate    ${count} + 2

        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        # IF    "${excel_index}" == "3"
        #    Set Cell Value    7    5    ${STR_CASE_NUM}
        # END
        Set Cell Value    ${excel_index}    6    ${STR_CASE_NUM}
        Save Workbook
        #    ------- VerifY Ticket Summary -------
        Run Keyword And Continue On Failure    Verify Ticket Summary Data
        #    ------- Verify CRM Data -------------
        Run Keyword And Continue On Failure    FACE UXUI: Verify CRM Data
    END

Verify Master Data And Ticket Submission With CRM Checking : FACE UX
    [Documentation]    Verify Master Data And Ticket Submission With CRM Checking : FACE UX
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE UX    UX
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${brand_item}    Get From List    ${BRAND}   ${index}
        IF    "${st_item}" != "EMPTY"
            ${expected_title}    Catenate    ${sr_item}    ${st_item}    ${sc_item}
        ELSE
            ${expected_title}    Catenate    ${sr_item}   ${sc_item}
        END

        #    ------- Fill In FACE UX Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE UX Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        #    ------- Verify Ticket Viewer -------
        Run Keyword And Continue On Failure    Verify Ticket Title In The "Ticket Viewer"    ${expected_title}
        #    ------- VerifY Ticket Summary -------
        Run Keyword And Continue On Failure
        ...    Verify Ticket Summary    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}

        #    ------ Solution Tracker Portal Verifications ------
        Run Keyword And Continue On Failure    Get ST Ticket Number In Ticket Summary
        Verify The Ticket In Solution Tracker Portal    ${URL_ALL_CASES_FACE}    ${STR_CASE_NUM}
        Verify The Automated Ticket Title     ${STR_CASE_NUM}   ${sr_item}    ${st_item}    ${sc_item}
        Go Back And Switch To ST Form Page
    END

Verify Master Data And Field Validation : FACE UX
    [Documentation]    Verify Master Data And Field Validation : FACE UX
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE UX    UXUI
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${brand_item}    Get From List    ${BRAND}   ${index}

        #    ------- Fill In FACE UXUI Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE UX Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
        ${excel_index}    Evaluate    ${count} + 2
        #    ------- Submit The Ticket -------
        Submit The Ticket
        # IF    "${excel_index}" == "3"
        #    Set Cell Value    7    5    ${STR_CASE_NUM}
        # END
        Set Cell Value    ${excel_index}    6    ${STR_CASE_NUM}
        Save Workbook
    END

Submit The Ticket
    [Documentation]    Submit The Ticket
    ${stat}    Run Keyword And Return Status
    ...    Wait Until Element Is Enabled    //button[@class="btn btn-primary"]    30s
    Retrieve All Entered Data In The Form
    IF    "${stat}" == "True"
        Click Element    //button[@class="btn btn-primary"]
        Wait Until Page Contains Element    //div[@class="datatable-body-cell-label"]    120s
        #Wait Until Page Contains Element    ${DATA_TABLE}    120s
        Get The Case Ticket Number In Ticket Viewer
    ELSE
        Set Test Variable    ${STR_CASE_NUM}    Failed
        Capture Page Screenshot
        Fail    Submit Button is Disabled
    END

Retrieve All Entered Data In The Form
    [Documentation]    Get the information entered by the user in the form
    ${DICT_RETRIEVED_VALUES}    Create Dictionary
    FOR    ${field}    IN    @{LIST_UXUI_ALL_FIELDS}
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
    [Documentation]    The information provided by the user in the ticket form should match the ticket summary details.
    Wait Until Element Is Visible    ${DATA_TABLE}    120s
    Click Element    ${DATA_TABLE}
    Wait Until Page Contains Element    //div[contains(text(),'Ticket Info')]
    FOR    ${field}    IN    @{LIST_UXUI_ALL_FIELDS}
        ${field_exist}    Run Keyword And Return Status    Element Should Be Visible    ${DETAIL_${field}}
        IF    ${field_exist}==${False}
            Log    N/A
        ELSE
            ${actual_value}    Get Text    ${DETAIL_${field}}
            Run Keyword And Continue On Failure    Should Be Equal As Strings     ${DICT_RETRIEVED_VALUES}[${field}]    ${actual_value}
        END
    END

FACE UXUI: Verify CRM Data
    [Documentation]    Keyword to verify data in the CRM
    ${get_stat}    Run Keyword And Return Status    Switch Window    title=Search - Dynamics 365
    IF    "${get_stat}" == "False"
        Go To Agent Portal
    ELSE
        Log    Switched to CRM Page.
    END
    Login To Agent Portal
    Go To Agent Portal Ticket Details    ${STR_CASE_NUM}
    Run Keyword And Continue On Failure    FACE UXUI : Compare Data In CRM    ${LIST_CRM_SUMMARY_TAB}    Summary Tab
    Run Keyword And Continue On Failure    FACE UXUI : Compare Data In CRM    ${LIST_CRM_DETAILED_INFO_TAB}    Detailed Information Tab
    Run Keyword And Continue On Failure    Go Back And Switch To ST Form Page

FACE UXUI : Compare Data In CRM
    [Documentation]    The information provided by the user in the ticket form should match the ticket summary details.
    [Arguments]    ${list}    ${tab}=none
    Wait Until Element Is Visible    //h1[@title='${STR_CASE_NUM}']    120s
    IF    "${tab}"=="Detailed Information Tab"    Click Element    //li[@aria-label='Detailed Information']
    FOR    ${field}    IN    @{list}
        IF    "${field}"=="Priority" or "${field}"=="Description"
            ${actual_value}    Run Keyword And Continue On Failure    Get Text    ${CRM_DETAIL_${field}}
            Run Keyword And Continue On Failure    Should Be Equal As Strings     ${DICT_RETRIEVED_VALUES}[${field}]    ${actual_value}
        ELSE IF    "${field}"=="Attachment"
            ${actual_value}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute    ${CRM_DETAIL_${field}}    title
            Run Keyword And Continue On Failure    Should Contain    ${actual_value}     Jpg_Img_Photo.jpg
        ELSE
            ${actual_value}    Run Keyword And Continue On Failure    Scroll To Element And Get Element Attribute    ${CRM_DETAIL_${field}}    title
            IF    "${field}"=="Case Number"
                Run Keyword And Continue On Failure    Should Be Equal As Strings     ${STR_CASE_NUM}    ${actual_value}
            ELSE
                Run Keyword And Continue On Failure    Should Be Equal As Strings     ${DICT_RETRIEVED_VALUES}[${field}]    ${actual_value}
            END
        END
    END

Scroll To Element And Get Element Attribute
    [Documentation]    Keyword to scroll to element and get text
    [Arguments]    ${locator}    ${attribute}
    Scroll "${locator}" Into Center
    Wait Until Page Contains Element    ${locator}    20s
    ${value}    Get Element Attribute    ${locator}    ${attribute}
    RETURN    ${value}

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

Go To Agent Portal
    [Documentation]    Keyword to redirect the user to Agent Portal
    Scroll And Click The Element    ${BTN_AGENT_PORTAL}
    ${get_stat_1}    Run Keyword And Return Status    Switch Window    title=${TAB_NAME_LOGIN}    timeout=2s
    Go To    ${UAT_CRM_V2}

Go To Agent Portal Ticket Details
    [Documentation]    Keyword to get the agent portal ticket details
    [Arguments]    ${case_num}
    Wait Until Page Contains Element    ${UAT_SEARCH_ICON}    30s
    Click Element    ${UAT_SEARCH_ICON}
    Wait Until Page Contains Element    ${CRM_GLOBAL_SEARCH_BOX}    120s
    Input Text    ${CRM_GLOBAL_SEARCH_BOX}    ${case_num}
    Click Element    ${SEARCH_BOX_ICON}
    Set Test Variable    ${SEARCHED_CASE_NUM}    //span[text()='${case_num}'][1]
    Wait Until Page Contains Element    ${SEARCHED_CASE_NUM}    30s
    Click Element    ${SEARCHED_CASE_NUM}

Get The Case Ticket Number In Ticket Viewer
    [Documentation]    Keyword to get the case ticket number in the ticket viewer details
    ${data_table_title}    Set Variable
    ...    //div[@class="datatable-body-cell-label"]/a[text()="${SPACE}${EXPECTED_TITLE}"]
    Wait Until Page Contains Element    ${data_table_title}    120s
    ${data_table_title}    Get Variable Value    ${data_table_title}
    ${data_table_case}    Set Variable    ${data_table_title}/preceding::datatable-body-cell[3]/div/a
    ${str_case_num}    Get Text    ${data_table_case}
    Set Suite Variable    ${STR_CASE_NUM}

Fill In FACE UXUI Solution Tracker Form
    [Documentation]    Fill In FACE UX Solution Tracker form
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${brand_item}
    Change Division    Face Tribes (FACE)
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" As Service Classification
    Select "${st_item}" As Service Type
    Select "${sr_item}" As Service Requirement
    Select "${brand_item}" As Brand
    Fill In Requestor's Info [Division, Sub-division, Location]
    Fill In Request Info [Description, Priority, Project Owner]
    ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}
    Fill In Product Info And Other Fields

Get Excel Data - FACE UX
    [Documentation]    Get Excel Data - FACE UX
    [Arguments]    ${sheet_name}
    Open Workbook       ${MASTER_DATA}
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    Sub-Division
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    Service Classification
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    Service Type
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    Service Requirement
    ${BRAND}    Get Table Column    ${TABLE}    Brand
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}
    Set Test Variable    ${BRAND}

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
        Scroll "${DDL_CUSTOMER LOCATION}" Into Center
        Wait Until Keyword Succeeds    3x    10s
        ...    Select From List By Label    ${DDL_CUSTOMER LOCATION}    ${selected_location}
    ELSE IF    "${field}" == "Priority"
        ${selected_priority}    Random Element    ${LIST_PRIORITY}
        Scroll "${DDL_PRIORITY}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_PRIORITY}    ${selected_priority}
    ELSE IF    "${field}" == "Brand"
        ${selected_brand}    Random Element    ${LIST_BRANDS}
        Scroll "${DDL_BRAND}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_BRAND}    ${selected_brand}
        Log    Brand
    END

Get ST Ticket Number In Ticket Summary
    [Documentation]    Get The Ticket Number
    Wait Until Element Is Visible    //div[@class='ticket-details__header']/h4
    ${case_number}    Get Text    //div[@class='ticket-details__header']/h4
    ${str_case_num}    Remove String    ${case_number}    Ticket Number:${SPACE}
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