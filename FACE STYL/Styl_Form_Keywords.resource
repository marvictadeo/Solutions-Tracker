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
Resource             Solution_Tracker_Portal_Keywords.resource


*** Keywords ***
Fill In Customer's Info [Division, Sub-division, Location]
    [Documentation]    Random Selection in Customer's Info
    Select Random Option For "Customer Division And Sub-Division" Dropdown
    Select Random Option For "Customer Location" Dropdown

Fill In Request Information
    [Documentation]    Fill In Request Info [Priority, Subject, Description, Type of Output, Required File Format,
    ...                                      Required Color, Academy Upload, Attachment, File Link]
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}

    #    --- Subject ---
    Input Text    ${SUBJECT}    Internal QA Test STYL
    #    --- Description ---
    Input Text    ${DESCRIPTION}
    ...    Internal QA - FACE TECH ${\n} Sub-Division - ${subdiv_item} ${\n} Service Classification - ${sc_item} ${\n} ${\n} Service Type - ${st_item} ${\n} Service Requirement - ${sr_item}
    #    --- Priority ---
    Select Random Option For "Priority" Dropdown
    IF   "${sc_item}" == "Company Chops/E-Chops"
        #    --- Required File Format ---
        Input Text    ${TXT_FILE_FORMAT}    PNG
        #    --- Required Color ---
        Input Text    ${TXT_REQUIRED_COLOR}    RED
    ELSE IF    "${sc_item}" == "Documents"
        #    --- Type of Output ---

        IF   "${st_item}" == "Forms and Other Documents - Type B"
            Select Random Option For "Type Of Output - B" Dropdown
        ELSE
            Select Random Option For "Type Of Output - A" Dropdown
        END
        #    --- Academy Upload ---
        Wait Until Element Is Enabled    ${ACADEMY_UPLOAD}    30s
        ${RAD_BTN_ACADEMY_UPLOAD}    Get WebElements    ${ACADEMY_UPLOAD}
        ${RANDOM_BTN}    Random Element        ${RAD_BTN_ACADEMY_UPLOAD}
        Click Element    ${RANDOM_BTN}
    END
    #    --- Attachment(s) ---
    Wait Until Element Is Enabled    ${ATTACHMENT}    30s
    Choose File    ${ATTACHMENT}    ${JPG_IMAGE_SAMPLE}
    #    --- File Link ---
    Input Text    ${TXT_FILE_LINK}    https://www.learningcontainer.com/wp-content/uploads/2020/08/Sample-Webp-File-for-Testing-1.webp
    #    Pause Execution

Submit The Ticket
    [Documentation]    Submit The Ticket
    ${stat}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[@class="btn btn-primary"]    30s
    IF    "${stat}" == "True"
        Click Element    //button[@class="btn btn-primary"]
        Wait Until Page Contains Element    ${DATA_TABLE}    120s
    END

Change Division
    [Arguments]    ${division}
    [Documentation]    Keyword to Change the Division
    Scroll "${DDL_DIVISION}" Into Center
    Wait Until Element Is Enabled    ${DDL_DIVISION}    30s
    Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_DIVISION}    ${division}

Select Sub-Division
    [Arguments]    ${subdiv_item}
    [Documentation]    Keyword to Change Sub-division
    Set Test Variable    ${SUBDIV_VALUE}    ${DDL_SUBDIVISION}\[text()="${SPACE}${subdiv_item}${SPACE}"]
    Wait Until Element Is Enabled    ${DDL_SUBDIVISION}    30s
    Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SUBDIVISION}    ${subdiv_item}

Select "${sc_item}" As Service Classification
    [Documentation]    Select the service classification
    ${not_empty}    Run Keyword And Return Status    Should Not Be Equal As Strings    ${sc_item}    EMPTY
    IF    ${not_empty}
        Set Test Variable    ${SC_VALUE}    ${DDL_SC}\[text()="${SPACE}${sc_item}${SPACE}${SPACE}"]
        Wait Until Element Is Enabled    ${DDL_SC}    30s
        Run Keyword And Continue On Failure    Select Service Classification Value    ${sc_item}
    END

Select "${st_item}" As Service Type
    [Documentation]    Select the service type
    ${not_empty}    Run Keyword And Return Status    Should Not Be Equal As Strings    ${st_item}    EMPTY
    IF    ${not_empty}
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
    ${not_empty}    Run Keyword And Return Status    Should Not Be Equal As Strings    ${sr_item}    EMPTY
    IF    ${not_empty}
        Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${SR_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${SR_VALUE}    ${DDL_SR}\[text()="${SPACE}${sr_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_SR}   30s
            Run Keyword And Continue On Failure    Select Service Requirement Value    ${sr_item}
        END
    END

Select "${scat_item}" As Service Category
    [Documentation]    Select the service category
    ${not_empty}    Run Keyword And Return Status    Should Not Be Equal As Strings    ${scat_item}    EMPTY
    IF    ${not_empty}
        Set Test Variable    ${SCAT_VALUE}
        ...    ${DDL_SCAT}\[text()="${SPACE}${scat_item}${SPACE}"]
        ${stat}    Run Keyword And Return Status    Click Element    ${SCAT_VALUE}
        IF    "${stat}" == "False"
            Set Test Variable    ${SCAT_VALUE}
            ...    ${DDL_SCAT}\[text()="${SPACE}${scat_item}${SPACE}${SPACE}"]
            Wait Until Element Is Enabled     ${DDL_SCAT}   30s
            Run Keyword And Continue On Failure    Select Service Category Value    ${scat_item}
        END
    END

Select Service Classification Value
    [Arguments]    ${sc_item}
    [Documentation]    Keyword to Select Service Classification Value
    TRY
        Wait Until Element Is Visible    ${DDL_SC}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_SC}    ${sc_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_SC}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_SC}    ${sc_item}
    END

