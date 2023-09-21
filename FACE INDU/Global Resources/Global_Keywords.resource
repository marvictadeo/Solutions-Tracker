*** Settings ***
Documentation        Global Keywords for Test Cases.
Library              Collections
Library              String
Library              Dialogs
Library              SeleniumLibrary
Library              FakerLibrary
Library              RPA.HTTP
Library              RPA.Tables
Library              RPA.Excel.Files
Resource             Global_Variables.resource

*** Keywords ***
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



# ================================================================================ #
# ---------------------- KEYWORDS THAT USE JAVASCRIPTS (JS) ---------------------- #
# ================================================================================ #

The "${element}" Is Clicked Using Javascript
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

Wait Until All Elements Are Visible
    [Documentation]    Keyword to Verify if All the elements are visible
    ...    Use if to many elements on to be checked on the page
    [Arguments]    ${list_of_elements}
    FOR    ${element}    IN    @{list_of_elements}
        Wait Until Element Is Visible    ${element}
    END

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
    ELSE    # locator is xpath
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

Get Random Integer Range ${start_int} And ${end_int}
    [Documentation]    Get Random Integer Range ${start_int} and ${end_int}. range(${start_int}, ${end_int})
    ${result}    Evaluate              random.sample(range(${start_int}, ${end_int}), 1)    random
    ${number}    Get From List         ${result}    0
    ${number}    Convert To Integer    ${number}
    RETURN       ${number}

Get "${locator}" Length
    [Documentation]    Gets WebElement's Length.
    ${elements}         Get WebElements        ${locator}
    ${length}           Get Length             ${elements}
    RETURN              ${length}

Get Random Element From ${locator}
    [Documentation]    Gets random element from the given locator using this format: (${locator})[random_index].
    ${element_count}       Get "${locator}" Length
    TRY
        ${index}               Get Random Integer Range ${1} And ${element_count + 1}
    EXCEPT     	Evaluating expression 'random.sample(range(1, 1), 1)' failed: ValueError: Sample larger than population or is negative
        ${index}               Get Random Integer Range ${0} And ${element_count + 1}
    END
    Set Test Variable      ${RANDOM_ELEMENT}          (${locator})[${index}]
    Set Test Variable      ${RANDOM_INDEX}    ${index}
    RETURN                 ${RANDOM_ELEMENT}

Click Element Then Show
    [Documentation]    Clicks Element Then Waits an element to be Visible
    [Arguments]    ${locator_click}    ${locator_show}    ${wait_time}=3s
    ${notShown}    Run Keyword And Return Status    Element Should Not Be Visible    ${locator_show}
    IF    ${notShown} == ${False}    RETURN
    Scroll "${locator_click}" Into Center
    Wait Until Keyword Succeeds    3x    1s    Click Element    ${locator_click}
    Wait Until Element Is Visible    ${locator_show}    ${wait_time}

Convert To List If Not
    [Documentation]    Convert To List If Not
    [Arguments]        ${variable}
    ${datatype}        Evaluate                   type($variable).__name__
    IF                 "${datatype}" != "list"
        ${variable}    Create List                ${variable}
    END
    RETURN             ${variable}

Reload And Wait Until Page Is Loaded
    [Documentation]    Reload And Wait Until Page Is Loaded
    Reload Page
    Sleep    2s
    Wait Until Page Does Not Contain Element    ${PAGE_LOADER}    ${MAX_TIMEOUT}

WebElements Length Should Be Equal As Integers
    [Documentation]    Verififes WebElements' Length if Equal As Integers
    [Arguments]    ${locator}         ${expected_length}
    ${elements}    Get WebElements    ${locator}
    ${length}      Get Length         ${elements}
    Should Be Equal As Integers       ${expected_length}    ${length}    msg=WebElements Length Should Be ${expected_length} but found ${length}.

