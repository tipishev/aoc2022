def parse: [.[] | (split(" ") | [first, (last | tonumber)])];

def expand:
  reduce .[] as [$direction, $count]
  ([]; . + [$direction * $count | split("")] | flatten)
;

[inputs] | parse | expand
