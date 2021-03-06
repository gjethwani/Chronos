<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% int noOfDays = (int)request.getAttribute("noOfDays");
	int startDay = (int)request.getAttribute("startDay");
	int startMonth = (int)request.getAttribute("startMonth");
	int startYear = (int)request.getAttribute("startYear"); 
	int startHour = (int)request.getAttribute("startHour");
	String startTimeOfDay = (String)request.getAttribute("startTimeOfDay");
	int noOfHours = (int)request.getAttribute("noOfHours"); 
	String endpoint = "'UpdateAvailability'"; 
	String meetingId = (String)request.getAttribute("meetingID");
	meetingId = "'" + meetingId + "'";
	String type = (String)request.getAttribute("userType");
	type = "'" + type + "'";
	String username = (String)request.getAttribute("username");
	username = "'" + username + "'";
	/*String userId = (String)request.getAttribute("hostId");
	if(userId == null){
		userId = (String)request.getAttribute("guestId");
	}
	userId = "'" + userId + "'";*/
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
		<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-colors-signal.css">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Chronos</title>
		<link rel="stylesheet" type="text/css" href="selectTimes.css">
		<style>
			.deselected:hover {
				background-color: #a12613;
			}
		</style>
	</head>
	<body onload="connectToServer()" class="w3-container w3-margin w3-animate-opacity">
		<img src="CF_Logo_OnWhite.png" alt="Logo" class="w3-image" style="width: 50%; max-width:400px">
		<p>Please select when you're NOT available.</p>
		<div id="tableContainer"></div>
		<table id="dateTable"></table>
		<br>
		<input type="button" value="Submit" onclick="send()" class="w3-button w3-signal-red w3-round-large">	
	</body>
	<script>

	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/Project_Chronos/ws");
		socket.onopen = function(event) {
			// document.getElementById("dummy").innerHTML += "Connected!";
		}
		socket.onmessage = function(event) {
			document.getElementById("dummy").innerHTML += event.data + "<br />";
		}
		socket.onclose = function(event) {
			// document.getElementById("dummy").innerHTML += "Disconnected!";
		}
	}
		Date.prototype.addDays = function(days) {
			  var newDate = new Date(this.valueOf());
			  newDate.setDate(newDate.getDate() + days);
			  return newDate;
		}
		var selectedIndexes = [];
		var toSend = "";
		function send() {
			for (var i = 0; i < noOfDays * noOfHours; i++) {
				var one = false;
				for (var j = 0; j < selectedIndexes.length; j++) {
					if (selectedIndexes[j] === i.toString()) {
						one = true;
					}
				}
				if (one) {
					toSend += "1";
				} else {
					toSend += "0";
				}
				toSend += ",";
			}
			socket.send("<%= username %>" + " just updated availability info");
	       // var xhttp = new XMLHttpRequest();
	        //xhttp.send();
	        //window.location = 'GuestEnd.jsp';
	         document.location.href= <%= endpoint %> + "?meetingId=" + <%= meetingId %> + "&username=" + <%=username%>+ "&freeTimes=" + toSend + "&userType=" + <%=type%>; 
	        return;
		}
		function convertDateIntToString(dateInt) {
			switch (dateInt) {
				case 1:
					return "Mon";
				case 2:
					return "Tue";
				case 3:
					return "Wed";
				case 4:
					return "Thu";
				case 5:
					return "Fri";
				case 6:
					return "Sat";
				case 0:
					return "Sun";
			}
		}
		function convertMonthIntToString(monthInt) {
			switch (monthInt) {
				case 0:
					return "Jan";
				case 1:
					return "Feb";
				case 2:
					return "Mar";
				case 3:
					return "Apr";
				case 4:
					return "May";
				case 5:
					return "Jun";
				case 6:
					return "Jul";
				case 7:
					return "Aug";
				case 8:
					return "Sep";
				case 9:
					return "Oct";
				case 10:
					return "Nov";
				case 11:
					return "Dec";
			}
		}
		var selectedBackgroundColour = "darkred";
		var unselectedBackgroundColour = "white";
		var noOfDays = <%= noOfDays %>;
		var startDate = new Date(<%= startYear %>, <%= startMonth %>, <%= startDay %>);
		for (var i = -1; i < noOfDays; i++) {
			var currDate = startDate.addDays(i);
			
			var th = document.createElement("th");
			if (i === -1) {
				th.appendChild(document.createElement("tr"));
				document.getElementById("dateTable").appendChild(th);
				continue;
			}
			
			var trDayOfWeek = document.createElement("tr");
			trDayOfWeek.classList.add("dateHeaders");
			var tdDayOfWeek = document.createElement("td");
			tdDayOfWeek.classList.add("dateHeaders");
			var textDayOfWeek = document.createTextNode(convertDateIntToString(currDate.getDay()));
			tdDayOfWeek.appendChild(textDayOfWeek);
			trDayOfWeek.appendChild(tdDayOfWeek);
			
			var trDate = document.createElement("tr");
			trDate.classList.add("dateHeaders");
			var tdDate = document.createElement("td");
			tdDate.classList.add("dateHeaders");
			var textDate = document.createTextNode(currDate.getDate());
			tdDate.appendChild(textDate);
			trDate.appendChild(tdDate);
			
			var trMonth = document.createElement("tr");
			trMonth.classList.add("dateHeaders");
			var tdMonth = document.createElement("td");
			tdMonth.classList.add("dateHeaders");
			var textMonth = document.createTextNode(convertMonthIntToString(currDate.getMonth()));
			tdMonth.appendChild(textMonth);
			trMonth.appendChild(tdMonth);
			
			th.appendChild(trDayOfWeek);
			th.appendChild(trDate);
			th.appendChild(trMonth);
			
			document.getElementById("dateTable").appendChild(th);
		}
		var startHour = <%= startHour %>;
		var startTimeOfDay = "<%= startTimeOfDay %>";
		var noOfHours = <%= noOfHours %>;
		var indexOfCells = 0;
		for (var k = 0; k < noOfHours; k++) {
			var trTime = document.createElement("tr");
			for (var j = 0; j < noOfDays + 1; j++) {
				var tdTime = document.createElement("td");
				if (j === 0) {
					tdTime.className = "doNotClick";
					var hourToOutput = startHour + k;
					if (hourToOutput >= 12) {
						hourToOutput = hourToOutput % 12;
						if (hourToOutput === 0) {
							hourToOutput = 12;
							if (startTimeOfDay === "am") {
								startTimeOfDay = "pm";
							} 
							else {
								startTimeOfDay = "am";
							}
						}
					}
					var tdText = document.createTextNode((hourToOutput).toString() + startTimeOfDay);
					tdTime.appendChild(tdText);
				} else {
					tdTime.id = indexOfCells;
				//	tdTime.style.backgroundColor = unselectedBackgroundColour;
					tdTime.className = "deselected";
					//tdTime.onclick = timeClicked(tdTime.id);
					indexOfCells += 1;
				}
				trTime.appendChild(tdTime);
			}
			document.getElementById("dateTable").appendChild(trTime);
		}
		var cells = document.querySelectorAll("td");
		for (var i = 0; i < cells.length; i++) {
		    cells[i].addEventListener("click", function() {
		    	   if (this.className != "doNotClick") {
		    		   if (this.className === "deselected") {
		    			   selectedIndexes.push(this.id);
		    		   } else {
		   			   var index = selectedIndexes.indexOf(this.id);
					   if (index > -1) {
					   	   selectedIndexes.splice(index, 1);
					   }
		    		   }
		    		   this.className= this.className == "deselected" ? "selected" : "deselected";
		    	   }
		    });
		}
	</script>
</html>
