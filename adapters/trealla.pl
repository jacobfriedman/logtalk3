%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Adapter file for Trealla Prolog 2.59.21 and later versions
%  Last updated on November 12, 2024
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ISO Prolog Standard predicates that we must define because they are
%  not built-in
%
%  add a clause for '$lgt_iso_predicate'/1 declaring each ISO predicate that
%  we must define; there must be at least one clause for this predicate
%  whose call should fail if we don't define any ISO predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_iso_predicate'(?callable).
%
% table of missing ISO predicates which are defined in this file

% remove the following clause if you need to define any ISO predicate
'$lgt_iso_predicate'(_) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  de facto standard Prolog predicates that might be missing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% between(+integer, +integer, ?integer) -- built-in


% findall(?term, +callable, ?list, +list) -- built-in


% forall(+callable, +callable) -- built-in


% format(+stream_or_alias, +character_code_list_or_atom, +list)
% format(+character_code_list_or_atom, +list)

'$lgt_format'(Stream, Format, Arguments) :-
	format(Stream, Format, Arguments).

'$lgt_format'(Format, Arguments) :-
	format(Format, Arguments).


% numbervars(?term, +integer, ?integer) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  predicate properties
%
%  this predicate must return at least static, dynamic, and built_in
%  properties for an existing predicate (and ideally meta_predicate/1
%  properties for built-in predicates and library predicates)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_predicate_property'(+callable, ?predicate_property)

'$lgt_predicate_property'(Pred, Prop) :-
	predicate_property(Pred, Prop).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  meta-predicates
%
%  the setup_call_cleanup/3 meta-predicate is only strictly required if
%  the backend Prolog compiler supports a compatible multi-threading
%  implementation but the developer tools can also take advantage of it
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% setup_call_cleanup(+callable, +callable, +callable) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Prolog non-standard built-in meta-predicates and meta-directives
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_meta_predicate'(@callable, ?callable, ?atom)
%
% table of meta-predicate patterns for proprietary built-in predicates;
% the third argument, which must be either "predicate" or "control_construct",
% is used to guide the compilation of these meta-predicates in debug mode

'$lgt_prolog_meta_predicate'(*->(_, _), *->(0, 0), control_construct).
'$lgt_prolog_meta_predicate'(call_cleanup(_, _), call_cleanup(0, 0), predicate).
'$lgt_prolog_meta_predicate'(call_nth(_, _), call_nth(0, *), predicate).
'$lgt_prolog_meta_predicate'(if(_, _, _), if(0, 0, 0), predicate).
'$lgt_prolog_meta_predicate'(setup_call_cleanup(_, _, _), setup_call_cleanup(0, 0, 0), predicate).
'$lgt_prolog_meta_predicate'(task(_), task(0), predicate).
'$lgt_prolog_meta_predicate'(task(_, _), task(1, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _), task(2, *, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _, _), task(3, *, *, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _, _, _), task(4, *, *, *, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _, _, _, _), task(5, *, *, *, *, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _, _, _, _, _), task(6, *, *, *, *, *, *), predicate).
'$lgt_prolog_meta_predicate'(task(_, _, _, _, _, _, _, _), task(7, *, *, *, *, *, *, *), predicate).
'$lgt_prolog_meta_predicate'(time(_), time(0), predicate).


% '$lgt_prolog_meta_directive'(@callable, -callable)

'$lgt_prolog_meta_directive'(_, _) :-
	fail.


% '$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(@nonvar, -atom)

'$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(_, _) :-
	fail.


% '$lgt_prolog_phrase_predicate'(@callable)
%
% table of predicates that call non-terminals
% (other than the de facto standard phrase/2-3 predicates)

'$lgt_prolog_phrase_predicate'(pio:phrase_from_file(_, _)).
'$lgt_prolog_phrase_predicate'(pio:phrase_from_file(_, _, _)).
'$lgt_prolog_phrase_predicate'(pio:phrase_to_file(_, _)).
'$lgt_prolog_phrase_predicate'(pio:phrase_to_file(_, _, _)).
'$lgt_prolog_phrase_predicate'(pio:phrase_to_stream(_, _)).


% '$lgt_candidate_tautology_or_falsehood_goal_hook'(@callable)
%
% valid candidates are proprietary built-in predicates with no
% side-effects when called with ground arguments

