
#############################################################################
##
##   This script creates a XVM logtalk.pl file with the Logtalk compiler and
##   runtime and optionally an application.pl file with a Logtalk application
##
##   Last updated on March 18, 2025
##
##   This file is part of Logtalk <https://logtalk.org/>
##   Copyright 2022-2025 Paulo Moura <pmoura@logtalk.org>
##   Copyright 2022 Hans N. Beck
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


#Requires -Version 7.3

[CmdletBinding()]
param(
	[Parameter()]
	[Switch]$c,
	[String]$d = $pwd,
	[String]$t,
	[String]$n = "application",
	[String]$p = "$env:LOGTALKHOME\paths\paths.pl",
	[String]$s = "$env:LOGTALKHOME\scripts\embedding\settings-embedding-sample.lgt",
	[String]$l,
	[String]$g = "true",
	[Switch]$f,
	[Switch]$x,
	[Switch]$v,
	[Switch]$h
)

function Write-Script-Version {
	$myFullName = $MyInvocation.ScriptName
	$myName = Split-Path -Path $myFullName -leaf -Resolve
	Write-Output "$myName 0.12"
}

function Get-Logtalkhome {
	if ($null -eq $env:LOGTALKHOME)
	{
		Write-Output "The environment variable LOGTALKHOME should be defined first, pointing"
		Write-Output "to your Logtalk installation directory!"
		Write-Output "Trying the default locations for the Logtalk installation..."

		$DEFAULTPATHS = [string[]](
			"C:\Program Files (x86)\Logtalk",
			"C:\Program Files\Logtalk",
			"%LOCALAPPDATA%\Logtalk"
		)

		# Checking all default paths
		foreach ($DEFAULTPATH in $DEFAULTPATHS) {
			Write-Output "Looking for: $DEFAULTPATH"
			if (Test-Path $DEFAULTPATH) {
				Write-Output "... using Logtalk installation found at $DEFAULTPATH"
				$env:LOGTALKHOME = $DEFAULTPATH
				break
			}
		}
	}
	# At the end LOGTALKHOME was set already or now is set
}

function Get-Logtalkuser {
	if ($null -eq $env:LOGTALKUSER) {
		Write-Output "After the script completion, you must set the environment variable"
		Write-Output "LOGTALKUSER pointing to %USERPROFILE%\Documents\Logtalk."
		$env:LOGTALKUSER = "%USERPROFILE%\Documents\Logtalk"
	}
	# At the end LOGTALKUSER was set already or now is set
}

function Write-Usage-Help() {
	$myFullName = $MyInvocation.ScriptName
	$myName = Split-Path -Path $myFullName -leaf -Resolve

	Write-Output "This script creates a XVM logtalk.pl file with the Logtalk compiler/runtime"
	Write-Output "and an optional application.pl file from an application source code given"
	Write-Output "its loader file. When embedding an application, this script also creates a"
	Write-Output "loader.pl file for loading all generated Prolog and foreign library files,"
	Write-Output "optionally calling a startup goal."
	Write-Output ""
	Write-Output "Usage:"
	Write-Output "  $myName [-c] [-d directory] [-t tmpdir] [-n name] [-p paths] [-s settings] [-l loader] [-g goal] [-f] [-x]"
	Write-Output "  $myName -v"
	Write-Output "  $myName -h"
	Write-Output ""
	Write-Output "Optional arguments:"
	Write-Output "  -c compile library alias paths in paths and settings files"
	Write-Output "  -d directory for generated QLF files (absolute path; default is current directory)"
	Write-Output "  -t temporary directory for intermediate files (absolute path; default is an auto-created directory)"
	Write-Output "  -n name of the generated saved state (default is application)"
	Write-Output "  -p library paths file (absolute path; default is $p)"
	Write-Output "  -s settings file (absolute path or 'none'; default is $s)"
	Write-Output "  -l loader file for the application (absolute path)"
	Write-Output "  -g startup goal for the application in canonical syntax (default is $g)"
	Write-Output "  -f copy foreign library files loaded by the application"
	Write-Output "  -x encrypt the generated logtalk.pl and application.pl files"
	Write-Output "  -v print version of $myName"
	Write-Output "  -h help"
	Write-Output ""
}

