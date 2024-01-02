*** Settings ***
Documentation    Variables for FACE GRAP Form


*** Variables ***
${MAX_TIMEOUT}                                   30s
${BTN_CREATE}                      //div[@class="card-button__wrapper"]//div[text()='Create']
${DATA_TABLE}                      //div[@class="datatable-body-cell-label"]/a[text()=" Internal QA Test GRAP"]
${JPG_IMAGE_SAMPLE}                ${CURDIR}${/}Jpg_Img_Photo.jpg

# Excel Data
${MASTER_DATA}                          ${CURDIR}${/}..\\Master_File.xlsx

# Common Fields

${DDL_DIVISION}                              //select[@formcontrolname="division"]
${DDL_SUBDIVISION}                           //select[@formcontrolname="subDivision"]
${DDL_SC}                                    //select[@formcontrolname="serviceClassification"]
${DDL_ST}                                    //select[@formcontrolname="serviceType"]
${DDL_SR}                                    //select[@formcontrolname="serviceRequirement"]
${TXT_SUBJECT}                               //input[@formcontrolname="subject"]
${TXT_DESCRIPTION}                           //textarea[@formcontrolname="description"]
${DDL_PRIORITY}                              //select[@formcontrolname="priority"]
${DDL_CUSTOMER_DIVISION}                     //label[@for="senderDivision"]//following-sibling::div/select
${DDL_CUSTOMER_SUBDIVISION}                  //label[@for="senderSubDivision"]//following-sibling::div/select
${DDL_CUSTOMER_LOCATION}                     //label[@for="senderLocation"]//following-sibling::div/select
${DDL_PRODUCT_CATEGORY}                      //select[@formcontrolname='productCategory']
${DDL_MODEL_CODE}                            //select[@formcontrolname='modelCode']
${DDL_MODEL_CODE_OPTION}                     //select[@formcontrolname='modelCode']/option[2]

# DDL Value Lists
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

# MT and Coolaudio are for Banner Asset Design and Newsletter Only

@{LIST_FACE_DIVISION}                 FACE
# ...                                   AVAI    BRAN    BRAN COMM    COMP    CUST AVAI    CUST SUPP
# ...                                   DIGI  FACE     HEAR      HOSP
# ...                                   INNO      LEGA      QUAL      RESE
# ...                                   STRA      TRAN      TREA      VALU      VISI

@{LIST_AVAI_SUB_DIV}                  AVAI      AVAI CONT      AVAI DEMA      AVAI INVE      AVAI LEAN
...                                   AVAI LOGI      AVAI PMC WARE      AVAI PROD
@{LIST_BRAN_SUB_DIV}                  AM BRAN CATE    BE BRAN CATE     BX BRAN CATE
...                                   LG BRAN CATE    MI BRAN CATE     MT BRAN CATE      TA BRAN CATE
...                                   TE BRAN CATE    TS BRAN CATE
@{LIST_BRAN COMM_SUB_DIV}             BRAN COMM    BRAN COMM CONT    BRAN COMM EVEN
...                                   BRAN COMM RELA      BRAN COMM SOCI
@{LIST_COMP_SUB_DIV}                  COMP    COMP GRC    COMP IA
@{LIST_CUST AVAI_SUB_DIV}             CUST AVAI    CUST AVAI CDS    CUST AVAI COMM
...                                   CUST AVAI DEMA    CUST AVAI ENTE
@{LIST_CUST SUPP_SUB_DIV}             CUST QUAL    UST SUPP SERV    CUST SUPP SOLU    CUST SUPP TECH
@{LIST_DIGI_SUB_DIV}                  DIGI      DIGI APPL      DIGI INFR
@{LIST_FACE_SUB_DIV}                  FACE      FACE BA    FACE COPY      FACE GRAP      FACE INDU
...                                   FACE MEDI      FACE PRIN      FACE QUAL    FACE REND
...                                   FACE STYL      FACE TECH      FACE UX      FACE VIDE
...                                   FACE WEB
@{LIST_HEAR_SUB_DIV}                  HEAR      HEAR ACQU      HEAR DEVE      HEAR REWA
@{LIST_HOSP_SUB_DIV}                  HOSP      HOSP ACCO      HOSP EHS      HOSP FACI      HOSP TRAV
@{LIST_INNO_SUB_DIV}                  INNO      INNO ACOU      INNO COMP      INNO MECH
...                                   INNO PCB    INNO SOFT      INNO SYST
@{LIST_LEGA_SUB_DIV}                  LEGA COMM      LEGA GOVE      LEGA HEAR      LEGA IP
@{LIST_QUAL_SUB_DIV}                  QUAL
@{LIST_RESE_SUB_DIV}                  RESE      RESE AI      RESE DATA      RESE PLAT
@{LIST_STRA_SUB_DIV}                  STRA PROD
@{LIST_TRAN_SUB_DIV}                  TRAN    TRAN BRAN    TRAN SHAR
@{LIST_TREA_SUB_DIV}                  TREA INVE    TREA OTC    TREA PTP    TREA RTR    TREA TAX
@{LIST_VALU_SUB_DIV}                  Customer Feedback    VALU    VALU DM    VALU IDM
@{LIST_VISI_SUB_DIV}                  VISI STRA

