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
		date is 2021-01-26,
		comment is 'Unit tests for the de facto standard Prolog atanh/1 built-in function.'
	]).

	:- uses(lgtunit, [
		op(700, xfx, =~=), (=~=)/2
	]).

	% tests from the Logtalk portability work

	test(lgt_atanh_1_01, true(X =~= 0.549306)) :-
		{X is atanh(0.5)}.

	test(lgt_atanh_1_02, error(instantiation_error)) :-
		% try to delay the error to runtime
		variable(N),
		{_X is atanh(N)}.

	test(lgt_atanh_1_03, error(type_error(evaluable,foo/0))) :-
		% try to delay the error to runtime
		foo(0, Foo),
		{_X is atanh(Foo)}.

	test(lgt_atanh_1_04, error(type_error(evaluable,foo/1))) :-
		% try to delay the error to runtime
		foo(1, Foo),
		{_X is atanh(Foo)}.

	test(lgt_atanh_1_05, error(type_error(evaluable,foo/2))) :-
		% try to delay the error to runtime
		foo(2, Foo),
		{_X is atanh(Foo)}.

	test(lgt_atanh_1_06, error(evaluation_error(undefined))) :-
		% try to delay the error to runtime
		{_X is atanh(-1.1)}.

	test(lgt_atanh_1_07, error(evaluation_error(undefined))) :-
		% try to delay the error to runtime
		{_X is atanh(1.1)}.

	test(lgt_atanh_1_08, errors([evaluation_error(undefined), evaluation_error(zero_divisor)])) :-
		% try to delay the error to runtime
		{_X is atanh(-1.0)}.

	test(lgt_atanh_1_09, errors([evaluation_error(undefined), evaluation_error(zero_divisor)])) :-
		% try to delay the error to runtime
		{_X is atanh(1.0)}.

	% auxiliary predicates used to delay errors to runtime

	variable(_).

	foo(0, foo).
	foo(1, foo(1)).
	foo(2, foo(1,2)).

:- end_object.
