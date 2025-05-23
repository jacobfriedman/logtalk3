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


`meta`
======

This library provides implementations of common meta-predicates. The `meta`
object implements common meta-predicates like `map/3` and `fold_left/4`.

See also the `meta_compiler` library, which provides optimized compilation
of meta-predicate calls.


API documentation
-----------------

Open the [../../docs/library_index.html#meta](../../docs/library_index.html#meta)
link in a web browser.


Loading
-------

To load the main entities in this library, load the `loader.lgt` file:

	| ?- logtalk_load(meta(loader)).


Testing
-------

To test this library predicates, load the `tester.lgt` file:

	| ?- logtalk_load(meta(tester)).


Usage
-----

See e.g. the `metapredicates` example and unit tests.
