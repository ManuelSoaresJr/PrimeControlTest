*** Settings ***
Documentation    Workflow teste para PrimeControl. Acessar o site de developer do clashroyale, obter uma lista de membros de um determinado clan e exportar em csv
Library    SeleniumLibrary
Library    OperatingSystem
Library    resources/generateClanMembersCsv.py
resource    resources/logBuilder.robot

*** Variable ***
${URL}    https://developer.clashroyale.com/
${IPURL}    https://www.expressvpn.com/pt/what-is-my-ip
${BROWSER}    Chrome
${USERID}    manuelsoaresjr@yahoo.com.br
${PASSWORD}    password
${KEYNAME}    Teste
${KEYDSC}    Chave para acesso a API Clash Royale pelo robo de teste PrimeControl.
${IP}      
${CLANNAME}    The resistance
${LOCATION}    Brazil
${TOKEN}

*** Tasks ***
Obter Ip Dinamicamente
    #log de inicio do processo   
    Log Builder    LEVEL=INFO    MESSAGE=Processo teste PrimeControl iniciado.    TASK=Teste PrimeControl
    [Documentation]    Obter o endereço ip externo da maquina local dinamicamente.
    #log de inicio de tarefa   
    Log Builder    LEVEL=INFO    MESSAGE=Task iniciada.    TASK=Obter Ip Dinamicamente
    Open Browser    ${IPURL}    ${BROWSER}
        # check da tarefa
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:ip-address    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Obter Ip Dinamicamente    MESSAGE=Site para verificação dinâmica de ip não está disponível.
        # Em caso de sucesso
    ${IP}=    Get Element Attribute    class:ip-address    innerText
    Set Global Variable      ${IP}
    Log Builder    LEVEL=DEBUG    MESSAGE=Obter Ip externo concluído - ${IP}.    TASK=Obter Ip Dinamicamente
    Close Browser

Login Clash Royale API Website
    [Documentation]    Acessar o website https://developer.clashroyale.com/ e efetuar login
    #log de inicio de tarefa   
    Log Builder    LEVEL=INFO    MESSAGE=Task iniciada.    TASK=Login Clash Royale API Website
    ## Ações da tarefa
    # Acessar website da API Clash Royale
    Open Browser    ${URL}    ${BROWSER}
        # check da tarefa
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:header__brand    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Login Clash Royale API Website    MESSAGE=Erro ao abrir a URL solicitada.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Acessar URL concluído.    TASK=Login Clash Royale API Website
    # Clicar no botão login
    Click Element    dom:document.getElementsByClassName("login-menu")[0].lastChild
        # check da tarefa
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    id:email    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Login Clash Royale API Website    MESSAGE=Elemento Log In não localizado.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Clicar em Login concluído.    TASK=Login Clash Royale API Website
    # Realizar Login
    Input Text    id:email    ${USERID}
    Input Password    id:password    ${PASSWORD}
    Click Button    class:btn-primary
        # check da tarefa
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:dropdown-toggle__text    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    Error Handling    TASK=Login Clash Royale API Website    RECOVERY=True    SCENE=1
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Realizar Login concluído.    TASK=Login Clash Royale API Website

