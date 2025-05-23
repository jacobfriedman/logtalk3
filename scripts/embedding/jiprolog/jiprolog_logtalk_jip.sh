#!/usr/bin/env bash

#############################################################################
##
##   This script creates a JIProlog logtalk.jip file with the Logtalk
##   compiler and runtime and optionally an application.jip file with
##   a Logtalk application
##
##   Last updated on March 23, 2025
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


print_version() {
	echo "$(basename "$0") 0.21"
	exit 0
}

if ! [ "$LOGTALKHOME" ]; then
	echo "The environment variable LOGTALKHOME should be defined first, pointing"
	echo "to your Logtalk installation directory!"
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
	elif [ -d "$HOME/share/logtalk" ]; then
		LOGTALKHOME="$HOME/share/logtalk"
		echo "... using Logtalk installation found at $HOME/share/logtalk"
	elif [ -f "$( cd "$( dirname "$0" )" && pwd )/../core/core.pl" ]; then
		LOGTALKHOME="$( cd "$( dirname "$0" )" && pwd )/.."
		echo "... using Logtalk installation found at $( cd "$( dirname "$0" )" && pwd )/.."
	else
		echo "... unable to locate Logtalk installation directory!" >&2
		echo
		exit 1
	fi
	echo
	export LOGTALKHOME=$LOGTALKHOME
elif ! [ -d "$LOGTALKHOME" ]; then
	echo "The environment variable LOGTALKHOME points to a non-existing directory!" >&2
	echo "Its current value is: $LOGTALKHOME" >&2
	echo "The variable must be set to your Logtalk installation directory!" >&2
	echo
	exit 1
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
		echo "Cannot find version information in the Logtalk user directory at $LOGTALKUSER!"
		echo "Creating an up-to-date Logtalk user directory..."
		logtalk_user_setup
	else
		system_version=$(cat "$LOGTALKHOME/VERSION.txt")
		user_version=$(cat "$LOGTALKUSER/VERSION.txt")
		if [ "$user_version" \< "$system_version" ]; then
			echo "Logtalk user directory at $LOGTALKUSER is outdated: "
			echo "    $user_version < $system_version"
			echo "Creating an up-to-date Logtalk user directory..."
			logtalk_user_setup
		fi
	fi
else
	echo "Cannot find \$LOGTALKUSER directory! Creating a new Logtalk user directory"
	echo "by running the \"logtalk_user_setup\" shell script:"
	logtalk_user_setup
fi

# default values
directory="$(pwd -P)"
temporary=""
paths="$LOGTALKHOME/paths/paths.pl"
settings="$LOGTALKHOME/scripts/embedding/settings-embedding-sample.lgt"
compile="false"

usage_help() {
	echo
	echo "This script creates a JIProlog logtalk.jip file with the Logtalk compiler and"
	echo "runtime and an optional application.jip file from an application source code"
	echo "given its loader file."
	echo
	echo "Usage:"
	echo "  $(basename "$0") [-c] [-d directory] [-t tmpdir] [-p paths] [-s settings] [-l loader]"
	echo "  $(basename "$0") -v"
	echo "  $(basename "$0") -h"
	echo
	echo "Optional arguments:"
	echo "  -c compile library alias paths in paths and settings files"
	echo "  -d directory for generated .jip files (absolute path; default is current directory)"
	echo "  -t temporary directory for intermediate files (absolute path; default is an auto-created directory)"
	echo "  -p library paths file (absolute path; default is $paths)"
	echo "  -s settings file (absolute path or 'none'; default is $settings)"
	echo "  -l loader file for the application (absolute path)"
	echo "  -v print version of $(basename "$0")"
	echo "  -h help"
	echo
}

while getopts "cd:t:p:l:s:vh" option; do
	case $option in
		c) compile="true";;
		d) d_arg="$OPTARG";;
		t) t_arg="$OPTARG";;
		p) p_arg="$OPTARG";;
		s) s_arg="$OPTARG";;
		l) l_arg="$OPTARG";;
		v) print_version;;
		h) usage_help; exit 0;;
		*) usage_help; exit 1;;
	esac
done

if [ "$d_arg" != "" ] ; then
	directory="$d_arg"
fi

if [ "$t_arg" != "" ] ; then
	temporary="$t_arg"
fi

if [ "$p_arg" != "" ] ; then
	if [ -f "$p_arg" ] ; then
		paths="$p_arg"
	else
		echo "The $p_arg library paths file does not exist!" >&2
		exit 1
	fi
fi

if [ "$s_arg" != "" ] && [ "$s_arg" != "none" ] ; then
	if [ -f "$s_arg" ] ; then
		settings="$s_arg"
	else
		echo "The $s_arg settings file does not exist!" >&2
		exit 1
	fi
