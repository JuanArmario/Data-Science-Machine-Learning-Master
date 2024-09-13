import random
import MenuModule
import getpass
import ExcelFileUtil

def guessTheNumberAlgorythm(gameMOde, maxRangeNumberToGuess, maxNumberOfTries):
    randomNumber = 0
    isNumberFound = False
    numberOfTries = maxNumberOfTries

    if gameMOde == 1:
        randomNumber = random.randint(1, maxRangeNumberToGuess)
    else:
        randomNumber = numberValidation(maxRangeNumberToGuess)
        
    print(randomNumber)
    print(maxNumberOfTries)

    while not isNumberFound and numberOfTries != 0:
        insertOptionMessage = "Intenta adivinar el numero: "
        numberIntroduced = int(input(insertOptionMessage))

        print(numberIntroduced)
        print(randomNumber)

        numberOfTries -= 1 
        isNumberFound = numberIntroduced == randomNumber 

        if isNumberFound:
            print("Has ganado!!!")
            saveGameData('W')
            MenuModule.restartGame()
            break
        else:
            greaterOrSmallerString = "mayor" if numberIntroduced < int(randomNumber) else "menor"

        if numberOfTries == 0:
            print("GAME OVER. Numero maximo de intentos alcanzado")
            saveGameData('L')
            MenuModule.restartGame()
            break

        print("El numero que intentas adivinar es " + greaterOrSmallerString)


def numberValidation(maxRangeNumberToGuess):
    insertOptionMessage = "Inserta un numero a adivinar entre 1 y " + str(maxRangeNumberToGuess) + " "
    numeroSelected = getpass.getpass(prompt = insertOptionMessage)
    while not numeroSelected.isdigit() or int(numeroSelected) > maxRangeNumberToGuess:
        numeroSelected = getpass.getpass(prompt = "El numero introducido es incorrecto. Por favor, escribe un numero entre 1 y " + str(maxRangeNumberToGuess) + ": ")

    return int(numeroSelected)

def saveGameData(result):
    nameIntroduced = nameValidation()
    ExcelFileUtil.addGameResult(nameIntroduced, result)

def nameValidation():
    insertNameMessage = "Introduce tu nombre: "
    nameIntroduced = input(insertNameMessage)
    while nameIntroduced == "":
        nameIntroduced = input("Por favor introduzca nu nombre valido ")

    return nameIntroduced
    