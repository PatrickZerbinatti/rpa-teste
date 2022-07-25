*** Settings ***
Variables    ../../../../../LIBRARY/CORE/variables.py
Library      Browser


*** Keywords ***
Dado que eu entre no site itdashboard
    [Arguments]                ${timeout}           ${URL}              ${download}
    Set Browser Timeout        ${timeout}
    New Browser                headless=False
    New Context                acceptDownloads=${download}
    New Page                   ${URL}

