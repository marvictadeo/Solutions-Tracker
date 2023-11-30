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
${DDL_CUSTOMER_DIVISION}                     //select[@formcontrolname="senderDivision"]
${DDL_CUSTOMER_SUBDIVISION}                  //select[@formcontrolname="senderSubDivision"]
${DDL_CUSTOMER_LOCATION}                     //select[@formcontrolname="senderLocation"]

# DDL Value Lists
@{LIST_PRIORITY}                      Minor    Major    Critical
@{LIST_LOCATION}                      ET-VG1 (Empower Tribe VG1 Ltd.)
...                                   ET-VG2 (Empower Tribe VG2 Ltd.)
...                                   ET-VG3 (Empower Tribe VG3 Ltd.)
...                                   ET1 (Empower Trust)
...                                   MT-BM1 (Music Tribe Global Services Ltd.)
...                                   MT-BM2 (Music Tribe Commercial BM Ltd.)
...                                   MT-CA1 (Music Tribe Brands CA Ltd.)
...                                   MT-CN1 (Zhongshan Eurotec Electronics Limited)
...                                   MT-CN2 (Zhongshan Eurotec Electronics Limited – Shenzhen Branch)
...                                   MT-CN3 (Zhongshan Behringer Electronics Ltd.)
...                                   MT-DE1 (Music Tribe Brands DE GmbH)
...                                   MT-DK1 (Music Tribe Brands DK A/S)
...                                   MT-DK2 (Music Tribe Innovation DK A/S)
...                                   MT-IN1 (Music Tribe Innovation Private Limited)
...                                   MT-MU1 (Music Tribe Manufacturing Ltd.)
...                                   MT-MY1 (Music Tribe Commercial MY Sdn Bhd)
...                                   MT-MY2 (Music Tribe Hi-Tech Electronics Sdn Bhd)
...                                   MT-PH1 (Music Group Commercial BM Ltd. ROHQ)
...                                   MT-PH2 (Music Tribe Services PH Corp)
...                                   MT-PH3 (Music Group Macao Commercial Offshore Limited ROHQ - Philippines)
...                                   MT-PH4 (Music Group Commercial PH Inc.)
...                                   MT-PH5 (Behringer Holdings (Pte) Ltd. ROHQ)
...                                   MT-PH6 (Music Global Shared Services Inc.)
...                                   MT-SE1 (Music Tribe Brands Sweden AB)
...                                   MT-UK1 (Music Tribe Brands UK Ltd.)
...                                   MT-UK4 (Aston Microphones Limited)
...                                   MT-US1 (Music Tribe Commercial NV Inc.)
...                                   MT-VG1 (Music Tribe VG1 Ltd.)

@{LIST_BRANDS}                        Music Tribe    Aston Microphones    Midas    Lab Gruppen    Tannoy
...                                   Turbosound    TC Electronic    TC Helicon
...                                   Behringer    Klark Teknik    Bugera    Lake    Coolaudio

@{LIST_FACE_DIVISION}                 AVAI    BRAN    BRAN COMM    COMP    CUST AVAI    CUST SUPP
...                                   DIGI  FACE     HEAR      HOSP
...                                   INNO      LEGA      QUAL      RESE
...                                   STRA      TRAN      TREA      VALU      VISI

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
@{LIST_FACE_SUB_DIV}                  FACE      FACE COPY      FACE GRAP      FACE INDU
...                                   FACE MEDI      FACE PRIN      FACE QUAL    FACE REND
...                                   FACE STYL      FACE TECH      FACE UX      FACE VIDE
...                                   FACE WEB      PERF FACE BA
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
