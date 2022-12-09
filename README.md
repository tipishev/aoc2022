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

uses an undocumented function `_nwise` for chunking.

```
jq -nRf 3-1.jq 3-big.txt
jq -nRf 3-2.jq 3-big.txt
```

## Day 4

```
jq -nRf 4-1.jq 4-big.txt
jq -nRf 4-2.jq 4-big.txt
```

## Day 5

```
jq -nRf 5-1.jq 5-big.txt
jq -nRf 5-2.jq 5-big.txt
```

## Day 6

```
jq -nRf 6-1.jq 6-big.txt
jq -nRf 6-2.jq 6-big.txt
```

## Day 7

```
jq -nRf 7-1.jq 7-big.txt
jq -nRf 7-2.jq 7-big.txt
```

## Day 8

Man, fuck those eaves, why don't the Elves want to see the tallest tree in the distance?
Part 2 is inefficient, takes a few seconds on a Macbook M1, about a minute on my home laptop.

```
jq -nRf 8-1.jq 8-big.txt
jq -nRf 8-2.jq 8-big.txt
```
