*** Settings ***
Resource          ../Settings/Library.robot
Resource          ../Locators/YouTubePage.robot

*** Variables ***
${json}           ${empty}

*** Test Cases ***
Get Result From YouTube API
    Log To Console    "READING FROM YouTube API...."
    ${fileContent}    Catenate    ${EXECDIR}\\Resources\\YouTube\\YouTubeAPIReader.exe
    Log To Console    ${fileContent}
    ${stdOut}    Run Process    ${fileContent}    stdout=stdout.json
    ${apiResult}    Get File    stdout.json
    Log To Console    ${apiResult}
    ${lines}    Split To Lines    ${apiResult}
    ${length}    Get Length    ${lines}
    : FOR    ${I}    IN RANGE    1    ${length}
    \    ${e} =    Get From List    ${lines}    ${I}
    \    ${str} =    Replace String Using Regexp    ${e}    \(.*):    ${EMPTY}
    \    Log To Console    ${str}
    ${tmp}    Load Json From File    stdout.json
    Set Suite Variable    ${json}    ${tmp}

Compare API With UI
    Log To Console    Comparing API Results To UI....
    Open Browser    about:blank    ${browser}
    Maximize Browser Window
    ${count} =    Get Length    ${json}
    : FOR    ${i}    IN RANGE    0    ${count}
    \    ${videos}    Get From Dictionary    ${json}    ${i}
    \    ${link}    Get From Dictionary    ${videos}    Link
    \    ${title}    Get From Dictionary    ${videos}    Title
    \    ${desciption}    Get From Dictionary    ${videos}    Description
    \    Go To    ${link}
    \    ${videoTitleOnThePAge}    Get Text    ${videoTitleXpath}
    \    Log    ${videoTitleOnThePAge}
    \    Should Be Equal    ${videoTitleOnThePAge}    ${title}
    \    ${url}    Get Location
    \    Should Be Equal    ${link}    ${url}
    \    Sleep    2s
    \    ${videoDEscOnThePAge}    Get Text    ${videoDescXpath}
    \    Log    ${videoDEscOnThePAge}
    \    Capture Page Screenshot    ${i}.png
    Close All Browsers
