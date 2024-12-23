edge(a, b, 2).
edge(b, a, 2).
edge(a, c, 3).
edge(c, a, 3).
edge(a, f, 4).
edge(f, a, 4).
edge(b, c, 2).
edge(c, b, 2).
edge(c, d, 3).
edge(d, c, 3).
edge(c, e, 1).
edge(e, c, 1).
edge(d, f, 5).
edge(f, d, 5).

find_path(Start, End, Cost, Path) :-
    find_path(Start, End, Cost, Path, [Start]), !.

find_path(Start, End, Cost, Path, _) :-
  edge(Start, End, Cost),
  Path = [Start, End].

find_path(Start, End, TotalCost, Path, Visited) :-
  edge(Start, X, InitCost),
  not(member(X, Visited)),
  find_path(X, End, RestCost, TailPath, [X|Visited]),
  TotalCost is InitCost + RestCost,
  Path = [Start|TailPath].

% find_path(a,d, TC, P).