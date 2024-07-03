*** Settings ***
Documentation    Global Variables for Test Cases.


*** Variables ***
# Global Links
# ${BROWSER}                      Firefox
${BROWSER}                        Chrome
${LINK_CRM}                       http://10.224.57.5:8080/
# ${LINK_CRM}                     https://customer.musictribe.com/

# Solution Tracker Form
${BTN_CREATE}                     //div[@class="card-button__wrapper"]//div[text()='Create']
${BTN_VIEW}                       //div[@class="card-button__wrapper"]//div[text()='View']
${DDL_DIVISION}                   //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                //select[@formcontrolname="subDivision"]
${DDL_SC}                         //select[@formcontrolname="serviceClassification"]
${DDL_ST}                         //select[@formcontrolname="serviceType"]
${DDL_SR}                         //select[@formcontrolname="serviceRequirement"]
${DDL_AR}                         //select[@formcontrolname="actionRequired"]

${SUBJECT}                        //input[@formcontrolname="subject"]
${DESCRIPTION}                    //textarea[@formcontrolname="description"]

${ATTACHMENT}                          //input[@class="file-upload__input"]
${PRODUCT_VECTOR_ARTWORK_ATTACHMENT}   //label[@for='productVectorArtworkInput']/following::input[@name='attachment'][1]
${COMPLETE_PRODUCT_3D_ATTACHMENT}      //input[@formcontrolname='attachmentLink']
${REFERENCE_FILE_ATTACHMENT}           //label[@for='referenceFileInput']/following::input[@name='attachment'][1]
${STOCK_IMG_ATTACHMENT}               //label[@for='stockImageFileInput']/following::input[@name='attachment'][1]

${DDL_PRIORITY}                        //select[@formcontrolname="priority"]
${DDL_CUST_DIVISION}                   //label[@for="senderDivision"]/following-sibling::div/child::select
${DDL_CUST_SUB_DIVISION}               //label[@for="senderSubDivision"]/following-sibling::div/child::select
${DDL_CUST_LOCATION}                   //label[@for="senderLocation"]/following-sibling::div/child::select
${DDL_BRAND}                           //label[@for="brand"]/following-sibling::div/child::select
${DDL_PURPOSE}                         //select[@formcontrolname='purpose']
${DDL_TYPE_OF_OUTPUT}                  //select[@formcontrolname='typeOfOutput']

${MODEL_CODE}                        //label[text()='${SPACE}Model Code${SPACE}${SPACE}']/following::input[1]

${BTN_CANCEL}                     //button[contains(text(),'Reset')]
${BTN_SUBMIT}                     //button[contains(text(),'Submit')]

# Library File Location
${FACE_REND_DATA}                ${CURDIR}/FORM_FACE_REND.xlsx
${MASTER_DATA}                   ${CURDIR}/Master_File.xlsx
${JPG_IMAGE_SAMPLE}              ${CURDIR}/Jpg_Img_Photo.jpg
${JPG_NAME}                      Jpg_Img_Photo.jpg

# Form Values
${DIV_VALUE}                     Face Tribes${SPACE}${SPACE}(FACE)
${SUBDIV_VALUE}                  FACE REND
${INPUT_SUBJECT}                 Internal QA - FACE REND

# Fields
@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_LOCATION}                      ET1 (Empower Trust)
...                                   MT1 (Music Trust)
...                                   MT-BM1 (Music Tribe Global Services Ltd.)
...                                   MT-CA1 (Music Tribe Brands CA Ltd.)
...                                   MT-CN1 (Zhongshan Eurotec Electronics Limited)

