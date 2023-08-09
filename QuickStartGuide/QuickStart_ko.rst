.. default-role:: code

============================================
  Robot Framework Quick Start Guide 한글버전
============================================

.. contents:: Table of contents:
   :local:
   :depth: 2


시작하기 전에
=============

이 문서에 대하여
----------------

이 문서는 reStructuredText_ 마크업 문법을 사용하여 작성되었으며
Robot Framework의 사용법을 소개하면서 동시에 다음과 같은 명령으로
테스트 자동화를 수행할 수 있다.

.. code:: shell

    $ robot QuickStart_ko.rst

문서를 작성하다 보면, 다음과 같은 오류가 발생할 수 있으며,
관련된 해결 방법은 `rst 오류 관련 Note`_ 에 기술하였다.

rst 오류 관련 Note
------------------

- "Inline interpreted text or phrase reference start-string without end-string."와 같은 오류 발생 시:
  한글과 함께 사용할 때 end-string에서 한칸 띄운다.


Robot Framework 소개
--------------------

`Robot Framework`_ 은 수용 테스트(acceptance testing)와 수용 테스트 주도 개발(ATDD)을 위한
오픈 소스 테스트 자동화 프레임워크이다.
키워드 주도 테스트(keyword-driven testing) 접근법으로 "tabular test data syntax"를 사용하여
쉽게 테스트 케이스 `Test cases`_ 를 작성할 수 있다.

`Robot Framework`_ 은 operating system과 application에 독립적이며,
`Python <http://python.org>`_ 으로 구현되어 있으며
`Jython <http://jython.org>`_ (JVM) 과 `IronPython <http://ironpython.net>`_ (.NET)에서
동작할 수 있다.

.. _Robot Framework: http://robotframework.org


이 가이드를 위한 설치 및 실행 방법
==================================

설치
-------------

`Robot Framework`_ 설치

.. code:: shell

    $ pip install robotframework

이 문서는 reStructuredText_ markup language를 사용하여 작성되었으며,
Robot Framework test data를 code blocks에 포함하고 있다.
이러한 형식으로 테스트를 실행하려면 추가적으로 `docutils`_ 를 설치해야 한다.

`docutils`_ 설치

.. code:: shell

    $ pip install docutils


참조 링크:

- `Robot Framework installation instructions`_

.. _docutils: https://pypi.python.org/pypi/docutils
.. _`Robot Framework installation instructions`:
   https://github.com/robotframework/robotframework/blob/master/INSTALL.rst


테스트 대상: 데모 어플리케이션 login.py의 동작
----------------------------------------------

데모 어플리케이션은 계정 생성, 로그인, 비밀번호 변경 기능 등을 제공한다.

.. code:: shell

    $ python sut/login.py
    $ python sut/login.py create inyoung Pass1234
    $ python sut/login.py login inyoung Pass1234
    $ python sut/login.py change-password inyoung Pass5678

* 동작 명령 (actions)
    - create
    - login
    - change-password
    - help


테스트 실행
-------------

테스트를 실행하기 위해서는 다음과 같은 명령을 사용한다.

.. code:: console

    $ robot QuickStart_ko.rst

또는, 다음과 같이 options을 이용하여 실행할 수도 있다.    

.. code:: console

    $ robot --log custom_log.html --name Custom_Name QuickStart.rst


테스트 결과 보기
-------------------

위 명령을 실행하면 다음과 같은 파일이 생성되어 테스트 결과를 확인할 수 있다.

`report.html <http://robotframework.org/QuickStartGuide/report.html>`__
    Higher level test report.
`log.html <http://robotframework.org/QuickStartGuide/log.html>`__
    Detailed test execution log.
`output.xml <http://robotframework.org/QuickStartGuide/output.xml>`__
    Results in machine readable XML format.


참조 매뉴얼:
------------
- `Robot Framework User Guide`_
- `reStructuredText`_ 를 위한 `rst 빠른 참조 매뉴얼`_

.. _Robot Framework User Guide: http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html
.. _reStructuredText: https://docutils.sourceforge.io/rst.html
.. _rst 빠른 참조 매뉴얼: https://docutils.sourceforge.io/docs/user/rst/quickref.html


