________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
________________________________________________________________________


`random`
========

This library provides portable random number generators and an abstraction
over the native backend Prolog compiler random number generator if available.
It includes predicates for generating random floats and random integers in
a given interval; predicates for generating random sequences and sets;
predicates for randomly selecting, enumerating, and swapping elements from a
list; predicates that succeed, fail, or call another predicate with a given
probability; and predicates for sampling common probability distributions.


API documentation
-----------------

Open the [../../docs/library_index.html#random](../../docs/library_index.html#random)
link in a web browser.


Loading
-------

To load all entities in this library, load the `loader.lgt` file:

	| ?- logtalk_load(random(loader)).


Testing
-------

To test this library predicates, load the `tester.lgt` file:

	| ?- logtalk_load(random(tester)).


Usage
-----

The `random` object implements a portable random number generator and supports
multiple random number generators, using different seeds, by defining derived
objects. For example:

	:- object(my_random_generator_1,
		extends(random)).

		:- initialization(::reset_seed).

	:- end_object.

The `fast_random` object also implements a portable random number generator
but does not support deriving multiple random number generators, which makes
it a bit faster than the `random` object.

The `random` and `fast_random` objects manage the random number generator
seed using internal dynamic state. The predicates that update the seed
are declared as synchronized (when running on Prolog backends that support
threads). Still, care must be taken when using these objects from
multi-threaded applications, as there is no portable solution to protect
seed updates from signals and prevent inconsistent state when threads are
canceled.

The `random` and `fast_random` objects always initialize the random generator
seed to the same value, thus providing a pseudo random number generator. The
`randomize/1` predicate can be used to initialize the seed with a random
value. The argument should be a large positive integer. In alternative, when
using a small integer argument, discard the first dozen random values.

The `backend_random` object abstracts the native backend Prolog compiler
random number generator for the basic `random/1`, `get_seed/1`, and `set_seed/1`
predicates providing a portable implementation for the remaining predicates.
This makes the object stateless, which allows reliable use from multiple
threads. Consult the backend Prolog compiler documentation for details on
its random number generator properties. Note that several of the supported
backend Prolog systems, notably B-Prolog, CxProlog, ECLiPSe, JIProlog, and
Quintus Prolog, do not provide implementations for both the `get_seed/1` and
`set_seed/1` predicates and calling these predicates simply succeed without
performing any action.

All random objects (`random`, `fast_random`, and `backend_random`) implement
the `sampling_protocol` protocol. To maximize performance, the shared
implementations of the sampling predicates is defined in the `sampling.lgt`
file that's included in the random objects. This allows these predicates
to call the basic `random/1` and `random/3` predicates as locally defined
predicates.