# @{LIST_LOCATION}                      ET1 (Empower Trust)
# ...                                   ET-BM1 (Music Tribe Commercial BM Ltd.)
# ...                                   ET-CN1 (Zhongshan BEHRINGER Electronics Limited)
# ...                                   ET-DE1 (Music Tribe Brands DE GmbH)
# ...                                   ET-DK1 (Music Tribe Brands DK A/S)
# ...                                   ET-MY1 (Empower Tribe MY1 Sdn Bhd)
# ...                                   ET-PH1 (Music Group Commercial BM Ltd. ROHQ)
# ...                                   ET-SE1 (Empower Tribe SE1 AB)
# ...                                   ET-UK1 (Music Tribe Brands UK Ltd.)
# ...                                   ET-VG1 (Empower Tribe VG1 Ltd.)
# ...                                   ET-VG2 (Empower Tribe VG2 Ltd.)
# ...                                   ET-VG3 (Empower Tribe VG3 Ltd.)
# ...                                   MT1 (Music Trust)
# ...                                   MT-BM1 (Music Tribe Global Services Ltd.)
# ...                                   MT-CA1 (Music Tribe Brands CA Ltd.)
# ...                                   MT-CN1 (Zhongshan Eurotec Electronics Limited)
# ...                                   MT-DE1 (Music Tribe DE1 GmbH)
# ...                                   MT-DK1 (Music Tribe DK1 A/S)
# ...                                   MT-DK2 (Music Tribe Innovation DK A/S)
# ...                                   MT-IN1 (Music Tribe Innovation Private Limited)
# ...                                   MT-MU1 (Music Tribe Manufacturing Ltd.)
# ...                                   MT-MY1 (Music Tribe Commercial MY Sdn Bhd)
# ...                                   MT-PH1 (Music Global Shared Services Inc.)
# ...                                   MT-SE1 (Music Tribe SE1 AB)
# ...                                   MT-SE2 (Music Tribe Brands Sweden AB)
# ...                                   MT-UK1 (Music Tribe UK1 A/S)
# ...                                   MT-US1 (Music Tribe Commercial NV Inc.)
# ...                                   MT-VG1 (Music Tribe VG1 Ltd.)
# ...                                   MT-VG2 (Music Tribe VG2 Ltd.)

@{LIST_FACE_DIVISION}                 Face Tribes${SPACE}${SPACE}(FACE)
# ...                                  Availability Tribes (AVAI)    Digital Tribes (DIGI)    Face Tribes${SPACE}${SPACE}(FACE)    Heart Tribes (HEAR)   Horizon Tribe (HORIZON)   Hospitality Tribes (HOSP)
# ...                                  Innovation Tribes (INNO)    Legal Tribes (LEGA)    Performance Tribes (PERF)    Research Tribes (RESE)    Transformation Tribes (TRAN)    Treasure Tribes (TREA)    Value Tribes (VALU)

@{LIST_AVAI_SUB_DIV}                      AVAI      AVAI CONT      AVAI DEMA      AVAI INVE      AVAI LEAN
...                                       AVAI LOGI      AVAI PMC WARE      AVAI PROD

@{LIST_BRAN_SUB_DIV}                      AM BRAN CATE     BE BRAN CATE      BX BRAN CATE
...                                       LG BRAN CATE    MI BRAN CATE     MT BRAN CATE      TA BRAN CATE
...                                       TE BRAN CATE      TS BRAN CATE

@{LIST_BRAN COMM_SUB_DIV}                 BRAN COMM    BRAN COMM CONT    BRAN COMM EVEN
...                                       BRAN COMM RELA      BRAN COMM SOCI

@{LIST_COMP_SUB_DIV}                      COMP    COMP GRC    COMP IA

@{LIST_CUST AVAI_SUB_DIV}                 CUST AVAI    CUST AVAI CDS    CUST AVAI COMM
...                                       CUST AVAI DEMA    CUST AVAI ENTE

@{LIST_CUST SUPP_SUB_DIV}                 CUST QUAL    CUST SUPP SERV    CUST SUPP SOLU    CUST SUPP TECH

@{LIST_DIGI_SUB_DIV}                      DIGI      DIGI APPL      DIGI INFR

@{LIST_FACE_SUB_DIV}                      FACE      FACE COPY      FACE GRAP      FACE INDU
...                                       FACE MEDI      FACE PRIN      FACE QUAL    FACE REND
...                                       FACE STYL      FACE TECH      FACE UXUI      FACE VIDE
...                                       FACE WEB      FACE BA

@{LIST_HEAR_SUB_DIV}                      HEAR      HEAR ACQU      HEAR DEVE      HEAR REWA

@{LIST_HOSP_SUB_DIV}                      HOSP      HOSP ACCO      HOSP EHS      HOSP FACI      HOSP TRAV

@{LIST_INNO_SUB_DIV}                      INNO      INNO ACOU      INNO COMP      INNO MECH
...                                       INNO PCB    INNO SOFT      INNO SYST

