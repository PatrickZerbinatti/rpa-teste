*** Settings ***
Library    Browser
Library    Collections
Library    ../../LIBRARY/CORE/variables.py
Library    String
Library    RPA.Excel.Files
Resource    ../../LIBRARY/ITDASHBOARD/WEB/RESOURCE/PAGE/home.robot
Resource    ../../LIBRARY/ITDASHBOARD/WEB/LOCATORS/itdashboard_locator.robot
Resource    ../../LIBRARY/ITDASHBOARD/WEB/LOCATORS/advanced_search_locator.robot
Resource    ../../LIBRARY/CORE/extracoes.robot
Resource    ../../LIBRARY/CORE/download_file.robot
Resource    ../../LIBRARY/ITDASHBOARD/WEB/RESOURCE/resource.robot

*** Variables ***
@{agency_list}=    Create List
&{chosen_agency}
${PAGES}

*** Tasks ***
Extracao de dados
    Dado que eu entre no site itdashboard       30      ${URL_ITDASHBOARD}      True
    Entao extraio a lista de agencias e suas respectivas despesas
    E escrevo as agencias em um arquivo excel  Agency   ${agency_list}
    Entao vou para a pesquisa avancada
    E seleciono a agencia configurada
    E extraio o valor de cada investimento fazendo download de todos os arquivos
    E escrevo a agencia escolhida no mesmo excel    ${AGENCY_WANTED}    ${agency_list}     ${OUTPUT}\\Agency.xlsx

*** Keywords ***
Entao extraio a lista de agencias e suas respectivas despesas
    @{elements} =    Get Select Options    ${agencySelect}

    @{agency_list}=    Create List
    FOR     ${element}  IN  @{elements}
        ${name}       Get From Dictionary         ${element}        label
        ${selected}   Get From Dictionary    ${element}    selected

        IF  '${selected}' == 'False'
            ${promise}      Promise To    Wait For Response    response => response.url().endsWith('plotlyElement.js?v=0.1') && response.request().method() === 'GET'
            ${selected}     Select Options By       ${agencySelect}        label       ${name}
            Wait For    ${promise}
        END

        ${amount}       Get Text    ${agencyAmount}

        ${agency}       Create Dictionary       name=${name}      amount=${amount}
        Append To List      ${agency_list}       ${agency}
    END

    Set Global Variable    ${agency_list}


E escrevo as agencias em um arquivo excel
    [Arguments]     ${name}   ${list}

    Create Workbook     sheet_name=${name}
    Append Rows To Worksheet    ${list}
    Save Workbook   ${OUTPUT}\\${name}.xlsx


Entao vou para a pesquisa avancada
    Go To    ${URL_SEARCH_ADVANCED}


E seleciono a agencia configurada
    Type Text    ${searchInput}    ${AGENCY_WANTED}
    ${promise}      Promise To    Wait For Response    response => response.url().endsWith('size') && response.request().method() === 'GET'
    Click e espero a resposta da requisicao     ${searchButton}     plus.svg        GET
    ${total_pages}      Wait For    ${promise}
    
    ${total_pages}      Get From Dictionary    ${total_pages}    body

    ${itens_by_page}    Get Selected Options    //*[@id="show-by"]

    ${PAGES}    Evaluate    ${total_pages}/${itens_by_page}

    ${PAGES}    Convert To Number   ${PAGES}    0
    
    Set Global Variable    ${PAGES}


E extraio o valor de cada investimento fazendo download de todos os arquivos

    ${spending_list}        Create List
    ${uii_list}     Create List

    FOR    ${page}    IN RANGE    ${PAGES}
        ${spendings}        Extrair lista de texto de selector com muitiplos resultados     ${multipleSpending}
        ${uiis}     Extrair lista de texto de selector com muitiplos resultados     ${multipleUii}

        ${download_exists}      Get Element Count    ${businessCase}
        IF    ${download_exists} != 0
            ${download_buttons}     Get Elements        ${businessCase}
            FOR    ${button}    IN    @{download_buttons}
                Imprimir Business Case      ${button}
            END
        END


        Append To List    ${spending_list}      ${spendings}
        Append To List    ${uii_list}      ${uiis}
        IF    ${page+1} < ${PAGES}
            Click e espero a resposta da requisicao     ${nextPage}     none/       GET
        END
    END

    &{chosen_agency}=    Create Dictionary    spending=${spending_list}    uii=${uii_list}
    Set Global Variable    &{chosen_agency}


E escrevo a agencia escolhida no mesmo excel
    [Arguments]    ${name}    ${list}   ${dir}

    Open Workbook    ${dir}
    Create Worksheet    name=${name}  content=${list}   header=True
    Save Workbook