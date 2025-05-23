#!/usr/bin/env bash

#############################################################################
##
##   Common environment setup for Logtalk integration scripts
##   Last updated on March 25, 2025
##
##   This file is part of Logtalk <https://logtalk.org/>
##   SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>
##   SPDX-License-Identifier: Apache-2.0
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
##
#############################################################################


setup_logtalk_env() {
	if ! [ "$LOGTALKHOME" ]; then
		echo "The environment variable LOGTALKHOME should be defined first"
		echo "pointing to your Logtalk installation directory!"
		echo "Trying the default locations for the Logtalk installation..."
		if [ -d "/usr/local/share/logtalk" ]; then
			LOGTALKHOME=/usr/local/share/logtalk
			echo "... using Logtalk installation found at /usr/local/share/logtalk"
		elif [ -d "/usr/share/logtalk" ]; then
			LOGTALKHOME=/usr/share/logtalk
			echo "... using Logtalk installation found at /usr/share/logtalk"
		elif [ -d "/opt/local/share/logtalk" ]; then
			LOGTALKHOME=/opt/local/share/logtalk
			echo "... using Logtalk installation found at /opt/local/share/logtalk"
		elif [ -d "/opt/share/logtalk" ]; then
			LOGTALKHOME=/opt/share/logtalk
			echo "... using Logtalk installation found at /opt/share/logtalk"
		elif [ -d "/opt/homebrew/share/logtalk" ]; then
			LOGTALKHOME=/opt/homebrew/share/logtalk
			echo "... using Logtalk installation found at /opt/homebrew/share/logtalk"
		elif [ -d "$HOME/share/logtalk" ]; then
			LOGTALKHOME="$HOME/share/logtalk"
			echo "... using Logtalk installation found at $HOME/share/logtalk"
		elif [ -f "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../../core/core.pl" ]; then
			LOGTALKHOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
			echo "... using Logtalk installation found at $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
		else
			echo "... unable to locate Logtalk installation directory!" >&2
			echo
			return 1
		fi
		echo
		export LOGTALKHOME=$LOGTALKHOME
	elif ! [ -d "$LOGTALKHOME" ]; then
		echo "The environment variable LOGTALKHOME points to a non-existing directory!" >&2
		echo "Its current value is: $LOGTALKHOME" >&2
		echo "The variable must be set to your Logtalk installation directory!" >&2
		echo
		return 1
	fi

	if ! [ "$LOGTALKUSER" ]; then
		echo "The environment variable LOGTALKUSER should be defined first, pointing"
		echo "to your Logtalk user directory!"
		echo "Trying the default location for the Logtalk user directory..."
		echo
		export LOGTALKUSER=$HOME/logtalk
	fi

	if [ -d "$LOGTALKUSER" ]; then
		if ! [ -f "$LOGTALKUSER/VERSION.txt" ]; then
			echo "Cannot find VERSION.txt in the Logtalk user directory at $LOGTALKUSER!"
			echo "Creating an up-to-date Logtalk user directory..."
			logtalk_user_setup
		else
			system_version=$(cat "$LOGTALKHOME/VERSION.txt")
			user_version=$(cat "$LOGTALKUSER/VERSION.txt")
			if [ "$user_version" \< "$system_version" ]; then
				echo "Logtalk user directory at $LOGTALKUSER is outdated: "
				echo "	$user_version < $system_version"
				echo "Creating an up-to-date Logtalk user directory..."
				logtalk_user_setup
			fi
		fi
	else
		echo "Cannot find the Logtalk user directory at $LOGTALKUSER!"
		echo "Running the logtalk_user_setup shell script to create the directory:"
		logtalk_user_setup
	fi

	LOGTALK_STARTUP_DIRECTORY=$(pwd)
	export LOGTALK_STARTUP_DIRECTORY

	return 0
}
