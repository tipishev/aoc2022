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

def to_vector: # convert 2 points into a vector
  [(first | first) - (last | first),
   (first |  last) - (last | last)];

def vector_add: # add 2 vectors
  [(first | first) + (last | first),
   (first | last)  + (last | last)];

def vector_length: first*first + last*last | sqrt;

def to_movement:
 # when touching the tail doesn't move
 if (. | vector_length) < 2 then [0, 0]

 # linear stretch
 elif . == [ 0,  2] then [ 0,  1]
 elif . == [ 2,  0] then [ 1,  0]
 elif . == [ 0, -2] then [ 0, -1]
 elif . == [-2,  0] then [-1,  0]

 # diagonal stretch
 elif . == [ 1,  2] then [ 1,  1]
 elif . == [ 2,  1] then [ 1,  1]
 elif . == [ 2, -1] then [ 1, -1]
 elif . == [ 1, -2] then [ 1, -1]
 elif . == [-1, -2] then [-1, -1]
 elif . == [-2, -1] then [-1, -1]
 elif . == [-2,  1] then [-1,  1]
 elif . == [-1,  2] then [-1,  1]

 else error("wat?!") end;

def move_tail: # change tail position depending on head
  ([.head_at, .tail_at] | to_vector | to_movement) as $delta
  | [.tail_at, $delta] | vector_add;

def track_tail_visits:
  reduce .[] as $move
  ( # initial state: everything at the origin
    [0, 0] | {head_at: ., tail_at: ., tail_visited: [.]};

    . # update rule
    | ({head_at, $move}   | move_head) as $new_head_at
    | ({tail_at, head_at} | move_tail) as $new_tail_at
    | {head_at: $new_head_at,
       tail_at: $new_tail_at,
       tail_visited: (.tail_visited + [$new_tail_at]) | unique}
  )
  | .tail_visited
;

# the main pipeline
[inputs] | parse | expand | track_tail_visits | length
