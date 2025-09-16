# Example-PoCs
To try a PoC, please enter the directory of that PoC and `make` it.
`gcc` is required.

## Flush+Reload
A simple Flush+Reload covert channel demo.
Note that if the machine has multiple NUMA nodes,
which is the case for ECE LRC machines,
please pin the processes to the same node.

The pinning can be done via `numactl`,
but it isn't available on ECE LRC.
As a workaround, you can find which cores belong to the same NUMA node and
pin the processes to those cores.
Such information can be obtained with `lscpu | grep NUMA`.
For example, if the command's output is:
```
NUMA node0 CPU(s):   0,2,4,6,8,10
NUMA node1 CPU(s):   1,3,5,7,9,11
```
You can pin the program to any two cores from the same node,
e.g., `taskset -c 0,2 ./flush_reload.bin`.

## Spectre
The `Spectre` directory contains two Spectre PoCs.
The first one is a naive Spectre PoC that is commonly found on the Internet.
The victim function in the naive PoC is carefully designed for the attacker
and thus it's a bit unrealistic.
The naive PoC can be invoked with `./spectre.bin naive`.

The second PoC implements a more plausible Spectre attack
involving a toy sales-management system.
This PoC can be invoked without any command-line arguments,
i.e., `./spectre.bin`.

## Strcmp
A naive string comparison implementation that demonstrates information
leakage from end-to-end timing.
