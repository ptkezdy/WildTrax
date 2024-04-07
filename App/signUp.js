document.getElementById("signUp").addEventListener("submit", function (event) {
  event.preventDefault();
  if (checkPassword()){
    handleFormData();
  } else {
    alert("Passwords dont match goofy")
  }
  
});


function checkPassword() {
  console.log('checking')
  var password = document.getElementById("password").value;
  var confirm = document.getElementById("confirmPassword").value;
  
  if (confirm === password){
    return true 
  } else {
    return false 
  }
}

function handleFormData() {
  
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;
  
  
  
  var data = JSON.stringify({
    email: email,
    password: password,
  });

  fetch("https://gqn16jjel6.execute-api.us-east-2.amazonaws.com/serverless_lambda_stage/signUp", { // replace with api url from the env file
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: data,
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("Network Error");
      }
      return response.json();
    })
    .then((data) => {
      console.log("Success");
      window.location.href = "calendar.html";

    })
    .catch((error) => {
      console.log("Error: ", error);
      // display error message
    });
    
}