Test cases
==========

Workflow tests
--------------

.. code:: robotframework

    *** Test Cases ***
    사용자 계정 생성,로그인 기능
        유효한 사용자 생성    fred    P4ssw0rd
        로그인 시도    fred    P4ssw0rd
        Status Should Be    Logged In

    잘못된 비밀번호로 로그인 시도
        유효한 사용자 생성    betty    P4ssw0rd
        Attempt to login with credentials    betty    wrong
        Status Should Be    Access Denied

    잘못된 비밀번호로 로그인 시도 (강제 BuiltIn Fail 될 것이다.)
        유효한 사용자 생성    betty    P4ssw0rd
        Attempt to login with credentials    betty    wrong
        Fail    이것은 사용자가 입력한 Fail 메시지 입니다.    그리고 이것은 두번째 메시지

    잘못된 비밀번호로 로그인 시도 (강제 Failmsg 될 것이다.)
        유효한 사용자 생성    betty    P4ssw0rd
        Attempt to login with credentials    betty    wrong
        Failmsg    이것은 사용자가 입력한 Fail 메시지 입니다.    그리고 이것은 두번째 메시지


위에서 보듯이, 테스트 케이스는 테스트의 흐름을 정의한다.

- "사용자 계정 생성 로그인 기능", "잘못된 비밀번호로 로그인 시도"은 테스트 케이스의 이름이고,
  테스트 결과 레포트에 기술되는데 사용된다.
- "유효한 사용자 생성"과 "로그인 시도"는 테스트 실행을 위한 키워드이다. (**_사용자 정의 키워드_** 이다.)
- "Status Should Be"는 라이브러리와 매칭되는 키워드로 함수명과 동일해야 한다.
  아래 코드 예제에서 "status_should_be" 함수명을 확인할 수 있다. (대소문자를 구분하지 않는다.)

코드 예제:

.. code:: python

    class LoginLibrary(object):

        def status_should_be(self, expected_status):
            if expected_status != self._status:
                raise AssertionError("Expected status to be '%s' but was '%s'."
                                    % (expected_status, self._status))


Higher-level tests
------------------

사용자 정의 키워드를 사용하여 테스트 케이스를 더 높은 수준으로 추상화할 수 있으며,
테스트 기반 개발 `acceptance test-driven development (ATDD)`__ 및
행위 중심 개발 `behavior-driven development (BDD)`__ 등에 유용하게 활용되어질 수 있다.

다음은 BDD의 *given-when-then* 형식을 사용한 예이다:

.. code:: robotframework

    *** Test Cases ***
    사용자 비밀번호 변경 기능
        Given 사용자는 계정을 가지고 있다
        When 비밀번호를 변경할 수 있다
        Then 새로운 비밀번호로 로그인 할 수 있다
        And 이전 비밀번호로는 로그인 할 수 없다

__ http://en.wikipedia.org/wiki/Acceptance_test-driven_development
__ http://en.wikipedia.org/wiki/Behavior_driven_development


Data-driven tests
-----------------

- 여러가지 데이터 유형으로 입력값을 변경하면서 테스트를 반복할 수 있다.
- `[Template]` 설정으로 테스트 케이스를 데이터 드라이브 테스트로 만들 수 있다.

아래는 "안전하지 않은 비밀번호로 계정을 생성하면 실패해야 한다" 키워드로 정의된
테스트 케이스를 사용한 예이다:

.. code:: robotframework

    *** Test Cases ***
    유효하지 않은 비밀번호
        [Template]    안전하지 않은 비밀번호로 계정을 생성하면 실패해야 한다
        abCD5            ${PWD INVALID LENGTH}
        abCD567890123    ${PWD INVALID LENGTH}
        123DEFG          ${PWD INVALID CONTENT}
        abcd56789        ${PWD INVALID CONTENT}
        AbCdEfGh         ${PWD INVALID CONTENT}
        abCD56+          ${PWD INVALID CONTENT}

