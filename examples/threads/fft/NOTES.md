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

# threads - fft

This folder provides a multi-threading solution for calculating the Fast
Fourier Transform. This solution is mostly intended for benchmarking.

Print Logtalk, Prolog backend, and kernel versions (if running as a notebook):

```logtalk
%versions
```

Start by loading the example and the required library files:

```logtalk
logtalk_load(fft(loader)).
```

NOTE: some example queries below use a proprietary predicate `time/1` in
order to get accurate goal times. This predicate is found on several Prolog
systems. For other Prolog compilers, replace the `time/1` call by any
appropriate timing calls (e.g., `cputime/0`).

Start by testing the results for the various multi-threading versions to check
the results using a random number generator to create an initial list:

```logtalk
N=8, cgenerator::list(N,L), fft(1)::fft(N,L,F1), fft(2)::fft(N,L,F2), fft(4)::fft(N,L,F4).
```

<!--
N = 8,
L = [c(0.562342, 0.37745), c(0.448983, 0.0468073), c(0.482978, 0.81187), c(0.229581, 0.879153), c(0.39853, 0.909), c(0.248164, 0.314326), c(0.744353, 0.0665809), c(0.381964, 0.993583)],
F1 = [c(3.4969, 4.39877), c(-0.0616465, -0.866927), c(1.24514, 0.493602), c(0.929429, -0.127675), c(0.879511, -0.0689684), c(-1.10131, -0.718926), c(-1.77806, 0.322397), c(0.888774, -0.412674)],
F2 = [c(3.4969, 4.39877), c(-0.0616465, -0.866927), c(1.24514, 0.493602), c(0.929429, -0.127675), c(0.879511, -0.0689684), c(-1.10131, -0.718926), c(-1.77806, 0.322397), c(0.888774, -0.412674)],
F4 = [c(3.4969, 4.39877), c(-0.0616465, -0.866927), c(1.24514, 0.493602), c(0.929429, -0.127675), c(0.879511, -0.0689684), c(-1.10131, -0.718926), c(-1.77806, 0.322397), c(0.888774, -0.412674)]

true.
-->

Now we check using known results - in this case against Matlab... too lazy to do my own calcs:

```logtalk
N=8, L=[c(1,0),c(2,0),c(3,0),c(4,0),c(5,0),c(6,0),c(7,0),c(8,0)], fft(4)::fft(N,L,F4), fft(8)::fft(N,L,F8).
```

<!--
N = 8,
L = [c(1, 0), c(2, 0), c(3, 0), c(4, 0), c(5, 0), c(6, 0), c(7, 0), c(8, 0)],
F4 = [c(36.0, 0.0), c(-4.0, -9.65686), c(-4.0, -4.0), c(-4.0, -1.65686), c(-4.0, 0.0), c(-4.0, 1.65686), c(-4.0, 4.0), c(-4.0, 9.65686)],
F8 = [c(36.0, 0.0), c(-4.0, -9.65686), c(-4.0, -4.0), c(-4.0, -1.65686), c(-4.0, 0.0), c(-4.0, 1.65686), c(-4.0, 4.0), c(-4.0, 9.65686)]

true.
-->

From Matlab - we can see that the results are ok for 4 and 8 threads... within rounding errors...

EDU» x = [1 ,2,3,4,5,6,7,8]
EDU» fft(x,8)
ans =
 36.00000000000000                     
-4.00000000000000 + 9.65685424949238i
-4.00000000000000 + 4.00000000000000i 
-4.00000000000000 + 1.65685424949238i
-4.00000000000000                     
-4.00000000000000 - 1.65685424949238i
-4.00000000000000 - 4.00000000000000i 
-4.00000000000000 - 9.65685424949238i


Now a longer test with N=16384...

```logtalk
N=16384, cgenerator::list(N, L), time(fft(1)::fft(N,L,F1)), time(fft(2)::fft(N,L,F2)), time(fft(4)::fft(N,L,F3)).
```

<!--
% 1,540,128 inferences, 1.18 CPU in 1.27 seconds (93% CPU, 1305193 Lips)
% 16,496 inferences, 1.23 CPU in 0.77 seconds (159% CPU, 13411 Lips)
% 16,495 inferences, 1.34 CPU in 0.54 seconds (249% CPU, 12310 Lips)

