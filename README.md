# Example-PoCs

## Flush+Reload
Enter the directory `Flush+Reload` and `make` the project.
`gcc` is required.
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

