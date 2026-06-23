package controller;

import dao.NotificationDAO;
import model.Notification;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO dao;

    public void init() {
        dao = new NotificationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("delete".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                dao.deleteNotification(id);
            } 
            else if ("markRead".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                dao.updateStatus(id, "READ");
            }
            else if ("read".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                dao.updateStatus(id, "READ");
            }
            
            // Redirect back to notifications page
            String referer = request.getHeader("referer");
            if (referer != null && referer.contains("notifications.jsp")) {
                response.sendRedirect("notifications.jsp");
            } else {
                response.sendRedirect("notifications.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("notifications.jsp?error=1");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Notification n = new Notification();
            n.setMatricNo(request.getParameter("matric_no"));
            n.setParcelId(request.getParameter("parcel_id"));
            n.setNotificationType(request.getParameter("notification_type"));
            n.setMessage(request.getParameter("message"));
            n.setNotificationStatus("UNREAD");

            dao.addNotification(n);
            response.sendRedirect("notifications.jsp?success=added");
        } else {
            response.sendRedirect("notifications.jsp");
        }
    }
}