# Falling Words Challenge

## Game play and mechanics:
- In the beginning, player will see a `play` button
- After pressing `play` button and 2 secs delay, a word (custom widget) moves from top to bottom.
- In the bottom of screen there are three widget. Comparable word, `Correct` and `Wrong` buttons.
- Player has a few second to decide and select if the moving word is correct translation of the bottom word or no.
- After the moving words reach to the bottom, selection borders and moving object reset.
- Regarding to the Player answer, a minimal score board shows the score.
- Game will finish if player reply by 3 wrong or 3 empty answeres. the other case is total 10 answers (addition of correct, wrong and not answered).
- After the game finished, a play button shown to engage player re-play or simply quit the app.
- Random words generator algorithm, works 50-50% probablility of correct or wrong pair. First it decides should it be a correct pair or wrong one. 
- If in the randome word generator algorithm, the value is false (i.e. we need to generate a wrong pair and player should select `wrong` button to get the score), it will randomly choose another element in the words list, except itself.

## Time investing:
- Whole process took almost 7 hours.
- Most time consuming parts were animation and game mechanics (refresh the animation) (almost 80%).
- One of the specific decisions made during implementation, was how to end the game. 
- Regardless of UI/UX, landscape mode has a room to improve (Time restriction) and it's first thing I would like to improve.

