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


:- if(current_logtalk_flag(prolog_dialect, eclipse)).
	:- ensure_loaded('module.ecl').
:- elif(current_logtalk_flag(prolog_dialect, tau)).
	:- use_module(module).
:- elif(current_logtalk_flag(modules, supported)).
	:- ensure_loaded(module).
:- endif.

:- initialization((
	logtalk_load(basic_types(loader)),
	logtalk_load(os(loader)),
	logtalk_load([category], [events(deny), optimize(on)]),
	logtalk_load([objects, database_other, database, maze, graph], [events(deny), optimize(on)]),
	logtalk_load([plain, benchmarks], [events(deny), optimize(on)])
)).
