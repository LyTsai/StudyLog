const myHeading = document.querySelector('h1');
myHeading.textContent = 'Hello world!';

// java script
let randomNumber = Math.floor(Math.random() * 100) + 1;
const guesses = document.querySelector(".guesses");
const lastResult = document.querySelector(".lastResult");
const lowOrHigh = document.querySelector(".lowOrHigh");

const guessSubmit = document.querySelector(".guessSubmit");
const guessField = document.querySelector(".guessField");
guessSubmit.addEventListener("click", checkGuess);

let guessCount = 1;
let resetButton;

function checkGuess() {
  let userGuess = Number(guessField.value);
  if (guessCount === 1) {
    guesses.textContent = "Last guess: ";
  }
  guesses.textContent += userGuess + " ";
  
  if (userGuess === randomNumber) {
    lastResult.textContent = "Congratulations";
    lastResult.style.backgroundColor = "green";
    setGameOver();
  } else if (guessCount === 10) {
    lastResult.textContent = "!!!!Game Over!!!!";
    setGameOver();
  }else {
    if (userGuess < randomNumber) {
      lastResult.textContent = "Too low";
    }else {
      lastResult.textContent = "Too high";
    }
    lastResult.style.backgroundColor = 'red';
  }

  guessCount++;
  guessField.value = "";
  guessField.focus();
}



function setGameOver() {
  
  guessField.disabled = true;
  guessSubmit.disabled = true;
  // if (resetButton) {
    
  // }
  resetButton = document.createElement("button");
  resetButton.textContent = "Restart";
  document.body.appendChild(resetButton)
  resetButton.addEventListener("click", resetGame);
}

function resetGame() {
  guessCount = 1;

  const resetParas = document.querySelectorAll('.resultParas p');
  for (let i = 0 ; i < resetParas.length; i++) {
    resetParas[i].textContent = '';
  }

  resetButton.parentNode.removeChild(resetButton);

  guessField.disabled = false;
  guessSubmit.disabled = false;
  guessField.value = '';
  guessField.focus();
  lastResult.style.backgroundColor = 'white';
  lastResult.textContent = "";
  randomNumber = Math.floor(Math.random() * 100) + 1;
}


let myImage = document.querySelector('img');
myImage.onclick = () => {
    let imageSrc = myImage.getAttribute('src');
    if (imageSrc === 'images/icon0.png') {
        myImage.setAttribute('src', 'images/icon1.png');
    }else {
        myImage.setAttribute('src', 'images/icon0.png');
    }
};

let myButton = document.querySelector('button');
myButton.onclick = function() {
    setUserName();
}

function setUserName() {
    let myName = prompt('Please Enter your Name:');
    if (!myName) {
        setUserName();
    }else {
        localStorage.setItem('name', myName)
        myHeading.textContent = 'Hello' + myName;
    }
}