'$lgt_candidate_tautology_or_falsehood_goal_hook'(?=(_, _)).
'$lgt_candidate_tautology_or_falsehood_goal_hook'(cyclic_term(_)).
'$lgt_candidate_tautology_or_falsehood_goal_hook'(is_list(_)).
'$lgt_candidate_tautology_or_falsehood_goal_hook'(name(_, _)).
'$lgt_candidate_tautology_or_falsehood_goal_hook'(plus(_, _, _)).
'$lgt_candidate_tautology_or_falsehood_goal_hook'(succ(_, _)).


% '$lgt_prolog_database_predicate'(@callable)
%
% table of non-standard database built-in predicates

'$lgt_prolog_database_predicate'(assert(_)).
'$lgt_prolog_database_predicate'(asserta(_, _)).
'$lgt_prolog_database_predicate'(assertz(_, _)).
'$lgt_prolog_database_predicate'(clause(_, _, _)).
'$lgt_prolog_database_predicate'(listing(_)).


% '$lgt_prolog_predicate_property'(?callable)
%
% table of proprietary predicate properties; used by the
% compiler when checking if a predicate property is valid

'$lgt_prolog_predicate_property'(control_construct).
'$lgt_prolog_predicate_property'(native_code).


% '$lgt_prolog_deprecated_built_in_predicate_hook'(?callable, ?callable)
%
% table of proprietary deprecated built-in predicates
% when there's a Prolog system advised alternative

'$lgt_prolog_deprecated_built_in_predicate_hook'(_, _) :-
	fail.


% '$lgt_prolog_deprecated_built_in_predicate_hook'(?callable)
%
% table of proprietary deprecated built-in predicates without
% a direct advised alternative

'$lgt_prolog_deprecated_built_in_predicate_hook'(_) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  file name extension predicates
%
%  these extensions are used by Logtalk load/compile predicates
%
%  you may want to change the extension for the intermediate files
%  generated by the Logtalk compiler ("object" files) to match the
%  extension expected by default by your Prolog compiler
%
%  there should only a single extension defined for object files but
%  but multiple extensions can be defined for Logtalk and Prolog source
%  files and for backend specific temporary files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_file_extension'(?atom, ?atom)

'$lgt_file_extension'(logtalk, '.lgt').
'$lgt_file_extension'(logtalk, '.logtalk').
% there must be a single object file extension
'$lgt_file_extension'(object, '.pl').
'$lgt_file_extension'(prolog, '.pl').
'$lgt_file_extension'(prolog, '.prolog').
'$lgt_file_extension'(prolog, '.pro').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  backend Prolog compiler features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_feature'(?atom, ?atom)
%
% backend Prolog compiler supported features (that are compatible with Logtalk)

'$lgt_prolog_feature'(prolog_dialect, trealla).
'$lgt_prolog_feature'(prolog_version, v(Major, Minor, Patch)) :-
	current_prolog_flag(version_data, trealla(Major, Minor, Patch, _)).
'$lgt_prolog_feature'(prolog_compatible_version, '@>='(v(2, 59, 21))).

'$lgt_prolog_feature'(encoding_directive, source).
'$lgt_prolog_feature'(tabling, unsupported).
'$lgt_prolog_feature'(engines, Engines) :-
	(	predicate_property(message_queue_create(_, _), built_in) ->
		Engines = supported
	;	Engines = unsupported
	).
'$lgt_prolog_feature'(threads, Threads) :-
	(	predicate_property(message_queue_create(_, _), built_in) ->
		Threads = supported
	;	Threads = unsupported
	).
'$lgt_prolog_feature'(modules, supported).
'$lgt_prolog_feature'(coinduction, unsupported).
'$lgt_prolog_feature'(unicode, full).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  default flag values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_default_flag'(?atom, ?atom)
%
% default values for all flags

