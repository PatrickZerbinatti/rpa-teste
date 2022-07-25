*** Settings ***
Library          Browser
Library          String
Library          variables.py


*** Keywords ***
Imprimir Business Case
    [Arguments]     ${businessButton}
    ${elem}=          Get Element   ${businessButton}
    ${href}=          Get Property  ${elem}  href

    New Page        ${href}

    ${name}     Get Text    //*[@id="block-data-visualizer-content"]/div/fieldset[1]/div/div/div[1]/div[2]
    ${name_striped}     Replace String        ${name}       ${EMPTY}        _
    ${name_striped}     Replace String        ${name_striped}       :        -

    ${dl_promise}            Promise To Wait For Download                     ${OUTPUT}\\${name_striped}.html
    Download      ${href}
    ${file_obj}=             Wait for                                          ${dl_promise}
    Close Page
