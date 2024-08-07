*** Settings ***
Documentation    Global Variables for Test Cases.


*** Variables ***
# Global Links
# ${BROWSER}                      Firefox

${BROWSER}                        Chrome

#    ........................Solution Tracker Portal---------------------------------------------
# Login Credentials
${LOGO_CRM}                   //img[@title='Music Tribe CRM']
${BTN_LOGIN_SUBMIT}           //input[@type='submit']
${BTN_AGENT_PORTAL}           //header/div[1]/div[2]/a[1]
${TAB_NAME_LOGIN}             Sign in to your account
${UAT_CRM_V2}                 https://musictribeservice.crm5.dynamics.com/main.aspx?appid=b5f12461-796e-ee11-9ae7-002248ebf471&pagetype=dashboard&id=d201a642-6283-4f1d-81b7-da4b1685e698&type=system&_canOverride=true
${UAT_SEARCH_ICON}            //body/div[@id='shell-container']/div[@id='ApplicationShell']/div[1]/div[1]/div[1]/div[3]/div[2]/div[1]/div[1]/div[1]/ul[1]/li[1]/button[1]/span[1]/span[1]
${SEARCH_BOX_ICON}            //span[@id='searchButtonIcon']

# URL Sandbox
${URL_ALL_CASES_FACE}                  https://musictribeservice.crm5.dynamics.com/main.aspx?appid=22fd57cc-73f4-ed11-8848-002248ebf403&pagetype=entitylist&etn=incident&viewid=8eb7d675-e50f-ee11-8f6e-002248ebf403&viewType=1039
${CRM_GLOBAL_SEARCH_BOX}               //input[@aria-label='Search box']

# Login Credentials
${EMAIL}    email
${PASSWORD}    password

#    Locators
${SEARCH_BOX}                //input[@aria-label='Case Filter by keyword']
${SAVE_CASE}                 //button[@aria-label='Save (CTRL+S)']
${TAB_DETAILED_INFO}         //li[@title='Detailed Information']
${DATA_TABLE}                //div[@class="datatable-body-cell-label"]

# Login Modal
${TXT_EMAIL}                 //input[@type="email"]
${TXT_PASSWORD}              //input[@type="password"]
${BTN_SUBMIT}                //input[@type='submit']

@{LIST_CRM_SUMMARY_TAB}            Case Number    Division      Sub-Division    Service Classification    Service Requirement    Subject
...                                Description    Priority    Customer Division    Customer Sub-Division     Customer Location
@{LIST_CRM_DETAILED_INFO_TAB}      Attachment    Brand    Project Owner

# CRM Ticket Details
${CRM_DETAIL_Case Number}                        //input[@aria-label="Case Number"]
${CRM_DETAIL_Division}                           //ul[@title='Division']/li/div[2]/div
${CRM_DETAIL_Sub-Division}                       //ul[@title='Sub-Division']/li/div[2]/div
${CRM_DETAIL_Service Classification}             //ul[@title='Service Classification']/li/div[2]/div
${CRM_DETAIL_Service Requirement}                //select[@aria-label="Service Requirement"]
${CRM_DETAIL_PRIORITY}                           //div[contains(text(),'Priority')]/preceding-sibling::div/div
${CRM_DETAIL_Subject}                            //input[@aria-label="Subject"]
${CRM_DETAIL_Description}                        //textarea[@aria-label='Description']
${CRM_DETAIL_Customer Division}                  //ul[@title='Customer Division']/li/div[2]/div
${CRM_DETAIL_Customer Sub-Division}              //ul[@title='Customer Sub-Division']/li/div[2]/div
${CRM_DETAIL_Customer Location}                  //select[@aria-label='Customer Location']
${CRM_DETAIL_BRAND}                              //div[@data-id='mt_brand.fieldControl-LookupResultsDropdown_mt_brand_selected_tag_text']
${CRM_DETAIL_Project Owner}                      //input[@aria-label="Project Owner"]
${CRM_DETAIL_ATTACHMENT}                         //input[@aria-label="Attachments"]

# Ticket Details
${LBL_SUBJECT}               //input[@aria-label="Subject"]
${TICKET_DETAILS_HEADER}     //*[@class='ticket-details__header']
${TICKET_DETAILS_ITEMS}      //ul[@class='ticket-details__body']
@{LIST_UXUI_ALL_FIELDS}      Division      Sub-Division    Service Classification    Service Type    Service Requirement    Subject
...                          Description    Attachment    Project Owner    Brand    Priority
...                          Customer Division    Customer Sub-Division     Customer Location