Select Service Type Value
    [Arguments]    ${st_item}
    [Documentation]    Keyword to Select Service Type Value
    TRY
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Value    ${DDL_ST}    ${st_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_ST}
        Wait Until Keyword Succeeds    3x    1s    Select From List By Label    ${DDL_ST}    ${st_item}
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

Select Service Category Value
    [Arguments]    ${scat_item}
    [Documentation]    Keyword to Select Service Requirement Value
    TRY
        Wait Until Element Is Visible    ${DDL_SCAT}
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Value    ${DDL_SCAT}    ${scat_item}
    EXCEPT
        Wait Until Element Is Visible    ${DDL_SCAT}
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_SCAT}    ${scat_item}
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

Verify Master Data And Ticket Submission : FACE STYL
    [Documentation]    Verify Ticket Creation And Master Data : FACE TECH
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE STYL    STYL
    ${length}    Get Length    ${SUB_DIVISION}
    Pause Execution
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${scat_item}    Get From List    ${SERVICE_CATEGORY}    ${index}
        #    ------- Fill In FACE TECH Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE STYL Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}     ${scat_item}
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        #    ------- Verify Ticket Summary -------
        Run Keyword And Continue On Failure
        ...    Verify Ticket Summary
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}
    END

Verify Master Data And Ticket Submission With CRM Checking : FACE STYL
    [Documentation]    Verify Master Data And Ticket Submission With CRM Checking : FACE TECH
    Check Create Page
    #    ----- Change Excel Sheet Name -----
    Get Excel Data - FACE STYL    STYL
    ${length}    Get Length    ${SUB_DIVISION}
    FOR    ${count}    IN RANGE    ${length}
        ${index}    Evaluate    ${count} - 1
        ${subdiv_item}    Get From List    ${SUB_DIVISION}    ${index}
        ${sc_item}    Get From List    ${SERVICE_CLASSIFICATION}    ${index}
        ${st_item}    Get From List    ${SERVICE_TYPE}    ${index}
        ${sr_item}    Get From List    ${SERVICE_REQUIREMENT}    ${index}
        ${scat_item}    Get From List    ${SERVICE_CATEGORY}    ${index}

        #    ------- Fill In FACE TECH Form -------
        Check Create Page
        Run Keyword And Continue On Failure    Fill In FACE STYL Solution Tracker Form
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}
        #    ------- Submit The Ticket -------
        Run Keyword And Continue On Failure    Submit The Ticket
        #    ------ Verify Ticket Summary ------
        Run Keyword And Continue On Failure
        ...    Verify Ticket Summary
        ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}
        #    ------ Verify Ticket In ST Portal ------
        Run Keyword And Continue On Failure    Get ST Ticket Number In Ticket Summary
        Verify The Ticket In Solution Tracker Portal    ${URL_ALL_CASES_FACE}    ${STR_CASE_NUM}
        Go Back And Switch To ST Form Page
    END

Fill In FACE STYL Solution Tracker Form
    [Documentation]    Fill In FACE TECH Solution Tracker form
    [Arguments]    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}
    Change Division    Face Tribes (FACE)
    Select Sub-Division    ${subdiv_item}
    Select "${sc_item}" As Service Classification
    Select "${st_item}" As Service Type
    Select "${sr_item}" As Service Requirement
    Select "${scat_item}" As Service Category
    Fill In Customer's Info [Division, Sub-division, Location]
    Fill In Request Information
    ...    ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}

Get Excel Data - FACE STYL
    [Documentation]    Get Excel Data - FACE STYL
    [Arguments]    ${sheet_name}
    Open Workbook       ${MASTER_DATA}    read_only=True
    ${table}    Select A Worksheet    ${sheet_name}
    Set Test Variable    ${TABLE}
    ${SUB_DIVISION}    Get Table Column    ${TABLE}    Sub-Division
    ${SERVICE_CLASSIFICATION}    Get Table Column    ${TABLE}    Service Classification
    ${SERVICE_TYPE}    Get Table Column    ${TABLE}    Service Type
    ${SERVICE_REQUIREMENT}    Get Table Column    ${TABLE}    Service Requirement
    ${SERVICE_CATEGORY}    Get Table Column    ${TABLE}    Service Category
    Set Test Variable    ${SUB_DIVISION}
    Set Test Variable    ${SERVICE_CLASSIFICATION}
    Set Test Variable    ${SERVICE_TYPE}
    Set Test Variable    ${SERVICE_REQUIREMENT}
    Set Test Variable    ${SERVICE_CATEGORY}

Verify Ticket Summary
    [Arguments]   ${subdiv_item}    ${sc_item}    ${st_item}    ${sr_item}    ${scat_item}
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
        IF    "${scat_item}" != "EMPTY"
            ${SR_RESULT}    Set Variable    //span[contains(text(),'Service Requirement:')]//following-sibling::strong[contains(text(),"${scat_item.strip()}")]
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
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_CUST_DIVISION}    ${selected_cust_div}

        ${selected_cust_subdiv}    Random Element    ${LIST_${selected_cust_div}_SUB_DIV}
        Scroll "${DDL_CUST_SUB_DIVISION}" Into Center
        Wait Until Element Is Enabled    ${DDL_CUST_SUB_DIVISION}    30s
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_CUST_SUB_DIVISION}    ${selected_cust_subdiv}
    ELSE
        ${selected_item}    Random Element    ${LIST_${field}}
        Scroll "${DDL_${field}}" Into Center
        Wait Until Keyword Succeeds    3x    1s
        ...    Select From List By Label    ${DDL_${field}}    ${selected_item}
        Set Suite Variable    ${SELECTED_ITEM}
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