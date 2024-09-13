import GuessTheNumberAlgorythm
import sys
import ExcelFileUtil

gameMenuDictionary = {  "1": "Partida modo solitario",
                        "2": "Partida 2 Jugadores",
                        "3": "Estadistica",
                        "4": "Salir", }

gameDifficultyNumberOfTriesDictionary = {   "1": "Facil (20 intentos)",
                                            "2": "Media (12 intentos)",
                                            "3": "Dificil (5 intentos)" }

gameDifficultyRangeOfNumberDictionary = {   "1": "Facil (1-100)",
                                            "2": "Media (1-500)",
                                            "3": "Dificil (1-1000)" }

#MENU - Creation
def gameMenu():
    for game in gameMenuDictionary:
        print(game + ". " + gameMenuDictionary[game])

def difficultyNumberOfTriesMenu():
    for gameDifficulty in gameDifficultyNumberOfTriesDictionary:
        print(gameDifficulty + ". " + gameDifficultyNumberOfTriesDictionary[gameDifficulty])

def difficultyRangeOfNumberMenu():
    for gameDifficulty in gameDifficultyRangeOfNumberDictionary:
        print(gameDifficulty + ". " + gameDifficultyRangeOfNumberDictionary[gameDifficulty])

#MENU - Validation
def gameMenuValidation():
    return menuValidation(gameMenuDictionary)

def difficultyNumberOfTriesMenuValidation():
    optionSelected = menuValidation(gameDifficultyNumberOfTriesDictionary)
    numerbOfTries = 0

    if optionSelected == 1:
        numerbOfTries = 20
    elif optionSelected == 2:
        numerbOfTries = 12
    else:
        numerbOfTries = 5

    return numerbOfTries

def difficultyRangeOfNumberMenuValidation():
    optionSelected = menuValidation(gameDifficultyRangeOfNumberDictionary)
    maxRangeNumberToGuess = 0

    if optionSelected == 1:
        maxRangeNumberToGuess = 100
    elif optionSelected == 2:
        maxRangeNumberToGuess = 500
    else:
        maxRangeNumberToGuess = 1000

    return maxRangeNumberToGuess

def menuValidation(dictionary):
    optionSelected = 0    
    dictionaryLength = len(dictionary.keys())
    optionSelected = int(input("Por favor, escirbe una opcion entre 1 y " + str(dictionaryLength) + ": "))

    while str(optionSelected) not in dictionary.keys():
        optionSelected = int(input("La opcion elegida es incorrecta. Por favor, escribe una opcion entre 1 y " + str(dictionaryLength) + ": "))

    return optionSelected

#MENU - Selection
def menuSelection(gameOption):
    if gameOption == 1:
        difficultyNumberOfTriesMenu()
        numberOfTries = difficultyNumberOfTriesMenuValidation()
        difficultyRangeOfNumberMenu()
        maxRangeNumberToGuess = difficultyRangeOfNumberMenuValidation()
        GuessTheNumberAlgorythm.guessTheNumberAlgorythm(1, maxRangeNumberToGuess, numberOfTries)

    if gameOption == 2:
        difficultyNumberOfTriesMenu()
        numberOfTries = difficultyNumberOfTriesMenuValidation()
        difficultyRangeOfNumberMenu()
        maxRangeNumberToGuess = difficultyRangeOfNumberMenuValidation()
        GuessTheNumberAlgorythm.guessTheNumberAlgorythm(2, maxRangeNumberToGuess, numberOfTries)

    if gameOption == 3:
        nameIntroduced = filtrarEstadistica()
        print(nameIntroduced)
        excel = ExcelFileUtil.showInfo(nameIntroduced)
        restartGame()

    if gameOption == 4:
        exit()

#RESTART GAME       
def restartGame():
    gameMenu()
    gameOption = gameMenuValidation()
    menuSelection(gameOption)

#STATISTICS FILTER
def filtrarEstadistica():
    insertNameMessage = "Introduce un nombre para filtrar o pulse intro para mostrar todo el fichero: "
    nameIntroduced = input(insertNameMessage)
    return nameIntroduced
    
