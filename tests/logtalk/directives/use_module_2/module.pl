%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>
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


:- if(current_logtalk_flag(prolog_dialect, eclipse)).

	:- module(module).

	:- export((p/1, q/1, r/1, s/2, t/2)).

	p(1).

	q(2).

	r(3).

	s(1, one).
	s(2, two).

	t(1, a). t(1, b). t(1, c).
	t(2, x). t(2, y). t(2, z).

:- else.

	:- module(module, [p/1, q/1, r/1, s/2, t/2]).

	p(1).

	q(2).

	r(3).

	s(1, one).
	s(2, two).

	t(1, a). t(1, b). t(1, c).
	t(2, x). t(2, y). t(2, z).

:- endif.