% startup flags:
'$lgt_default_flag'(settings_file, allow).
% lint compilation flags:
'$lgt_default_flag'(linter, default).
'$lgt_default_flag'(general, warning).
'$lgt_default_flag'(encodings, warning).
'$lgt_default_flag'(unknown_entities, warning).
'$lgt_default_flag'(unknown_predicates, warning).
'$lgt_default_flag'(undefined_predicates, warning).
'$lgt_default_flag'(singleton_variables, warning).
'$lgt_default_flag'(steadfastness, silent).
'$lgt_default_flag'(naming, silent).
'$lgt_default_flag'(duplicated_clauses, silent).
'$lgt_default_flag'(left_recursion, warning).
'$lgt_default_flag'(tail_recursive, silent).
'$lgt_default_flag'(disjunctions, warning).
'$lgt_default_flag'(conditionals, warning).
'$lgt_default_flag'(catchall_catch, silent).
'$lgt_default_flag'(portability, silent).
'$lgt_default_flag'(redefined_built_ins, silent).
'$lgt_default_flag'(redefined_operators, warning).
'$lgt_default_flag'(deprecated, warning).
'$lgt_default_flag'(missing_directives, warning).
'$lgt_default_flag'(duplicated_directives, warning).
'$lgt_default_flag'(trivial_goal_fails, warning).
'$lgt_default_flag'(always_true_or_false_goals, warning).
'$lgt_default_flag'(lambda_variables, warning).
'$lgt_default_flag'(grammar_rules, warning).
'$lgt_default_flag'(arithmetic_expressions, warning).
'$lgt_default_flag'(suspicious_calls, warning).
'$lgt_default_flag'(underscore_variables, dont_care).
% optional features compilation flags:
'$lgt_default_flag'(complements, deny).
'$lgt_default_flag'(dynamic_declarations, deny).
'$lgt_default_flag'(events, deny).
'$lgt_default_flag'(context_switching_calls, allow).
% other compilation flags:
'$lgt_default_flag'(scratch_directory, './.lgt_tmp/').
'$lgt_default_flag'(report, Report) :-
	(	catch(current_prolog_flag(verbose, false), _, fail) ->
		Report = warnings
	;	Report = on
	).
'$lgt_default_flag'(clean, on).
'$lgt_default_flag'(code_prefix, '$').
'$lgt_default_flag'(optimize, off).
'$lgt_default_flag'(source_data, on).
'$lgt_default_flag'(reload, changed).
'$lgt_default_flag'(debug, off).
% Prolog compiler and loader flags:
'$lgt_default_flag'(prolog_compiler, []).
'$lgt_default_flag'(prolog_loader, []).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  operating-system access predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_os_file_name'(+atom, -atom)
% '$lgt_prolog_os_file_name'(-atom, +atom)
%
% converts between Prolog internal file paths and operating-system paths

'$lgt_prolog_os_file_name'(Path, Path).


% '$lgt_expand_path'(+atom, -atom)
%
% expands a file path to a full path

'$lgt_expand_path'(Path, ExpandedPath) :-
	working_directory(Current, Current),
	absolute_file_name(Path, ExpandedPath, [expand(true), relative_to(Current)]).


% '$lgt_file_exists'(+atom)
%
% checks if a file exists

'$lgt_file_exists'(File) :-
	exists_file(File).


% '$lgt_delete_file'(+atom)
%
% deletes a file

'$lgt_delete_file'(File) :-
	delete_file(File).


% '$lgt_directory_exists'(+atom)
%
% checks if a directory exists

'$lgt_directory_exists'(Directory) :-
	exists_directory(Directory).


% '$lgt_current_directory'(-atom)
%
% gets current working directory

'$lgt_current_directory'(Directory) :-
	working_directory(Directory0, Directory0),
	atom_chars(Directory, Directory0).


% '$lgt_change_directory'(+atom)
%
% changes current working directory

'$lgt_change_directory'(Directory) :-
	working_directory(_, Directory).


% '$lgt_make_directory'(+atom)
%
% makes a new directory; succeeds if the directory already exists

'$lgt_make_directory'(Directory) :-
	(	exists_directory(Directory) ->
		true
	;	make_directory(Directory)
	).


% '$lgt_directory_hashes'(+atom, -atom, -atom)
%
% returns the directory hash and dialect as an atom with the format _hash_dialect
% plus the the directory hash and PID as an atom with the format _hash_pid

'$lgt_directory_hashes'(Directory, HashDialect, HashPid) :-
	term_hash(Directory, Hash),
	'$lgt_prolog_feature'(prolog_dialect, Dialect),
	pid(PID),
	atomic_list_concat(['_', Hash, '_', Dialect], HashDialect),
	atomic_list_concat(['_', Hash, '_', PID], HashPid).


% '$lgt_compile_prolog_code'(+atom, +atom, +list)
%
% compile to disk a Prolog file, resulting from a
% Logtalk source file, given a list of flags

'$lgt_compile_prolog_code'(_, _, _).


% '$lgt_load_prolog_code'(+atom, +atom, +list)
%
% compile and load a Prolog file, resulting from a
% Logtalk source file, given a list of flags

'$lgt_load_prolog_code'(File, _Source, _Options) :-
	consult(File).


% '$lgt_load_prolog_file'(+atom)
%
% compile and (re)load a Prolog file (used in standards compliance tests)

