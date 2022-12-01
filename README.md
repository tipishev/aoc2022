# Advent of Code 2022 in jq

## Day 1

Add an empty line on the top and the bottom of the input files.

```bash
cat 1-big.txt | jq --raw-input -f 1-1.jq
cat 1-big.txt | jq --raw-input -f 1-2.jq
```
