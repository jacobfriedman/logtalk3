%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>
%  SPDX-License-Identifier: Apache-2.0
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% don't rely on SWI-Prolog autoloading mechanism to be enabled
:- if(current_logtalk_flag(prolog_dialect, swi)).

	:- use_module(library(dialect), [exists_source/1]).

:- endif.


:- if((current_logtalk_flag(prolog_dialect, Dialect), (Dialect == swi; Dialect == yap))).

	:- if(exists_source(library(jpl))).

		:- use_module(library(jpl), []).
		:- initialization(logtalk_load([java_protocols,java_jpl], [optimize(on)])).

	:- else.

		:- initialization((write('(JPL library not available)'), nl)).

	:- endif.

:- elif((current_logtalk_flag(prolog_dialect, xvm), logtalk_library_path(jni, _))).

	:- initialization((
		logtalk_load(jni(loader)),
		logtalk_load([java_protocols,java_jpl], [optimize(on)])
	)).

:- elif(current_logtalk_flag(prolog_dialect, ji)).

	:- initialization(logtalk_load([java_protocols,java_jip], [optimize(on)])).

:- else.

	:- initialization((write('(not applicable)'), nl)).

:- endif.
