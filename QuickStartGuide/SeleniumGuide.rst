.. default-role:: code

============================================
  Seleninum Library - 사용 가이드 - Examples
============================================

.. contents::
   :local:
   :depth: 2

SeleniumLibrary 설치
---------------------

`SeleniumLibrary`_ (`Selenium Reference Guide`_) 는 `Robot Framework`_ 의 테스트 라이브러리입니다.
Robot Framework는 Python으로 작성되었으며, Python 2.7 이상이 설치되어 있어야 합니다.

SeleniumLibrary는 다음과 같이 설치할 수 있습니다.
더 상세한 내용은 `설치 가이드`_ 를 참조하시기 바랍니다.

.. code:: bash

    $ pip install robotframework-seleniumlibrary

* 위 명령으로 설치된 결과
    - PySocks-1.7.1
    - async-generator-1.10
    - cffi-1.15.1
    - h11-0.14.0
    - outcome-1.2.0
    - pycparser-2.21
    - robotframework-pythonlibcore-4.1.2
    - robotframework-seleniumlibrary-6.0.0
    - selenium-4.8.2
    - sniffio-1.3.0
    - sortedcontainers-2.4.0
    - trio-0.22.0
    - trio-websocket-0.10.2
    - wsproto-1.2.0

.. _Robot Framework: http://robotframework.org
.. _SeleniumLibrary: https://github.com/robotframework/SeleniumLibrary
.. _Selenium Reference Guide: https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
.. _설치 가이드: https://github.com/robotframework/SeleniumLibrary#installation


SeleniumLibrary 와 Selenium2Library 비교
------------------------------------------

다음은 차이점을 비교한 표입니다.

+----------------------+-----------------------------------------------------+------------------------------------------------------+
|                      | SeleniumLibrary                                     | Selenium2Library                                     |
+======================+=====================================================+======================================================+
| Selenium 버전        | Selenium 3 이상                                     | Selenium 2.x                                         |
+----------------------+-----------------------------------------------------+------------------------------------------------------+
| 드라이버             | GeckoDriver, ChromeDriver 등 지원                   | FirefoxDriver, ChromeDriver 등 지원                  |
+----------------------+-----------------------------------------------------+------------------------------------------------------+
| 키워드               | Selenium WebDriver의 API 직접 사용                  | Selenium WebDriver의 API를 래핑하여 간결한 문법 제공 |
+----------------------+-----------------------------------------------------+------------------------------------------------------+
| 예시 키워드          | Click Element, Input Text, Get Element Attribute 등 | Click Element, Input Text, Get Text 등               |
+----------------------+-----------------------------------------------------+------------------------------------------------------+
| Robot Framework 버전 | Robot Framework 3.x                                 | Robot Framework 2.x                                  |
+----------------------+-----------------------------------------------------+------------------------------------------------------+

로그인 테스트
-------------

위 `SeleniumLibrary 설치`_ 후 다음 명령으로 수행하면 FAIL이 나더라고 일단 테스트를 수행해볼 수 있으며
chrome 브라우저가 open 했다가 close 하는 것을 확인할 수 있다. (향 후 headless로 동작하는 것도 테스트해볼 것)

.. code:: bash

    $ robot SeleniumGuide.rst

.. code:: robotframework

    *** Settings ***
    Library           SeleniumLibrary
    Library           OperatingSystem
    Library           DatabaseLibrary
    Library           lib/utils.py
    
    #Suite Setup       Open Browser    ${url}    ${browser}
    #Suite Teardown    Close Browser
   
    *** Variables ***
    ${url}            http://localhost:5000
    ${browser}        chrome
    
    *** Test Cases ***
    Login Test
        [Documentation]    로그인 테스트
        로그인 페이지 접속
        Input Text    username    admin
        Input Text    password    admin
        Click Button    xpath://*[@id="loginForm"]/div/div/button
        Page Should Contain    You are log in.
    
    Search Test
        [Documentation]    This test case verifies search functionality.
        Input Text    search_field    Robot Framework
        Click Button    search_button
        Page Should Contain    Results for 'Robot Framework'
    
    *** Keywords ***
    Page Should Contain
        [Arguments]    ${expected_text}
        Wait Until Page Contains    ${expected_text}    timeout=10s

