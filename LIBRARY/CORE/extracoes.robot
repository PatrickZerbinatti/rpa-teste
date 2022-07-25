*** Settings ***
Library     Browser
Library     Collections


*** Keywords ***

Extrair lista de texto de selector com muitiplos resultados
    [Arguments]       ${selector}

    ${elements}         Browser.Get Elements        ${selector}

    ${return_list}        Create List
    FOR    ${element}    IN    @{elements}
        ${text}         Get Text        ${element}
        Append To List    ${return_list}      ${text}
    END

    RETURN     ${return_list}
