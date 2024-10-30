victim(mr_boddy).
victim(cook).
victim(motorist).
victim(police_officer).
victim(yvette).
victim(singing_telegram).

suspect(professor_plum).
suspect(mrs_peacock).
suspect(mrs_white).
suspect(miss_scarlet).
suspect(colonel_mustard).
suspect(mr_green).
suspect(wadsworth).

weapon(wrench).
weapon(candlestick).
weapon(lead_pipe).
weapon(knife).
weapon(revolver).
weapon(rope).

room(hall).
room(kitchen).
room(lounge).
room(library).
room(billiard_room).

murder(mr_boddy,candlestick,hall).
murder(cook,knife,kitchen).
murder(motorist,wrench,lounge).
murder(police_officer,lead_pipe,library).
murder(singing_telegram,revolver,hall).
murder(yvette,rope,billiard_room).


% Update accuse to solve the murders.
% Add more facts and rules as needed.
accuse(V,S) :- murder(V,W,R), suspect(S), 
                motive(V,S), weapon(W, S), 
                room(R,S), not(alibi(S,V)).

% *The cook had worked for Mrs. Peacock, and had stolen money from her.
% *The motorist was blackmailing Colonel Mustard.
% *Yvette had worked for Miss Scarlet's brothel before, and left on bad terms.
% *Yvette and Colonel Mustard had formerly had an affair, and she was threatening to tell his wife.
% *Mrs. White knew that Yvette was also having an affair with her husband.
% *Miss Scarlet had been bribing the police officer to keep him from arresting her.
% *Professor Plum had lost his license as a psychiatrist after having an affair with his patient, who turns out to be the singing telegram.
% *Wadsworth has an unnatural hatred for singing telegrams.

motive(mr_boddy, S) :- suspect(S), S \= wadsworth.
motive(cook, mrs_peacock).
motive(motorist, colonel_mustard).
motive(yvette, miss_scarlet).
motive(yvette, colonel_mustard).
motive(yvette, mrs_white).
motive(police_officer, miss_scarlet).
motive(singing_telegram, professor_plum).
motive(singing_telegram, wadsworth).

weapon(knots, S) :- suspect(S), S \= colonel_mustard.
weapon(guns, S) :- suspect(S), S \= professor_plum.
weapon(candlestick, S) :- suspect(S), S \= mrs_peacock.
weapon(W, S) :- weapon(W),suspect(S).

not_in_room(billiard_room, S) :- suspect(S), S = miss_scarlet.
not_in_room(kitchen, S) :- suspect(S), S = professor_plum.
not_in_room(R,S) :- suspect(S), murder(mr_boddy,_,R), S = colonel_mustard.
room(R,S) :- room(R), suspect(S), not(not_in_room(R,S)).

alibi(mrs_white, mr_boddy).
alibi(mr_green, Victim) :- murder(Victim, _, _).
alibi(miss_scarlet, Victim) :-
    murder(_, revolver, Room), murder(Victim, _, Room).