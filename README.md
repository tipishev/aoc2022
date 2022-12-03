# Advent of Code 2022 in jq

## Day 1

Add an empty line on the top and the bottom of the input files.

```bash
cat 1-big.txt | jq --raw-input -f 1-1.jq
cat 1-big.txt | jq --raw-input -f 1-2.jq
```
## Day 2

```
jq -nRf 2-1.jq 2-big.txt
jq -nRf 2-2.jq 2-big.txt
```

## Day 3

```
jq -nRf 3-1.jq 3-big.txt
```
