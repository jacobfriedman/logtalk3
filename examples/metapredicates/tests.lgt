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


% entities for testing meta-predicates calling meta-predicates and passing
% closures corresponding to control constructs

:- object(library).

	:- public(my_call/1).
	:- meta_predicate(my_call(0)).
	my_call(Goal) :-
		call(Goal).

	:- public(my_call/2).
	:- meta_predicate(my_call(1, *)).
	my_call(Closure, Arg) :-
		call(Closure, Arg).

	:- public(self_closure/1).
	self_closure(X) :-
		my_call(::q, X).

	:- protected(q/1).
	q(library).

	a(library).

:- end_object.



:- object(extended_library,
	extends(library)).

	q(extended_library).

:- end_object.



:- object(client).

	:- public(test1/1).
	test1(L) :-
		library::my_call(setof(E, a(E), L)).

	:- public(test2/1).
	test2(L) :-
		library::my_call(setof(E, call(a, E), L)).

	:- public(test3/1).
	test3(L) :-
		library::my_call(call(setof, E, call(a, E), L)).

	a(1). a(2). a(3).

:- end_object.



:- object(parent).

	:- public(self_closure/1).
	self_closure(X) :-
		library::my_call(::q, X).

	:- protected(q/1).
	q(parent).

:- end_object.



:- object(proto,
	extends(parent)).

	:- public(super_closure/1).
	super_closure(X) :-
		library::my_call(^^q, X).

	q(proto).

:- end_object.



% entities for testing calling meta-predicates from within categories

:- category(test_category).

	:- public(p/1).
	p(Out) :-
		meta::map(double, [1,2,3], Out).

	double(X, Y) :-
		Y is 2*X.

:- end_category.



:- object(test_object,
	imports(test_category)).

	double(X, Y) :-
		Y is 3*X.

:- end_object.



% the following two objects, "m2" and "m1", implement a Logtalk version
% of a Ulrich Neumerkel example posted in the SWI-Prolog mailing list
% on December 7, 2010 on the "Should var/1 be module-aware?" thread

:- object(m2).

	:- public(p/2).
	:- meta_predicate(p(*, 1)).
	p(X, Cont) :-
		call(Cont, g(X)).

	g(m2).

:- end_object.



:- object(m1).

	:- public(r/2).
	r(X, Y) :-
		m2::p(Y, ','(g(X))).

	g(m1).

:- end_object.



:- category(ctg).

	:- private(cp1/2).
	cp1(F, L) :-
		FX =.. [F, X],
		findall(X, FX, L).

	:- private(cp2/2).
	cp2(_, L) :-
		findall(X, a(X), L).

	a(1).
	a(2).
	a(3).

:- end_category.


:- object(obj,
	imports(ctg)).

	:- public(op1d/1).
	op1d(L) :-
		^^cp1(a, L).

	:- public(op2d/1).
	op2d(L) :-
		^^cp2(a, L).

	:- public(op1s/1).
	op1s(L) :-
		::cp1(a, L).

	:- public(op2s/1).
	op2s(L) :-
		::cp2(a, L).

:- end_object.



:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:11:0,
		author is 'Parker Jones and Paulo Moura',
		date is 2023-08-06,
		comment is 'Unit tests for the "metapredicates" example.'
	]).

	:- uses(lgtunit, [
		assertion/2
	]).

	test(metapredicates_01, true(Sorted == [1, 2, 3, 4, 9])) :-
		^^suppress_text_output,
		sort(user)::sort([3,1,4,2,9], Sorted).

	test(metapredicates_02, true(Included-Excluded == [2, 4]-[1, 3, 5])) :-
		meta::partition(user::even_integer, [1,2,3,4,5], Included, Excluded).

	test(metapredicates_03, true(Result == 34)) :-
		meta::fold_left(user::sum_squares, 0, [1,2,3], Result).

	test(metapredicates_04, true(Result == 'PREFIXabcdefghi')) :-
		meta::fold_left(atom_concat, 'PREFIX', [abc,def,ghi], Result).

	test(metapredicates_05, true(Result == abcdefghiSUFIX)) :-
		meta::fold_right(atom_concat, 'SUFIX', [abc,def,ghi], Result).

	test(metapredicates_06, true(Result == 15)) :-
		meta::fold_left(predicates::sum, 0, [1,2,3,4,5], Result).

	test(metapredicates_07, true(Result == 120)) :-
		meta::fold_left(predicates::product, 1, [1,2,3,4,5], Result).

	test(metapredicates_08, true(Result == (10, 10))) :-
		meta::fold_left(predicates::tuple, (0,0), [(1,2),(3,4),(6,4)], Result).

	test(metapredicates_09, true(Result == [0, 1, 5, 34])) :-
		meta::scan_left(user::sum_squares, 0, [1,2,3], Result).

	test(metapredicates_10, true(Result == [1, 5, 34])) :-
		meta::scan_left_1(user::sum_squares, [1,2,3], Result).

	test(metapredicates_11, true(Result == [15, 14, 12, 9, 5])) :-
		meta::scan_right(predicates::sum, 5, [1,2,3,4], Result).

	test(metapredicates_12, true(Result == [10, 9, 7, 4])) :-
		meta::scan_right_1(predicates::sum, [1,2,3,4], Result).

	test(metapredicates_13, true(Result == 15)) :-
		meta::fold_left_1([X,Y,Z]>>(Z is X+Y), [1,2,3,4,5], Result).

	test(metapredicates_14, true(Result == 3)) :-
		meta::fold_right_1([X,Y,Z]>>(Z is X-Y), [1,2,3,4,5], Result).

	test(metapredicates_15, true(Result == 120)) :-
		meta::fold_right_1([X,Y,Z]>>(Z is X*Y), [1,2,3,4,5], Result).

	test(metapredicates_16, true) :-
		meta::map(integer, [1,2,3,4,5]).

	test(metapredicates_17, true(Codes == [97, 98, 99, 100, 101])) :-
		meta::map(char_code, [a,b,c,d,e], Codes).

	% tests for calling meta-predicates with other meta-predicates as meta-arguments

	test(metapredicates_18, true(L == [1, 2, 3])) :-
		client::test1(L).

	test(metapredicates_19, true(L == [1, 2, 3])) :-
		client::test2(L).

	test(metapredicates_20, true(L == [1, 2, 3])) :-
		client::test3(L).

	% tests for calling meta-predicates with closure corresponding to control constructs

	test(metapredicates_21, true(X == proto)) :-
		proto::self_closure(X).

	test(metapredicates_22, true(X == parent)) :-
		parent::self_closure(X).

	test(metapredicates_23, true(X == library)) :-
		library::self_closure(X).

	test(metapredicates_24, true(X == extended_library)) :-
		extended_library::self_closure(X).

	test(metapredicates_25, true(X == parent)) :-
		proto::super_closure(X).

	test(metapredicates_26, true(L == [2, 4, 6])) :-
		test_object::p(L).

	test(metapredicates_27, true(X-Y == m1-m2)) :-
		m1::r(X, Y).

	test(metapredicates_28, true(Nth == 55)) :-
		fibonacci::nth(10, Nth).

	test(metapredicates_29, true(S1 == 179998)) :-
		company::company(C1),
		company::get_salary(company(C1), S1).

	test(metapredicates_30, true(S2 == 89999)) :-
		company::company(C1),
		company::cut_salary(company(C1), C2),
		company::get_salary(C2, S2).

	test(metapredicates_31, true(L == [2, 4])) :-
		meta::findall_member(N, [1, 2, 3, 4, 5], (N mod 2 =:= 0), L).

	test(metapredicates_32, true(L == [2, 4, 6, 8])) :-
		meta::findall_member(N, [1, 2, 3, 4, 5], (N mod 2 =:= 0), L, [6, 8]).

	test(metapredicates_33) :-
		obj::op1d(L1d),
		assertion(l1d, L1d == [1, 2, 3]),
		obj::op1s(L1s),
		assertion(l1s, L1s == [1, 2, 3]),
		obj::op2d(L2d),
		assertion(l2d, L2d == [1, 2, 3]),
		obj::op2s(L2s),
		assertion(l2s, L2s == [1, 2, 3]).

	test(metapredicates_34, true(L == [1, 2, 3])) :-
		wrappers_client::p(L).

	test(metapredicates_35, true(L == [1, 2, 3])) :-
		wrappers_client::q(L).

	test(metapredicates_36, true(L == [2, 1, 3])) :-
		wrappers_client::r(L).

	test(metapredicates_37, true(L == [2, 1, 3])) :-
		wrappers_client::s(L).

	test(metapredicates_38, true(Tokens == [abc,def,ghi])) :-
		grammar::codes([abc,def,ghi], Tokens).

	test(metapredicates_39, true(Left == '(((((((((0+1)+2)+3)+4)+5)+6)+7)+8)+9)')) :-
		folds::left(Left).

	test(metapredicates_40, true(Right == '(1+(2+(3+(4+(5+(6+(7+(8+(9+0)))))))))')) :-
		folds::right(Right).

	test(metapredicates_41, true(R == [9, 8, 7, 6, 5, 4, 3, 2, 1])) :-
		meta::fold_left([Y, X, [X|Y]]>>true, [], [1,2,3,4,5,6,7,8,9], R).

	test(metapredicates_42, true(R == [1, 2, 3, 4, 5, 6, 7, 8, 9])) :-
		meta::fold_right([X, Y, [X|Y]]>>true, [], [1,2,3,4,5,6,7,8,9], R).

	test(metapredicates_43) :-
		simple_client::test_whatever.

	test(metapredicates_44, true(Assertion)) :-
		^^set_text_output(''),
		simple_client::test_whatever_all,
		^^text_output_assertion('Hello world!', Assertion).

	test(metapredicates_45, true(Assertion)) :-
		^^set_text_output(''),
		simple_client_alt::test_whatever_all,
		^^text_output_assertion('Hello world!', Assertion).

:- end_object.