N = 16384,
L = [c(0.0980332, 0.534537), c(0.783046, 0.0702899), c(0.00399351, 0.458403), c(0.332693, 0.365153), c(0.584027, 0.271888), c(0.0550958, 0.545072), c(0.190854, 0.288811), c(0.0521769, 0.123861), c(..., ...)|...],
F1 = [c(8174.33, 8219.08), c(-20.8685, -26.0953), c(25.668, 53.9194), c(-27.0944, 19.5957), c(21.5431, -19.3457), c(29.1652, -14.5477), c(-9.71613, -11.4724), c(-30.8867, -26.4551), c(..., ...)|...],
F2 = [c(8174.33, 8219.08), c(-20.8685, -26.0953), c(25.668, 53.9194), c(-27.0944, 19.5957), c(21.5431, -19.3457), c(29.1652, -14.5477), c(-9.71613, -11.4724), c(-30.8867, -26.4551), c(..., ...)|...],
F3 = [c(8174.33, 8219.08), c(-20.8685, -26.0953), c(25.668, 53.9194), c(-27.0944, 19.5957), c(21.5431, -19.3457), c(29.1652, -14.5477), c(-9.71613, -11.4724), c(-30.8867, -26.4551), c(..., .

true.
-->

A smaller test:

```logtalk
N=8192, cgenerator::list(N, L), time(fft(1)::fft(N,L,F1)), time(fft(2)::fft(N,L,F2)), time(fft(4)::fft(N,L,F3)).
```

<!--
% 720,928 inferences, 0.55 CPU in 0.58 seconds (94% CPU, 1310778 Lips)
% 8,304 inferences, 0.55 CPU in 0.33 seconds (166% CPU, 15098 Lips)
% 8,304 inferences, 0.59 CPU in 0.24 seconds (241% CPU, 14075 Lips)

N = 8192,
L = [c(0.108653, 0.130382), c(0.299788, 0.366249), c(0.797314, 0.0934765), c(0.618671, 0.557751), c(0.23189, 0.736263), c(0.157462, 0.455775), c(0.398063, 0.128278), c(0.0265977, 0.540345), c(..., ...)|...],
F1 = [c(4119.95, 4113.57), c(-11.2542, 19.0867), c(29.8736, 13.7454), c(2.13094, -50.7658), c(-35.5401, 2.62093), c(-19.7409, 38.7919), c(28.3842, 56.9097), c(-11.8783, 8.50143), c(..., ...)|...],
F2 = [c(4119.95, 4113.57), c(-11.2542, 19.0867), c(29.8736, 13.7454), c(2.13094, -50.7658), c(-35.5401, 2.62093), c(-19.7409, 38.7919), c(28.3842, 56.9097), c(-11.8783, 8.50143), c(..., ...)|...],
F3 = [c(4119.95, 4113.57), c(-11.2542, 19.0867), c(29.8736, 13.7454), c(2.13094, -50.7658), c(-35.5401, 2.62093), c(-19.7409, 38.7919), c(28.3842, 56.9097), c(-11.8783, 8.50143), c(..., ...)|...]

true.
-->

A very big test:

```logtalk
N is 65536, cgenerator::list(N, L), time(fft(1)::fft(N,L,F1)), time(fft(2)::fft(N,L,F2)), time(fft(4)::fft(N,L,F3)).
```

<!--
% 6,946,848 inferences, 5.91 CPU in 6.42 seconds (92% CPU, 1175440 Lips)
% 65,648 inferences, 6.03 CPU in 3.80 seconds (159% CPU, 10887 Lips)
% 65,648 inferences, 6.31 CPU in 2.54 seconds (249% CPU, 10404 Lips)

N = 65536,
L = [c(0.416673, 0.410381), c(0.340778, 0.930646), c(0.373208, 0.0208154), c(0.853131, 0.265193), c(0.661878, 0.674402), c(0.99455, 0.599138), c(0.109308, 0.617546), c(0.187351, 0.0837411), c(..., ...)|...],
F1 = [c(32814.3, 32830.9), c(125.184, 70.4444), c(-100.912, 55.0937), c(3.58732, -131.877), c(107.255, 2.85792), c(-128.124, 25.6776), c(56.3197, -29.6811), c(-66.6174, -108.857), c(..., ...)|...],
F2 = [c(32814.3, 32830.9), c(125.184, 70.4444), c(-100.912, 55.0937), c(3.58732, -131.877), c(107.255, 2.85792), c(-128.124, 25.6776), c(56.3197, -29.6811), c(-66.6174, -108.857), c(..., ...)|...],
F3 = [c(32814.3, 32830.9), c(125.184, 70.4444), c(-100.912, 55.0937), c(3.58732, -131.877), c(107.255, 2.85792), c(-128.124, 25.6776), c(56.3197, -29.6811), c(-66.6174, -108.857), c(..., ...)|...]

true.
-->
