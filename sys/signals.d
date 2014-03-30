/**
 * POSIX signal handlers.
 *
 * License:
 *   This Source Code Form is subject to the terms of
 *   the Mozilla Public License, v. 2.0. If a copy of
 *   the MPL was not distributed with this file, You
 *   can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Authors:
 *   Vladimir Panteleev <vladimir@thecybershadow.net>
 */

module ae.sys.signals;

import std.exception;

public import core.sys.posix.signal;

alias void delegate() nothrow @system SignalHandler;

void addSignalHandler(int signum, SignalHandler fn)
{
	if (handlers[signum].length == 0)
	{
		auto old = signal(signum, &sighandle);
		assert(old == SIG_DFL, "A signal handler was already set");
	}
	handlers[signum] ~= fn;
}

void removeSignalHandler(int signum, SignalHandler fn)
{
	foreach (i, lfn; handlers[signum])
		if (lfn is fn)
		{
			handlers[signum] = handlers[signum][0..i] ~ handlers[signum][i+1..$];
			if (handlers[signum].length == 0)
				signal(signum, SIG_DFL);
			return;
		}
	assert(0);
}

// ***************************************************************************

version(linux) {
/// If the signal signum is raised during execution of code,
/// ignore it. Returns true if the signal was raised.
bool collectSignal(int signum, void delegate() code)
{
	sigset_t mask;
	sigemptyset(&mask);
	sigaddset(&mask, signum);
	sigset_t oldMask;
	errnoEnforce(pthread_sigmask(SIG_BLOCK, &mask, &oldMask) != -1);

	bool result;
	{
		scope(exit)
			errnoEnforce(pthread_sigmask(SIG_SETMASK, &oldMask, null) != -1);

		scope(exit)
		{
			timespec zerotime;
			result = sigtimedwait(&mask, null, &zerotime) == 0;
		}

		code();
	}

	return result;
}
}

private:

enum SIGMAX = 100;
shared SignalHandler[][SIGMAX] handlers;

extern(C) void sighandle(int signum) nothrow @system
{
	if (signum >= 0 && signum < handlers.length)
		foreach (fn; handlers[signum])
			fn();
}
