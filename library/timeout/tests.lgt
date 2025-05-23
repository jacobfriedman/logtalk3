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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 0:8:0,
		author is 'Paulo Moura',
		date is 2023-01-15,
		comment is 'Unit tests for the "timeout" library.'
	]).

	:- uses(timeout, [
		call_with_timeout/2, call_with_timeout/3
	]).

	cover(timeout).

	% call_with_timeout/2 tests

	test(call_with_timeout_2_01, ball(timeout((repeat,fail))), [condition(\+ current_logtalk_flag(prolog_dialect, swi))]) :-
		call_with_timeout((repeat,fail), 0.1).

	test(call_with_timeout_2_02, deterministic) :-
		call_with_timeout(true, 0.1).

	test(call_with_timeout_2_03, deterministic) :-
		call_with_timeout(repeat, 0.1).

	test(call_with_timeout_2_04, deterministic) :-
		call_with_timeout(my_repeat, 0.1).

	test(call_with_timeout_2_05, fail) :-
		call_with_timeout(fail, 0.1).

	test(call_with_timeout_2_06, ball(e)) :-
		call_with_timeout(throw(e), 0.1).

	test(call_with_timeout_2_07, ball(error(_, _))) :-
		call_with_timeout(_, 0.1).

	test(call_with_timeout_2_08, ball(error(_, _))) :-
		call_with_timeout(42, 0.1).

	% call_with_timeout/3 tests

	test(call_with_timeout_3_01, true(Result == timeout), [condition(\+ current_logtalk_flag(prolog_dialect, swi))]) :-
		call_with_timeout((repeat,fail), 0.1, Result).

	test(call_with_timeout_3_02, true(Result == true)) :-
		call_with_timeout(true, 0.1, Result).

	test(call_with_timeout_3_03, true(Result == true)) :-
		call_with_timeout(repeat, 0.1, Result).

	test(call_with_timeout_3_04, true(Result == true)) :-
		call_with_timeout(my_repeat, 0.1, Result).

	test(call_with_timeout_3_05, true(Result == fail)) :-
		call_with_timeout(fail, 0.1, Result).

	test(call_with_timeout_3_06, true(Result == error(e))) :-
		call_with_timeout(throw(e), 0.1, Result).

	test(call_with_timeout_3_07, subsumes(error(_), Result)) :-
		call_with_timeout(_, 0.1, Result).

	test(call_with_timeout_3_08, subsumes(error(_), Result)) :-
		call_with_timeout(42, 0.1, Result).

	% auxiliary predicates

	my_repeat.
	my_repeat :-
		my_repeat.

:- end_object.
