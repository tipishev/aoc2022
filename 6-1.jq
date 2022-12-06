def has_no_dupes: . | explode | (. | length) == (. | unique | length);
def rolling_window:
  . as $input
  | length as $len
  | range(0, $len - 4)
  | [. + 4, $input[.:. + 4]]
;
def select_no_dupes:
  select(.[1] | has_no_dupes)
;

[inputs | rolling_window | select_no_dupes] | .[0][0]
