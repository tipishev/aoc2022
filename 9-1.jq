def parse: # convert the input into a list of commands
  [.[] | (split(" ") | [first, (last | tonumber)])];

def expand: # convert the commands into a list of moves
  reduce .[] as [$direction, $count]
  ([]; . + [($direction * $count) | split("")] | flatten);

def move_head:  # change head position depending on move
  if   .move == "R" then .head_at | [first + 1, last] 
  elif .move == "L" then .head_at | [first - 1, last] 
  elif .move == "U" then .head_at | [first, last + 1]
  elif .move == "D" then .head_at | [first, last - 1] 
  else error("unrecognized direction '\(.move)'")
  end;

def move_tail: # change tail position depending on head
  [4, 20]
;

def process:
  reduce .[] as $move
  ( # initial state
    {head_at: [0, 0], tail_at: [0, 0], tail_visited: [[0, 0]]};

    . # update rule
    | ({head_at, $move}   | move_head) as $new_head_at
    | ({tail_at, head_at} | move_tail) as $new_tail_at
    | {head_at: $new_head_at,
       tail_at: $new_tail_at,
       tail_visited: (.tail_visited + [$new_tail_at]) | unique}
  )
;

# main pipeline
[inputs] | parse | expand | process
