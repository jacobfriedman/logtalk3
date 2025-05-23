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


:- if((
	predicate_property(asserta(_,_), built_in),
	% the GNU Prolog adapter file provides dummy definitions of this (and
	% other) predicates as built-in predicates to avoid embedding errors
	\+ current_logtalk_flag(prolog_dialect, gnu)
)).

	:- initialization((
		set_logtalk_flag(report, warnings),
		set_logtalk_flag(unknown_predicates, silent),
		logtalk_load(lgtunit(loader)),
		logtalk_load(test_object),
		logtalk_load(tests, [hook(lgtunit)]),
		tests::run
	)).

:- else.

	:- initialization((
		write('(not applicable)'), nl
	)).

:- endif.
