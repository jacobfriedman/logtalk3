%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
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


:- object(badcheck_pack,
	implements(pack_protocol)).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2024-10-15,
		comment is 'A local pack for testing.'
	]).

	name(badcheck).

	description('A local pack with a bad checksum for testing').

	license('Apache-2.0').

	home('file://test_files/badcheck').

	version(
		1:0:0,
		stable,
		'file://test_files/badcheck/v1.0.0.tar.gz',
		sha256 - 'c7ddfdb1bfd6afd81f4c1627bd7409ff0f90928511930079a0d576c1f49fa159',
		[logtalk @>= 3:42:0],
		all
	).

:- end_object.
