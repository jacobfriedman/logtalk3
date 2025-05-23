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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:9:0,
		author is 'Paulo Moura',
		date is 2023-06-30,
		comment is 'Unit tests for the ISO Prolog standard open/3-4 built-in predicates.'
	]).

	% tests from the ISO/IEC 13211-1:1995(E) standard, section 8.11.5.4

	test(iso_open_4_01, true) :-
		^^file_path('roger_data', Path),
		^^create_binary_file(Path, []),
		{open(Path, read, D, [type(binary)]),
		 at_end_of_stream(D)}.

	test(iso_open_4_02, true) :-
		^^file_path('scowen', Path),
		{open(Path, write, D, [alias(editor)]),
		 stream_property(D, alias(editor))}.

	test(iso_open_4_03, true) :-
		^^file_path('dave', Path),
		^^create_text_file(Path, 'foo.'),
		{open(Path, read, DD, []),
		 read(DD, foo),
		 at_end_of_stream(DD)}.

	% tests from the Prolog ISO conformance testing framework written by Péter Szabó and Péter Szeredi

	test(sics_open_4_04, error(instantiation_error)) :-
		{open(_, read, _)}.

	test(sics_open_4_05, error(instantiation_error)) :-
		{open(f, _, _)}.

	test(sics_open_4_06, error(instantiation_error)) :-
		{open(f, write, _, _)}.

	test(sics_open_4_07, error(instantiation_error)) :-
		{open(f, write, _, [type(text)|_])}.

	test(sics_open_4_08, error(instantiation_error)) :-
		{open(f, write, _, [type(text),_])}.

	test(sics_open_4_09, error(type_error(atom,1))) :-
		{open(f, 1, _)}.

	test(sics_open_4_10, error(type_error(list,type(text)))) :-
		{open(f, write, _, type(text))}.

	test(sics_open_4_11, error(uninstantiation_error(bar))) :-
		{open(f, write, bar)}.

	test(sics_open_4_12, error(domain_error(source_sink,foo(1,2)))) :-
		{open(foo(1,2), write, _)}.

	test(sics_open_4_13, error(domain_error(io_mode,red))) :-
		{open('foo', red, _)}.

	test(sics_open_4_14, error(domain_error(stream_option,bar))) :-
		{open(foo, write, _, [bar])}.

	test(sics_open_4_15, error(existence_error(source_sink,Path))) :-
		^^file_path('nonexistent', Path),
		{open(Path, read, _)}.

	test(sics_open_4_16, error(permission_error(open,source_sink,alias(a)))) :-
		^^file_path(foo, Path),
		{open(Path, write, _, [alias(a)]),
		 open(bar, write, _, [alias(a)])}.

	% tests from the Logtalk portability work

	test(lgt_open_4_17, error(instantiation_error)) :-
		{open(foo, write, _, [_|_])}.

	test(lgt_open_4_18, error(domain_error(stream_option,1))) :-
		{open(foo, write, _, [1])}.

	test(lgt_open_4_19, error(instantiation_error)) :-
		{open(foo, write, _, [alias(_)])}.

	test(lgt_open_4_20, error(domain_error(stream_option,alias(1)))) :-
		{open(foo, write, _, [alias(1)])}.

	test(lgt_open_4_21, error(instantiation_error)) :-
		{open(foo, write, _, [eof_action(_)])}.

	test(lgt_open_4_22, error(domain_error(stream_option,eof_action(1)))) :-
		{open(foo, write, _, [eof_action(1)])}.

	test(lgt_open_4_23, error(instantiation_error)) :-
		{open(foo, write, _, [reposition(_)])}.

	test(lgt_open_4_24, error(domain_error(stream_option,reposition(1)))) :-
		{open(foo, write, _, [reposition(1)])}.

	test(lgt_open_4_25, error(instantiation_error)) :-
		{open(foo, write, _, [type(_)])}.

	test(lgt_open_4_26, error(domain_error(stream_option,type(1)))) :-
		{open(foo, write, _, [type(1)])}.

	test(lgt_open_4_27, error(permission_error(open,source_sink,_)), [condition(create_no_read_permission_file)]) :-
		^^file_path('no_read_permission', Path),
		{open(Path, read, _, [])}.

	test(lgt_open_4_28, error(permission_error(open,source_sink,_)), [condition(create_no_write_permission_file)]) :-
		^^file_path('no_write_permission', Path),
		{open(Path, write, _, [])}.

	test(lgt_open_4_29, error(permission_error(open,source_sink,_)), [condition(create_no_append_permission_file)]) :-
		^^file_path('no_append_permission', Path),
		{open(Path, append, _, [])}.

	test(lgt_open_4_30, error(permission_error(open,source_sink,_)), [condition(not_running_as_root)]) :-
		{open('/no_write_permission', write, _, [])}.

	test(lgt_open_4_31, errors([permission_error(open,source_sink,_), existence_error(source_sink,_)]), [condition(os::operating_system_type(unix))]) :-
		{open('/foo/bar/no_write_permission', write, _, [])}.

	test(wg17_open_4_32, error(domain_error(stream_option,type(nontype)))) :-
		{open(foo, write, _, [type(nontype)])}.

	test(lgt_open_4_33, error(domain_error(stream_option,foobar(1)))) :-
		{open(foo, write, _, [foobar(1)])}.

	test(lgt_open_4_34, error(domain_error(stream_option,foobar(a,1)))) :-
		{open(foo, write, _, [foobar(a,1)])}.

	% default type

	test(lgt_open_4_35, true(Type == text)) :-
		{open(d1, write, Stream),
		 stream_property(Stream, type(Type))}.

	test(lgt_open_4_36, true(Type == text)) :-
		{open(d2, write, Stream, []),
		 stream_property(Stream, type(Type))}.

	% check behavior on repeated options

	test(lgt_open_4_37, true(Type == text)) :-
		{open(tt, write, Stream, [type(binary), type(text)]),
		 stream_property(Stream, type(Type))}.

	test(lgt_open_4_38, true(Type == binary)) :-
		{open(tb, write, Stream, [type(text), type(binary)]),
		 stream_property(Stream, type(Type))}.

	test(lgt_open_4_39, true(Reposition == true)) :-
		{open(rt, write, Stream, [reposition(false), reposition(true)]),
		 stream_property(Stream, reposition(Reposition))}.

	- test(lgt_open_4_40, true(Reposition == false), [note('implementation defined per ISO standard')]) :-
		{open(rf, write, Stream, [reposition(true), reposition(false)]),
		 stream_property(Stream, reposition(Reposition))}.

	test(lgt_open_4_41, true(Action == eof_code)) :-
		^^file_path('dave', Path),
		os::ensure_file(Path),
		{open(Path, read, Stream, [eof_action(error), eof_action(eof_code)]),
		 stream_property(Stream, eof_action(Action))}.

	test(lgt_open_4_42, true(Action == reset)) :-
		^^file_path('dave', Path),
		os::ensure_file(Path),
		{open(Path, read, Stream, [eof_action(eof_code), eof_action(reset)]),
		 stream_property(Stream, eof_action(Action))}.

	test(lgt_open_4_43, true(Action == error)) :-
		^^file_path('dave', Path),
		os::ensure_file(Path),
		{open(Path, read, Stream, [eof_action(reset), eof_action(error)]),
		 stream_property(Stream, eof_action(Action))}.

	cleanup :-
		^^clean_file(roger_data),
		^^clean_file(scowen),
		^^clean_file(dave),
		^^clean_file(foo),
		^^clean_file(bar),
		^^clean_file(f),
		^^clean_file(no_read_permission),
		^^clean_file(no_write_permission),
		^^clean_file(no_append_permission),
		^^clean_file(d1),
		^^clean_file(d2),
		^^clean_file(tt),
		^^clean_file(tb),
		^^clean_file(rt),
		^^clean_file(rf).

	% auxiliary predicates

	create_no_read_permission_file :-
		os::operating_system_type(unix),
		not_running_as_root,
		^^file_path('no_read_permission', Path),
		^^create_text_file(Path, 'foo.'),
		atom_concat('chmod a-r ', Path, Command),
		os::shell(Command).

	create_no_write_permission_file :-
		os::operating_system_type(unix),
		not_running_as_root,
		^^file_path('no_write_permission', Path),
		^^create_text_file(Path, 'foo.'),
		atom_concat('chmod a-w ', Path, Command),
		os::shell(Command).

	create_no_append_permission_file :-
		os::operating_system_type(unix),
		not_running_as_root,
		^^file_path('no_append_permission', Path),
		^^create_text_file(Path, 'foo.'),
		atom_concat('chmod a-w ', Path, Command),
		os::shell(Command).

	not_running_as_root :-
		os::operating_system_type(unix),
		os::shell('if [ "$(id -u)" -eq 0 ]; then exit 1; fi').

:- end_object.
