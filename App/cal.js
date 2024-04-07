var table = document.getElementById("calendarTable");
var month = document.getElementById("Month");
var currentDate = new Date();
var currentMonth = currentDate.getMonth();
var currentYear = currentDate.getFullYear();
var daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();

let dateCounter = 1;
let tasks = [];

function addMonth() {
  month.innerHTML = currentDate.toLocaleString("default", { month: "long" });
}

/*function addDates() {
  for (let i = 0; i < 6; i++) {
    var week = table.insertRow();
    for (var j = 0; j < 7; j++) {
      var day = week.insertCell();
      if (i == 0 && j < new Date(currentYear, currentMonth, 1).getDay()) {
        day.innerHTML = "";
      } else if (dateCounter > daysInMonth) {
        break;
      } else {
        let eventsForDate = getTasks(Date(currentYear, currentMonth, dateCounter));
        let button = document.createElement("button");
        button.innerHTML = dateCounter;
        day.appendChild(button);
        dateCounter++;
      }
    }
  }
}*/
function addDates() {
  for (let i = 0; i < 6; i++) {
    var week = table.insertRow();
    for (var j = 0; j < 7; j++) {
      var day = week.insertCell();
      if (i == 0 && j < new Date(currentYear, currentMonth, 1).getDay()) {
        day.innerHTML = "";
      } else if (dateCounter > daysInMonth) {
        break;
      } else {
        let eventsForDate = getTasks(Date(currentYear, currentMonth, dateCounter));
        let button = document.createElement("button");
        let link = document.createElement("a");
        link.setAttribute("href", "calendar-todo.html?day=" + dateCounter); // Set href attribute to "calendar-todo.html"
        button.setAttribute("day", dateCounter);
        
        link.innerHTML = dateCounter;
        link.style.textDecoration = "none"; // Remove underline
        link.style.color = "#8b0201"; // Set color to #8b0201
        button.appendChild(link);
        day.appendChild(button);
        dateCounter++;
      }
    }
  }
}
/*
task.push(item.userID);
          task.push(item.name);
          task.push(item.desc);
          task.push(item.startDate);
          task.push(item.endDate);
          task.push(item.type);
          task.push(item.complete);

*/
function getTasks(date) {
  let schedule = [];
  tasks.forEach((item, index) => {
    let start = item.startDate.split('T')[0];
    let startArr = start.split('-');
    let startDate = new Date(startArr[0], startArr[1] - 1, startArr[2]);
    if (startDate == date) {
      schedule.push([item, index])
    }
  });
}

function updateTaskTable(tasks) {
  var table = document.getElementById("taskTable");
  tasks.forEach((item, index) => {
    if (item.type == "task") {
      var row = table.insertRow(index + 1);

      var cell1 = row.insertCell(0);
      //cell1.innerHTML = item.endDate;
      var inputString = item.endDate;
      var indexOfT = inputString.indexOf("T");

      // If 'T' is not found, return the original string as preceding and an empty string as following
      //if (indexOfT === -1) {

      //}

      // Split the string based on the index of 'T'
      var datestr = inputString.substring(0, indexOfT);
      var time = inputString.substring(indexOfT + 1);
      var hour = time.substring(0, 2);
      var minutes = time.substring(3);

      var cell2 = row.insertCell(1);
      cell2.innerHTML = item.name;

      var cell3 = row.insertCell(2);

      // Create the container for the custom checkbox
      var checkboxContainer = document.createElement("label");
      checkboxContainer.classList.add("checkbox-container");

      // Create the checkbox input element
      var checkBox = document.createElement("input");
      checkBox.type = "checkbox";
      checkBox.checked = item.complete;
      checkBox.classList.add("checkbox-style"); // Add the checkbox class

      // Create the checkmark icon span element with X
      var checkmark = document.createElement("span");
      checkmark.classList.add("checkmark");
      checkmark.innerHTML = "✕"; // X symbol

      // Append the checkbox and checkmark to the container
      checkboxContainer.appendChild(checkBox);
      checkboxContainer.appendChild(checkmark);

      // Append the container to the cell
      cell3.appendChild(checkboxContainer);
    }
  });
}

function loadTasks() {
  window.onload = function () {
    fetch(
      "https://gqn16jjel6.execute-api.us-east-2.amazonaws.com/serverless_lambda_stage/getTask?userID=user123",
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => {
        if (!response.ok) {
          throw new Error("Error");
        }
        return response.json();
      })
      .then((data) => {
        console.log("got data: ", data);
        tasks = data;
        console.log(tasks);
      })
      .catch((error) => {
        console.log("Error: ", error);
      });
  };
}

loadTasks();
addMonth();
addDates();
