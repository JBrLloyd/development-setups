#!/bin/bash

pathmunge () {
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH="$PATH:$1"
    else
      PATH="$1:$PATH"
    fi
  fi
}

PACKAGES = "python3 python3-pip"

if [ -f /etc/redhat-release ] ; then
  PKMGR=`yum`
elif [ -f /etc/debian_version ] ; then
  PKMGR=`apt`
fi

UPDATE_CMD = PKMGR + " update"
INSTALL_CMD = PKMGR + " install " + PACKAGES

eval "$UPDATE_CMD"
eval "$INSTALL_CMD"

python -m pip install --upgrade pip

PIP_INSTALL_PKS = "pip3 install virtualenv virtualenvwrapper"
eval "$PIP_INSTALL_PKS"

appendStartupFile () {
  grep -qxF "$1" $HOME/.bashrc || echo "$1" >> $HOME/.bashrc
}

# Add virutalenv to PATH
appendStartupFile "export PATH=$HOME/.local/bin/:$PATH"

# Setup virtualenvwrapper workspace
appendStartupFile "export WORKON_HOME=$HOME/.virtualenvs"
appendStartupFile "export PROJECT_HOME=$HOME/Devel"
appendStartupFile "source /usr/local/bin/virtualenvwrapper.sh"

mkdir -p $WORKON_HOME

source ~/.bashrc
