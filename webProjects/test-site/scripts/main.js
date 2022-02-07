const myHeading = document.querySelector('h1');
myHeading.textContent = 'Hello world!';

// let myHTML = document.querySelector('html');
// myHTML.addEventListener('click', function() {
//     alert('ouch! Stop poking me!');
// });
// document.querySelector('html').addEventListener("click", function() {
//     alert('ouch! Stop poking me!');
// });

// document.querySelector('html').addEventListener('click', ()=> {
//     alert('ouch! Stop poking me!');
// });


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