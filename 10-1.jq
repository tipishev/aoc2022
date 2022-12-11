[
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
]
