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

# lpa - faults

This example is an adaptation of the LPA Prolog++ faults example.

Print Logtalk, Prolog backend, and kernel versions (if running as a notebook):

```logtalk
%versions
```

Start by loading the example and the required library files:

```logtalk
logtalk_load(lpa_faults(loader)).
```

Start an interactive fault diagnosis process (skip if running as a notebook):

```logtalk
(current_object(jupyter) -> true; fault::findall).
```

<!--
Please answer all questions with yes or no.

The starter turns but the engine does not fire?   no.
The engine has difficulty starting?     yes.
The engine cuts out shortly after starting?     yes.

Location      : distributor
Possible Fault: Worn distributor brushes

No (more) explanations found.
true.
-->