.. error::

    [ ERROR ] Error in file 'D:\works\robot-begin\QuickStartGuide\SeleniumGuide.rst' on line 9: Non-existing setting ''.
    `Suite Setup` 과 `Suite Teardown` 는 여러줄로 작성할 수 있으나,
    한 줄일때는 `Suite Setup` 과 `Suite Teardown` 키워드과 같은 줄에 작성해야 한다.


화면이 뜨는 것을 기다리기
--------------------------

1. Implicit Wait:
   Set Selenium Implicit Wait 키워드를 사용하여 일정 시간 동안 기다릴 수 있습니다.
   이 방법은 모든 Selenium 키워드에 대해 적용되며, 예를 들어 다음과 같이 사용할 수 있습니다.

    .. code:: robotframework
    
        *** Test Cases ***
        My Test Case
            Set Selenium Implicit Wait    10 seconds

2. Explicit Wait:
   Wait Until Page Contains Element 또는 Wait Until Element Is Visible 등의
   Selenium 키워드를 사용하여 특정 요소가 나타날 때까지 기다릴 수 있습니다.
   이 방법은 특정 요소가 나타날 때까지 기다릴 필요가 있는 경우 유용합니다.

    .. code:: robotframework
    
        Wait Until Page Contains Element    xpath=//input[@id='username']

3. Custom Wait:
   직접 작성한 Python 함수를 사용하여 원하는 대로 기다릴 수 있습니다.
   예를 들어 다음과 같이 작성한 함수를 사용하여 5초 동안 기다릴 수 있습니다.

    .. code:: robotframework
    
        from time import sleep
        
        def wait_for_page_to_load():
            sleep(5)
            
        *** Test Cases ***
        My Test Case
            Call Python    wait_for_page_to_load

XPath로 Element 찾기
---------------------

- Log in을 포함하는 a 태그 찾기 그리고 첫번째 a 태그를 클릭

    - Chrome 브라우저에서는 console에 다음과 같이 입력하면 xpath를 볼 수 있다.

        .. code:: javascript
        
            $x(".//a[contains(text(),'Log in')]")
            $x(".//a[contains(text(),'Log in')]")[0]


    .. code:: robotframework

        *** Keywords ***
        로그인 페이지 접속
            [Documentation]    로그인 페이지 접속
            Wait Until Page Contains Element    xpath:.//a[contains(text(),'Log in')]
            Click Element    xpath:.//a[contains(text(),'Log in')]
            Wait Until Page Contains Element    xpath://*[@id="loginForm"]/div/div/button

- 상품 목록에서 n 번째 상품명 선택
  ( `예제` 는 `"//*[@id="productList"]/div/div[${index}]/div[2]/div[1]/a"` )
  , n값을 사용자 입력을 받는 테스트 (중요: `Dialogs`_ 라이브러리 사용)

    .. code:: robotframework

        *** Settings ***
        Library    Dialogs

        *** Keywords ***
        n번째 상품명은
            [Arguments]    ${index}
            @{Elements}=    Get WebElements    xpath:.//div[contains(@class,'product-list')]/a/div/div[1]/span
            ${product_name}=    Get Text    ${Elements}[${index}]
            [Return]    ${product_name}

        *** Test Cases ***
        2번째 상품명 출력
            ${product_name}=    n번째 상품명은    2
            Log    ${product_name}

        사용자가 입력한 n번째 상품명 출력
            ${input}=  Get Value From User    몇번째 상품명을 가져올지 숫자 입력:
            ${product_name}=    n번째 상품명은    ${input}
            Log    ${product_name}

    - 위 예제에서 Dialog는 다음과 같이 뜬다.

        .. image:: ./Dialogs.png
            :width: 220px
            :align: center

.. _Dialogs: https://robotframework.org/robotframework/latest/libraries/Dialogs.html#Get%20Value%20From%20User

DB 테스트
---------

- DB 테스트를 위해 `DatabaseLibrary`_ 를 설치 이용한다. (**주: 설치해야 한다.** franz-see에 의해 Python으로 구현되어 있음)
  본 테스트에서는 이를 이용한다.

    .. code:: bash
        
            $ pip install robotframework-databaselibrary

- 또는 DB 테스트를 위해 `DBLibrary`_ 를 설치한다.
  (이것은 github copilot이 추천해준 라이브러리, Java로 구현되어 있음)

    .. code:: bash
    
        $ pip install robotframework-dblibrary

