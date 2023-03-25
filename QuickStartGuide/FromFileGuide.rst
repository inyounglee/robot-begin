
Robot Framework의 Variable 들을 파일에서 읽는 예제
===================================================

예제 1
------------------

아래의 예제는 github copilot 이 추천해준 예제인데, 오류가 많아 해당 오류들을 모두 고쳐서 수정하여
동작하도록 만든 것이다. Test Cases의 `` 가 동작한 이후에 variable이 설정되는 한계를 가지고 있다.
그러나 실시간으로 Test Cases 가 동작하는 순간에 파일에서 읽어 값을 가져와 사용할 수 있다는 장점을 가진다.

사용되는 라이브러리

- `OperatingSystem`_
- `Collections`_
- `String`_
- `BuiltIn`_


다음의 키워드가 사용되고 있으므로 사용법을 확인할 수 있다.

- Get File
- Dictionary: Create, Set, Get
- Evaluate
- FOR
- IF

파일 `variable.conf` 의 내용은 다음과 같다.

::

    name=이인영
    address=서울시 강남구 역삼동
    phone=010-1234-5678
    age=25


.. code:: robotframework

    *** Settings ***
    Library    OperatingSystem
    Library    Collections
    Library    String

    *** Variables ***
    ${VARIABLES_FILE}    variables.conf
    ${LINE_FEED}    \n
    ${EQUAL}        =

    *** Test Cases ***
    Read Variables From File
        ${variables}=    Read Variables From File    ${VARIABLES_FILE}
        Log Many    ${variables}
        Log         ${variables}[name]
        Log         ${variables}[address]
        ${name}=    Get From Dictionary    ${variables}    name
        ${address}=    Get From Dictionary    ${variables}    address
        Log         ${name}
        Log         ${address}

    *** Keywords ***
    Read Variables From File
        [Arguments]    ${file}
        ${file_contents}=    Get File    ${file}
        ${lines}=    Split String    ${file_contents}    ${LINE_FEED}
        ${variables}=    Create Dictionary
        ${index}=    Set Variable    0
        FOR    ${line}    IN    @{lines}
            Log    ${line}
            IF    '${line}' == ''    BREAK
            ${key_value}=    Split String    ${line}    ${EQUAL}
            ${index}=    Evaluate    ${index} + 1
            Log Many    ${key_value}
            Log         ${index}
            ${key}=    Set Variable    ${key_value}[0]
            ${value}=    Set Variable    ${key_value}[1]
            Set To Dictionary    ${variables}    ${key}    ${value}
        END
        [Return]    ${variables}

.. warning::

    ${LINE_FEED} 변수를 설정할때 `${\n}` 으로 설정하면 에러가 발생한다.
    Github copilot 이 추천해준대로 사용했다가 오류가 발생했음.


.. _`OperatingSystem`: http://robotframework.org/robotframework/latest/libraries/OperatingSystem.html#Get%20File
.. _`Collections`: http://robotframework.org/robotframework/latest/libraries/Collections.html
.. _`String`: http://robotframework.org/robotframework/latest/libraries/String.html
.. _`BuiltIn`: http://robotframework.org/robotframework/latest/libraries/BuiltIn.html


예제 2 (Settings 섹션에서)
----------------------------

본 예제는 Settings 섹션에서 Variables 로 파일에서 읽어온 값을 사용하는 예제이다.

.. code:: robotframework

    *** Settings ***
    Variables    variables.py  ${OPTIONS}

    *** Variables ***
    ${OPTIONS}    encoding=utf-8

    *** Test Cases ***
    Read Variables From File2
        Log    ${name}
        Log    ${address}
        Log    ${phone}
        Log    ${age}

.. code:: python

    def get_variables(options=""):
    
        variables = {"name": "이인영",
            "address": "서울시 강남구 역삼동",
            "phone": "010-1234-5678",
            "age": 25}

        return variables
