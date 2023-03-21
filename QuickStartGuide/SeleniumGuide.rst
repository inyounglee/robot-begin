.. default-role:: code

============================================
  Seleninum Library - 사용 가이드 - Examples
============================================

.. contents::
   :local:
   :depth: 2

SeleniumLibrary 설치
---------------------

`SeleniumLibrary`_ 는 `Robot Framework`_ 의 테스트 라이브러리입니다.
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
    
    Suite Setup       Open Browser    ${url}    ${browser}
    Suite Teardown    Close Browser
    
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
