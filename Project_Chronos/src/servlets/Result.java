package servlets;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import objectFiles.Meeting;
import objectFiles.User;

/**
 * Servlet implementation class Result
 */
@WebServlet("/Result")
public class Result extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Meeting mt = (Meeting) request.getAttribute("meeting");
		User user = (User) request.getAttribute("user");
		
		request.setAttribute("noOfDays", mt.getNumDays());
		Date date = mt.getStartDate();
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int month = cal.get(Calendar.MONTH);
		int year = cal.get(Calendar.YEAR);
		year = year % 2000;
		request.setAttribute("startDay", day);
		request.setAttribute("startMonth", month);
		request.setAttribute("startYear", year);
		int hour = mt.getStartTime();
		if (hour >= 12) {
			hour = hour % 12;
			request.setAttribute("startHour", hour);
			request.setAttribute("startTimeOfDay", "pm");
		}
		else {
			request.setAttribute("startHour", hour);
			request.setAttribute("startTimeOfDay", "am");
		}
		request.setAttribute("noOfHours", mt.getNumHoursPerDay());
		request.setAttribute("responsesSoFar", mt.getUsersAnsweredToString());
		request.setAttribute("responseTimes", mt.getResponseTimes());

		
		
	
	}
}