@{LIST_LEGA_SUB_DIV}                      LEGA COMM      LEGA GOVE      LEGA HEAR      LEGA IP

@{LIST_QUAL_SUB_DIV}                      QUAL

@{LIST_RESE_SUB_DIV}                      RESE      RESE AI      RESE DATA      RESE PLAT

@{LIST_STRA_SUB_DIV}                      STRA PROD

@{LIST_TRAN_SUB_DIV}                      TRAN    TRAN BRAN    TRAN SHAR

@{LIST_TREA_SUB_DIV}                      TREA INVE    TREA OTC    TREA PTP    TREA RTR    TREA TAX

@{LIST_VALU_SUB_DIV}                      Customer Feedback    VALU    VALU DM    VALU IDM

@{LIST_VISI_SUB_DIV}                      VISI STRA

${LIST_BRAND}                             Aston    Behringer    Bugera    CoolAudio    Eurocom    Klark Teknik    Lab Gruppen    Lake    Midas    Tannoy    TC Electronic    TC Helicon    Turbosound

${LIST_PURPOSE}                           PDI1    PDI2    Website    Social Media    Banner    Promotion    Advertisement    Packaging    QSG    Other

${TXT_MODEL_CODE}                         Sample_Model_Code_000

# Ticket Viewer Locators
${TICKET_VIEWER_SEARCH}                   //input[@formcontrolname='search']
${TICKET_VIEWER_SEARCH_ICON}              //span[@class='icon icon-search']

# Ticket Info Locators
${BTN_CREATE_A_TICKET}                   //button[@routerlink='/create-ticket']
${TICKET_INFO}                           //div[contains(text(),'Ticket Info')]
${INFO_CASE_NUM}                         //div[@class='ticket-details__header']/h4
${INFO_NAME}                             //span[text()=' Name: ']/following-sibling::strong
${INFO_EMAIL}                            //span[text()=' Email: ']/following-sibling::strong
${INFO_DIVISION}                         //span[text()=' Division: ']/following-sibling::strong
${INFO_SUB_DIVISION}                     //span[text()=' Sub-Division: ']/following-sibling::strong
${INFO_SC}                               //span[text()=' Service Classification: ']/following-sibling::strong
${INFO_ST}                               //span[text()=' Service Type: ']/following-sibling::strong
${INFO_SR}                               //span[text()=' Service Requirement: ']/following-sibling::strong
${INFO_PRIORITY}                         //span[text()=' Priority: ']/following-sibling::strong
${INFO_CD}                               //span[text()=' Customer Division: ']/following-sibling::strong
${INFO_CSD}                              //span[text()=' Customer Sub-Division: ']/following-sibling::strong
${INFO_CL}                               //span[text()=' Customer Location: ']/following-sibling::strong
${INFO_ASSIGNEE}                         //span[text()=' Assignee: ']/following-sibling::strong
${INFO_DATE_OPENED}                      //span[text()=' Date Opened: ']/following-sibling::strong
${INFO_LAST_MODIFIED}                    //span[text()=' Last Modified: ']/following-sibling::strong

@{TICKET_INFO_DETAILS_FIELDS}            ${INFO_CASE_NUM}    ${INFO_NAME}   ${INFO_EMAIL}    ${INFO_DIVISION}    ${INFO_SUB_DIVISION}    ${INFO_SC}    ${INFO_SR}
...                                      ${INFO_PRIORITY}    ${INFO_CD}    ${INFO_CSD}    ${INFO_CL}    ${INFO_ASSIGNEE}    ${INFO_DATE_OPENED}    ${INFO_LAST_MODIFIED}

&{TICKET_INFO_DETAILS_LIST}              Case_Num=${EMPTY}    Name=${EMPTY}    Email=${EMPTY}    Division=${EMPTY}    Sub-Division=${EMPTY}    SC=${EMPTY}    SR=${EMPTY}    Priority=${EMPTY}
...                                      CD=${EMPTY}    CSD=${EMPTY}    CL=${EMPTY}    Assignee=${EMPTY}    Date_Opened=${EMPTY}    Last_Modified=${EMPTY}

@{TICKET_INFO_TO_VERIFY}                 Division    Sub-Division    SC    SR    Priority    CD    CSD    CL

# Excel File
# Sheet - Service Classification
${SHEET_SC}                      Service Classification