elif [ "$s_arg" == "none" ] ; then
	settings="none"
fi

if [ "$l_arg" != "" ] ; then
	if [ -f "$l_arg" ] ; then
		loader="$l_arg"
	else
		echo "The $l_arg loader file does not exist!" >&2
		exit 1
	fi
else
	loader=""
fi

mkdir -p "$directory"

if [ "$temporary" != "" ] ; then
	mkdir -p "$temporary"
else
	temporary=$(mktemp -d)
fi

if [[ ! "$temporary" || ! -d "$temporary" ]]; then
	echo "Could not create temporary directory!"
	exit 1
fi

cd "$temporary" || exit 1

operating_system=$(uname -s)

if [ "${operating_system:0:10}" == "MINGW32_NT" ] || [ "${operating_system:0:10}" == "MINGW64_NT" ] ; then
	# assume that we're running on Windows using the Git for Windows bash shell
	extension='.sh'
elif [ "$LOGTALKHOME" != "" ] && [ "$LOGTALKUSER" != "" ] && [ "$LOGTALKHOME" == "$LOGTALKUSER" ] ; then
	# assume that we're running Logtalk without using the installer scripts
	extension='.sh'
else
	extension=''
fi

case $(sed --help 2>&1) in
	*GNU*) sed_i () { sed -i "$@"; };;
	*) sed_i () { sed -i '' "$@"; };;
esac

cp "$LOGTALKHOME/adapters/ji.pl" .
cp "$LOGTALKHOME/core/core.pl" .

jiplgt$extension -g "logtalk_compile([core(expanding),core(monitoring),core(forwarding),core(user),core(logtalk),core(core_messages)],[optimize(on),scratch_directory('$temporary')]),halt"

if [ "$compile" != "false" ] ; then
	jiplgt$extension -g "logtalk_load(expand_library_alias_paths(loader)),logtalk_compile('$paths',[hook(expand_library_alias_paths),scratch_directory('$temporary')]),halt"
else
	cp "$paths" "$temporary/paths_lgt.pl"
fi

if [ "$settings" != "" ] && [ "$settings" != "none" ] ; then
	if [ "$compile" != "false" ] ; then
		jiplgt$extension -g "logtalk_load(expand_library_alias_paths(loader)),logtalk_compile('$settings',[hook(expand_library_alias_paths),optimize(on),scratch_directory('$temporary')]),halt"
	else
		jiplgt$extension -g "logtalk_compile('$settings',[optimize(on),scratch_directory('$temporary')]),halt"
	fi
	sed_i "s/settings_file, allow/settings_file, deny/" ji.pl
	cat \
		ji.pl \
		paths_*.pl \
		expanding*_lgt.pl \
		monitoring*_lgt.pl \
		forwarding*_lgt.pl \
		user*_lgt.pl \
		logtalk*_lgt.pl \
		core_messages*_lgt.pl \
		settings*_lgt.pl \
		core.pl \
		> logtalk.pl
else
	cat \
		ji.pl \
		paths_*.pl \
		expanding*_lgt.pl \
		monitoring*_lgt.pl \
		forwarding*_lgt.pl \
		user*_lgt.pl \
		logtalk*_lgt.pl \
		core_messages*_lgt.pl \
		core.pl \
		> logtalk.pl
fi

java -jar -DLOGTALKHOME="$LOGTALKHOME" -DLOGTALKUSER="$LOGTALKUSER" -DHOME="$HOME" "$JIP_HOME/jipconsole.jar" -n -g "op(600,xfy,::),op(600,fy,::),op(600,fy,^^),op(600,fy,:),op(700,xfx,as),op(200,fy,@),compile('logtalk.pl'),halt"

mv logtalk.jip "$directory"

if [ "$loader" != "" ] ; then
	mkdir -p "$temporary/application"
	cd "$temporary/application" || exit 1
	jiplgt$extension -g "set_logtalk_flag(clean,off),set_logtalk_flag(scratch_directory,'$temporary/application'),logtalk_load('$loader'),halt"
	if test -n "$(find . -maxdepth 1 -name '*.pl' -print -quit)" ; then
		files="$(ls -rt ./*.pl)"
		for a in $files ; do cat "$a" >> application.pl ; done
	else
		echo
		echo "No application files found!"
		echo
		exit 1
	fi
	jiplgt$extension -g "compile('application.pl'),halt"
	mv application.jip "$directory"
fi

function cleanup {
	rm -rf "$temporary"
}
# register cleanup function to be called on EXIT signal
trap cleanup EXIT
