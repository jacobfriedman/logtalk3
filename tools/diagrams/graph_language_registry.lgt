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


:- object(graph_language_registry).

	:- info([
		version is 1:0:1,
		author is 'Paulo Moura',
		date is 2020-03-25,
		comment is 'Registry of implemented graph languages.'
	]).

	:- public(language_object/2).
	:- multifile(language_object/2).
	:- if(current_logtalk_flag(prolog_dialect, qp)).
		:- dynamic(language_object/2).
	:- endif.
	:- mode(language_object(?atom, ?object_identifier), zero_or_more).
	:- info(language_object/2, [
		comment is 'Table of defined graph languages and their implementation objects.',
		argnames is ['Language', 'Object']
	]).

:- end_object.
