#!/usr/bin/env bash

function install_script() {
	local ZEE_COMPLETIONS_PATH=$HOME/.zee/zee_completions.sh
	local ZEE_FUNCTIONS_PATH=$HOME/.zee/zee_functions.sh

	if [[ -f "$ZEE_COMPLETIONS_PATH" ]]; then
		rm $ZEE_COMPLETIONS_PATH 2> /dev/null
	fi

	if [[ -f "$ZEE_FUNCTIONS_PATH" ]]; then
		rm $ZEE_FUNCTIONS_PATH 2> /dev/null
	fi

	local CURRENT_DIR=$(dirname $(realpath $0))

	ln -sf $CURRENT_DIR/scripts/zee_completions.sh $ZEE_COMPLETIONS_PATH
	ln -sf $CURRENT_DIR/scripts/zee_functions.sh $ZEE_FUNCTIONS_PATH
}

MY_SHELL=$(basename $SHELL)

if [[ $MY_SHELL == "zsh" ]]; then
  SHELL_CONFIG="$HOME/.zshrc"
else
  SHELL_CONFIG="$HOME/.bashrc"
fi

ZEE_ENV_PATH=$(echo 'source '$HOME'/.zee/zee_env.sh')
cat $SHELL_CONFIG | grep "$ZEE_ENV_PATH" > /dev/null

if [[ $? -eq 1 ]]; then
	ZEE_CLI_PATH=$HOME/.zee

  if [[ ! -d "$ZEE_CLI_PATH" ]]; then
    mkdir -p $ZEE_CLI_PATH
  fi

  install_script

  sed 's|ZEE_MOUNT_PATH=.*|ZEE_MOUNT_PATH='$HOME'|' < scripts/zee_env.sh > $ZEE_CLI_PATH/zee_env.sh

	echo "source $ZEE_CLI_PATH/zee_completions.sh" >> $SHELL_CONFIG
	echo "source $ZEE_CLI_PATH/zee_functions.sh" >> $SHELL_CONFIG
	echo "source $ZEE_CLI_PATH/zee_env.sh" >> $SHELL_CONFIG

  echo 'Script successfully added :)'
else
  install_script
  echo 'Script successfully updated :)'
fi