Wait Until Page Does Not Contain The Pre-Loaders
    [Documentation]   Keyword to wait until page doesn't contain preloaders
    Wait Until Element Is Not Visible           ${SPINNER}       ${MAX_TIMEOUT}
    Run Keyword And Ignore Error                Wait Until Page Does Not Contain Element    ${APP_LOADER_V2}    ${MAX_TIMEOUT}
    Wait Until Page Does Not Contain Element    ${APP_LOADER}    ${MAX_TIMEOUT}    error=Timeout exception is thrown. The spinner modal took longer to load than usual.

Wait Until Page Is Loaded
    [Documentation]    Waits Until Page Is Loaded
    [Arguments]        ${loadcomplete_timeout}=${MAX_TIMEOUT}
    Wait Until Page Does Not Contain The Pre-Loaders
    ${loader_is_visible}    Run Keyword And Return Status    Wait Until Page Contains Element                ${PAGE_LOADER}            3s
    IF    ${loader_is_visible}     Wait Until Page Does Not Contain Element        ${PAGE_LOADER}            ${loadcomplete_timeout}    error=Timeout exception is thrown. The spinner modal took longer to load than usual.

Mouse Hover And Click "${ELEMENT}" Element
    [Documentation]    Mouse Hover And Click Element
    Wait Until Element Is Visible     ${ELEMENT}    ${MAX_TIMEOUT}
    Mouse Over            ${ELEMENT}
    Wait Until Element Is Visible     ${ELEMENT}    ${MAX_TIMEOUT}
    Click Element    ${ELEMENT}

Verify CSS Property Value
    [Documentation]    Keyword to verify CSS Property Value
    [Arguments]    ${locator}    ${property}    ${value}
    ${css_prop}    Get CSS Property Value    ${locator}    ${property}
    Should Contain    ${css_prop}    ${value}    ${property}

Get Random Item From List
    [Documentation]    Get Random Item From List
    [Arguments]    ${list}
    ${len}    Get Length    ${list}
    ${random_index}    Get Random Integer Range ${0} And ${len}
    RETURN    ${list}[${random_index}]

WebElements (Attribute) Should Be Equal
    [Documentation]    Verifies list of WebElement's attribute. Should Be Equal As Strings with the given list.
    [Arguments]       ${locator}                ${list_values}            ${attribute_name}
    ${list_values}    Convert To List If Not    ${list_values}
    Wait Until Element Is Visible        ${locator}                       ${MAX_TIMEOUT}        error=WebElement(s) are not displayed. [${locator}]
    ${elements}    Get WebElements       ${locator}
    ${counter}     Convert To Integer    ${0}
    FOR            ${element}    IN      @{elements}
        ${attr_value}                    Get Element Attribute            ${element}            ${attribute_name}
        Should Be Equal As Strings       "${list_values}[${counter}]"     "${attr_value}"       msg=WebElement (${attribute_name}) should be equal to "${list_values}[${counter}]" but found "${attr_value}". [Index: ${counter}]
        ${counter}                       Convert To Integer               ${counter + 1}
    END

Set Selenium Speed To "${value}"
    [Documentation]    Sets Selenium Speed To "${value}"
    ${default_speed}    Get Selenium Speed
    Set Test Variable    ${DEFAULT_SELENIUM_SPEED}    ${default_speed}
    Set Selenium Speed    ${value}

Set Selenium Speed To Default
    [Documentation]    Sets Selenium Speed To Default. This should be used after Set Selenium Speed To "${value}" keyword.
    Set Selenium Speed    ${DEFAULT_SELENIUM_SPEED}

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

Go Back And Wait Until Page Is Loaded
    [Documentation]    Go Back And Wait Until Page Is Loaded
    Go Back
    Wait Until Page Is Loaded

Element Should Be In Active State
    [Arguments]    ${ELEMENT}
    [Documentation]    Check whether an element is active.
    ${element_state}    Get Element Attribute    ${ELEMENT}     class
    Should Contain    ${element_state}    active    or    activeView

Wait And Click Element
    [Documentation]    Wait And Click Element
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    ${MAX_TIMEOUT}
    Click Element    ${element}
