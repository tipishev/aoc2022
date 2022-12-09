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
def parse_right:  [parse_left[] | reverse];
def parse_top: parse_left | transpose;
def parse_bottom: [parse_top[] | reverse];

def row_visible:
  reduce .[] as $tree
  ({max_height: -1, visible: []};
  . as $max_height
  | if $tree.height > .max_height
      then {max_height: $tree.height,
            visible: (.visible + [$tree.location])}
      else .
    end)
  | .visible
  | .[]
;

def rows_visible:
  .[] | row_visible
;

[
  [inputs]
  | parse_left
  , parse_right
  , parse_top
  , parse_bottom
  | rows_visible
 ] | unique | length
