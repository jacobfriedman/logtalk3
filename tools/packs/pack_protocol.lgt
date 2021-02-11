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


:- protocol(pack_protocol).

	:- info([
		version is 0:1:0,
		author is 'Paulo Moura',
		date is 2021-02-11,
		comment is 'Package specification protocol.'
	]).

	:- public(description/1).
	:- mode(description(+atom), one).
	:- info(description/1, [
		comment is 'Package one line description.',
		argnames is ['Description']
	]).

	:- public(license/1).
	:- mode(license(+atom), one).
	:- info(license/1, [
		comment is 'Package license. Specified using the identifier from the SPDX License List (https://spdx.org/licenses/).',
		argnames is ['License']
	]).

	:- public(home_page/1).
	:- mode(home_page(+atom), one).
	:- info(home_page/1, [
		comment is 'Package home page URL.',
		argnames is ['HomePage']
	]).

	:- public(version/5).
	:- mode(version(++compound, +atom, +pair(atom,atom), ++list(pair(atom,callable)), +atom), one_or_more).
	:- mode(version(++compound, +atom, +pair(atom,atom), ++list(pair(atom,callable)), ++list(atom)), one_or_more).
	:- info(version/5, [
		comment is 'Table of available versions.',
		argnames is ['Version', 'URL', 'Checksum', 'Dependencies', 'Portability'],
		remarks is [
			'Version' - 'The ``Version`` argument uses the same format as entity versions: ``Major:Minor:Pathch``.',
			'URL' - 'Download URL for the package sources archive.',
			'Checksum' - 'A pair where the key is the hash algorithm and the value is the checksum. The algorithm must be supported by ``openssl`` (``sha256`` or better).',
			'Dependencies' - 'A list of the package dependencies. Each dependency is a pair ``Name-Closure`` where ``Name`` identifies the dependency and ``Closure`` allows checking version compatibility.',
			'Dependency names' - 'Either ``Registry::Dependency`` or just ``Dependency`` where both ``Registry`` and ``Dependency`` are atoms.'
			'Portability' - 'Either the atom ``all`` or a list of the supported backend Prolog compilers (using the identifier atoms use by the ``prolog_dialect`` flag).'
		]
	]).

:- end_protocol.
