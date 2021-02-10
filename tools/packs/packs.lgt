%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>
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


:- object(packs).

	:- info([
		version is 0:1:0,
		author is 'Paulo Moura',
		date is 2021-02-10,
		comment is 'Pack downloader, installer, upgrader, and remover.'
	]).

	:- public(help/0).
	:- mode(help, one).
	:- info(help/0, [
		comment is 'Provides help about the main commands.'
	]).

	:- public(available/0).
	:- mode(available, one).
	:- info(available/0, [
		comment is 'Lists all the packs that are available from registered sources.'
	]).

	:- public(installed/0).
	:- mode(installed, one).
	:- info(installed/0, [
		comment is 'Lists all the packs that are installed.'
	]).

	:- public(outdated/0).
	:- mode(outdated, one).
	:- info(outdated/0, [
		comment is 'Lists all the packs that are installed but outdated.'
	]).

	:- public(obsolete/0).
	:- mode(obsolete, one).
	:- info(obsolete/0, [
		comment is 'Lists all the packs that are installed but whose registered source cannot be accessed.'
	]).

	:- public(clean/0).
	:- mode(clean, one).
	:- info(clean/0, [
		comment is 'Cleans all package sources archives.'
	]).

	:- public(upgrade/0).
	:- mode(upgrade, zero_or_one).
	:- info(upgrade/0, [
		comment is 'Upgrades all outdated packages (that are not pinned).'
	]).

	:- public(location/1).
	:- mode(location(?atom), zero_or_one).
	:- info(location/1, [
		comment is 'Location (absolute path) where the packages are installed.'
	]).

	:- public(register/2).
	:- mode(register(+atom, +atom), zero_or_one).
	:- info(register/2, [
		comment is 'Registers a new package source. If the package is already registered, updates its URL if different.',
		argnames is ['Package', 'URL']
	]).

	:- public(forget/1).
	:- mode(forget(+atom), zero_or_one).
	:- info(forget/1, [
		comment is 'Forgets a registered package source.',
		argnames is ['Package']
	]).

	:- public(forget/2).
	:- mode(forget(+atom, ++list(compound)), zero_or_one).
	:- info(forget/2, [
		comment is 'Forgets a registered package source using the specified options.',
		argnames is ['Package', 'Options'],
		remarks is [
			'``clean(Boolean)`` option' - 'Clean package sources archive after de-registering. Default is ``false``.',
			'``uninstall(Boolean)`` option' - 'Uninstall package. Default is ``true``.'
		]
	]).

	:- public(registry/2).
	:- mode(registry(?atom, ?atom), zero_or_more).
	:- info(registry/2, [
		comment is 'Enumerates, by backtracking, all package registry entries.',
		argnames is ['Package', 'URL']
	]).

	:- public(registries/0).
	:- mode(registries, one).
	:- info(registries/0, [
		comment is 'Prints a list of all available registries.'
	]).

	:- public(registry/1).
	:- mode(registry(+atom), one).
	:- info(registry/1, [
		comment is 'Prints all registry entries.',
		argnames is ['Registry']
	]).

	:- public(describe/1).
	:- mode(describe(+atom), zero_or_one).
	:- info(describe/1, [
		comment is 'Describes a registered package, including installed version if applicable.',
		argnames is ['Package']
	]).

	:- public(check/1).
	:- mode(check(+atom), zero_or_one).
	:- info(check/1, [
		comment is 'Checks a package specification.',
		argnames is ['Spec']
	]).

	:- public(install/1).
	:- mode(install(+atom), zero_or_one).
	:- info(install/1, [
		comment is 'Installs a new package.',
		argnames is ['Spec']
	]).

	:- public(install/2).
	:- mode(install(+atom, ++list(compound)), zero_or_one).
	:- info(install/2, [
		comment is 'Installs a new package using the specified options.',
		argnames is ['Spec', 'Options'],
		remarks is [
			'``clean(Boolean)`` option' - 'Clean package sources archive after installation. Default is ``false``.',
			'``verbose(Boolean)`` option' - 'Verbose installation steps. Default is ``false``.'
		]
	]).

	:- public(uninstall/1).
	:- mode(uninstall(+atom), zero_or_one).
	:- info(uninstall/1, [
		comment is 'Uninstalls a package.',
		argnames is ['Package']
	]).

	:- public(uninstall/2).
	:- mode(uninstall(+atom, ++list(compound)), zero_or_one).
	:- info(uninstall/2, [
		comment is 'Uninstalls a package using the specified options.',
		argnames is ['Package', 'Options'],
		remarks is [
			'``clean(Boolean)`` option' - 'Clean package sources archive after uninstalling. Default is ``false``.',
			'``verbose(Boolean)`` option' - 'Verbose uninstallation steps. Default is ``false``.'
		]
	]).

	:- public(clean/1).
	:- mode(clean(+atom), zero_or_one).
	:- info(clean/1, [
		comment is 'Cleans a package sources archive.',
		argnames is ['Package']
	]).

	:- public(upgrade/1).
	:- mode(upgrade(+atom), zero_or_one).
	:- info(upgrade/1, [
		comment is 'Upgrades a package.',
		argnames is ['Package']
	]).

	:- public(location/2).
	:- mode(location(?atom, ?atom), zero_or_more).
	:- info(location/2, [
		comment is 'Location (absolute path) where a package is installed.',
		argnames is ['Package', 'Location']
	]).

	:- public(pin/1).
	:- mode(pin(+atom), zero_or_one).
	:- info(pin/1, [
		comment is 'Pins a package, preventing it from being upgraded.',
		argnames is ['Package']
	]).

	:- public(unpin/1).
	:- mode(unpin(+atom), zero_or_one).
	:- info(unpin/1, [
		comment is 'Unpins a package, allowing it to be upgraded.',
		argnames is ['Package']
	]).

	:- uses(logtalk, [
		print_message/3
	]).

	:- uses(type, [
		check/2
	]).

	help :-
		print_message(information, packs, help).

	describe(Package) :-
		check(atom, Package),
		atom_concat(Package, '_pack', Object),
		atom_concat(Package, '_pack.lgt', File),
		logtalk_load(File),
		Object::summary(Summary),
		Object::description(Description),
		Object::license(License),
		Object::home_page(HomePage),
		setof(
			version(Version, URL, Checksum, Dependencies),
			Object::version(Version, URL, Checksum, Dependencies),
			Versions
		),
		print_message(information, packs, package_info(Package,Summary,Description,License,HomePage,Versions)).

:- end_object.
