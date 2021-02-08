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


% define a flag to allow the logtalk_tester script to pass the
% option to suppress the test file and directory path prefix
:- initialization(
	create_logtalk_flag(suppress_path_prefix, '', [type(atom), keep(true)])
).


:- object(xunit_net_v2_report).

	:- info([
		version is 2:0:0,
		author is 'Paulo Moura',
		date is 2021-02-08,
		comment is 'Intercepts unit test execution messages and generates a ``xunit_report.xml`` file using the xUnit.net v2 XML format in the same directory as the tests object file.',
		remarks is [
			'Usage' - 'Simply load this object before running your tests using the goal ``logtalk_load(lgtunit(xunit_net_v2_report))``.'
		]
	]).

	:- private(message_cache_/1).
	:- dynamic(message_cache_/1).
	:- mode(message_cache_(?callable), zero_or_more).
	:- info(message_cache_/1, [
		comment is 'Table of messages emitted by the lgtunit tool when running tests.',
		argnames is ['Message']
	]).

	% intercept all messages from the "lgtunit" object while running tests

	:- multifile(logtalk::message_hook/4).
	:- dynamic(logtalk::message_hook/4).

	logtalk::message_hook(Message, _, lgtunit, _) :-
		message_hook(Message),
		% allow default processing of the messages
		fail.

	% start
	message_hook(tests_start_date_time(Year,Month,Day,Hours,Minutes,Seconds)) :-
		!,
		retractall(message_cache_(_)),
		assertz(message_cache_(tests_start_date_time(Year,Month,Day,Hours,Minutes,Seconds))).
	message_hook(running_tests_from_object_file(Object, File)) :-
		!,
		logtalk::loaded_file_property(File, directory(Directory)),
		atom_concat(Directory, 'xunit_report.xml', ReportFile),
		(	stream_property(_, alias(xunit_report)) ->
			true
		;	open(ReportFile, write, _, [alias(xunit_report)])
		),
		assertz(message_cache_(running_tests_from_object_file(Object,File))).
	% stop
	message_hook(tests_ended) :-
		!,
		close(xunit_report).
	message_hook(tests_end_date_time(Year,Month,Day,Hours,Minutes,Seconds)) :-
		!,
		assertz(message_cache_(tests_end_date_time(Year,Month,Day,Hours,Minutes,Seconds))),
		generate_xml_report.
	% "testcase" tag predicates
	message_hook(passed_test(Object, Test, File, Position, Note, Time)) :-
		!,
		assertz(message_cache_(test(Object, Test, passed_test(File, Position, Note, Time)))).
	message_hook(non_deterministic_success(Object, Test, File, Position, Note, Time)) :-
		!,
		assertz(message_cache_(test(Object, Test, non_deterministic_success(File, Position, Note, Time)))).
	message_hook(failed_test(Object, Test, File, Position, Reason, Note, Time)) :-
		!,
		assertz(message_cache_(test(Object, Test, failed_test(File, Position, Reason, Note, Time)))).
	message_hook(skipped_test(Object, Test, File, Position, Note)) :-
		!,
		assertz(message_cache_(test(Object, Test, skipped_test(File, Position, Note)))).
	% catchall clause
	message_hook(Message) :-
		assertz(message_cache_(Message)).

	% generate the XML report

	generate_xml_report :-
		write_report_header,
		write_assemblies_element.

	write_report_header :-
		write(xunit_report, '<?xml version="1.0" encoding="UTF-8"?>'), nl(xunit_report).

	write_assemblies_element :-
		write_xml_open_tag(assemblies, []),
		write_assembly_element,
		write_xml_close_tag(assemblies).

	write_assembly_element :-
		assembly_name(Name),
		assembly_config_file(ConfigFile),
		assembly_time(Time),
		assembly_run_date(RunDate),
		assembly_run_time(RunTime),
		assembly_stats(Tests, Errors, Failures, Skipped),
		write_xml_open_tag(assembly,
			[	name-Name, 'config-file'-ConfigFile, 'test-framework'-lgtunit,
				'run-date'-RunDate, 'run-time'-RunTime,
				time-Time,
			 	total-Tests, errors-Errors, failures-Failures, skipped-Skipped
			]
		),
		write_errors_element,
		write_collection_element,
		write_xml_close_tag(assembly).

	write_errors_element :-
		\+ message_cache_(broken_step(_, _, _)),
		\+ message_cache_(failed_step(_, _)),
		!.
	write_errors_element :-
		write_xml_open_tag(errors, []),
		message_cache_(broken_step(Step, _Object, Error)),
		write_xml_open_tag(error, [type-error, name-Step]),
		write_xml_open_tag(failure, []),
		write_xml_cdata_element('stack-trace', [], Error),
		write_xml_close_tag(failure),
		write_xml_close_tag(error),
		fail.
	write_errors_element :-
		message_cache_(failed_step(Step, _Object)),
		write_xml_open_tag(error, [type-failure, name-Step]),
		write_xml_empty_tag(failure, []),
		write_xml_close_tag(error),
		fail.
	write_errors_element :-
		write_xml_close_tag(errors).

	write_collection_element :-
		collection_stats(Tests, Errors, Failures, Skipped),
		collection_name(Name),
		collection_time(Time),
		write_xml_open_tag(collection,
			[	name-Name, time-Time,
			 	total-Tests, errors-Errors, failures-Failures, skipped-Skipped
			]
		),
		write_test_elements,
		write_xml_close_tag(collection).

	write_test_elements :-
		message_cache_(tests_skipped(Object, Note)),
		message_cache_(running_tests_from_object_file(Object, File)),
		Object<<test_(Name, _),
		write_test_element_tags(skipped_test(File, 0-0, Note), Name, Object),
		fail.
	write_test_elements :-
		message_cache_(test(Type, Name, Test)),
		write_test_element_tags(Test, Name, Type),
		fail.
	write_test_elements.

	write_test_element_tags(passed_test(File, Position, Note, Time), Name, Type) :-
		write_xml_open_tag(test, [name-Name, type-Type, method-'', time-Time, result-'Pass']),
		write_xml_open_tag(traits, []),
		suppress_path_prefix(File, Short),
		write_xml_empty_tag(trait, [name-file, value-Short]),
		write_xml_empty_tag(trait, [name-position, value-Position]),
		write_xml_empty_tag(trait, [name-note, value-Note]),
		write_xml_close_tag(traits),
		write_xml_close_tag(test).
	write_test_element_tags(non_deterministic_success(File, Position, Note, Time), Name, Type) :-
		write_xml_open_tag(test, [name-Name, type-Type, method-'', time-Time, result-'Fail']),
		write_xml_open_tag(traits, []),
		suppress_path_prefix(File, Short),
		write_xml_empty_tag(trait, [name-file, value-Short]),
		write_xml_empty_tag(trait, [name-position, value-Position]),
		write_xml_close_tag(traits),
		write_xml_open_tag(failure, []),
		test_message(Note, 'Non-deterministic success', Message),
		write_xml_cdata_element(message, [], Message),
		write_xml_close_tag(failure),
		write_xml_close_tag(test).
	write_test_element_tags(failed_test(File, Position, Reason, Note, Time), Name, Type) :-
		write_xml_open_tag(test, [name-Name, type-Type, method-'', time-Time, result-'Fail']),
		write_xml_open_tag(traits, []),
		suppress_path_prefix(File, Short),
		write_xml_empty_tag(trait, [name-file, value-Short]),
		write_xml_empty_tag(trait, [name-position, value-Position]),
		write_xml_close_tag(traits),
		write_xml_open_tag(failure, []),
		failed_test(Reason, Description, _, Error),
		test_message(Note, Description, Message),
		write_xml_cdata_element(message, [], Message),
		(	Error == '' ->
			true
		;	write_xml_cdata_element('stack-trace', [], Error)
		),
		write_xml_close_tag(failure),
		write_xml_close_tag(test).
	write_test_element_tags(skipped_test(File, Position, Note), Name, Type) :-
		write_xml_open_tag(test, [name-Name, type-Type, method-'', time-0.0, result-'Skip']),
		write_xml_open_tag(traits, []),
		suppress_path_prefix(File, Short),
		write_xml_empty_tag(trait, [name-file, value-Short]),
		write_xml_empty_tag(trait, [name-position, value-Position]),
		write_xml_close_tag(traits),
		test_message(Note, 'Skipped test', Reason),
		write_xml_cdata_element(reason, [], Reason),
		write_xml_close_tag(test).

	% failed_test(Reason, Description, Type, Error)
	failed_test(non_deterministic_success, 'Non-deterministic success', non_deterministic_success, '').
	failed_test(failure_instead_of_error, 'Failure instead of error', failure_instead_of_error, '').
	failed_test(failure_instead_of_success, 'Failure instead of success', failure_instead_of_success, '').
	failed_test(error_instead_of_success(Error), 'Error instead of success', error_instead_of_success, Error).
	failed_test(error_instead_of_failure(Error), 'Error instead of failure', error_instead_of_failure, Error).
	failed_test(success_instead_of_error, 'Success instead of error', success_instead_of_error, '').
	failed_test(success_instead_of_failure, 'Success instead of failure', success_instead_of_failure, '').
	failed_test(wrong_error(_, Error), 'Wrong error', wrong_error, Error).
	failed_test(quick_check_failed(Error, _, _), 'QuickCheck test failed', quick_check_failed, Error).
	failed_test(quick_check_error(Error, _, _), 'QuickCheck test error', quick_check_error, Error).
	failed_test(step_error(_, Error), 'Test step error', step_error, Error).
	failed_test(step_failure(Step), 'Test step failure', step_failure, Step).

	test_message(Note, Description, Message) :-
		(	Note == '' ->
			Message = Description
		;	atom_concat(Description, ': ', Message0),
			atom_concat(Message0, Note, Message)
		).

	% "assembly" tag attributes

	assembly_time(Time) :-
		message_cache_(tests_start_date_time(Year0, Month0, Day0, Hours0, Minutes0, Seconds0)),
		message_cache_(tests_end_date_time(Year, Month, Day, Hours, Minutes, Seconds)),
		julian_day(Year0, Month0, Day0, JulianDay0),
		julian_day(Year, Month, Day, JulianDay),
		Time is
			(JulianDay - JulianDay0) * 86400 +
			(Hours - Hours0) * 3600 +
			(Minutes - Minutes0) * 60 +
			Seconds - Seconds0.

	assembly_stats(Tests, 0, 0, Tests) :-
		message_cache_(tests_skipped(Object, _Note)),
		!,
		Object<<number_of_tests(Tests).
	assembly_stats(Tests, 0, Failures, Skipped) :-
		assembly_stats(0, Tests, 0, Failures, 0, Skipped).

	assembly_stats(Tests0, Tests, Failures0, Failures, Skipped0, Skipped) :-
		(	retract(message_cache_(tests_results_summary(_Object, PartialTests, PartialSkipped, _, PartialFailures, _))) ->
			Tests1 is Tests0 + PartialTests,
			Failures1 is Failures0 + PartialFailures,
			Skipped1 is Skipped0 + PartialSkipped,
			assembly_stats(Tests1, Tests, Failures1, Failures, Skipped1, Skipped)
		;	Tests is Tests0,
			Failures is Failures0,
			Skipped is Skipped0
		).

	assembly_config_file(Name) :-
		once(message_cache_(running_tests_from_object_file(_, File))),
		suppress_path_prefix(File, Name).

	assembly_name(Name) :-
		once(message_cache_(running_tests_from_object_file(Object, File))),
		(	logtalk::loaded_file_property(File, library(Library)),
			Library \== startup ->
			Name = library(Library)
		;	% use the object file directory
			object_property(Object, file(_,Directory)),
			suppress_path_prefix(Directory, Name)
		).

	assembly_run_date(RunDate) :-
		message_cache_(tests_start_date_time(Year, Month, Day, _, _, _)),
		integers_to_atoms([Year,Month,Day], [AYear,AMonth0,ADay0]),
		pad_single_char_atoms([AMonth0,ADay0], [AMonth,ADay]),
		concatenate_atoms([AYear,'-',AMonth,'-',ADay], '', RunDate).

	assembly_run_time(RunTime) :-
		message_cache_(tests_start_date_time(_, _, _, Hours, Minutes, Seconds)),
		integers_to_atoms([Hours,Minutes,Seconds], [AHours0,AMinutes0,ASeconds0]),
		pad_single_char_atoms([AHours0,AMinutes0,ASeconds0], [AHours,AMinutes,ASeconds]),
		concatenate_atoms([AHours,':',AMinutes,':',ASeconds], '', RunTime).

	% "collection" tag attributes

	collection_stats(Tests, Errors, Failures, Skipped) :-
		assembly_stats(Tests, Errors, Failures, Skipped).

	collection_name(Name) :-
		assembly_name(Name).

	collection_time(Time) :-
		assembly_time(Time).

	% date and time auxiliary predicates

	julian_day(Year, Month, Day, JulianDay) :-
		% code copied from Daniel L. Dudley iso8601 contribution to Logtalk
		A is (14 - Month) // 12,
		Y is Year + 4800 - A,
		M is Month + (12 * A) - 3,
		D is Day + ((153 * M + 2) // 5) + (365 * Y) + (Y // 4),
		JulianDay is D - (Y // 100) + (Y // 400) - 32045.

	integers_to_atoms([], []).
	integers_to_atoms([Integer| Integers], [Atom| Atoms]) :-
		number_codes(Integer, Codes),
		atom_codes(Atom, Codes),
		integers_to_atoms(Integers, Atoms).

	pad_single_char_atoms([], []).
	pad_single_char_atoms([Atom| Atoms], [PaddedAtom| PaddedAtoms]) :-
		(	atom_length(Atom, 1) ->
			atom_concat('0', Atom, PaddedAtom)
		;	PaddedAtom = Atom
		),
		pad_single_char_atoms(Atoms, PaddedAtoms).

	concatenate_atoms([], Concat, Concat).
	concatenate_atoms([Atom| Atoms], Concat0, Concat) :-
		atom_concat(Concat0, Atom, Concat1),
		concatenate_atoms(Atoms, Concat1, Concat).

	suppress_path_prefix(Path, ShortPath) :-
		% bypass the compiler as the flag is only created after loading this file
		{current_logtalk_flag(suppress_path_prefix, Prefix)},
		(	atom_concat(Prefix, ShortPath, Path) ->
			true
		;	ShortPath = Path
		).

	% XML auxiliary predicates

	write_xml_empty_tag(Tag, Atts) :-
		write(xunit_report, '<'),
		write(xunit_report, Tag),
		write_xml_tag_attributes(Atts),
		write(xunit_report, '/>'), nl(xunit_report).

	write_xml_open_tag(Tag, Atts) :-
		write(xunit_report, '<'),
		write(xunit_report, Tag),
		write_xml_tag_attributes(Atts),
		write(xunit_report, '>'), nl(xunit_report).

	write_xml_element(Tag, Atts, Text) :-
		write(xunit_report, '<'),
		write(xunit_report, Tag),
		write_xml_tag_attributes(Atts),
		write(xunit_report, '>'),
		write(xunit_report, Text),
		write(xunit_report, '</'),
		write(xunit_report, Tag),
		write(xunit_report, '>'), nl(xunit_report).

	writeq_xml_cdata_element(Tag, Atts, Text) :-
		write(xunit_report, '<'),
		write(xunit_report, Tag),
		write_xml_tag_attributes(Atts),
		write(xunit_report, '><![CDATA['),
		pretty_print_vars_quoted(Text),
		write(xunit_report, ']]></'),
		write(xunit_report, Tag),
		write(xunit_report, '>'), nl(xunit_report).

	write_xml_cdata_element(Tag, Atts, Text) :-
		write(xunit_report, '<'),
		write(xunit_report, Tag),
		write_xml_tag_attributes(Atts),
		write(xunit_report, '><![CDATA['),
		pretty_print_vars(Text),
		write(xunit_report, ']]></'),
		write(xunit_report, Tag),
		write(xunit_report, '>'), nl(xunit_report).

	write_xml_tag_attributes([]).
	write_xml_tag_attributes([Attribute-Value| Rest]) :-
		write(xunit_report, ' '),
		write(xunit_report, Attribute),
		write(xunit_report, '="'),
		write(xunit_report, Value),
		write(xunit_report, '"'),
		write_xml_tag_attributes(Rest).

	write_xml_close_tag(Tag) :-
		write(xunit_report, '</'),
		write(xunit_report, Tag),
		write(xunit_report, '>'), nl(xunit_report).

	pretty_print_vars(Term) :-
		\+ \+ (
			numbervars(Term, 0, _),
			write_term(xunit_report, Term, [numbervars(true)])
		).

	pretty_print_vars_quoted(Term) :-
		\+ \+ (
			numbervars(Term, 0, _),
			write_term(xunit_report, Term, [numbervars(true), quoted(true)])
		).

:- end_object.
