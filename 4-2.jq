def parse:
  inputs/","        # split line by comma
  |[.[]/"-"         # split components by dash
    |[.[]           # each element in dash-split
      |tonumber]];  # to number

def bool_to_int: if . then 1 else 0 end;
def overlaps:
  .[0][1] < .[1][0]
  or
  .[0][0] > .[1][1]
  | not
;

[parse | overlaps | bool_to_int] | add