# Columns - Service Classification
${ST_PRODUCT_IMG_REND}              Product Image Rendering
${ST_PRODUCT_IMG_LIFESTYLE}         Product Rendering on Lifestyle Photo
${ST_PRODUCT_IMG_ASSET}             Product Image Asset
${ST_VST_IMG_ASSET}                 VST Image Asset for Development

# Sheet - FACE REND
${SHEET_FACE_REND}               FACE REND

# Columns - FACE REND
${CO_SUB_DIVISION}               Sub-Division
${CO_SERVICE_CLASSIFICATION}     Service Classification
${CO_SERVICE_TYPE}               Service Type
${CO_SERVICE_REQUIREMENT}        Service Requirement
${CO_SERVICE_CATEGORY}           Service Category
${CO_ASSIGNEE}                   Assignee
${CO_BRAND}                      Brands
${CO_PURPOSE}                    Purpose
${CO_TYPE_OF_OUTPUT}             Type of Output

#    ------------ Solution Tracker Portal ------------
${BTN_AGENT_PORTAL}              //header/div[1]/div[2]/a[1]
${TAB_NAME_LOGIN}                Sign in to your account
${UAT_TAB_NAME_AGENT_PORTAL}     Customer Service Agent Dashboard - Dynamics 365
${PROD_TAB_NAME_AGENT_PORTAL}    Solution Tracker Agent Dashboard - Dynamics 365
${ST_TAB_PAGE}                   MT Solutions Tracker

# Login Credentials
${EMAIL}                        marylou.delacerna@musictribe.com
${PASSWORD}                     Xbox@36310Pancor@

# URL Sandbox
${UAT_CRM}                      https://musictribeservice.crm5.dynamics.com/main.aspx?appid=22fd57cc-73f4-ed11-8848-002248ebf403&pagetype=dashboard&id=338ea94a-8f9f-ea11-a812-000d3a31a607&type=system&_canOverride=true
${UAT_CRM_V2}                   https://musictribeservice.crm5.dynamics.com/main.aspx?appid=b5f12461-796e-ee11-9ae7-002248ebf471&pagetype=dashboard&id=d201a642-6283-4f1d-81b7-da4b1685e698&type=system&_canOverride=true
${PROD_CRM}                     https://musictribe.crm5.dynamics.com/main.aspx?appid=3295c66c-98fa-ed11-8f6e-000d3aa14915&pagetype=dashboard&id=26cfb7b6-a203-48d3-895f-e6c44937f5a8&type=system&_canOverride=true

# Login Modal
${TXT_EMAIL}                 //input[@type="email"]
${TXT_PASSWORD}              //input[@type="password"]
${BTN_LOGIN_SUBMIT}          //input[@type='submit']

# Locators
${UAT_SEARCH_ICON}            //body/div[@id='shell-container']/div[@id='ApplicationShell']/div[1]/div[1]/div[1]/div[3]/div[2]/div[1]/div[1]/div[1]/ul[1]/li[1]/button[1]/span[1]/span[1]
${LOGO_CRM}                   //img[@title='Music Tribe CRM']
${SEARCH_BOX}                //input[@aria-label='Search box']
${SEARCH_BOX_ICON}           //span[@id='searchButtonIcon']
${SAVE_CASE}                 //button[@aria-label='Save (CTRL+S)']
${TAB_DETAILED_INFO}         //li[@title='Detailed Information']

# CRM Ticket Details
${CASE_SUMMARY_NUM}                  //input[@aria-label="Case Number"]
${CASE_SUMMARY_DIV}                  //ul[@title='Division']/li/div[2]/div
${CASE_SUMMARY_SUBDIV}               //ul[@title='Sub-Division']/li/div[2]/div
${CASE_SUMMARY_SC}                   //ul[@title='Service Classification']/li/div[2]/div
${CASE_SUMMARY_ST}                   //div[@data-id='mt_stv2_servicetype.fieldControl-LookupResultsDropdown_mt_stv2_servicetype_selected_tag_text']
${CASE_SUMMARY_SR}                   //select[@aria-label="Service Requirement"]
${CASE_SUMMARY_PRIORITY}             //div[contains(text(),'Priority')]/preceding-sibling::div/div
${CASE_SUMMARY_SUBJ}                 //input[@aria-label="Subject"]
${CASE_SUMMARY_DESC}                 //textarea[@id='id-f290fe03-7f6e-ee11-9ae7-002248ebf403-12-descriptione0dece4b-6fc8-4a8f-a065-082708572369-description.fieldControl-text-box-text']
${CASE_SUMMARY_CD}                   //ul[@title='Customer Division']/li/div[2]/div
${CASE_SUMMARY_CSD}                  //ul[@title='Customer Sub-Division']/li/div[2]/div
${CASE_SUMMARY_CL}                   //label[text()='Customer Location']/following::input[1]