MariaDB에 접속하고 접속 해제

- Settings 절에 아래와 같이 Library를 추가해야 한다.
  Suite Setup/Teardown이 하나만 허용하므로 위에 `로그인 테스트`_ 에 기술한다.

    .. code:: text
    
        Library           DatabaseLibrary
        
        Suite Setup
            Connect To Database    ${DBAPI_NAME}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
        Suite Teardown
            Disconnect From Database

.. error::

    `Connect To Database` 를 `Suite Setup` 에서 사용을 하면 `Query` 키워드 동작시에 다음과 같은 오류가 발생한다.
    `AttributeError: 'NoneType' object has no attribute 'cursor'`
    따라서 위와 같이 말고, 아래와 같이 `MariaDB 접속 테스트` 에서 Query 전과 후에 `Disconnect From Database` 로 함께 사용한다.

.. code:: robotframework

    *** Test Cases ***
    MariaDB 접속 테스트
        [Documentation]    MariaDB 접속 테스트
        Connect To Database    ${DBAPI_NAME}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
        ${result}=    Query    SELECT 1
        Log Many    ${result}
        Disconnect From Database

    *** Variables ***
    ${DBAPI_NAME}       pymysql
    ${DBAPI_MODULE}     pymysql
    ${DB_NAME}          test
    ${DB_USER}          test
    ${DB_PASSWORD}      test
    ${DB_HOST}          localhost
    ${DB_PORT}          3306
    ${DB_PARAMETERS}


Insert 테스트

.. code:: robotframework

    *** Test Cases ***
    MariaDB Insert 테스트
        [Documentation]    MariaDB Insert 테스트
        Connect To Database    ${DBAPI_NAME}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
        ${result}=    Execute Sql String    INSERT INTO user (name, age) VALUES ('test', 10)
        Log    ${result}
        Disconnect From Database


.. _DatabaseLibrary: https://franz-see.github.io/Robotframework-Database-Library/api/1.2.2/DatabaseLibrary.html
.. _DBLibrary: https://github.com/MarketSquare/robotframework-dblibrary 

테스트 케이스 실행 또는 제외
-----------------------------

- 테스트 케이스 실행

    .. code:: bash
        
        $ robot --test "테스트 케이스 이름" SeleninumGuide.rst
        > robot.exe --test "MariaDB 접속 테스트" .\SeleniumGuide.rst
        > robot.exe --test "MariaDB*" .\SeleniumGuide.rst

- 테스트 케이스 제외

    .. code:: bash
            
        $ robot --exclude "테스트 케이스 이름" SeleninumGuide.rst
        > robot.exe --exclude "MariaDB 접속 테스트" .\SeleniumGuide.rst


User-Agent 변경
---------------

.. code:: robotframework

    *** Test Cases ***
    User-Agent 변경 테스트
        ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
        #${user_agent}=  Set Variable  Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36
        #${user_agent}=  Set Variable    Inyoung's RobotFramework Test
        ${user_agent}=  Set Variable    --user-agent="Inyoung's RobotFramework Test"
        #Call Method  ${options}  add_argument  --user-agent=${user_agent}
        Call Method  ${options}  add_argument  ${user_agent}
        Create Webdriver  Chrome  chrome_options=${options}
        #${desired_capabilities}=  Create Dictionary  chromeOptions=${options.to_capabilities()}
        #Open Browser  http://localhost:5000  chrome  ${desired_capabilities}
        Go To    http://localhost:5000
        wait for    5
        Close Browser

테스트는 다음과 같이 User-Agent 변경 테스트만 따로 실행한다.
(Suite Setup/Teardown을 주석처리하여 동작하지 않도록 설정해야 한다.)

.. code:: bash

    $ robot --test "User-Agent 변경 테스트" .\SeleniumGuide.rst

.. note::

    정확히 다음과 같은 상태에서 테스트가 정상적으로 동작한다.
    주석처리된 부분은 또 다른 예제들로 실패한다.
    이후 테스트 필요. by 이인영

::

    ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    ${user_agent}=  Set Variable    --user-agent="Inyoung's RobotFramework Test"
    Call Method  ${options}  add_argument  ${user_agent}
    Create Webdriver  Chrome  chrome_options=${options}
    Go To    http://localhost:5000

