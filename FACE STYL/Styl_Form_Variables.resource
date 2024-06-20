*** Settings ***
Documentation    Global Variables for Test Cases.


*** Variables ***
# Global Links
# ${BROWSER}                      Firefox

${BROWSER}                        Chrome

#    ........................Solution Tracker Portal---------------------------------------------
# Login Credentials
${EMAIL}    yna.calimlim@musictribe.com
${PASSWORD}    Pass4Mail@041122*

# URL Sandbox
${URL_ALL_CASES_FACE}    https://musictribeservice.crm5.dynamics.com/main.aspx?appid=22fd57cc-73f4-ed11-8848-002248ebf403&pagetype=entitylist&etn=incident&viewid=8eb7d675-e50f-ee11-8f6e-002248ebf403&viewType=1039
${URL_ALL_CASES}         https://musictribeservice.crm5.dynamics.com/main.aspx?appid=b5f12461-796e-ee11-9ae7-002248ebf471&pagetype=entitylist&etn=incident&viewid=00000000-0000-0000-00aa-000010001030&viewType=1039

#    Locators
${SEARCH_BOX}                //input[@aria-label='Case Filter by keyword']
${SAVE_CASE}                 //button[@aria-label='Save (CTRL+S)']
${TAB_DETAILED_INFO}         //li[@title='Detailed Information']

# Login Modal
${TXT_EMAIL}                 //input[@type="email"]
${TXT_PASSWORD}              //input[@type="password"]
${BTN_SUBMIT}                //input[@type='submit']

# Ticket Details
${LBL_SUBJECT}               //input[@aria-label="Subject"]

#    ........................Solution Tracker Customer Website.....................................

#    Ticket Summary
${TICKET_DETAILS_HEADER}     //*[@class='ticket-details__header']
${TICKET_DETAILS_ITEMS}      //ul[@class='ticket-details__body']
@{LIST_STYL_ALL_FIELDS}      Division      Sub-Division    Service Classification    Service Type    Service Requirement    Service Category
...                          Subject    Description    Type of Output    Academy Upload    Attachment(s)/Link    Required File Format    Required Color    Priority
...                          Customer Division    Customer Sub-Division     Customer Location

${DETAIL_Division}                               ${TICKET_DETAILS_ITEMS}//li/span[contains(text(),"Division:")]/following-sibling::strong
${DETAIL_Sub-Division}                           ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Sub-Division:")]/following-sibling::strong
${DETAIL_Service Classification}                 ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Classification:")]/following-sibling::strong
${DETAIL_Service Type}                           ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Type:")]/following-sibling::strong
${DETAIL_Service Requirement}                    ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Requirement:")]/following-sibling::strong
${DETAIL_Service Category}                       ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Service Category:")]/following-sibling::strong
${DETAIL_Type of Output}                         ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Type of Output:")]/following-sibling::strong
${DETAIL_Academy Upload}                         ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Academy Upload:")]/following-sibling::strong
${DETAIL_Attachment(s)/Link}                     ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Attachment(s)/Link:")]/following-sibling::strong
${DETAIL_Required File Format}                   ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Required File Format:")]/following-sibling::strong
${DETAIL_Required Color}                         ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Required Color:")]/following-sibling::strong
${DETAIL_Priority}                               ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Priority:")]/following-sibling::strong
${DETAIL_Customer Division}                      ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Division:")]/following-sibling::strong
${DETAIL_Customer Sub-Division}                  ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Sub-Division:")]/following-sibling::strong
${DETAIL_Customer Location}                      ${TICKET_DETAILS_ITEMS}//span[contains(text(),"Customer Location:")]/following-sibling::strong
${DETAIL_Subject}                                ${TICKET_DETAILS_HEADER}/p[2]
${DETAIL_Description}                            ${TICKET_DETAILS_HEADER}/p[3]

#    Ticket Creation Form
&{DICT_FORM_FIELDS_LOCATORS}           Division=${DDL_DIVISION}    Sub-Division=${DDL_SUBDIVISION}    Service Classification=${DDL_SC}    Service Type=${DDL_ST}
...                                    Service Requirement=${DDL_SR}    Service Category=${DDL_SCAT}
...                                    Description=${DESCRIPTION}    Type of Output=${DDL_TYPE OF OUTPUT - A}    Academy Upload=${ACADEMY_UPLOAD}
...                                    Required File Format=${TXT_FILE_FORMAT}    Required Color=${TXT_REQUIRED_COLOR}    Priority=${DDL_PRIORITY}
...                                    Customer Division=${DDL_CUST_DIVISION}    Customer Sub-Division=${DDL_CUST_SUB_DIVISION}     Customer Location=${DDL_CUSTOMER LOCATION}

${DDL_DIVISION}                        //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                     //select[@formcontrolname="subDivision"]
${DDL_CUST_DIVISION}                   //label[@for="senderDivision"]//following-sibling::div/select
${DDL_CUST_SUB_DIVISION}               //label[@for="senderSubDivision"]//following-sibling::div/select
${DDL_CUSTOMER LOCATION}               //label[@for="senderLocation"]//following-sibling::div/select
${DDL_PRIORITY}                        //select[@formcontrolname="priority"]
${DDL_SC}                              //select[@formcontrolname="serviceClassification"]
${DDL_ST}                              //select[@formcontrolname="serviceType"]
${DDL_SR}                              //select[@formcontrolname="serviceRequirement"]
${DDL_SCAT}                            //select[@formcontrolname="serviceCategory"]
${CREATE}                              //div[@class="card-button__wrapper"]//div[text()='Create']
${ATTACHMENT}                          //input[@class="file-upload__input"]
${JPG_IMAGE_SAMPLE}                    ${CURDIR}${/}Jpg_Img_Photo.jpg
${MASTER_DATA}                         ${CURDIR}${/}..\\Master_File.xlsx
${SUBJECT}                             //input[@formcontrolname="subject"]
${DESCRIPTION}                         //textarea[@formcontrolname="description"]
${DATA_TABLE}                          //div[@class="datatable-body-cell-label"]

# Global Variables
${ICON_PRELOADER}                      //div[contains(@class,'_loader_loader__en2c7')]
${ICON_PRELOADER_ACTIVE}               //div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ACTIVE_POPOVER}
...    //div[contains(@class,'_popover_preloader')]/div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ATTR}                 class
${ICON_PRELOADER_VERIFY_ATTR}          active

@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_REQUIRED_COLOR}                Red    Blue    Black    Other
@{LIST_TYPE OF OUTPUT - A}            Editable    PDF    Both Editable and PDF
@{LIST_TYPE OF OUTPUT - B}            PDF Form    Microsoft Form
@{LIST_CUSTOMER_LOCATION}              ET-BM1 (Music Tribe Commercial BM Ltd.)

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

${TXT_REQUIRED_COLOR}                          //input[@formcontrolname="requiredColor"]
${TXT_FILE_FORMAT}                             //input[@formcontrolname="requiredFileFormat"]
${ACADEMY_UPLOAD}                              //label[@for="academyUpload"]//following-sibling::div/div[@class="form-check form-check-inline"]
${TXT_FILE_LINK}                               //input[@formcontrolname="fileLink"]
${DDL_TYPE OF OUTPUT - A}                      //select[@formcontrolname="typeOfOutput"]
${DDL_TYPE OF OUTPUT - B}                      //select[@formcontrolname="typeOfOutput"]
