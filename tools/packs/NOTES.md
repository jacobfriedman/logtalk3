________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>
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


``packs``
=========

This tool provides predicates for downloading, installing, upgrading, and
removing third-party libraries.


Requirements
------------

The following command-line commands are required:

- `openssl`
- `curl`
- `tar`
- `unzip`


API documentation
-----------------

This tool API documentation is available at:

[../../docs/library_index.html#packs](../../docs/library_index.html#packs)


Loading
-------

This tool can be loaded using the query:

	| ?- logtalk_load(packs(loader)).


Testing
-------

To test this tool, load the `tester.lgt` file:

	| ?- logtalk_load(packs(tester)).


Pack specification
------------------

A pack is specified using a Logtalk source file defining an object that
implements the `pack_protocol`. The source file should be named after
the name of the third-party library. The file must be available from 
a declared pack registry.

The pack sources must be available for downloading as a `.zip` or a
`.tar.gz` archive. The checksum for the archive should use one of the
hash algorithms supported by OpenSSL. These can be listed using the
command:

	$ openssl list -digest-commands

Use of the SHA-256 hash algorithm (`sha256`) or better is recommended.
