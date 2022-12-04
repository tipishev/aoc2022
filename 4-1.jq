def parse:inputs/","|[.[]/"-"|[.[]|tonumber]];

def fully_contains:
((.[0][0] >= .[1][0]) and (.[0][1] <= .[1][1]))
or
((.[1][0] >= .[0][0]) and (.[1][1] <= .[0][1]))
;

def bool_to_int: if . then 1 else 0 end;

[parse | fully_contains | bool_to_int] | add
