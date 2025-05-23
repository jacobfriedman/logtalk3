________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
________________________________________________________________________


This directory contains example scripts for creating SWI-Prolog QLF files
and standalone saved states from Logtalk core files and Logtalk source
files.

The following scripts are provided:

- `swipl_logtalk_qlf.sh`  
	Bash shell script for POSIX systems
- `swipl_logtalk_qlf.ps1`  
	PowerShell script for Windows systems

Both scripts create a `logtalk.qlf` file with the Logtalk compiler and
runtime and an optional `application.qlf` file for an application.

Usage
-----

Use `swipl_logtalk_qlf.sh -h` or `swipl_logtalk_qlf.ps1 -h` for a list
and description of the script options.

The `-f Action` option allows passing the foreign object action when
creating a standalone saved state. See the SWI-Prolog `qsave_program/2`
predicate documentation on the `foreign(Action)` option for details.

See the script usage examples in the `../SCRIPT.txt` file on how to
create a SWI-Prolog saved state that includes a Logtalk application.
