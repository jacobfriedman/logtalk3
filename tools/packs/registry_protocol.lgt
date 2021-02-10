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


:- protocol(registry_protocol).

	:- info([
		version is 0:1:0,
		author is 'Paulo Moura',
		date is 2021-02-07,
		comment is 'Packs registry protocol.'
	]).

	:- public(description/1).
	:- mode(description(+atom), one).
	:- info(description/1, [
		comment is 'Packs registry one line description.',
		argnames is ['Description']
	]).

	:- public(home_page/1).
	:- mode(home_page(+atom), one).
	:- info(home_page/1, [
		comment is 'Packs registry home page URL.',
		argnames is ['HomePage']
	]).

	:- public(archive/1).
	:- mode(archive(+atom), one).
	:- info(archive/1, [
		comment is 'Download URL for the packs registry archive.',
		argnames is ['URL']
	]).

:- end_protocol.