.. note::

    다음의 첫번째가 Robot Framework에서 Selenium WebDriver를 이용하여 요청을 보낼 때 User-Agent 이고,
    두번째는 Chrome 브라우저로 직접 요청을 보낼 때 User-Agent 이다. 둘이 동일한것을 알 수 있다.

::

    Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36
    Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36


브라우저 크기를 설정하여 열기
--------------------------------

* 아래의 예제는 이전 `로그인 테스트`_  에서 Suite Setup/Teardown을 주석처리하여 동작하지 않도록 설정한 후 실행해야 한다.

.. code:: robotframework

    *** Keywords ***
    Chrome 브라우저 오픈
        ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
        ${windows_size}=  Set Variable    --window-size=1920,1080
        Call Method  ${options}  add_argument  ${windows_size}
        Create Webdriver  Chrome  chrome_options=${options}
        Go To    ${url}


    *** Settings ***
    # 이건 동작하지 않는다.
    #Suite Setup       Open Browser    ${url}    ${browser}    window_size=1920x1080
    # 이건 오류가 발생한다. "ValueError: not enough values to unpack (expected 2, got 1)"
    #Suite Setup       Open Browser    ${url}    ${browser}    desired_capabilities=chromeOptions={"args": ["--window-size=1024,768"]}
    # 이것도 "Variable '${driver}' not found." 오류가 발생한다.
    #Suite Setup    ${driver}=    Open Browser    ${url}    ${browser}
    #...    ${driver}.set_window_size(1920, 1080)

    # 이것은 정상적으로 동작한다.
    Suite Setup       Chrome 브라우저 오픈
    Suite Teardown    Close Browser


아래의 예제를 Test cases 안에서 사용하면 정상적으로 동작한다.
그럼, Suite Setup 에서 사용하기 위해서는 어떻게 해야 하나?
`Chrome 브라우저 오픈` 과 같이 Keyword로 만들어서 사용하면 된다.

::

        ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
        ${windows_size}=  Set Variable    --window-size=1920,1080
        Call Method  ${options}  add_argument  ${windows_size}
        Create Webdriver  Chrome  chrome_options=${options}
        Go To    ${url}
 

스크롤하면서 목록 가져오기
--------------------------------

* 본 예제는 python-test/flask-shop 을 대상으로 제작된 것이다.

.. code:: robotframework

    *** Keywords ***
    Apparel 메뉴 선택
        Click Element    xpath:/html/body/header/div[3]/nav/ul/li[1]/a[contains(text(),"Apparel")]
        # Apparel 제목을 읽을 수 있을때까지 기다린다.
        Wait Until Page Contains Element    xpath://*[@id="product-list-page"]/div/div[2]/div/div[1]/h1/strong[contains(text(),"Apparel")]

    Scroll to Bottom
        Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)

    *** Test cases ***
    Apparel 제품 목록 읽기
        [Documentation]    Apparel 제품 목록 읽기
        Apparel 메뉴 선택
        ${product_list}=    Get Webelements    xpath://*[@id="product-list-page"]/div/div[2]/div/div[3]/div/div[1]/div[contains(@class,"product-list")]
        ${product_list_count}=    Get Length    ${product_list}
        Log Many    ${product_list}
        Log Many    ${product_list_count}
        FOR    ${i}    IN RANGE    0    ${product_list_count}
            ${element}=    Set Variable    xpath://*[@id="product-list-page"]/div/div[2]/div/div[3]/div/div[1]/div[${i}+1]/a/div/div[1]/span
            Wait Until Page Contains Element    ${element}
            Run Keyword And Ignore Error    Scroll Element Into View    ${element}
            wait for    1
            ${product_name}=    Get Text    ${element}
            Log Many    ${product_name}
        END
        Scroll to Bottom
        wait for    3

::

    Apparel 제품 목록:
    //*[@id="product-list-page"]/div/div[2]/div/div[3]/div/div[1]/div[contains(@class, "product-list")]
    Apparel 제품명:
    //*[@id="product-list-page"]/div/div[2]/div/div[3]/div/div[1]/div[1]/a/div/div[1]/span

.. error::

    위에서 `Run Keyword And Ignore Error` 를 사용하여
    `Scroll Element Into View` 키워드 실행시 발생하는 오류
    `MoveTargetOutOfBoundsException: Message: move target out of bounds` 를 무시하고 실행하도록 하여 해결한다.
