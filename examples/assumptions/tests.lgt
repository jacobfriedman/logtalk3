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
		version is 1:3:0,
		author is 'Paulo Moura',
		date is 2024-11-16,
		comment is 'Unit tests for the "assumptions" example.'
	]).

	cover(assumptions).
	cover(paths).
	cover(grades).

	test(assumptions_1, true(Paths == [[1,2,4,5], [1,3,5]])) :-
		findall(Path, (paths::init, paths::path(1,5,Path)), Paths).

	test(assumptions_2, true(Person == hans)) :-
		grades::assumel(take(hans, german)),
		grades::grade(Person).

	test(assumptions_3, false) :-
		grades::assumel(take(hans, italian)),
		grades::grade(_).

:- end_object.