Criar Nova Chave
    [Documentation]    Criar uma chave de acesso para API Clash Royale vinculado ao usuário utilizado.
    #log de inicio de tarefa
    Log Builder    LEVEL=INFO    MESSAGE=Task Criar Nova Chave iniciada.    TASK=Criar Nova Chave
    ## Ações da tarefa
    # Clicar no drop down menu
    ${STATUS}=    Run Keyword And Return Status    Click Button    class:dropdown-toggle
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Falha ao clicar no drop-down menu.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Clicar em dropdown button concluído.    TASK=Criar Nova Chave
    # Clicar no sub menu account
    ${STATUS}=    Run Keyword And Return Status    Click Element    dom:document.getElementsByClassName("dropdown-menu")[0].firstElementChild
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Falha ao clicar no sub menu account.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Clicar em account menu concluído.    TASK=Criar Nova Chave
    # Clicar em criar nova chave
    ${STATUS}=    Run Keyword And Return Status    Click Element    class:create-key-btn
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Falha ao clicar no botão criar nova chave.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Clicar em create new key concluído.    TASK=Criar Nova Chave
    # Criar Chave
    Input Text    id:name    ${KEYNAME}
    Input Text    id:description    ${KEYDSC}
    Input Text    id:range-0    ${IP}
    Click Button    class:btn-primary
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:alert-success    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Falha ao criar nova chave.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Create new key concluído.    TASK=Criar Nova Chave
    # Acessar detalhes da nova chave
    Sleep    3 s
    Click Element    dom:document.getElementsByClassName('api-keys')[0].childNodes[1].childNodes[0]
        # check da tarefa
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:delete-btn    7 s
        # Em caso de falha
    Run keyword if    ${STATUS}==False    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Falha ao acessar detalhes da nova chave.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Acessar detalhes da nova chave concluído.    TASK=Criar Nova Chave
    # Recuperar Token
    ${TOKEN}=    Get Element Attribute    dom:document.getElementsByClassName('input-lg')[0].firstElementChild    textContent
    Set Global Variable      ${TOKEN}
        # Em caso de falha
    Run keyword if    "${TOKEN}"=="${None}"    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=Não foi possível recuperar o token.
        # Em caso de sucesso
    Log Builder    LEVEL=DEBUG    MESSAGE=Recuperar Token concluído - ${TOKEN}.    TASK=Criar Nova Chave
    Close Browser

Gerar csv
    [Documentation]    Atraves de um script em python, utiliza a API clash royale com o token obtido, recupera os dados necessários e gera o CSV experado na pasta results.
    #log de inicio de tarefa
    Log Builder    LEVEL=INFO    MESSAGE=Task Gerar csv iniciada.    TASK=Gerar csv
    ## Ações da tarefa
    ${STATUS}=    Generate ClanMembers Csv    ${CLANNAME}    ${LOCATION}    ${TOKEN}
        # Em caso de falha
    Run keyword if    "${STATUS['status']}"!="Success"    ErrorLog Builder    TASK=Criar Nova Chave    MESSAGE=${STATUS}    
        # Em caso de sucesso
    Run keyword if    "${STATUS['status']}"=="Success"    Log Builder    LEVEL=DEBUG    MESSAGE=Gerar csv concluído.    TASK=Gerar csv

*** Keywords ***
Error Handling
    [Arguments]    ${TASK}    ${RECOVERY}    ${SCENE}
    # Utilize o recurso abaixo para mapear e construir cenários de tentativa de recuperação de erros conhecidos
    ## Task Realizar Login
    Run keyword if    ${RECOVERY}==True and ${SCENE}==1   Verificar Se User e Senha Invalidos    TASK=${TASK}
    # Caso a recuperação não seja possivel
    ErrorLog Builder    TASK=${TASK}    MESSAGE=Erro na realização da tarefa

#### Cenarios de Error Handling ####
##
## User e senha invalidos na autenticação
Verificar Se User e Senha Invalidos
    [Arguments]    ${TASK}
    # Buscar elemento Alert #ToDo - Melhorar seletor
    ${STATUS}=    Run Keyword And Return Status    Wait Until Element Is Visible    class:alert-danger
    # Caso user e senha invalidos
    Run keyword if    ${STATUS}==True   User e Senha Invalidos    TASK=${TASK}
    # Gerar erro
    ErrorLog Builder    TASK=${TASK}    MESSAGE=Usuário e senha invalidos.
User e Senha Invalidos
    [Arguments]    ${TASK}
    # Notificar Cliente por e-mail
    # To Do
    Log Builder    LEVEL=INFO    MESSAGE=Cliente Notificado por e-mail.    TASK=${TASK}
    
