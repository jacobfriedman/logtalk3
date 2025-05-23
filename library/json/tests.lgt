%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org> and
%  Jacinto Dávila <jdavila@optimusprime.ai>
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
		version is 0:17:0,
		author is 'Paulo Moura and Jacinto Dávila',
		date is 2024-01-14,
		comment is 'Tests for different collections of JSON files and other media in JSON format.'
	]).

	:- uses(json, [
		parse/2, generate/2
	]).

	:- uses(os, [
		directory_files/3, path_concat/3, shell/2
	]).

	:- uses(lgtunit, [
		assertion/1, assertion/2
	]).

	:- uses(logtalk, [
		print_message(debug, json, Message) as dbg(Message)
	]).

	:- uses(list, [
		member/2
	]).

	cover(json(_)).

	setup :-
		^^clean_file('test_files/simple/output01.json').

	cleanup :-
		setup,
		^^clean_text_input.

	collection('test_files/json_org').
	collection('test_files/simple').

	test(parse_codes, true) :-
		parse(codes([0'[, 0'1, 0']]), _Term).

	test(parse_skip_ws, true) :-
		atom_codes('\r\t\n {"a":"b"}', Codes),
		json::parse(codes(Codes), _Obj).

	test(parse_simple_glossary_json, true) :-
		^^file_path('test_files/json_org/simple_glossary.json', Path),
		parse(file(Path), _Term).

	test(parse_menu_lists_json, true) :-
		^^file_path('test_files/json_org/menu_lists.json', Path),
		parse(file(Path), _Term).

	test(parse_menu_items_lists_json, true) :-
		^^file_path('test_files/json_org/menu_items_lists.json', Path),
		parse(file(Path), _Term).

	test(parse_widget_conf_json, true) :-
		^^file_path('test_files/json_org/widget_conf.json', Path),
		parse(file(Path), _Term).

	test(parse_web_app_lists_json, true) :-
		^^file_path('test_files/json_org/web_app_lists.json', Path),
		parse(file(Path), _Term).

	test(parse_stream, true) :-
		^^file_path('test_files/json_org/web_app_lists.json', Path),
		open(Path, read, Stream),
		parse(stream(Stream), _Term),
		close(Stream).

	test(parse_line, true(Term1-Term2 == {a-0}-{b-[1,2,3]})) :-
		^^set_text_input(in, '{"a":0}\n{"b":[1,2,3]}\n'),
		parse(line(in), Term1),
		parse(line(in), Term2),
		close(in).

	test(parse_chars, true(Term == {a-b})) :-
		atom_chars('{"a":"b"}', Chars),
		parse(chars(Chars), Term).

	test(parse_object_curly, true(Term == {a-1,b-2,c-3})) :-
		json(curly,dash,atom)::parse(atom('{"a":1, "b":2, "c":3}'), Term).

	test(parse_object_list, true(Term == json([a-1,b-2,c-3]))) :-
		json(list,dash,atom)::parse(atom('{"a":1, "b":2, "c":3}'), Term).

	test(parse_pair_equal, true(Term == json([a=1,b=2,c=3]))) :-
		json(list,equal,atom)::parse(atom('{"a":1, "b":2, "c":3}'), Term).

	test(parse_pair_colon, true(Term == json([':'(a,1),':'(b,2),':'(c,3)]))) :-
		json(list,colon,atom)::parse(atom('{"a":1, "b":2, "c":3}'), Term).

	test(generate_chars, true(Term == {a-b})) :-
		generate(chars(Chars), {a-b}),
		atom_chars(Atom, Chars),
		parse(atom(Atom), Term).

	test(parse_generate_atom, true(Atom == '[1,2,{"a":"b"}]')) :-
		parse(atom('[1,2,{"a":"b"}]'), Prolog),
		generate(atom(Atom), Prolog).

	test(parse_simple_valid_files, true) :-
		^^file_path('test_files/simple', Directory),
		directory_files(Directory, Files, [type(regular), paths(absolute), extensions(['.json'])]),
		forall(regular_member(File, Files), assertion(File, json::parse(file(File), _))).

	test(parse_simple_invalid_files, true) :-
		^^file_path('test_files/json_org', Directory),
		directory_files(Directory, Files, [type(regular), paths(absolute), extensions(['.json'])]),
		forall(fail_named(File, Files), assertion(File, (catch(json::parse(file(File), _), Error, true), nonvar(Error)))).

	test(parse_json_org_valid_files, true) :-
		^^file_path('test_files/json_org', Directory),
		directory_files(Directory, Files, [type(regular), paths(absolute), extensions(['.json'])]),
		forall(regular_member(File, Files), assertion(File, json::parse(file(File), _))).

	test(roundtrip_hexadecimals, true(roundtrip(File))) :-
		^^suppress_text_output,
		^^file_path('test_files/simple/hexadecimals.json', File).

	test(encode_pair_string_number, true(A == '{"a":1}')) :-
		generate(atom(A), {a-1}).

	test(encode_pair_dash_string_object, true(A == '{"a":{"b":"c"}}')) :-
		generate(atom(A), {a-{b-c}}).

	test(encode_pair_equal_string_object, true(A == '{"a":{"b":"c"}}')) :-
		generate(atom(A), {a={b=c}}).

	test(encode_pair_colon_string_object, true(A == '{"a":{"b":"c"}}')) :-
		generate(atom(A), {':'(a,{':'(b,c)})}).

	test(roundtrip_object_representation, true(JSON-Chars == json([])-['{','}'])) :-
		json(list,dash,atom)::(parse(chars(['{','}']), JSON), generate(chars(Chars), JSON)).

	test(roundtrip_string_representation, true(JSON-Chars == {}-['"','{','}','"'])) :-
		json(list,dash,atom)::(parse(chars(['"','{','}','"']), JSON), generate(chars(Chars), JSON)).

	test(roundtrip_simple_files, true) :-
		^^file_path('test_files/simple', Directory),
		directory_files(Directory, Files, [type(regular), paths(absolute), extensions(['.json'])]),
		forall(roundtrip_named(File, Files), assertion(roundtrip(File))).

	test(term_rountrip_compound_object, true(Term=={ vars-['SubClass', 'Comment'], unifications-[ {'SubClass'-'NodeSignal', 'Comment'-'A node signal'}, {'SubClass'-'InvariantSignal', 'Comment'-'A graph invariant signal'} ] }), [note(term(Term))]) :-
		generate(codes(Codes), { vars - ['SubClass', 'Comment'], unifications - [ {'SubClass' - 'NodeSignal', 'Comment' - 'A node signal'}, {'SubClass'- 'InvariantSignal', 'Comment'- 'A graph invariant signal'} ] }),
		parse(codes(Codes), Term).

	test(valid_escape, true) :-
		parse(atom('"\\t  \\r  \\n \\f \\b \\/ \\\\ \\"  "'), _Term).

	test(new_line_escape, true(Term == {a-'\n'})) :-
		^^file_path('test_files/escape_sequences/new_line.json', Path),
		parse(file(Path), Term).

	test(tab_escape, true(Term == {a-'\t'})) :-
		^^file_path('test_files/escape_sequences/tab.json', Path),
		parse(file(Path), Term).

	test(unicode_escape, true(Term == {codes([97])-codes([945])})) :-
		^^file_path('test_files/escape_sequences/unicode.json', Path),
		json(codes)::parse(file(Path), Term).

	test(json_escape_char, true) :-
		generate(codes(_Codes), '"\t  \r  \n \f \b \" \\ \\/ "').

	test(json_atom_parse_codes, true(Term == hello)) :-
		json(atom)::parse(codes([34,104,101,108,108,111,34]), Term).

	test(json_chars_parse_codes, true(Term == chars([h,e,l,l,o]))) :-
		json(chars)::parse(codes([34,104,101,108,108,111,34]), Term).

	test(json_codes_parse_codes, true(Term == codes([104,101,108,108,111]))) :-
		json(codes)::parse(codes([34,104,101,108,108,111,34]), Term).

	test(json_generate_codes_from_codes, true(Codes == [34, 104, 101, 108, 108, 111, 34])) :-
		json(codes)::generate(codes(Codes), codes([104, 101, 108, 108, 111])).

	test(json_generate_chars_from_chars, true(Chars == ['"', h, e, l, l, o, '"'])) :-
		json(_)::generate(chars(Chars),  chars([h, e, l, l, o])).

	test(json_double_quote_escape_parse, true(Term == {foo-'bar "1" baz'})) :-
		^^file_path('test_files/simple/double_quote_escape.json', Path),
		json(atom)::parse(file(Path), Term).

	test(json_double_quote_escape_generate, true(Atom == '{"foo":"bar \\"1\\" baz"}')) :-
		json(atom)::generate(atom(Atom), {foo-'bar "1" baz'}).

	test(json_generate_error_object_list_representation, error(domain_error(json_sink, {a-b}))) :-
		json(list,dash,atom)::generate(chars(_), {a-b}).

	test(json_generate_error_object_curly_representation, error(domain_error(json_sink, json([a-b])))) :-
		json(curly,dash,atom)::generate(chars(_), json([a-b])).

	% auxiliary predicates

	regular_member(File, Files) :-
		member(File, Files),
		\+ sub_atom(File, _, _, _, to_fail_),
		\+ sub_atom(File, _, _, _, roundtrip_).

	fail_named(File, Files) :-
		member(File, Files),
		\+ \+ sub_atom(File, _, _, _, to_fail_).

	roundtrip_named(File, Files) :-
		member(File, Files),
		\+ \+ sub_atom(File, _, _, _, roundtrip_).

	roundtrip(File) :-
		parse(file(File), Prolog), generate(codes(Codes), Prolog),
		dbg('Prolog term read from file and generated as a list of codes'-[Prolog, Codes]).

:- end_object.