${DETAIL_Division}                               ${TICKET_DETAILS_ITEMS}//li/span[contains(text(),"Division:")]/following-sibling::strong
${DETAIL_Sub-Division}                           ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Sub-Division:")]/following-sibling::strong
${DETAIL_Service Classification}                 ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Classification:")]/following-sibling::strong
${DETAIL_Service Type}                           ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Type:")]/following-sibling::strong
${DETAIL_Service Requirement}                    ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Requirement:")]/following-sibling::strong
${DETAIL_Attachment}                             ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Attachment:")]/following-sibling::strong
${DETAIL_Brand}                                  ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Brand:")]/following-sibling::strong
${DETAIL_Project Owner}                          ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Project Owner:")]/following-sibling::strong
${DETAIL_Priority}                               ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Priority:")]/following-sibling::strong
${DETAIL_Customer Division}                      ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Division:")]/following-sibling::strong
${DETAIL_Customer Sub-Division}                  ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Sub-Division:")]/following-sibling::strong
${DETAIL_Customer Location}                      ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Location:")]/following-sibling::strong
${DETAIL_Subject}                                ${TICKET_DETAILS_HEADER}/p[2]
${DETAIL_Description}                            ${TICKET_DETAILS_HEADER}/p[3]

#    Ticket Creation Form
&{DICT_FORM_FIELDS_LOCATORS}           Division=${DDL_DIVISION}    Sub-Division=${DDL_SUBDIVISION}    Service Classification=${DDL_SC}    Service Type=${DDL_ST}
...                                    Service Requirement=${DDL_SR}    Subject=${EMPTY}    Description=${DESCRIPTION}    Brand=${DDL_BRAND}
...                                    Project Owner=${PROJECT_OWNER}            Priority=${DDL_PRIORITY}
...                                    Customer Division=${DDL_CUST_DIVISION}    Customer Sub-Division=${DDL_CUST_SUB_DIVISION}     Customer Location=${DDL_CUSTOMER LOCATION}

#    ........................Solution Tracker Customer Website.....................................

${DDL_DIVISION}                        //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                     //select[@formcontrolname="subDivision"]
${DDL_CUST_DIVISION}                   //label[@for="senderDivision"]//following-sibling::div/select
${DDL_CUST_SUB_DIVISION}               //label[@for="senderSubDivision"]//following-sibling::div/select
${DDL_CUSTOMER LOCATION}               //label[@for="senderLocation"]//following-sibling::div/select
${DDL_PRIORITY}                        //select[@formcontrolname="priority"]
${DDL_SC}                              //select[@formcontrolname="serviceClassification"]
${DDL_ST}                              //select[@formcontrolname="serviceType"]
${DDL_SR}                              //select[@formcontrolname="serviceRequirement"]
${CREATE}                              //div[@class="card-button__wrapper"]//div[text()='Create']
${ATTACHMENT}                          //input[@class="file-upload__input"]
${JPG_IMAGE_SAMPLE}                    ${CURDIR}${/}Jpg_Img_Photo.jpg
${MASTER_DATA}                         ${CURDIR}${/}..\\Master_File.xlsx
${SUBJECT}                             //input[@formcontrolname="subject"]
${DESCRIPTION}                         //textarea[@formcontrolname="description"]

# Global Variables
${ICON_PRELOADER}                      //div[contains(@class,'_loader_loader__en2c7')]
${ICON_PRELOADER_ACTIVE}               //div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ACTIVE_POPOVER}
...    //div[contains(@class,'_popover_preloader')]/div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ATTR}                 class
${ICON_PRELOADER_VERIFY_ATTR}          active

@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_LOCATION}                      MT-BM1 (Music Tribe Global Services Ltd.)

@{LIST_FACE_DIVISION}                 AVAI    BRAN    BRAN COMM    COMP    CUST AVAI    CUST SUPP
...                                   DIGI  FACE     HEAR      HOSP
...                                   INNO      LEGA      QUAL      RESE
...                                   STRA      TRAN      TREA      VALU      VISI

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
@{LIST_CUST SUPP_SUB_DIV}                 CUST QUAL    UST SUPP SERV    CUST SUPP SOLU    CUST SUPP TECH
@{LIST_DIGI_SUB_DIV}                      DIGI      DIGI APPL      DIGI INFR
@{LIST_FACE_SUB_DIV}                      FACE      FACE COPY      FACE GRAP      FACE INDU
...                                       FACE MEDI      FACE PRIN      FACE QUAL    FACE REND
...                                       FACE STYL      FACE TECH      FACE UX      FACE VIDE
...                                       FACE WEB      PERF FACE BA
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

@{LIST_BRANDS}                        Midas    Lab Gruppen    Tannoy
...                                   Turbosound    TC Electronic    TC Helicon
...                                   Behringer    Klark Teknik    Bugera    Lake

#    ------------------------
${PROJECT_OWNER}                           //input[@formcontrolname="projectOwner"]
${DDL_BRAND}                               //label[@for="brand"]//following-sibling::div/select