개별 테스트에서 `[Template]` 설정을 사용하는 것 외에도 이 가이드의 후반부에 정의된
`setups and teardowns`_ 와 같은 설정 테이블에서 테스트 템플릿 설정을 한 번 사용할 수 있다.
유효하지 않은 길이의 암호 사례와 기타 유효하지 않은 사례에 대해 별도의 명명된 테스트를
쉽게 만들 수 있다. 그러나 템플릿이 이 파일의 다른 테스트에도 적용되기 때문에
해당 테스트를 별도의 파일로 옮겨야 한다.

- `${PWD INVALID LENGTH}`, `${PWD INVALID CONTENT}` 는 variables_ 에 정의된 변수이다.


Keywords
========

Robot Framework에서 테스트 케이스는 키워드를 사용하여 테스트의 흐름을 정의한다.
키워드는 "라이브러리에서 가져온 키워드" `Library keywords`_ 또는
"사용자 정의 키워드" `user keywords`_ 일 것이다.

Library keywords
----------------

가장 하위 키워드는 표준 프로그래밍 언어로 구현된 "테스트 라이브러리"에 정의되어 있으며,
"표준 라이브러리", "외부 라이브러리" 및 "사용자 정의 라이브러리"로 나눌 수 있다.

- `*** Settings ***` 섹션 `Library` 를 사용하여 정의한다.
- "표준 라이브러리" `Standard libraries`_ 는 
  `OperatingSystem`_, `Screenshot` and `BuiltIn` 등이 있으며,
- "외부 라이브러리"는 예를 들어 웹을 테스트하기 위한 `Selenium2Library`_ 가 있는데
  이는 별도로 설치해야 한다.
- 그리고 "사용자 정의 라이브러리"는 `create custom test libraries`__ 와 같이 구현하고
  `Library` 설정을 사용하여 import 한 후 사용할 수 있다.

이 가이드에서는 `OperatingSystem`_ 라이브러리 (`Remove File` 등을 위해)와,
`LoginLibrary` 라이브러리 (`Attempt to login with credentials` 등을 위해)를 import 한다.

아래는 `OperatingSystem` 라이브러리와 `LoginLibrary` 라이브러리를 import 하는 예이다:

.. code:: robotframework

    *** Settings ***
    Library           OperatingSystem
    Library           lib/LoginLibrary.py

.. _Standard libraries: http://robotframework.org/robotframework/#standard-libraries
.. _Selenium2Library: https://github.com/rtomac/robotframework-selenium2library/#readme
.. _OperatingSystem: http://robotframework.org/robotframework/latest/libraries/OperatingSystem.html
__ `Creating test libraries`_

User keywords
-------------

- 위에서 사용된 상위 키워드들은 아래의 키워드 테이블에 정의되어 있는 것들이다.
- *user-defined keywords* 또는 줄여서 *user keywords* 라고 명칭한다.
- `*** keywords ***` 섹션에 정의한다.
- `Test cases`_ 를 정의하듯이 상위 수준의 키워드를 만들 수 있다.
- 입력값은 `[Arguments]` 설정을 사용하여 정의한다.
- 아래 keywords에서 "Remove file", "Create user", "Status should be",
  "Attempt to login with credentials"는 하위 키워드들로 `Library keywords`_ 이다.

.. code:: robotframework

    *** Keywords ***
    로그인 데이터 파일 삭제
        Remove file    ${DATABASE FILE}

    유효한 사용자 생성
        [Arguments]    ${username}    ${password}
        Create user    ${username}    ${password}
        Status should be    SUCCESS

    안전하지 않은 비밀번호로 계정을 생성하면 실패해야 한다
        [Arguments]    ${password}    ${error}
        Create user    example    ${password}
        Status should be    Creating user failed: ${error}

    로그인 시도
        [Arguments]    ${username}    ${password}
        Attempt to login with credentials    ${username}    ${password}
        Status should be    Logged In

    # 아래의 keywords는 higher-level tests에 사용된다.
    # given/when/then/and 에 사용된다.

    사용자는 계정을 가지고 있다
        유효한 사용자 생성    ${USERNAME}    ${PASSWORD}

    비밀번호를 변경할 수 있다
        Change password     ${USERNAME}    ${PASSWORD}    ${NEW PASSWORD}
        Status should be    SUCCESS

    새로운 비밀번호로 로그인 할 수 있다
        로그인 시도    ${USERNAME}    ${NEW PASSWORD}

    이전 비밀번호로는 로그인 할 수 없다
        Attempt to login with credentials    ${USERNAME}    ${PASSWORD}
        Status should be    Access Denied


