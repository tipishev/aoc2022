# [inputs]

def prio:
  explode[]
  | if (. < 97) then (. - 38) else (. - 96) end
;

def halv:
  (. | length | . / 2) as $middle |
  [.[:$middle], .[$middle:]]
;

def both:
  [.[] | explode | unique] | .[0] as $left | .[0] - .[1] | $left - . |  implode
;


[inputs | halv | both | prio] | add
