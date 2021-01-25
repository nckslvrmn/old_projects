Pokemon Go Stats
=======

script to do a few pokemon IV or CP operations. the subcommands are as follows:
```
Usage: ./pgo COMMAND OPTIONS

Commonly used command are:
  perf_cps :  display perfect cps of a pokemon by level.
  calc_ivs :  calculate possible IVs of given pokemon.

run './pgo COMMAND -h' for more information on a specific command.<Paste>
```

to calculate perfect IVs of a given pokemon, run:
```
> ./pgo perf_cps -p charizard
1: 41
1.5: 84
2: 128
2.5: 172
3: 215
3.5: 259
4: 303
...
```

you can also specify a level:
```
> ./pgo perf_cps -p charizard -l 40
40: 2890
```

to find possible IVs, run:
```
./pgo calc_ivs -p meltan -c 878 -h 104 -l 29
[14, 15, 15]
```
where -c is CP -h is HP and -l is level.