Variables
=========

Defining variables
------------------

- 일반적으로 변경될 수 있는 테스트에 사용되는 모든 데이터는 변수로 정의하는 것이 가장 좋다.

다음은 위 테스트에서 사용되는 변수들을 정의한 것이다:

.. code:: robotframework

    *** Variables ***
    ${USERNAME}               janedoe
    ${PASSWORD}               J4n3D0e
    ${NEW PASSWORD}           e0D3n4J
    ${DATABASE FILE}          ${TEMPDIR}${/}robotframework-quickstart-db.txt
    ${PWD INVALID LENGTH}     Password must be 7-12 characters long
    ${PWD INVALID CONTENT}    Password must be a combination of lowercase and uppercase letters and numbers

변수는 테스트 실행 시에 command line에서 변경할 수 있다.

예:

.. code:: console

    $ pybot --variable USERNAME:johndoe --variable PASSWORD:J0hnD0e QuickStart_ko.rst

또한 Robot Framework 은 항상 사용할 수 있는 `${TEMPDIR}` 와 `${/}` 같은
내장 변수 `Built-in variables`__ 를 제공한다.

__ https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#built-in-variables


Using variables
---------------

- 테스트 데이터의 대부분의 위치에서 변수를 사용할 수 있다.
- 변수는 대부분의 키워드의 인자로 사용된다.
- 반환값을 변수에 할당하고 다시 사용할 수도 있다. 예를 들어,
  `Database Should Contain` 에서 "Get File" 키워드 ( `Library keywords`_ 참조 ) 는 `${database}` 변수에
  데이터베이스 내용을 설정하고,
  `BuiltIn`_ 키워드인 `Should Contain` 를 사용하여 내용을 확인한다.
  라이브러리 키워드와 사용자 키워드 모두 반환값을 가질 수 있다.
- `[Tags]` 는 `태그 사용하기`_ 에서 설명한다.

.. _User keyword: `User keywords`_
.. _BuiltIn: `Standard libraries`_

.. code:: robotframework

    *** Test Cases ***
    User status is stored in database
        [Tags]    variables    database
        유효한 사용자 생성    ${USERNAME}    ${PASSWORD}
        Database Should Contain    ${USERNAME}    ${PASSWORD}    Inactive
        로그인 시도    ${USERNAME}    ${PASSWORD}
        Database Should Contain    ${USERNAME}    ${PASSWORD}    Active

    *** Keywords ***
    Database Should Contain
        [Arguments]    ${username}    ${password}    ${status}
        ${database} =     Get File    ${DATABASE FILE}
        Should Contain    ${database}    ${username}\t${password}\t${status}\n


Organizing test cases
=====================

Test suites
-----------

Test cases 의 집합을 *test suite* 라고 한다.
보통 하나의 파일에 `Test cases`_ 들을 기술하면 파일명이 Test suite의 이름이 된다.
이 가이드의 Test suites 명은 파일명인 `QuickStart_ko` 이다.

또한 여러 파일과 디렉토리 구조를 사용하여 `Test suites`_ 구성할 수 있는데,
다음은 구성의 한 예이다:

.. code:: console

    My Test Suite
    ├── Login Tests
    │   ├── Login Test 1.robot
    │   ├── Login Test 2.robot
    │   └── ...
    ├── User Tests
    │   ├── User Creation Test.robot
    │   ├── User Management Test.robot
    │   └── ...
    ├── Product Tests
    │   ├── Product Creation Test.robot
    │   ├── Product Management Test.robot
    │   └── ...
    ├── ...
    └── Common Resources
        ├── Resource 1.robot
        ├── Resource 2.robot
        └── ...

위 예에서

