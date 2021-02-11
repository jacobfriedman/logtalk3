%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>
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


:- category(packs_registries).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2021-02-11,
		comment is 'Packs registry predicates.'
	]).

	:- public(registries/0).
	:- mode(registries, one).
	:- info(registries/0, [
		comment is 'Prints a list of all available registries.'
	]).

	:- public(registry/1).
	:- mode(registry(+atom), one).
	:- info(registry/1, [
		comment is 'Prints all registry entries.',
		argnames is ['Registry']
	]).

	registries :-
		logtalk::expand_library_path(logtalk_packs, Directory),
		os::path_concat(Directory, 'registries/', Path),
		os::directory_files(Path, Registries, [type(directory), dot_files(false)]),
		logtalk::print_message(information, packs, 'Registries'::Registries).

:- end_category.
