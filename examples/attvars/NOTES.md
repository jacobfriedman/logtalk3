---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.16.7
  kernelspec:
    display_name: Logtalk
    language: logtalk
    name: logtalk_kernel
---

<!--
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
-->

# attvars

This an example of using attributed variables within Logtalk objects and
categories. It requires the use of a backend Prolog compiler with support
for attributed variables. Tested with B-Prolog, SWI-Prolog, XSB, and YAP.
The individual examples are adaptations of code found on the SWI-Prolog
documentation.

When using SWI-Prolog or YAP, the `attvars_hook` hook object works by
creating a shadow module (with the same name as the object or category
internal prefix) containing the `attribute_goals//1` and `attr_unify_hook/2`
hooks that are required by the attributed variables implementation. These
hooks are compiled as module multifile predicates in order to avoid spurious
compiler warning messages (note that the hook clause bodies are compiled
within the context of the container object).

When using XSB, the `attvars_hook` hook object works by generating the
`install_verify_attribute_handler/4` and `install_attribute_portray_hook/3`
XSB directives, invoked using Logtalk-compiled arguments. These directives
allow the use of common code for SWI-Prolog, XSB, and YAP.

When using B-Prolog, the `attribute_goals//1` hook grammar rule is discarded.

Caveats:

1. The supported attribute variables built-in predicates (`get_attr/3`,
`put_attr/3`, and `del_attr/3`) can only be called from within objects (or
categories).

2. Calls to the supported attribute variables built-in predicates with a
second argument not corresponding to the enclosing entity are compiled as
references to other Logtalk entities. If you need to refer to a Prolog
module instead, wrap the predicate call using the `{}/1` control construct.

Print Logtalk, Prolog backend, and kernel versions (if running as a notebook):

```logtalk
%versions
```

Start by loading the example and the required library files:

```logtalk
logtalk_load(attvars(loader)).
```

Simple finite, typed, domain reasoner:

```logtalk
domain(atom)::domain(X, [a,b]), X = c.
```

<!--
false.
-->

```logtalk
domain(integer)::domain(X, [1,2]), domain(integer)::domain(X, [1,3]).
```

<!--
X = 1.
-->

```logtalk
domain(integer)::domain(X, [1,2,3]), domain(integer)::domain(X, [1,3]).
```

<!--
domain(X, [1, 3]).
-->
