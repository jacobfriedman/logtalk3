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


:- object(directory_load_diagram(Format),
	imports(directory_diagram(Format))).

	:- info([
		version is 3:0:1,
		author is 'Paulo Moura',
		date is 2024-04-01,
		comment is 'Predicates for generating directory loading dependency diagrams.',
		parameters is ['Format' - 'Graph language file format.'],
		see_also is [directory_dependency_diagram(_), file_dependency_diagram(_), library_dependency_diagram(_)]
	]).

	:- uses(list, [
		member/2
	]).

	:- private(sub_diagram_/2).
	:- dynamic(sub_diagram_/2).
	:- mode(sub_diagram_(?atom, ?atom), zero_or_more).
	:- info(sub_diagram_/2, [
		comment is 'Table of directory sub-diagrams to support their generation.',
		argnames is ['Project', 'Directory']
	]).

	% first, output the directory node if it loads files
	output_library(Project, Directory, Options) :-
		^^add_link_options(Directory, Options, LinkingOptions),
		^^omit_path_prefix(Directory, Options, Relative),
		once((
			logtalk::loaded_file_property(_, directory(Directory))
		;	modules_diagram_support::loaded_file_property(_, directory(Directory))
		)),
		parameter(1, Format),
		file_load_diagram(Format)::diagram_name_suffix(Suffix),
		^^add_node_zoom_option(Project, Suffix, LinkingOptions, NodeOptions),
		assertz(sub_diagram_(Project, Directory)),
		^^output_node(Directory, Relative, directory, [], directory, NodeOptions),
		^^remember_included_directory(Directory),
		fail.
	% second, output edges for all directories loaded by files in this directory
	output_library(_, Directory, Options) :-
		^^option(exclude_directories(ExcludedDirectories), Options),
		% any Logtalk or Prolog directory file may load other files
		(	logtalk::loaded_file_property(File, directory(Directory))
		;	modules_diagram_support::loaded_file_property(File, directory(Directory))
		),
		% look for a file in another directory that have this file as parent
		(	logtalk::loaded_file_property(Other, parent(File)),
			logtalk::loaded_file_property(Other, directory(OtherDirectory)),
			OtherDirectory \== Directory
		;	modules_diagram_support::loaded_file_property(Other, parent(File)),
			modules_diagram_support::loaded_file_property(Other, directory(OtherDirectory)),
			OtherDirectory \== Directory,
			% not a Logtalk generated intermediate Prolog file
			\+ logtalk::loaded_file_property(_, target(Other))
		),
		\+ (
			member(ExcludedDirectory, ExcludedDirectories),
			sub_atom(OtherDirectory, 0, _, _, ExcludedDirectory)
		),
		% edge not previously recorded
		\+ ^^edge(Directory, OtherDirectory, _, _, _),
		(	logtalk::loaded_file_property(Other, directory(OtherDirectory)) ->
			^^remember_referenced_logtalk_directory(OtherDirectory)
		;	% Prolog directory module
			^^remember_referenced_prolog_directory(OtherDirectory)
		),
		^^save_edge(Directory, OtherDirectory, [loads], loads_directory, [tooltip(loads)| Options]),
		fail.
	output_library(_, _, _).

	output_sub_diagrams(Options) :-
		parameter(1, Format),
		^^option(zoom(true), Options),
		file_dependency_diagram(Format)::default_option(layout(Layout)),
		sub_diagram_(Project, Directory),
		file_load_diagram(Format)::directory(Project, Directory, [layout(Layout)| Options]),
		fail.
	output_sub_diagrams(_).

	reset :-
		^^reset,
		retractall(sub_diagram_(_, _)).

	% by default, diagram layout is top to bottom:
	default_option(layout(top_to_bottom)).
	% by default, diagram title is empty:
	default_option(title('')).
	% by default, print current date:
	default_option(date(true)).
	% by default, don't print Logtalk and backend version data:
	default_option(versions(false)).
	% by default, don't omit any prefix when printing paths:
	default_option(omit_path_prefixes(Prefixes)) :-
		(	logtalk::expand_library_path(home, Home) ->
			Prefixes = [Home]
		;	Prefixes = []
		).
	% by default, don't print directory paths:
	default_option(directory_paths(false)).
	% by default, print relation labels:
	default_option(relation_labels(true)).
	% by default, print external nodes:
	default_option(externals(true)).
	% by default, print node type captions:
	default_option(node_type_captions(true)).
	% by default, write diagram to the current directory:
	default_option(output_directory('./dot_dias')).
	% by default, don't exclude any directories:
	default_option(exclude_directories([])).
	% by default, don't exclude any source files:
	default_option(exclude_files([])).
	% by default, don't link to sub-diagrams:
	default_option(zoom(false)).
	% by default, use a '.svg' extension for linked diagrams
	default_option(zoom_url_suffix('.svg')).

	diagram_description('Directory load diagram').

	diagram_name_suffix('_directory_load_diagram').

	message_diagram_description('directory load').

:- end_object.



:- object(directory_load_diagram,
	extends(directory_load_diagram(dot))).

	:- info([
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2019-04-07,
		comment is 'Predicates for generating directory loading dependency diagrams in DOT format.',
		see_also is [directory_dependency_diagram, file_dependency_diagram]
	]).

:- end_object.
