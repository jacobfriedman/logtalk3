%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Adapter file for Ciao Prolog 1.22.0
%  Last updated on November 15, 2024
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


:- use_package(iso_strict).

:- set_prolog_flag(multi_arity_warnings, off).

:- op(1200, xfx, (-->)).
:- op(600,  xfy, (:)).



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

'$lgt_iso_predicate'(_) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  de facto standard Prolog predicates that might be missing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% between(+integer, +integer, ?integer)

:- use_module(library(between), [between/3]).


% findall(?term, +callable, ?list, +list)

:- use_module(library(aggregates)).


% forall(+callable, +callable) -- provided by the "iso" package


% format(+stream_or_alias, +character_code_list_or_atom, +list)
% format(+character_code_list_or_atom, +list)

:- use_module(library(format)).

'$lgt_format'(Stream, Format, Arguments) :-
	format(Stream, Format, Arguments).

'$lgt_format'(Format, Arguments) :-
	format(Format, Arguments).


% numbervars(?term, +integer, ?integer)

:- use_module(library(write), [numbervars/3]).



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

'$lgt_predicate_property'(Pred, built_in) :-
	'$lgt_iso_spec_predicate'(Pred).

'$lgt_predicate_property'(Pred, static) :-
	predicate_property(Pred, compiled).

'$lgt_predicate_property'(Pred, static) :-
	functor(Pred, Functor, Arity),
	atom_concat('user:', Functor, Functor2),
	functor(Pred2, Functor2, Arity),
	predicate_property(Pred2, compiled).

'$lgt_predicate_property'(Pred, Prop) :-
	predicate_property(Pred, Prop).

'$lgt_predicate_property'(Pred, Prop) :-
	functor(Pred, Functor, Arity),
	atom_concat('user:', Functor, Functor2),
	functor(Pred2, Functor2, Arity),
	predicate_property(Pred2, Prop).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  meta-predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% setup_call_cleanup(+callable, +callable, +callable) -- not supported



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

'$lgt_prolog_meta_predicate'(if(_, _, _), if(0, 0, 0), predicate).


% '$lgt_prolog_meta_directive'(@callable, -callable)

'$lgt_prolog_meta_directive'(data(_), data(/)).
'$lgt_prolog_meta_directive'(prop(_), prop(/)).


% '$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(@nonvar, -atom)

'$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(Spec, *) :-
	var(Spec),
	!.
'$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(goal, 0).
'$lgt_prolog_to_logtalk_meta_argument_specifier_hook'(pred(N), M) :-
	M is N - 1.


% '$lgt_prolog_phrase_predicate'(@callable)
%
% table of predicates that call non-terminals
% (other than the de facto standard phrase/2-3 predicates)

'$lgt_prolog_phrase_predicate'(_) :-
	fail.


% '$lgt_candidate_tautology_or_falsehood_goal_hook'(@callable)
%
% valid candidates are proprietary built-in predicates with no
% side-effects when called with ground arguments

'$lgt_candidate_tautology_or_falsehood_goal_hook'(_) :-
	fail.


% '$lgt_prolog_database_predicate'(@callable)
%
% table of non-standard database built-in predicates

'$lgt_prolog_database_predicate'(assert(_)).
'$lgt_prolog_database_predicate'(assert(_, _)).
'$lgt_prolog_database_predicate'(asserta(_, _)).
'$lgt_prolog_database_predicate'(assertz(_, _)).
'$lgt_prolog_database_predicate'(clause(_, _, _)).


% '$lgt_prolog_predicate_property'(?callable)
%
% table of proprietary predicate properties; used by the
% compiler when checking if a predicate property is valid

'$lgt_prolog_predicate_property'(compiled).
'$lgt_prolog_predicate_property'(interpreted).


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
'$lgt_file_extension'(tmp, '.itf').
'$lgt_file_extension'(tmp, '.po').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  backend Prolog compiler features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_feature'(?atom, ?atom)
%
% backend Prolog compiler supported features (that are compatible with Logtalk)

'$lgt_prolog_feature'(prolog_dialect, ciao).
'$lgt_prolog_feature'(prolog_version, v(Major, Minor, Patch)) :-
	current_prolog_flag(version_data, ciao(Major, Minor, Patch, _)).