function Confirm-Parameters() {

	if ($h -eq $true) {
		Write-Usage-Help
		Exit 0
	}

	if ($v -eq $true) {
		Write-Script-Version
		Exit 0
	}

	if (-not(Test-Path $p)) { # cannot be ""
		Write-Output "The $p library paths file does not exist!"
		Start-Sleep -Seconds 2
		Exit 1
	}

	if (($s -ne "") -and ($s -ne "none") -and (-not(Test-Path $s))) {
		Write-Output "The $s settings file does not exist!"
		Start-Sleep -Seconds 2
		Exit 1
	}

	if (($l -ne "") -and (-not(Test-Path $l))) {
		Write-Output "The $l loader file does not exist!"
		Start-Sleep -Seconds 2
		Exit 1
	}

	if ($t -eq "") {
		$t = "$pwd\tmp"
	}

	if (-not (Test-Path $d)) {
		try {
			New-Item -Path $d -ItemType Directory > $null
		} catch {
			Write-Output "Could not create destination directory at $d!"
			Start-Sleep -Seconds 2
			Exit 1
		}
	}

	if (-not (Test-Path $t)) {
		try {
			New-Item -Path $t -ItemType Directory > $null
		} catch {
			Write-Output "Could not create temporary directory at $t!"
			Start-Sleep -Seconds 2
			Exit 1
		}
	}

}

###################### here it starts ############################

Confirm-Parameters

Get-Logtalkhome

# Check for existence
if (Test-Path $env:LOGTALKHOME) {
	$output = "Found LOGTALKHOME at: $env:LOGTALKHOME"
	Write-Output $output
} else {
	Write-Output "... unable to locate Logtalk installation directory!"
	Start-Sleep -Seconds 2
	Exit 1
}

Get-Logtalkuser

# Check for existence
if (Test-Path $env:LOGTALKUSER) {
	if (!(Test-Path $env:LOGTALKUSER/VERSION.txt)) {
		Write-Output "Cannot find version information in the Logtalk user directory at %LOGTALKUSER%!"
		Write-Output "Creating an up-to-date Logtalk user directory..."
		logtalk_user_setup
	} else {
		$system_version = Get-Content $env:LOGTALKHOME/VERSION.txt
		$user_version = Get-Content $env:LOGTALKUSER/VERSION.txt
		if ($user_version -lt $system_version) {
			Write-Output "Logtalk user directory at %LOGTALKUSER% is outdated: "
			Write-Output "    $user_version < $system_version"
			Write-Output "Creating an up-to-date Logtalk user directory..."
			logtalk_user_setup
		}
	}
} else {
	Write-Output "Cannot find %LOGTALKUSER% directory! Creating a new Logtalk user directory"
	Write-Output "by running the logtalk_user_setup shell script:"
	logtalk_user_setup
}

Push-Location
Set-Location $t

Copy-Item -Path "$env:LOGTALKHOME\adapters\xvm.pl" -Destination .
Copy-Item -Path "$env:LOGTALKHOME\core\core.pl" -Destination .
$ScratchDirOption = ", scratch_directory('$($t.Replace('\','/'))')"

$GoalParam = "logtalk_compile([core(expanding), core(monitoring), core(forwarding), core(user), core(logtalk), core(core_messages)], [optimize(on)$ScratchDirOption]), halt."
xvmlgt --goal $GoalParam

if ($c -eq $true) {
	$GoalParam = "logtalk_load(expand_library_alias_paths(loader)),logtalk_compile('$($p.Replace('\','/'))',[hook(expand_library_alias_paths)$ScratchDirOption]),halt."
	xvmlgt --goal $GoalParam
} else {
	Copy-Item -Path $p -Destination "$t\paths_lgt.pl"
}