@{LIST_ASSET_FORMATS}                 Select All    Desktop Banner    Tablet Banner    Mobile Banner
...                                   Facebook Cover Photo    Facebook Wall Post     Facebook Story Post
...                                   Instagram Wall Post    Instagram Story Post    Twitter Cover Photo
...                                   Twitter Wall Post      Community News Post     Community Brand Post
...                                   Mailchimp Product Image    MS Teams Banner     LinkedIn Post
...                                   Amazon Banner

@{LIST_FORMAT}                        JPG    PNG    TIFF    PDF    AI

${IMG_SPECIFIC_IMAGE}                  //label[contains(text(), 'Specific Images to use')]/following::input[@name='attachment'][1]
${IMG_HEADER_CONTENT}                  //label[contains(text(), 'Header and content Image')]/following::input[@name='attachment'][1]
${IMG_FLOORPLAN}                       //label[contains(text(), 'Structural Floorplan')]/following::input[@name='attachment'][1]
${IMG_REFERENCE}                       //label[@for='photoReferenceInput']/following::input[@name='attachment'][1]
${IMG_PRODUCT_LIST}                    //label[@for='prdoctListInput']/following::input[@name='attachment'][1]

${TXT_HEADLINE}                        //input[@formcontrolname='headline']
${TXT_SUB_HEADLINE}                    //input[@formcontrolname='subHeadline']
${TXTA_HEADLINE}                       //textarea[@formcontrolname='headlineOrText']
${TXT_PROOFED_COPY}                    //textarea[@formcontrolname='proofedCopyImagesLink']

${DATE_PUBLIC_LAUNCH}                  //label[@for='publicLaunchDate']/following::input[1]
${DATE_POSTING}                        //label[@for='postingDate']/following::input[1]
${DATE_NEEDED}                         //label[@for='dateNeeded']/following::input[1]

${DDL_BRAND}                           //label[@for='brand']/following-sibling::div/select
${TXT_ASSET_FORMATS}                   //label[@for='requiredAssetFormats']/following::input[1]
${TXT_FORMAT}                          //label[@for='formats']/following::input[1]

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

# Excel Variables
${SHEET_NAME}                            GRAP
${COL_SUB_DIVISION}                      Sub-Division
${COL_SERVICE_CLASSIFICATION}            Service Classification
${COL_SERVICE_TYPE}                      Service Type
${COL_SERVICE_REQUIREMENT}               Service Requirement

# Input Variables

# Add (FACE) once fixed
${INPUT_DIVISION}                        Face Tribes
${INPUT_HEADLINE}                        Sample Headline
${INPUT_SUB_HEADLINE}                    Sample Sub-Headline
${INPUT_SUBJECT}                         Internal QA Test GRAP
${INPUT_PROOFED_COPY}                    Sample Proofed Copy ${\n} https://file-examples.com/index.php/sample-images-download/sample-jpg-download/