- Common Resources 디렉토리는 `Library`_ 등을 포함할 수 있다.

.. _Library: `Creating test libraries`_


Setups and teardowns
--------------------

각 테스트 전후에 특정 키워드 액션이 실행되도록 설정할 수 있다.

테스트 전체에 적용되도록 하기 위해서

- `*** Settings ***` 섹션에 기술한다.
- 각 `Test cases`_ 전 또는 후에 실행되도록 하려면 `Test Setup` 과 `Test Teardown` 을
- 전체 `Test suites`_ 전 또는 후에 실행되도록 하려면 `Suite Setup` 과 `Suite Teardown` 로 기술한다.

각 `Test cases`_ 안에

- `[Setup]` 과 `[Teardown]` 을 사용하여 특정 키워드를 실행하도록 설정할 수 있다.
  이는 `data-driven tests`_ 에서 `[Template]` 을 사용하는 것과 같이 기술한다.

이 가이드의 테스트에서는 각 테스트가 실행된 후에 데이터베이스를 비우도록 설정한다:

.. code:: robotframework

    *** Settings ***
    Suite Setup       로그인 데이터 파일 삭제
    Test Teardown     로그인 데이터 파일 삭제


태그 사용하기
--------------

각 테스트 마다 또는 전체 테스트에 메타 정보로 사용하기 위한 태그를 설정할 수 있다.

각 테스트마다 안에 태그를 설정하려면 `[Tags]` 를 사용한다.
예를 들어, 이전의 Test case의 `User status is stored in database`__ 테스트는
`variables` 와 `database` 라는 두 개의 태그를 가진다.

파일안의 전체 테스트에 태그를 설정하려면
`*** Settings ***` 섹션에 `Force Tags` 와 `Default Tags` 를 사용하여 설정한다.

__ `Using variables`_

.. code:: robotframework

    *** Settings ***
    Force Tags        quickstart
    Default Tags      example    smoke

태그는 보고서와 같은 다양한 곳에서 다양한 용도로 사용되어 질 수 있으며,
테스트를 실행할 때 어떤 테스트를 실행할지 선택하는 데에도 사용된다.

예를 들어 다음과 같이 실행할 수 있다:

.. code:: console

    $ robot --include smoke QuickStart.rst
    $ robot --exclude database QuickStart.rst


Creating test libraries
=======================

- 본 가이드의 테스트를 위해서는 `LoginLibrary` 라는 테스트 라이브러리가 필요하다.
- 이 라이브러리는 `Python`_ 으로 작성되었으며, `<lib/LoginLibrary.py>`_ 에 위치하고 있다.
- 라이브러리의 설정은 `Library keywords`_ 에서 확인할 수 있다.
- 테스트 케이스에서 실행하기 위한 키워드와 라이브러리 함수의 매핑은 이름으로 이루어지며,
  예를 들어 `Create User` 키워드는 `create_user` 함수에 매핑된다.

다음은 `LoginLibrary` 라이브러리의 코드이다:

.. code:: python

    import os.path
    import subprocess
    import sys


    class LoginLibrary(object):

        def __init__(self):
            self._sut_path = os.path.join(os.path.dirname(__file__),
                                          '..', 'sut', 'login.py')
            self._status = ''

        def create_user(self, username, password):
            self._run_command('create', username, password)

        def change_password(self, username, old_pwd, new_pwd):
            self._run_command('change-password', username, old_pwd, new_pwd)

        def attempt_to_login_with_credentials(self, username, password):
            self._run_command('login', username, password)

        def status_should_be(self, expected_status):
            if expected_status != self._status:
                raise AssertionError("Expected status to be '%s' but was '%s'."
                                     % (expected_status, self._status))

        def failmsg(self, msg, msg2):
            raise AssertionError("강제로 FAIL 그리고 메시지는: '%s', '%s'."
                                     % (msg, msg2))


        def _run_command(self, command, *args):
            command = [sys.executable, self._sut_path, command] + list(args)
            process = subprocess.Popen(command, stdout=subprocess.PIPE,
                                       stderr=subprocess.STDOUT)
            self._status = process.communicate()[0].strip()
