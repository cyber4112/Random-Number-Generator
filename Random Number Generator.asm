INCLUDE Irvine32.inc

.data
welcomeMsg      BYTE "       ==========WELCOME========= ", 0
namePrompt      BYTE "What's your Name : ", 0
playerName      BYTE 20 DUP (?)
rangePrompt     BYTE "Choose a range (e.g., enter 10 for range 1-10): ", 0
startMsg        BYTE "I have selected a random number between 1 and ", 0
guessPrompt     BYTE "Enter your guess: ", 0
highMsg         BYTE "Your guess is too high.", 0
lowMsg          BYTE "Your guess is too low.", 0
correctMsg      BYTE "Congratulations! You guessed the correct number: ", 0
wrongMsg        BYTE "Sorry, that's not correct. The number was: ", 0
tryAgainMsg     BYTE "Do you want to play again? (0 for yes, 1 for no): ", 0
goodbyeMsg      BYTE "Thanks for playing! Goodbye.", 0
newline         BYTE 13, 10, 0  ; Carriage return and newline
bestScoreMsg    BYTE "Your best score (fewest guesses): ", 0
bestScore       DWORD 999  ; Start with a high score (impossible score)
.code

main PROC
    ; Welcome message
    mov edx, OFFSET welcomeMsg
    call WriteString
    mov edx, OFFSET newline
    call WriteString

    ; Get player's name
    mov edx, OFFSET namePrompt
    call WriteString
    lea edx, playerName
    mov ecx, SIZEOF playerName
    call ReadString

    ; Main game loop
gameLoop:
    ; Choose range for the game
    mov edx, OFFSET rangePrompt
    call WriteString
    call ReadInt
    mov esi, eax  ; Store the chosen range in ESI

    ; Generate random number between 1 and chosen range
    call Randomize
    mov eax, esi
    call RandomRange
    inc eax  ; Make it 1 to chosen range
    mov ebx, eax  ; Store the random number in EBX

    ; Inform the player about the game
    mov edx, OFFSET startMsg
    call WriteString
    mov eax, esi
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Initialize guess count
    mov ecx, 0  ; ECX will count the number of guesses

    ; Player's guess loop
guessLoop:
    ; Get player's guess
    mov edx, OFFSET guessPrompt
    call WriteString
    call ReadInt
    inc ecx  ; Increment guess count

    ; Check if the guess is correct
    cmp eax, ebx
    je correctGuess

    ; Provide hint
    cmp eax, ebx
    jl tooLow
    mov edx, OFFSET highMsg
    call WriteString
    jmp guessLoop

tooLow:
    mov edx, OFFSET lowMsg
    call WriteString
    jmp guessLoop

correctGuess:
    ; If guess is correct
    mov edx, OFFSET correctMsg
    call WriteString
    mov eax, ebx
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Update best score if this attempt is better
    cmp ecx, bestScore
    jge displayScore
    mov bestScore, ecx

displayScore:
    ; Display the best score
    mov edx, OFFSET bestScoreMsg
    call WriteString
    mov eax, bestScore
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

askToPlayAgain:
    ; Ask the player if they want to play again
    mov edx, OFFSET tryAgainMsg
    call WriteString
    call ReadInt
    cmp eax, 0
    je gameLoop

    ; If player chooses not to play again, end the game
    mov edx, OFFSET goodbyeMsg
    call WriteString
    mov edx, OFFSET newline
    call WriteString

    INVOKE ExitProcess, 0

main ENDP
END main