'$lgt_prolog_feature'(prolog_compatible_version, @>=(v(1,22,0))).

'$lgt_prolog_feature'(encoding_directive, unsupported).
'$lgt_prolog_feature'(tabling, supported).
'$lgt_prolog_feature'(engines, unsupported).
'$lgt_prolog_feature'(threads, unsupported).
'$lgt_prolog_feature'(modules, supported).
'$lgt_prolog_feature'(coinduction, unsupported).
'$lgt_prolog_feature'(unicode, unsupported).



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
'$lgt_default_flag'(scratch_directory, ScratchDirectory) :-
	(	using_windows ->
		ScratchDirectory = './lgt_tmp/'
	;	ScratchDirectory = './.lgt_tmp/'
	).
'$lgt_default_flag'(report, on).
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
	absolute_file_name(Path, ExpandedPath).


% '$lgt_file_exists'(+atom)
%
% checks if a file exists

'$lgt_file_exists'(File) :-
	file_exists(File),
	file_property(File, type(regular)).


% '$lgt_delete_file'(+atom)
%
% deletes a file

'$lgt_delete_file'(File) :-
	delete_file(File).


% '$lgt_directory_exists'(+atom)
%
% checks if a directory exists

'$lgt_directory_exists'(Directory) :-
	file_exists(Directory),
	file_property(Directory, type(directory)).


% '$lgt_current_directory'(-atom)
%
% gets current working directory

'$lgt_current_directory'(Directory) :-
	working_directory(Directory, Directory).


% '$lgt_change_directory'(+atom)
%
% changes current working directory

'$lgt_change_directory'(Directory) :-
	cd(Directory).


% '$lgt_make_directory'(+atom)
%
% makes a new directory; succeeds if the directory already exists

'$lgt_make_directory'(Directory) :-
	(	file_exists(Directory) ->
		true
	;	make_directory(Directory)
	).


% '$lgt_directory_hashes'(+atom, -atom, -atom)
%
% returns the directory hash and dialect as an atom with the format _hash_dialect
% plus the the directory hash and PID as an atom with the format _hash_pid

:- use_module(library(indexer/hash), [hash_term/2]).
:- use_module(library(lists), [append/3]).

'$lgt_directory_hashes'(Directory, HashDialect, HashPid) :-
	hash_term(Directory, Hash),
	'$lgt_prolog_feature'(prolog_dialect, Dialect),
	get_pid(PID),
	number_codes(Hash, HashCodes),
	atom_codes(Dialect, DialectCodes),
	append([0'_| HashCodes], [0'_| DialectCodes], HashDialectCodes),
	atom_codes(HashDialect, HashDialectCodes),
	number_codes(PID, PIDCodes),
	append([0'_| HashCodes], [0'_| PIDCodes], HashPidCodes),
	atom_codes(HashPid, HashPidCodes).


% '$lgt_compile_prolog_code'(+atom, +atom, +list)
%
% compile to disk a Prolog file, resulting from a
% Logtalk source file, given a list of flags

'$lgt_compile_prolog_code'(_, _, _).


% '$lgt_load_prolog_code'(+atom, +atom, +list)
%
% compile and load a Prolog file, resulting from a
% Logtalk source file, given a list of flags

'$lgt_load_prolog_code'(File, _, _) :-
	set_prolog_flag(multi_arity_warnings, off),
	ensure_loaded(File).


% '$lgt_load_prolog_file'(+atom)
%
% compile and (re)load a Prolog file (used in standards compliance tests)

'$lgt_load_prolog_file'(File) :-
	ensure_loaded(File).


% '$lgt_file_modification_time'(+atom, -nonvar)
%
% gets a file modification time, assumed to be an opaque term but comparable

'$lgt_file_modification_time'(File, Time) :-
	file_property(File, mod_time(Time)).


% '$lgt_environment_variable'(?atom, ?atom)
%
% access to operating-system environment variables

