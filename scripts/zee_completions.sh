#!/usr/bin/env bash

function _zee::completions() {
	local CURR="${COMP_WORDS[COMP_CWORD]}"
	local PREV="${COMP_WORDS[COMP_CWORD-1]}"

	case ${COMP_CWORD} in
		1)
			if [[ $_ZEE_MODE == "client" ]]; then
				local ARG1_LIST="config help ping set"
			else
				local ARG1_LIST="config help set"
			fi

			COMPREPLY=($(compgen -W "$ARG1_LIST" ${CURR}))
			;;
		2)
			case ${PREV} in
				set)
			    if [[ $_ZEE_MODE == "client" ]]; then
			    	local ARG2_LIST="container mode mount_path workspace"
					else
			    	local ARG2_LIST="container date mode workspace"
			    fi

					COMPREPLY=($(compgen -W "$ARG2_LIST" ${CURR}))
					;;
			esac
			;;
		3)
			case ${PREV} in
				mode)
					COMPREPLY=($(compgen -W "client robot" ${CURR}))
					;;
			esac
			;;
		*)
			COMPREPLY=()
			;;
	esac
}

complete -F _zee::completions zee
