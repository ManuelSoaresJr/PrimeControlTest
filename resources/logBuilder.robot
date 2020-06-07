*** Settings ***
Documentation    Robo responsável por centralizar a construção de logs do projeto.
Library    SeleniumLibrary
Library    OperatingSystem

*** Keywords ***
Log Builder
    [Arguments]    ${LEVEL}    ${MESSAGE}    ${TASK}
    Log    ${MESSAGE}    level=${LEVEL}    console=yes 
    ${currentTime}=     Get Time    NOW
    Append to File    log/log.txt    ${currentTime} - ${LEVEL} - ${TASK} - ${MESSAGE} \n 

ErrorLog Builder
    [Arguments]    ${TASK}    ${MESSAGE}
    ${currentTime}=     Get Time    NOW
    Append to File    log/error.txt    ${currentTime} - ${TASK} - ${MESSAGE} \n
    Log Builder    LEVEL=ERROR    MESSAGE=${MESSAGE}    TASK=${TASK}
    # finaliza execução do workflow
    Fatal Error  msg=Execução concluída com falha.
    Close Browser