'$lgt_environment_variable'(Variable, Value) :-
	getenvstr(Variable, String),
	atom_codes(Value, String).


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
	line_count(Stream, Last),
	Line is Last + 1.



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
	read_term(Stream, Term, [lines(LineBegin,LineEnd)| Options]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Prolog dialect specific term and goal expansion
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_prolog_term_expansion'(@callable, -callable)

'$lgt_prolog_term_expansion'((:- Directive), Expanded) :-
	nonvar(Directive),
	% allow first-argument indexing
	catch('$lgt_ciao_directive_expansion'(Directive, Expanded), _, fail).


'$lgt_ciao_directive_expansion'(imports(Module, Imports), (:- use_module(Module, Imports))).
'$lgt_ciao_directive_expansion'(meta_predicate(Template), (:- meta_predicate(CTemplate))) :-
	logtalk_load_context(entity_type, _),
	'$lgt_ciao_directive_meta_predicate'(Template, CTemplate).
'$lgt_ciao_directive_expansion'(module(Module, Exports, []), module(Module, Exports)) :-
	(	var(Module) ->		% module name taken from file name
		'$lgt_ciao_find_module_name'(Module)
	;	true
	).
'$lgt_ciao_directive_expansion'(module(Module, Exports, [assertions]), (:- module(Module, Exports))) :-
	(	var(Module) ->		% module name taken from file name
		'$lgt_ciao_find_module_name'(Module)
	;	true
	).
'$lgt_ciao_directive_expansion'(table(Predicates), [{:- use_package(tabling)}, {:- table(TPredicates)}]) :-
	logtalk_load_context(entity_type, _),
	'$lgt_ciao_table_directive_expansion'(Predicates, TPredicates).


'$lgt_ciao_find_module_name'(Module) :-
	stream_property(Stream, mode(read)),
	stream_property(Stream, file_name(Path)),
	no_path_file_name(Path, File),
	extension(File, '.lgt'),
	basename(File, Module),
	!.


'$lgt_ciao_directive_meta_predicate'(Template, CTemplate) :-
	functor(Template, Functor, Arity),
	'$lgt_compile_predicate_indicators'(Functor/Arity, _, CFunctor/_),
	Template =.. [Functor| Args],
	'$lgt_ciao_directive_meta_predicate_args'(Args, CArgs),
	CTemplate =.. [CFunctor| CArgs].

'$lgt_ciao_directive_meta_predicate_args'([], []).
'$lgt_ciao_directive_meta_predicate_args'([Arg| Args], [CArg| CArgs]) :-
	'$lgt_ciao_directive_meta_predicate_arg'(Arg, CArg),
	'$lgt_ciao_directive_meta_predicate_args'(Args, CArgs).

'$lgt_ciao_directive_meta_predicate_arg'(clause, ::).
'$lgt_ciao_directive_meta_predicate_arg'(fact, ::).
'$lgt_ciao_directive_meta_predicate_arg'(goal, 0).
'$lgt_ciao_directive_meta_predicate_arg'(+, *).
'$lgt_ciao_directive_meta_predicate_arg'(?, *).
'$lgt_ciao_directive_meta_predicate_arg'(-, *).


'$lgt_ciao_table_directive_expansion'([Predicate| Predicates], [TPredicate| TPredicates]) :-
	!,
	'$lgt_ciao_table_directive_predicate'(Predicate, TPredicate),
	'$lgt_ciao_table_directive_expansion'(Predicates, TPredicates).
'$lgt_ciao_table_directive_expansion'((Predicate, Predicates), (TPredicate, TPredicates)) :-
	!,
	'$lgt_ciao_table_directive_predicate'(Predicate, TPredicate),
	'$lgt_ciao_table_directive_expansion'(Predicates, TPredicates).
'$lgt_ciao_table_directive_expansion'(Predicate, TPredicate) :-
	'$lgt_ciao_table_directive_predicate'(Predicate, TPredicate).

'$lgt_ciao_table_directive_predicate'(F/A, TF/TA) :-
	'$lgt_compile_predicate_indicators'(F/A, _, TF/TA).
'$lgt_ciao_table_directive_predicate'(F//A, TF/TA) :-
	A2 is A + 2,
	'$lgt_compile_predicate_indicators'(F/A2, _, TF/TA).


% '$lgt_prolog_goal_expansion'(@callable, -callable)

'$lgt_prolog_goal_expansion'(_, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  converts between Prolog stream encoding names and XML encoding names
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_logtalk_prolog_encoding'(?atom, ?atom, +stream)

'$lgt_logtalk_prolog_encoding'(_, _, _) :-
	fail.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  lambda expressions support predicates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% '$lgt_copy_term_without_constraints'(@term, ?term)

'$lgt_copy_term_without_constraints'(Term, Copy) :-
	copy_term(Term, Copy).



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
		error(existence_error(procedure, ModFunctor/Arity), _),
		error(existence_error(procedure, Functor/Arity), _)
	) :-
	atom_concat('user:', Functor, ModFunctor).



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


% term_hash(@callable, +integer, +integer, -integer) -- built-in



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  atomics concat (not currently used in the compiler/runtime)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% atomic_concat(+atomic, +atomic, ?atom)

atomic_concat(Atomic1, Atomic2, Atom) :-
	(	var(Atomic1) ->
		throw(error(instantiation_error, atomic_concat(Atomic1, Atomic2, Concat)))
	;	var(Atomic2) ->
		throw(error(instantiation_error, atomic_concat(Atomic1, Atomic2, Concat)))
	;	\+ atomic(Atomic1) ->
		throw(error(type_error(atomic, Atomic1), atomic_concat(Atomic1, Atomic2, Concat)))
	;	\+ atomic(Atomic2) ->
		throw(error(type_error(atomic, Atomic2), atomic_concat(Atomic1, Atomic2, Concat)))
	;	'$lgt_ciao_atomic_atom'(Atomic1, Atom1),
		'$lgt_ciao_atomic_atom'(Atomic2, Atom2),
		atom_concat(Atom1, Atom2, Atom)
	).

'$lgt_ciao_atomic_atom'(Atomic, Atom) :-
	(	atom(Atomic) ->
		Atom = Atomic
	;	atom_number(Atom, Atomic)
	).


% atomic_list_concat(@list(atomic), ?atom)

atomic_list_concat([Atomic| Atomics], Atom) :-
	!,
	(	var(Atomic) ->
		throw(error(instantiation_error, atomic_list_concat/2))
	;	\+ atomic(Atomic) ->
		throw(error(type_error(atomic, Atomic), atomic_list_concat/2))
	;	'$lgt_ciao_atomic_atom'(Atomic, Atom0),
		'$lgt_ciao_atomic_list_concat'(Atomics, Atom0, Atom)
	).
atomic_list_concat([], '').

'$lgt_ciao_atomic_list_concat'([Next| Atomics], Atom0, Atom) :-
	!,
	atomic_list_concat([Next| Atomics], Atom1),
	atom_concat(Atom0, Atom1, Atom).
'$lgt_ciao_atomic_list_concat'([], Atom, Atom).


% atomic_list_concat(@list(atomic), +atom, ?atom)

atomic_list_concat([Atomic| Atomics], Separator, Atom) :-
	!,
	(	var(Atomic) ->
		throw(error(instantiation_error, atomic_list_concat/3))
	;	var(Separator) ->
		throw(error(instantiation_error, atomic_list_concat/3))
	;	\+ atomic(Atomic) ->
		throw(error(type_error(atomic, Atomic), atomic_list_concat/3))
	;	\+ atomic(Separator) ->
		throw(error(type_error(atomic, Separator), atomic_list_concat/3))
	;	'$lgt_ciao_atomic_atom'(Atomic, Atom0),
		'$lgt_ciao_atomic_atom'(Separator, SeparatorAtom),
		'$lgt_ciao_atomic_list_concat'(Atomics, Atom0, SeparatorAtom, Atom)
	).
atomic_list_concat([], _, '').

'$lgt_ciao_atomic_list_concat'([Next| Atomics], Atom0, SeparatorAtom, Atom) :-
	!,
	atomic_list_concat([Next| Atomics], SeparatorAtom, Atom2),
	atom_concat(SeparatorAtom, Atom2, Atom1),
	atom_concat(Atom0, Atom1, Atom).
'$lgt_ciao_atomic_list_concat'([], Atom, _, Atom).



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

'$lgt_user_module_qualification'(Goal, user:Goal).



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
	current_predicate(Module:Predicate).



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
