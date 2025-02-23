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


	normal(Mean, Deviation, Scaled) :-
		normal(Value),
		Scaled is Mean + Deviation * Value.

	normal(Value) :-
		random(X1),
		random(X2),
		Value is sqrt(-2.0 * log(X1)) * cos(2.0*pi*X2).

	lognormal(Mean, Deviation, Scaled) :-
		normal(Mean, Deviation, Value),
		Scaled is exp(Mean + Deviation * Value).

	lognormal(Value) :-
		normal(Value0),
		Value is exp(Value0).

	geometric(Probability, Value) :-
		random(Random),
		Value is ceiling(log(1 - Random) / log(1 - Probability)).

	exponential(Lambda, Value) :-
		Lambda > 0,
		random(Random),
		Value is -log(1.0 - Random) / Lambda.

	binomial(Trials, Probability, Value) :-
		binomial(Trials, Probability, 0, Value).

	binomial(0, _, Value, Value) :-
		!.
	binomial(N, Probability, Value0, Value) :-
		M is N - 1,
		random(Random),
		(	Random < Probability ->
			Value1 is Value0 + 1,
			binomial(M, Probability, Value1, Value)
		;	binomial(M, Probability, Value0, Value)
		).

	logistic(Location, Scale, Value) :-
		random(Random),
		Value is Location + Scale * log(Random / (1 - Random)).

	logistic(Location, Value) :-
		random(Random),
		Value is Location + log(Random / (1 - Random)).

	logistic(Value) :-
		logistic(0.0, Value).

	poisson(Mean, Value) :-
		Mean >= 0,
		poisson(Mean, 0, 1.0, Value).

	poisson(Mean, Value, Product, Value) :-
		Product =< exp(- Mean),
		!.
	poisson(Mean, N0, Product0, Value) :-
		random(Random),
		N is N0 + 1,
		Product is Product0 * Random,
		poisson(Mean, N, Product, Value).

	power(Exponent, Value) :-
		random(Random),
		Value is Exponent * Random ** (1 / Exponent) / Exponent.

	weibull(Shape, Value) :-
		random(Random),
		Value is (-log(Random)) ** (1 / Shape).

	weibull(Lambda, Shape, Value) :-
		Shape > 0,
		random(Random),
		Value is Lambda * (-log(Random)) ** (1 / Shape).

	uniform(Lower, Upper, Value) :-
		random(Lower, Upper, Value).

	circular_uniform_polar(Radius, Rho, Theta) :-
		random(Random),
		Rho is Radius * sqrt(Random),
		DoublePi is 2 * pi,
		random(0.0, DoublePi, Theta).

	circular_uniform_cartesian(Radius, X, Y) :-
		circular_uniform_polar(Radius, Rho, Theta),
		X is Rho * cos(Theta),
		Y is Rho * sin(Theta).

	standard_t(DegreesOfFreedom, Value) :-
		normal(Normal),
		chi_squared(DegreesOfFreedom, ChiSquared),
		Value is Normal / sqrt(ChiSquared / DegreesOfFreedom).

	chi_squared(DegreesOfFreedom, ChiSquared) :-
		chi_squared(DegreesOfFreedom, 0, ChiSquared).

	chi_squared(0, ChiSquared, ChiSquared) :-
		!.
	chi_squared(N, ChiSquared0, ChiSquared) :-
		M is N - 1,
		normal(Normal),
		ChiSquared1 is ChiSquared0 + Normal * Normal,
		chi_squared(M, ChiSquared1, ChiSquared).
