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


:- initialization((
	logtalk_load(basic_types(loader)),
	logtalk_load(os(loader)),
	logtalk_load(help, [optimize(on)])
)).

% experimental features
:- if(current_logtalk_flag(prolog_dialect, ciao)).
	:- use_module(library(process)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, eclipse)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, gnu)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, xvm)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, sicstus)).
	:- use_module(library(process)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, swi)).
	:- use_module(library(process)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, trealla)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, xsb)).
	:- initialization(logtalk_load(help_info_support)).
:- elif(current_logtalk_flag(prolog_dialect, yap)).
	:- use_module(library(system)).
	:- initialization(logtalk_load(help_info_support)).
:- endif.
