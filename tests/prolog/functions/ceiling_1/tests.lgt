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
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2020-07-14,
		comment is 'Unit tests for the ISO Prolog standard ceiling/1 built-in function.'
	]).

	% tests from the ISO/IEC 13211-1:1995(E) standard, section 9.1.7

	test(iso_ceiling_1_01, true(X == 0)) :-
		{X is ceiling(-0.5)}.

	% tests from the ECLiPSe test suite

	test(eclipse_ceiling_1_02, true(X == 4)) :-
		{X is ceiling(3.5)}.

	test(eclipse_ceiling_1_03, true(X == -3)) :-
		{X is ceiling(-3.5)}.

	% tests from the Logtalk portability work

	test(lgt_ceiling_1_04, error(instantiation_error)) :-
		% try to delay the error to runtime
		variable(N),
		{_X is ceiling(N)}.

	test(lgt_ceiling_1_05, error(type_error(float,9))) :-
		% try to delay the error to runtime
		{_X is ceiling(9)}.

	test(lgt_ceiling_1_06, error(type_error(evaluable,foo/0))) :-
		% try to delay the error to runtime
		foo(0, Foo),
		{_X is ceiling(Foo)}.

	test(lgt_ceiling_1_07, error(type_error(evaluable,foo/1))) :-
		% try to delay the error to runtime
		foo(1, Foo),
		{_X is ceiling(Foo)}.

	% auxiliary predicates used to delay errors to runtime

	variable(_).

	foo(0, foo).
	foo(1, foo(1)).

:- end_object.
