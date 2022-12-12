def parse: [
  foreach (inputs/" "
          | [.[0], (.[1] // empty | tonumber)]) as $command
  (
    {cycle:0, X: 1};
    if $command[0] == "noop"
      then .cycle += 1
    elif $command[0] == "addx"
      then .cycle += 2 | .X += $command[1]
    else
      error("wat?!")
    end;
    .)
];

def twenties:
  reduce .[] as $item
  ({search: 20, out: [], prev: null};
  if $item.cycle >= .search
    then {out: (.out + [.prev.X * .search]),
          search: (.search + 40),
	  prev: $item}
  else . | .prev = $item
  end) | .out | add;

parse | twenties