${CASE_SUMMARY_BRAND}                //div[@data-id='mt_brand.fieldControl-LookupResultsDropdown_mt_brand_selected_tag_text']

${CASE_SUMMARY_REQ_NAME}             //input[@aria-label="Requestor's Name"]
${CASE_SUMMARY_ATTACHMENT}           //input[@aria-label="Attachments"]
${CASE_SUMMARY_DATE_NEEDED}          //input[@aria-label="Date Needed"]
${CASE_SUMMARY_PURPOSE}              //select[@aria-label="Purpose"]
${CASE_SUMMARY_MODEL_CODE}           //input[@aria-label="Model Code's"]
${CASE_SUMMARY_TYPE_OF_OUTPUT}       //select[@aria-label="Type of Output"]
${CASE_SUMMARY_STOCK_IMG}            //input[@aria-label='Stock Image File Attachment(s)']
${CASE_SUMMARY_REF_IMG}              //input[@aria-label='Reference File Attachment(s)']
${CASE_SUMMARY_COMPLETE_3D_IMG}      //input[@aria-label='Complete Product 3D STP File']
${CASE_SUMMARY_PRODUCT_VECTOR_IMG}   //input[@aria-label='Product Vector Artwork']

@{CASE_TICKET_INFO_TO_VERIFY}       Case_Num    Division    Sub-Division    SC    SR    Priority    CD    CSD    CL

&{DIC_CRM_CASE_SUMMARY_IMG_REND_FIELDS}        NUM=${EMPTY}    SUBDIV=${EMPTY}    SC=${EMPTY}    ST=${EMPTY}    SR=${EMPTY}    # Default Fields
...                                        PRIORITY=${EMPTY}    CD=${EMPTY}    CSD=${EMPTY}    # Default Fields
...                                        BRAND=${EMPTY}   PURPOSE=${EMPTY}
...                                        MODEL_CODE=${EMPTY}
...                                        PRODUCT_VECTOR_IMG=${EMPTY}    COMPLETE_3D_IMG=${EMPTY}

&{DIC_CRM_CASE_SUMMARY_IMG_LIFESTYLE_FIELDS}        NUM=${EMPTY}    SUBDIV=${EMPTY}    SC=${EMPTY}    ST=${EMPTY}    SR=${EMPTY}    # Default Fields
...                                        PRIORITY=${EMPTY}    CD=${EMPTY}    CSD=${EMPTY}    # Default Fields
...                                        BRAND=${EMPTY}   PURPOSE=${EMPTY}
...                                        MODEL_CODE=${EMPTY}    TYPE_OF_OUTPUT=${EMPTY}
...                                        REF_IMG=${EMPTY}    STOCK_IMG=${EMPTY}

&{DIC_CRM_CASE_SUMMARY_IMG_ASSET_FIELDS}        NUM=${EMPTY}    SUBDIV=${EMPTY}    SC=${EMPTY}    ST=${EMPTY}    SR=${EMPTY}    # Default Fields
...                                        PRIORITY=${EMPTY}    CD=${EMPTY}    CSD=${EMPTY}    # Default Fields
...                                        ATTACHMENT=${EMPTY}    BRAND=${EMPTY}   PURPOSE=${EMPTY}
...                                        MODEL_CODE=${EMPTY}

&{DIC_CRM_CASE_SUMMARY_VST_ASSET_FIELDS}        NUM=${EMPTY}    SUBDIV=${EMPTY}    SC=${EMPTY}    ST=${EMPTY}    SR=${EMPTY}    # Default Fields
...                                        PRIORITY=${EMPTY}    CD=${EMPTY}    CSD=${EMPTY}    # Default Fields
...                                        BRAND=${EMPTY}   PURPOSE=${EMPTY}
...                                        MODEL_CODE=${EMPTY}
