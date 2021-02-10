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


:- category(packs_messages).

	:- info([
		version is 0:1:0,
		author is 'Paulo Moura',
		date is 2021-02-04,
		comment is 'Logtalkpacks tool default message translations.'
	]).

	:- multifile(logtalk::message_prefix_stream/4).
	:- dynamic(logtalk::message_prefix_stream/4).

	logtalk::message_prefix_stream(Kind, packs, Prefix, Stream) :-
		message_prefix_stream(Kind, Prefix, Stream).

	message_prefix_stream(information, '% ',     user_output).
	message_prefix_stream(warning,     '*     ', user_output).
	message_prefix_stream(error,       '!     ', user_output).

	:- multifile(logtalk::message_tokens//2).
	:- dynamic(logtalk::message_tokens//2).

	logtalk::message_tokens(Message, packs) -->
		message_tokens(Message).

	message_tokens(help) -->
		[	'Common queries using the packs tool:'-[], nl, nl
		].

	message_tokens(package_info(Package,Summary,Description,License,HomePage,Versions)) -->
		[	'Package: ~q - -w'-[Package, Summary], nl, nl,
			'Description: ~w'-[Description], nl, nl,
			'License: ~w'-[License], nl,
			'Home Page: ~w'-[HomePage], nl, nl
		],
		package_versions(Versions).

	package_versions([]) --> [nl].
	package_versions([version(Version, _URL, _Checksum, _Dependencies)| Versions]) -->
		['  ~w'-[Version], nl],
		package_versions(Versions).

:- end_category.
