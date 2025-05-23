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


:- object(random,
	implements((pseudo_random_protocol, sampling_protocol))).

	:- info([
		version is 2:12:1,
		author is 'Paulo Moura',
		date is 2025-04-07,
		comment is 'Portable random number generator predicates. Core predicates originally written by Richard O''Keefe. Based on algorithm AS 183 from Applied Statistics.',
		remarks is [
			'Multiple random number generators' - 'To define multiple random number generators, simply extend this object. The derived objects must send to *self* the ``reset_seed/0`` message.',
			'Randomness' - 'Loading this object always initializes the random generator seed to the same value, thus providing a pseudo random number generator. The ``randomize/1`` predicate can be used to initialize the seed with a random value.'
		],
		see_also is [fast_random, backend_random]
	]).

	:- public(reset_seed/0).
	:- mode(reset_seed, one).
	:- info(reset_seed/0, [
		comment is 'Resets the random generator seed to its default value. Use ``get_seed/1`` and ``set_seed/1`` instead if you need reproducibility.'
	]).

	:- public(randomize/1).
	:- mode(randomize(+positive_integer), one).
	:- info(randomize/1, [
		comment is 'Randomizes the random generator using a positive integer to compute a new seed. Use of a large integer is recommended. In alternative, when using a small integer argument, discard the first dozen random values.',
		argnames is ['Seed']
	]).

	:- uses(list, [
		length/2, nth1/3
	]).

	:- if(current_logtalk_flag(threads, supported)).
		:- synchronized([
			random/1, random/3,
			sequence/4, set/4, permutation/2,
			randseq/4, randset/4,
			reset_seed/0, get_seed/1, set_seed/1, randomize/1
		]).
	:- endif.

	:- initialization(::reset_seed).

	:- private(seed_/3).
	:- dynamic(seed_/3).
	:- mode(seed_(-integer, -integer, -integer), one).
	:- info(seed_/3, [
		comment is 'Stores the current random generator seed values.',
		argnames is ['S0', 'S1', 'S2']
	]).

	random(Random) :-
		::retract(seed_(A0, A1, A2)),
		random(A0, A1, A2, B0, B1, B2, Random),
		::asserta(seed_(B0, B1, B2)).

	random(A0, A1, A2, B0, B1, B2, Random) :-
		B0 is (A0*171) mod 30269,
		B1 is (A1*172) mod 30307,
		B2 is (A2*170) mod 30323,
		% as some Prolog backends may return Float as an integer or a rational
		% number, we explicitly convert the value into a float in the next goal
		Float is A0/30269 + A1/30307 + A2/30323,
		Random is float(Float) - truncate(Float).

	between(Lower, Upper, Random) :-
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		random(Float),
		Random is truncate(Float * (Upper - Lower + 1)) + Lower.

	member(Random, List) :-
		length(List, Length),
		random(Float),
		Index is truncate(Float*Length+1),
		nth1(Index, List, Random).

	select(Random, List, Rest) :-
		length(List, Length),
		random(Float),
		Index is truncate(Float*Length+1),
		select(1, Index, Random, List, Rest).

	select(Index, Index, Random, [Random| Rest], Rest) :-
		!.
	select(Current, Index, Random, [Head| Tail], [Head| Rest]) :-
		Next is Current + 1,
		select(Next, Index, Random, Tail, Rest).

	select(Random, List, New, Rest) :-
		length(List, Length),
		random(Float),
		Index is truncate(Float*Length+1),
		select(1, Index, Random, List, New, Rest).

	select(Index, Index, Random, [Random| Tail], New, [New| Tail]) :-
		!.
	select(Current, Index, Random, [Head| OldTail], New, [Head| NewTail]) :-
		Next is Current + 1,
		select(Next, Index, Random, OldTail, New, NewTail).

	swap(List, Mutation) :-
		length(List, Length),
		Length > 1,
		repeat,
			between(1, Length, N1),
			between(1, Length, N2),
		N1 =\= N2,
		!,
		(	N1 < N2 ->
			swap_1(N1, N2, List, Mutation)
		;	swap_1(N2, N1, List, Mutation)
		).

	swap_1(1, N2, [Element1| Rest0], [Element2| Rest]) :-
		!,
		swap_2(N2, Element1, Element2, Rest0, Rest).
	swap_1(N1, N2, [Head| Tail], [Head| Mutation]) :-
		M1 is N1 - 1,
		M2 is N2 - 1,
		swap_1(M1, M2, Tail, Mutation).

	swap_2(2, Element1, Element2, [Element2| Rest], [Element1| Rest]) :-
		!.
	swap_2(N2, Element1, Element2, [Head| Rest0], [Head| Rest]) :-
		M is N2 - 1,
		swap_2(M, Element1, Element2, Rest0, Rest).

	swap_consecutive(List, Mutation) :-
		length(List, Length),
		Limit is Length - 1,
		between(1, Limit, N),
		swap_consecutive(N, List, Mutation).

	swap_consecutive(1, [Element1, Element2| Rest], [Element2, Element1| Rest]) :-
		!.
	swap_consecutive(N, [Head| Tail], [Head| Mutation]) :-
		M is N - 1,
		swap_consecutive(M, Tail, Mutation).

	enumerate(List, Random) :-
		permutation(List, Permutation),
		list::member(Random, Permutation).

	sequence(Length, Lower, Upper, Sequence) :-
		integer(Length),
		Length >= 0,
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		::retract(seed_(A0, A1, A2)),
		sequence(Length, Lower, Upper, A0, A1, A2, B0, B1, B2, Sequence),
		::asserta(seed_(B0, B1, B2)).

	sequence(0, _, _, S0, S1, S2, S0, S1, S2, []) :-
		!.
	sequence(N, Lower, Upper, A0, A1, A2, S0, S1, S2, [Random| Sequence]) :-
		N2 is N - 1,
		random(A0, A1, A2, B0, B1, B2, Float),
		Random is truncate(Float * (Upper - Lower + 1)) + Lower,
		sequence(N2, Lower, Upper, B0, B1, B2, S0, S1, S2, Sequence).

	set(Length, Lower, Upper, Set) :-
		integer(Length),
		Length >= 0,
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		Length =< Upper - Lower + 1,
		::retract(seed_(A0, A1, A2)),
		set(Length, Lower, Upper, A0, A1, A2, B0, B1, B2, [], Set),
		::asserta(seed_(B0, B1, B2)).

	set(0, _, _, S0, S1, S2, S0, S1, S2, List, Set) :-
		!,
		sort(List, Set).
	set(N, Lower, Upper, A0, A1, A2, S0, S1, S2, Acc, Set) :-
		random(A0, A1, A2, B0, B1, B2, Float),
		Random is truncate(Float * (Upper - Lower + 1)) + Lower,
		(	not_member(Acc, Random) ->
			N2 is N - 1,
			set(N2, Lower, Upper, B0, B1, B2, S0, S1, S2, [Random| Acc], Set)
		;	set(N, Lower, Upper, B0, B1, B2, S0, S1, S2, Acc, Set)
		).

	permutation(List, Permutation) :-
		::retract(seed_(A0, A1, A2)),
		add_random_key(List, A0, A1, A2, B0, B1, B2, KeyList),
		::asserta(seed_(B0, B1, B2)),
		keysort(KeyList, SortedKeyList),
		remove_random_key(SortedKeyList, Permutation).

	add_random_key([], S0, S1, S2, S0, S1, S2, []).
	add_random_key([Head| Tail], A0, A1, A2, S0, S1, S2, [Random-Head| KeyTail]) :-
		random(A0, A1, A2, B0, B1, B2, Random),
		add_random_key(Tail, B0, B1, B2, S0, S1, S2, KeyTail).

	remove_random_key([], []).
	remove_random_key([_-Head| KeyTail], [Head| Tail]) :-
		remove_random_key(KeyTail, Tail).

	random(Lower, Upper, Random) :-
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		!,
		random(Float),
		Random is truncate((Float * (Upper - Lower) + Lower)).
	random(Lower, Upper, Random) :-
		float(Lower),
		float(Upper),
		Upper >= Lower,
		random(Float),
		Random is Float * (Upper-Lower) + Lower.

	randseq(Length, Lower, Upper, Sequence) :-
		integer(Length),
		Length >= 0,
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		!,
		::retract(seed_(A0, A1, A2)),
		randseq(Length, Lower, Upper, (A0, A1, A2), (B0, B1, B2), List),
		::asserta(seed_(B0, B1, B2)),
		map_truncate(List, Sequence).
	randseq(Length, Lower, Upper, Sequence) :-
		integer(Length),
		Length >= 0,
		float(Lower),
		float(Upper),
		Upper >= Lower,
		::retract(seed_(A0, A1, A2)),
		randseq(Length, Lower, Upper, (A0, A1, A2), (B0, B1, B2), Sequence),
		::asserta(seed_(B0, B1, B2)).

	randseq(0, _, _, Seed, Seed, []) :-
		!.
	randseq(N, Lower, Upper, (A0, A1, A2), (C0, C1, C2),  [Random| List]) :-
		N2 is N - 1,
		random(A0, A1, A2, B0, B1, B2, R),
		Random is R * (Upper-Lower)+Lower,
		randseq(N2, Lower, Upper, (B0, B1, B2), (C0, C1, C2), List).

	map_truncate([], []).
	map_truncate([Float| Floats], [Integer| Integers]) :-
		Integer is truncate(Float),
		map_truncate(Floats, Integers).

	randset(Length, Lower, Upper, Set) :-
		integer(Length),
		Length >= 0,
		integer(Lower),
		integer(Upper),
		Upper >= Lower,
		Length =< Upper - Lower,
		!,
		::retract(seed_(A0, A1, A2)),
		randset(Length, Lower, Upper, (A0, A1, A2), (B0, B1, B2), [], Set),
		::asserta(seed_(B0, B1, B2)).
	randset(Length, Lower, Upper, Set) :-
		integer(Length),
		Length >= 0,
		float(Lower),
		float(Upper),
		Upper >= Lower,
		::retract(seed_(A0, A1, A2)),
		randset(Length, Lower, Upper, (A0, A1, A2), (B0, B1, B2), [], Set),
		::asserta(seed_(B0, B1, B2)).

	randset(0, _, _, Seed, Seed, List, Set) :-
		!,
		sort(List, Set).
	randset(N, Lower, Upper, (A0, A1, A2), (C0, C1, C2), Acc, Set) :-
		random(A0, A1, A2, B0, B1, B2, Float),
		Float2 is Float * (Upper-Lower) + Lower,
		(	integer(Lower) ->
			Random is truncate(Float2)
		;	Random is Float2
		),
		(	not_member(Acc, Random) ->
			N2 is N - 1,
			randset(N2, Lower, Upper, (B0, B1, B2), (C0, C1, C2), [Random| Acc], Set)
		;	randset(N, Lower, Upper, (B0, B1, B2), (C0, C1, C2), Acc, Set)
		).

	not_member([], _).
	not_member([H| T], R) :-
		H =\= R,
		not_member(T, R).

	reset_seed :-
		::retractall(seed_(_, _, _)),
		::asserta(seed_(3172, 9814, 20125)).

	get_seed(seed(S0, S1, S2)) :-
		::seed_(S0, S1, S2).

	set_seed(seed(S0, S1, S2)) :-
		::retractall(seed_(_, _, _)),
		::asserta(seed_(S0, S1, S2)).

	randomize(Seed) :-
		integer(Seed),
		Seed > 0,
		::retractall(seed_(_, _, _)),
		S0 is Seed mod 30269,
		S1 is Seed mod 30307,
		S2 is Seed mod 30323,
		::asserta(seed_(S0, S1, S2)).

	maybe :-
		random(Random),
		Random < 0.5.

	maybe(Probability) :-
		float(Probability),
		0.0 =< Probability, Probability =< 1.0,
		random(Random),
		Random < Probability.

	maybe(K, N) :-
		integer(K), integer(N),
		0 =< K, K =< N,
		random(Float),
		Random is truncate(Float * N),
		Random < K.

	:- meta_predicate(maybe_call(0)).
	maybe_call(Goal) :-
		random(Random),
		Random < 0.5,
		once(Goal).

	:- meta_predicate(maybe_call(*, 0)).
	maybe_call(Probability, Goal) :-
		float(Probability),
		0.0 =< Probability, Probability =< 1.0,
		random(Random),
		Random < Probability,
		once(Goal).

	:- include(sampling).

:- end_object.
