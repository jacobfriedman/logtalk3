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


:- object(simpsons_extended,
	extends(simpsons)).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2017-03-06,
		comment is 'Extended Simpsons family.'
	]).

	% register this family by providing linking
	% clauses for the family basic relations

	:- multifile(family(_)::male/2).
	family(_)::male(simpsons_extended, Male) :-
		male(Male).

	:- multifile(family(_)::female/2).
	family(_)::female(simpsons_extended, Male) :-
		female(Male).

	:- multifile(family(_)::parent/3).
	family(_)::parent(simpsons_extended, Parent, Child) :-
		parent(Parent, Child).

	% define the family basic relations

	male(Male) :-
		^^male(Male).
	male(abe).
	male(herb).

	female(Male) :-
		^^female(Male).
	female(gaby).
	female(mona).

	parent(Parent, Child) :-
		^^parent(Parent, Child).
	parent(abe, homer).
	parent(abe, herb).
	parent(gaby, herb).
	parent(mona, homer).

:- end_object.
