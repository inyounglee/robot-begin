#!/bin/sh

#cd sh
#. ./check_python3.sh
#cd ..

pip3 install virtualenv
if test ! -d ./env; then
  virtualenv env
fi

. ./env/bin/activate

# pip freeze > requirements.txt
pip3 install -r requirements.txt
