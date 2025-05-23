..
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


.. rst-class:: align-right

**built-in method**

.. index:: pair: sender/1; Built-in method
.. _methods_sender_1:

``sender/1``
============

Description
-----------

::

   sender(Sender)

Unifies its argument with the object that sent the message under processing.

This private method is translated into a unification between its argument and
the corresponding implicit context argument in the predicate clause making
the call. This unification occurs at the clause head when the argument is not
bound at compile-time (the most common case).

Modes and number of proofs
--------------------------

::

   sender(?object_identifier) - zero_or_one

Errors
------

(none)

Examples
--------

::

   % after compilation, the write/1 call will
   % be the first goal in the clause body
   test :-
       sender(Sender),
       write('executing a method to answer a message sent by '),
       writeq(Sender), nl.

.. seealso::

   :ref:`methods_context_1`,
   :ref:`methods_parameter_2`,
   :ref:`methods_self_1`,
   :ref:`methods_this_1`
