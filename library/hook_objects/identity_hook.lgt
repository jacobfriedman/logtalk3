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


:- object(identity_hook,
	implements(expanding)).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2020-02-15,
		comment is 'Use this object as a file specific hook object to prevent any (other) user-defined expansion rules to be applied when compiling the file.',
		see_also is [
			backend_adapter_hook, default_workflow_hook,
			grammar_rules_hook, prolog_module_hook(_), object_wrapper_hook,
			write_to_stream_hook(_, _), write_to_stream_hook(_),
			print_goal_hook, suppress_goal_hook
		]
	]).

	% define the expansion predicates to trivially succeed without
	% changing input terms and goals to effectively prevent the
	% use of any default expansions when compiling a source file

	term_expansion(Term, Term).

	goal_expansion(Goal, Goal).

:- end_object.
