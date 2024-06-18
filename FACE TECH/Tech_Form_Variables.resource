*** Settings ***
Documentation    Global Variables for Test Cases.


*** Variables ***
# Global Links
# ${BROWSER}                      Firefox

${BROWSER}                        Chrome

#    ........................Solution Tracker Portal---------------------------------------------
# Login Credentials
${EMAIL}    email
${PASSWORD}    password

# URL Sandbox
${URL_ALL_CASES_FACE}                  https://musictribeservice.crm5.dynamics.com/main.aspx?appid=22fd57cc-73f4-ed11-8848-002248ebf403&pagetype=entitylist&etn=incident&viewid=8eb7d675-e50f-ee11-8f6e-002248ebf403&viewType=1039

#    Locators
${SEARCH_BOX}                          //input[@aria-label='Case Filter by keyword']
${SAVE_CASE}                           //button[@aria-label='Save (CTRL+S)']
${TAB_DETAILED_INFO}                   //li[@title='Detailed Information']

# Login Modal
${TXT_EMAIL}                           //input[@type="email"]
${TXT_PASSWORD}                        //input[@type="password"]
${BTN_SUBMIT}                          //input[@type='submit']

# Ticket Details
${LBL_SUBJECT}                         //input[@aria-label="Subject"]

#    ........................Solution Tracker Customer Website.....................................

${DDL_DIVISION}                        //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                     //select[@formcontrolname="subDivision"]
${DDL_CUST_DIVISION}                   //label[@for="senderDivision"]//following-sibling::div/select
${DDL_CUST_SUB_DIVISION}               //label[@for="senderSubDivision"]//following-sibling::div/select
${DDL_CUST_LOCATION}                   //label[@for="senderLocation"]//following-sibling::div/select
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
${DATA_TABLE}                          //div[@class="datatable-body-cell-label"]/a[text()=" Internal QA Test TECH"]

# Global Variables
${ICON_PRELOADER}                      //div[contains(@class,'_loader_loader__en2c7')]
${ICON_PRELOADER_ACTIVE}               //div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ACTIVE_POPOVER}
...    //div[contains(@class,'_popover_preloader')]/div[contains(@class,'_loader_loader__en2c7 _loader_is-active')]
${ICON_PRELOADER_ATTR}                 class
${ICON_PRELOADER_VERIFY_ATTR}          active

@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_LOCATION}                      ET1 (Empower Trust)
...                                   ET-BM1 (Music Tribe Commercial BM Ltd.)
...                                   ET-CN1 (Zhongshan BEHRINGER Electronics Limited)
...                                   ET-DE1 (Music Tribe Brands DE GmbH)
...                                   ET-DK1 (Music Tribe Brands DK A/S)
...                                   ET-MY1 (Empower Tribe MY1 Sdn Bhd)
...                                   ET-PH1 (Music Group Commercial BM Ltd. ROHQ)
...                                   ET-SE1 (Empower Tribe SE1 AB)
...                                   ET-UK1 (Music Tribe Brands UK Ltd.)
...                                   ET-VG1 (Empower Tribe VG1 Ltd.)
...                                   ET-VG2 (Empower Tribe VG2 Ltd.)
...                                   ET-VG3 (Empower Tribe VG3 Ltd.)
...                                   MT1 (Music Trust)
...                                   MT-BM1 (Music Tribe Global Services Ltd.)
...                                   MT-CA1 (Music Tribe Brands CA Ltd.)
...                                   MT-CN1 (Zhongshan Eurotec Electronics Limited)
...                                   MT-DE1 (Music Tribe DE1 GmbH)
...                                   MT-DK1 (Music Tribe DK1 A/S)
...                                   MT-DK2 (Music Tribe Innovation DK A/S)
...                                   MT-IN1 (Music Tribe Innovation Private Limited)
...                                   MT-MU1 (Music Tribe Manufacturing Ltd.)
...                                   MT-MY1 (Music Tribe Commercial MY Sdn Bhd)
...                                   MT-PH1 (Music Global Shared Services Inc.)
...                                   MT-SE1 (Music Tribe SE1 AB)
...                                   MT-SE2 (Music Tribe Brands Sweden AB)
...                                   MT-UK1 (Music Tribe UK1 A/S)
...                                   MT-US1 (Music Tribe Commercial NV Inc.)
...                                   MT-VG1 (Music Tribe VG1 Ltd.)
...                                   MT-VG2 (Music Tribe VG2 Ltd.)

@{LIST_BRANDS}                        Aston Microphones    Midas    Lab Gruppen    Tannoy
...                                   Turbosound    TC Electronic    TC Helicon
...                                   Behringer    Klark Teknik    Bugera    Lake

@{LIST_FACE_DIVISION}                 AVAI    BRAN    BRAN COMM    COMP    CUST AVAI    CUST SUPP
...                                   DIGI  FACE     HEAR      HOSP
...                                   INNO      LEGA      QUAL      RESE
...                                   STRA      TRAN      TREA      VALU      VISI

@{LIST_AVAI_SUB_DIV}                      AVAI      AVAI CONT      AVAI DEMA      AVAI INVE      AVAI LEAN
...                                       AVAI LOGI      AVAI PMC WARE      AVAI PROD
@{LIST_BRAN_SUB_DIV}                      AM BRAN CATE     BE BRAN CATE      BX BRAN CATE
...                                       LG BRAN CATE    MI BRAN CATE     MT BRAN CATE      TA BRAN CATE
...                                       TE BRAN CATE      TS BRAN CATE
@{LIST_BRAN COMM_SUB_DIV}                  BRAN COMM    BRAN COMM CONT    BRAN COMM EVEN
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

#    ---------------------- Pending Locators -----------------------
${DDL_BRAND}                              //label[@for="brand"]//following-sibling::div/select
${TXT_BRAND_LEADER}                       //input[@formcontrolname="brandCategoryLeaderBcl"]
${TXT_PRODUCT_LEADER}                     //input[@formcontrolname="performanceProductLeader"]
${TXT_MODEL_CODE}                         //input[@formcontrolname="modelCodeText"]
${REQUESTOR_NAME}                         //input[@formcontrolname="requestorName"]
${DATE_NEEDED}                            //div[@class="input-group datepicker"]
