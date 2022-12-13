def parse: [
  foreach (inputs/" "
          | [.[0], (.[1] // empty | tonumber)]) as $command
  (
    {cycle:0, X: 1, sprite: [0, 1, 2]};
    if $command[0] == "noop"
      then .cycle += 1
    elif $command[0] == "addx"
      then
      .cycle += 2
      | .X += $command[1]
      | .sprite = [.X-1, .X, .X+1]
    else
      error("wat?!")
    end;
    .) | {cycle, sprite}
]
;

def expand:
  . as $changes
  | [
    foreach range(240) as $cycle

    ({sprite: [0, 1, 2],
      next: $changes[0],
      changes: $changes[1:]};

     if $cycle < .next.cycle then .
     else {sprite: .next.sprite,
           next: .changes[0],
           changes:.changes[1:]}
     end;

     {$cycle, sprite})
   ]
;

def to_rows:
  _nwise(40)
  
;

def render:
  [.[]
  | .sprite as $sprite
  #| debug
  | if ((.cycle % 40) | in($sprite)) then "#" else "." end]
  | add
;

parse | expand | [to_rows]# | .[] | render