if (($s -eq "") -or ($s -eq "none")) {
	Get-Content -Path xvm.pl,
		paths_*.pl,
		expanding*_lgt.pl,
		monitoring*_lgt.pl,
		forwarding*_lgt.pl,
		user*_lgt.pl,
		logtalk*_lgt.pl,
		core_messages_*lgt.pl,
		core.pl | Set-Content "$d/logtalk.pl"
} else {
	if ($c -eq $true) {
		$GoalParam = "logtalk_load(expand_library_alias_paths(loader)),logtalk_compile('$($s.Replace('\','/'))',[hook(expand_library_alias_paths),optimize(on)$ScratchDirOption]), halt."
	} else {
		$GoalParam = "logtalk_compile('$($s.Replace('\','/'))',[optimize(on)$ScratchDirOption]), halt."
	}
	xvmlgt --goal $GoalParam
	(Get-Content xvm.pl) -replace 'settings_file, allow', 'settings_file, deny' | Set-Content xvm.pl
	Get-Content -Path xvm.pl,
		paths_*.pl,
		expanding*_lgt.pl,
		monitoring*_lgt.pl,
		forwarding*_lgt.pl,
		user*_lgt.pl,
		logtalk*_lgt.pl,
		core_messages*_lgt.pl,
		settings*_lgt.pl,
		core.pl | Set-Content "$d/logtalk.pl"
}

if ($l -ne "") {
	try {
		New-Item -Path "$t/application" -ItemType Directory > $null
		Push-Location "$t/application"
	} catch {
		Write-Output "Could not create temporary directory! at $t/application!"
		Start-Sleep -Seconds 2
		Exit 1
	}

	if ($f -eq $true) {
		$GoalParam = "consult('$($d.Replace('\', '/'))/logtalk.pl'), set_logtalk_flag(clean,off), set_logtalk_flag(scratch_directory,'$($t.Replace('\', '/'))/application'), logtalk_load('$($l.Replace('\', '/'))'), forall((current_plugin(PlugIn), plugin_property(PlugIn,file(File))), (decompose_file_name(File,_,Basename), atom_concat('$($d.Replace('\', '/'))',Basename,Copy), copy_file(File,Copy))), halt."
	} else {
		$GoalParam = "consult('$($d.Replace('\', '/'))/logtalk.pl'), set_logtalk_flag(clean,off), set_logtalk_flag(scratch_directory,'$($t.Replace('\', '/'))/application'), logtalk_load('$($l.Replace('\', '/'))'), halt."
	}

	xvmpl --goal $GoalParam
	Get-Item *.pl |
		Sort-Object -Property @{Expression = "LastWriteTime"; Descending = $false} |
		Get-Content |
		Set-Content "$d/application.pl"

	if ($x -eq $true) {
		$GoalEncryptLogtalk = "encrypt_program('$($d.Replace('\', '/'))/logtalk.pl'),halt."
		$GoalEncryptApplication = "encrypt_program('$($d.Replace('\', '/'))/application.pl'),halt."
		xvmpl --goal $GoalEncryptLogtalk
		xvmpl --goal $GoalEncryptApplication
		Remove-Item "$d/logtalk.pl" -Force
		Remove-Item "$d/application.pl" -Force
	}

	if ($f -eq $true) {
		$LoaderParam = "consult('$($d.Replace('\', '/'))/logtalk.pl'), set_logtalk_flag(report,off), logtalk_load('$loader'), open('$($d.Replace('\', '/'))/loader.pl',append,Stream), forall((current_plugin(PlugIn), plugin_property(PlugIn,file(File))), (decompose_file_name(File,_,Basename,_), format(Stream,'\tload_foreign_library(~q),~n',[Basename]))), close(Stream), halt."

		xvmpl --goal $LoaderParam
	}

	Set-Content -Path "$d/loader.pl" -Value ":- initialization(("
	Add-Content -Path "$d/loader.pl" -Value  "	consult(logtalk),"
	if ($g -eq "true") {
		Add-Content -Path "$d/loader.pl" -Value  "	consult(application)"
	} else {
		Add-Content -Path "$d/loader.pl" -Value  "	consult(application),"
		Add-Content -Path "$d/loader.pl" -Value  "	($g)"
	}
	Add-Content -Path "$d/loader.pl" -Value  "))."

	Pop-Location
}

Pop-Location

try {
	Remove-Item $t -Force -Recurse
} catch {
	Write-Output "Error occurred at cleanup"
}
