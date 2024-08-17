#!/usr/bin/env bash

function zee() {
	if [[ $_ZEE_MODE == "client" ]]; then
		_zee::client $1 $2 $3
	else
		_zee::robot $1 $2 $3
	fi
}

###################################################
#              CLIENT MAIN FUNCTIONS 
###################################################

function _zee::client() {
	case $1 in
		config)
			_zee::config
			;;
		help)
			_zee::help
			;;
		ping)
			_zee::ping $2
			;;
		set)
			case $2 in
				container)
					_zee::set_container $3
					;;
				mode)
					_zee::set_mode $3
					;;
				mount_path)
					_zee::set_mount_path $3
					;;
				workspace)
					_zee::set_workspace $3
					;;
				*)
					_zee::help
					;;
			esac
			;;
		*)
			_zee::help
			;;
	esac
}

###################################################
#              ROBOT MAIN FUNCTIONS 
###################################################

function _zee::robot() {
	case $1 in
		config)
			_zee::config
			;;
		help)
			_zee::help
			;;
		set)
			case $2 in
				container)
					_zee::set_container $3
					;;
				date)
					_zee::set_time
					;;
				mode)
					_zee::set_mode $3
					;;
				workspace)
					_zee::set_workspace $3
					;;
				*)
					_zee::help
					;;
			esac
			;;
		*)
			_zee::help
			;;
	esac
}

###################################################
#                COMMON FUNCTIONS 
###################################################

function _zee::help() {
	echo "zee config"
	echo "zee help"
	echo "zee set container <container_name>"
	echo "zee set mode <mode>"
	echo "zee set workspace <workspace_name>"

	if [[ $_ZEE_MODE == "client" ]]; then
		echo "zee ping <ip_address>"
		echo "zee set mount_path <mount_path>"
	else
		echo "zee set date"
	fi
}

function _zee::config() {
	echo "workspace: $_ZEE_WORKSPACE"
	echo "container: $_ZEE_CONTAINER"

	if [[ $_ZEE_MODE == "client" ]]; then
		echo "mount_path: $_ZEE_MOUNT_PATH"
	fi

	echo "mode: $_ZEE_MODE"
}

function _zee::change_env() {
  sed -i 's|'$1'=.*|'$1'='$2'|' $HOME/.zee/zee_env.sh

	source $HOME/.zee/zee_env.sh
	_zee::config
}

function _zee::set_workspace() {
  if [[ -z $1 ]]; then
    echo -e "usage:\tzee workspace <workspace_name>"
    exit 1
  fi

	_zee::change_env _ZEE_WORKSPACE $1
}

function _zee::set_container() {
  if [[ -z $1 ]]; then
    echo -e "usage:\tzee container <container_name>"
    exit 1
  fi

  _zee::change_env _ZEE_CONTAINER $1
}

function _zee::set_mode() {
  if [[ -z $1 ]]; then
    echo -e "usage:\tzee mode <mode>"
    exit 1
  fi

	_zee::change_env _ZEE_MODE $1
}

###################################################
#                  CLIENT MODE
###################################################

function _zee::set_mount_path() {
  if [[ -z $1 ]]; then
    echo -e "usage:\tzee mount_path <mount_path>"
    exit 1
  fi

  _zee::change_env _ZEE_MOUNT_PATH $1
}

function _zee::ping() {
  ping $1
}

###################################################
#                  ROBOT MODE
###################################################

function _zee::set_time() {
  echo "Please input date and time with this format below"
  echo "year-month-day Hour:Minutes"
	echo "example: 2010-05-12 19:12"
  read DATETIME
  sudo date -s "$DATETIME"
}
