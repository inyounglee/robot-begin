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


.. _selenium-library-examples:

Examples

.. _selenium-library-examples-login-test:

로그인 테스트

.. code:: robotframework

    *** Settings ***
    Library           SeleniumLibrary
    
    Suite Setup       Open Browser    ${url}    ${browser}
    Suite Teardown    Close Browser
    
    *** Variables ***
    ${url}            http://www.example.com
    ${browser}        chrome
    
    *** Test Cases ***
    Login Test
        [Documentation]    This test case verifies login functionality.
        Input Text    username_field    johndoe
        Input Text    password_field    password
        Click Button    login_button
        Page Should Contain    Welcome, John Doe!
    
    Search Test
        [Documentation]    This test case verifies search functionality.
        Input Text    search_field    Robot Framework
        Click Button    search_button
        Page Should Contain    Results for 'Robot Framework'
    
    *** Keywords ***
    Page Should Contain
        [Arguments]    ${expected_text}
        Wait Until Page Contains    ${expected_text}    timeout=10s