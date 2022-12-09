def enumerate:
  reduce .[] as $item 
  ([]; . + [[(. | length), $item]])
;

def to_records:
  [. as [$row, $row_content]
  | $row_content[]
  | . as [$col, $height]
  | [$row, $col] as $location
  | {$location, $height}]
;

def parse_left:
  [.
   | enumerate
   | .[]
   | [.[0], ([.[1] | split("") | .[] | tonumber] | enumerate)]
   | to_records]
;
def parse_right:  [parse_left | .[] | reverse];
def parse_top: parse_left | transpose;
def parse_bottom: [parse_top | .[] | reverse];

def _count_visible:
  (.arr | last) as $last
  | if .arr == [] then
      .counter
    elif .num <= $last then
      .counter + 1
    elif .num > $last then
      {num, arr: .arr[:-1], counter: (.counter + 1)} | _count_visible
    else
      error("wat?!")
    end
;

def count_visible: {num: .[0], arr: .[1], counter: 0} | _count_visible;

def row_visibility(direction):
  reduce .[] as $tree
  ({prev: [], acc: []};  # inital state
   . as $state
   | ([$tree.height, $state.prev] | count_visible) as $visible
   | ($tree | setpath([direction]; $visible )) as $new_tree
   | {prev: (.prev + [$tree.height]), 
      acc: (.acc + [$new_tree])})

  | .acc
;

def rows_visibility(direction):
  .[] | row_visibility(direction);

def delete_height_and_location:
  del(.height, .location)
;

def aggregate:
  reduce .[] as $item0
  ({};
  . as $lookup
  | ($item0.location | tostring) as $key
  | ($item0 | delete_height_and_location) as $item
  | if ($lookup | has($key))
    then
      . | .[$key] += $item
    else
      . | .[$key] |= $item
    end
  )
;

def score: .left * .right * .top * .bottom;

[[inputs] | (parse_left | rows_visibility("left"))
          , (parse_right | rows_visibility("right"))
          , (parse_top | rows_visibility("top"))
          , (parse_bottom | rows_visibility("bottom"))
] | flatten | aggregate | [.[] | score] | max

# ["25512"] | (parse_left | rows_visibility("left"))

