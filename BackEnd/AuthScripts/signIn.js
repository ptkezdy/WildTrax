const AmazonCognitoIdentity = require('amazon-cognito-identity-js');

// Cognito User Pool Id and App Client ID
const poolData = {
    UserPoolId: 'us-east-2_PbmKiUp9w', 
    ClientId: '5mqnor5ufuojmi9c8q7dq9tfm0', 
};

const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

document.getElementById('signIn').addEventListener('submitBtn', function(event) {
    event.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    const authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails({
        Username: username,
        Password: password,
    });

    const userData = {
        Username: username,
        Pool: userPool,
    };
    const cognitoUser = new AmazonCognitoIdentity.CognitoUser(userData);
    
    cognitoUser.authenticateUser(authenticationDetails, {
        onSuccess: function(result) {

            // Storing tokens in sessionStorage
            sessionStorage.setItem('accessToken', result.getAccessToken().getJwtToken());
            sessionStorage.setItem('idToken', result.getIdToken().getJwtToken()); 


            const sub = result.idToken.payload.sub;
            sessionStorage.setItem('userSub', sub); // used for get/put requests 

            console.log('Sign-in successful!');
            window.location.href = "calendar.html";

        },
        onFailure: function(err) {
            console.error('Sign-in failed:', err);
            alert('Sign-in failed: ', err)
        },
    });
});

