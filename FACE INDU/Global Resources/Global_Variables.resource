*** Settings ***
Documentation    Global Variables for Test Cases.


*** Variables ***
# Global Links
${BROWSER}                      Firefox
# ${BROWSER}                        Chrome
${LIBRARY_URL_PROD}               https://library.musictribe.com/library/
${LIBRARY_URL_UAT}                https://library.musictribe.com/uat-library/

# Global Variables
${MAX_TIMEOUT}                                   30s
${BTN_SIGN_IN}                                   //input[@name='login']
${LBL_LIBRARY_DIVISION}                          //p[@class='main-title']
${LBL_LIBRARY_HEADER_SUBTITLE}                   //div[@class='row document-header__subtitle ']
${LBL_LIBRARY_BREADCRUMB}                        //li[@class='breadcrumb--item active']
${LBL_LIBRARY_HEADER_DIVISION}                   //h2[@class='document-header__title mb-4 mb-sm-0']

# Excel Data
${FILE_MASTER_DATA}                  ${CURDIR}/../Resources/MT-GLOB_Music-Tribe-Library-Divisions-List_2023-07-24_Rev.0.xlsx

# Excel Data - Column Names
${SHEET_COLUMN_SLUG}                        Slug
${SHEET_COLUMN_NAME}                        Name
${SHEET_COLUMN_DESCRIPTION}                 Description

# URL Response Check
${STATUS_EXPECTED_RESPONSE}          200
