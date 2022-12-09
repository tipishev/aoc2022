def has_no_dupes: . | explode | (. | length) == (. | unique | length);
def rolling_window:
  . as $input
  | length as $len
  | range(0, $len - 14)
  | [. + 14, $input[.:. + 14]]
;
def first_no_dupes:
  [.[] | select(.[1] | has_no_dupes)][0][0]
;

inputs | rolling_window | first_no_dupes
