*** Settings ***
Library     Browser

*** Keywords ***
Click e espero a resposta da requisicao
    [Arguments]     ${botao}     ${terminado_em}    ${metodo}
    ${promise}      Promise To    Wait For Response     response => response.url().endsWith('${terminado_em}') && response.request().method() === '${metodo}'
    Click    ${botao}
    Wait For        ${promise}