'$lgt_load_prolog_file'(File) :-
	consult(File).


% '$lgt_file_modification_time'(+atom, -nonvar)
%
% gets a file modification time, assumed to be an opaque term but comparable

'$lgt_file_modification_time'(File, Time) :-
	time_file(File, Time).


% '$lgt_environment_variable'(?atom, ?atom)
%
% access to operating-system environment variables

'$lgt_environment_variable'(Variable, Value) :-
	getenv(Variable, Value).


% '$lgt_decompose_file_name'(+atom, ?atom, ?atom, ?atom)
%
% decomposes a file path in its components; the directory must always end
% with a slash; the extension must start with a "." when defined and must
% be the empty atom when it does not exist

'$lgt_decompose_file_name'(File, Directory, Name, Extension) :-
	atom_codes(File, FileCodes),
	(	'$lgt_strrch'(FileCodes, 0'/, [_Slash| BasenameCodes]) ->
		atom_codes(Basename, BasenameCodes),
		atom_concat(Directory, Basename, File)
	;	Directory = './',
		atom_codes(Basename, FileCodes),
		BasenameCodes = FileCodes
	),
	(	'$lgt_strrch'(BasenameCodes, 0'., ExtensionCodes) ->
		atom_codes(Extension, ExtensionCodes),
		atom_concat(Name, Extension, Basename)
	;	Name = Basename,
		Extension = ''
	).


% the following auxiliary predicate is simplified version of code
% written by Per Mildner and is used here with permission
'$lgt_strrch'(Xs, G, Ys) :-
	Xs = [X| Xs1],
	(	X == G ->
		'$lgt_strrch1'(Xs1, G, Xs, Ys)
	;	'$lgt_strrch'(Xs1, G, Ys)
	).

'$lgt_strrch1'([], _G, Ys, Ys).
'$lgt_strrch1'([X| Xs1], G, Prev, Ys) :-
	(	X == G ->
		'$lgt_strrch1'(Xs1, G, [X| Xs1], Ys)
	;	'$lgt_strrch1'(Xs1, G, Prev, Ys)
	).


% '$lgt_directory_files'(+atom, -list(atom))
%
% returns a list of files in the given directory

'$lgt_directory_files'(Directory, Files) :-
	directory_files(Directory, Files).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  getting stream current line number
%  (needed for improved compiler error messages)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_stream_current_line_number'(@stream, -integer)

'$lgt_stream_current_line_number'(Stream, Line) :-
	stream_property(Stream, line_count(Line)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  abstraction of the standard open/4 and close/1 predicates for dealing
%  with required proprietary actions when opening and closing streams
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_open'(+atom, +atom, -stream, @list)

'$lgt_open'(File, Mode, Stream, Options) :-
	open(File, Mode, Stream, Options).


% '$lgt_close'(@stream)

'$lgt_close'(Stream) :-
	close(Stream).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  customized version of the read_term/3 predicate for returning the term
%  position (start and end lines; needed for improved error messages) due
%  to the lack of a standard option for this purpose
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_read_term'(@stream, -term, +list, -pair(integer,integer))

'$lgt_read_term'(Stream, Term, Options, LineBegin-LineEnd) :-
	read_term(Stream, Term, [line_counts(LineBegin,LineEnd)| Options]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Prolog dialect specific term and goal expansion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_term_expansion'(@callable, -callable)

'$lgt_prolog_term_expansion'((:- Directive), Expanded) :-
	nonvar(Directive),
	% allow first-argument indexing
	catch('$lgt_trealla_directive_expansion'(Directive, Expanded), _, fail).

'$lgt_trealla_directive_expansion'(use_module(File), (:- use_module(Module, Imports))) :-
	File \= [_| _],
	% not the Logtalk use_module/1 directive
	logtalk_load_context(entity_type, module),
	% we're compiling a module as an object;
	% assume referenced modules are also compiled as objects
	!,
	'$lgt_trealla_list_of_exports'(File, Module, Imports).

'$lgt_trealla_directive_expansion'(use_module(File), [{:- use_module(File)}, (:- use_module(Module, Imports))]) :-
	File \= [_| _],
	% not the Logtalk use_module/1 directive
	logtalk_load_context(entity_type, _),
	% object or category using a Prolog module
	'$lgt_trealla_list_of_exports'(File, Module, Imports),
	use_module(File).

'$lgt_trealla_list_of_exports'(File, Module, Exports) :-
	logtalk_load_context(directory, Directory),
	(	'$lgt_file_extension'(prolog, Extension)
	;	'$lgt_file_extension'(logtalk, Extension)
	),
	atom_concat(File, Extension, Basename),
	absolute_file_name(Basename, Path, [relative_to(Directory)]),
	exists_file(Path),
	open(Path, read, In),
	setup_call_cleanup(true, read(In, (:- module(Module, Exports))), close(In)),
	!.


% '$lgt_prolog_goal_expansion'(@callable, -callable)

'$lgt_prolog_goal_expansion'(_, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  converts between Prolog stream encoding names and XML encoding names
%  (only necessary for Prolog compilers supporting different text encodings;
%  for others simply provide a dummy definition that always fail)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_logtalk_prolog_encoding'(?atom, ?atom, +stream)

'$lgt_logtalk_prolog_encoding'('UTF-8', 'UTF-8', _).
'$lgt_logtalk_prolog_encoding'('US-ASCII', 'US-ASCII', _).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  lambda expressions support predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_copy_term_without_constraints'(@term, ?term)

'$lgt_copy_term_without_constraints'(Term, Copy) :-
	copy_term_nat(Term, Copy).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  hooks predicates for writing and asserting compiled entity terms
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_write_compiled_term'(@stream, @callable, +atom, +atom, +integer)
%
% the third argument is the term type: runtime (internal runtime clause),
% user (compiled user-defined term), or aux (auxiliary clause resulting
% e.g. from term-expansion)

'$lgt_write_compiled_term'(Stream, Term, _Kind, _Path, _Line) :-
	write_canonical(Stream, Term),
	write(Stream, '.\n').


% '$lgt_assertz_entity_clause'(@clause, +atom)

'$lgt_assertz_entity_clause'(Clause, _Kind) :-
	assertz(Clause).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  error term normalization (when exception terms don't follow the ISO
%  Prolog standard)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_normalize_error_term'(@callable, -callable)

'$lgt_normalize_error_term'(
	Error,
	Error
).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  message token printing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%:- multifile('$logtalk#0.print_message_token#4'/5).
%:- dynamic('$logtalk#0.print_message_token#4'/5).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  term hashing (not currently used in the compiler/runtime)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% term_hash(@callable, +integer, +integer, -integer)

term_hash(_, _, _, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  atomics concat (not currently used in the compiler/runtime)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% atomic_concat(+atomic, +atomic, ?atom) -- built-in


% atomic_list_concat(@list(atomic), ?atom) -- built-in


% atomic_list_concat(@list(atomic), +atom, ?atom) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  string built-in type
%
%  define these predicates to trivially fail if no string type is available
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_string'(@term)

'$lgt_string'(_) :-
	fail.


% '$lgt_string_codes'(+string, -list(codes))
% '$lgt_string_codes'(-string, +list(codes))

'$lgt_string_codes'(_, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  module qualification to be used when calling Prolog meta-predicates
%  with meta-arguments that are calls to object or category predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_user_module_qualification'(@callable, -callable)

'$lgt_user_module_qualification'(Goal, Goal).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  auxiliary predicates for compiling modules as objects
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_find_module_predicate'(+atom, -atom, @callable)
%
% succeeds when Module:Predicate is visible in module Current

'$lgt_find_visible_module_predicate'(_Current, _Module, _Predicate) :-
	fail.


% '$lgt_current_module_predicate'(+atom, +predicate_indicator)
%
% succeeds when Module defines Predicate

'$lgt_current_module_predicate'(Module, Predicate) :-
	Module:current_predicate(Predicate).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  shortcuts to the Logtalk built-in predicates logtalk_load/1 and
%  logtalk_make/1
%
%  defined in the adapter files to make it easier to comment them out in case
%  of conflict with some Prolog native feature; they require conformance with
%  the ISO Prolog standard regarding the definition of the {}/1 syntax
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


{X} :-
	var(X),
	throw(error(instantiation_error, logtalk({X}, _))).
{*} :-
	!,
	logtalk_make(all).
{!} :-
	!,
	logtalk_make(clean).
{?} :-
	!,
	logtalk_make(check).
{@} :-
	!,
	logtalk_make(circular).
{#} :-
	!,
	logtalk_make(documentation).
{+d} :-
	!,
	logtalk_make(debug).
{+n} :-
	!,
	logtalk_make(normal).
{+o} :-
	!,
	logtalk_make(optimal).
{$} :-
	!,
	logtalk_make(caches).

{Files} :-
	'$lgt_conjunction_to_list'(Files, List),
	logtalk_load(List).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  end!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
