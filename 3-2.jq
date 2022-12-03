def prio:
  explode[]
  | if (. < 97) then (. - 38) else (. - 96) end
;

def intersect:
  [.[] | explode | unique] | .[0] as $left | .[0] - .[1] | $left - . |  implode
;

def badge:
  .[0] as $first | .[1] as $second | .[2] as $third |
  [
    [
      [$first, $second],
      [$second, $third],
      [$first, $third]
    ][]
  | intersect] |
  .[0] as $first_second | .[1] as $second_third | .[2] as $first_third |
  [
  [
    [$first_second, $second_third],
    [$second_third, $first_third],
    [$first_second, $first_third]
  ][] |
  intersect] | unique | first
;

# _nwise is undocumented
def triples: _nwise(3);

[[inputs] | triples | badge | prio] | add
