#include "timer.hh"

/*
 * Copyright (c) Tommi Junttila
 * Released under the GNU General Public License version 2.
 */

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>

namespace {

double filetime_to_seconds(const FILETIME &ft)
{
  ULARGE_INTEGER value;
  value.LowPart = ft.dwLowDateTime;
  value.HighPart = ft.dwHighDateTime;
  return static_cast<double>(value.QuadPart) * 1.0e-7; /* 100 ns units */
}

} // anonymous namespace

namespace bliss {

Timer::Timer()
{
  reset();
}

void Timer::reset()
{
  FILETIME creation_time, exit_time, kernel_time, user_time;
  if(GetProcessTimes(GetCurrentProcess(), &creation_time, &exit_time,
                     &kernel_time, &user_time))
    {
      start_time = filetime_to_seconds(kernel_time) + filetime_to_seconds(user_time);
    }
  else
    {
      start_time = 0.0;
    }
}

double Timer::get_duration()
{
  FILETIME creation_time, exit_time, kernel_time, user_time;
  if(GetProcessTimes(GetCurrentProcess(), &creation_time, &exit_time,
                     &kernel_time, &user_time))
    {
      double current = filetime_to_seconds(kernel_time) + filetime_to_seconds(user_time);
      return current - start_time;
    }
  return 0.0;
}

} // namespace bliss

#else

#include <unistd.h>
#include <sys/times.h>

namespace bliss {

static const double numTicksPerSec = (double)(sysconf(_SC_CLK_TCK));

Timer::Timer()
{
  reset();
}

void Timer::reset()
{
  struct tms clkticks;

  times(&clkticks);
  start_time =
    ((double) clkticks.tms_utime + (double) clkticks.tms_stime) /
    numTicksPerSec;
}


double Timer::get_duration()
{
  struct tms clkticks;

  times(&clkticks);
  double intermediate =
    ((double) clkticks.tms_utime + (double) clkticks.tms_stime) /
    numTicksPerSec;
  return intermediate - start_time;
}

} // namespace bliss

#endif
