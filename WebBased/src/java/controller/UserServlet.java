package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO dao;

    public void init() {
        dao = new UserDAO();
    }

    // =========================
    // DO GET - For Delete, Edit, View
    // =========================
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("delete".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                dao.deleteUser(id);
                response.sendRedirect("userManagement.jsp?success=deleted");
            }
            else if ("edit".equals(action) && idParam != null) {
                int id = Integer.parseInt(idParam);
                User user = dao.getUserById(id);
                request.setAttribute("user", user);
                request.getRequestDispatcher("editUser.jsp").forward(request, response);
            }
            else {
                response.sendRedirect("userManagement.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userManagement.jsp?error=1");
        }
    }

    // =========================
    // DO POST - For Add, Update
    // =========================
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName");
                String matricNo = request.getParameter("matricNo");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                // Validate
                if (fullName == null || matricNo == null || email == null || password == null) {
                    response.sendRedirect("userManagement.jsp?error=missing_fields");
                    return;
                }

                // Check if user exists
                if (dao.userExists(matricNo.trim(), email.trim())) {
                    response.sendRedirect("userManagement.jsp?error=exists");
                    return;
                }

                User u = new User();
                u.setFullName(fullName.trim());
                u.setMatricNo(matricNo.trim());
                u.setEmail(email.trim());
                u.setPassword(password.trim());
                u.setRole(role != null ? role : "student");
                u.setStatus("active");

                dao.addUser(u);
                response.sendRedirect("userManagement.jsp?success=added");
            }
            else if ("update".equals(action)) {
                String idParam = request.getParameter("userId");
                if (idParam == null) {
                    response.sendRedirect("userManagement.jsp?error=missing_id");
                    return;
                }

                int userId = Integer.parseInt(idParam);
                User u = dao.getUserById(userId);
                
                if (u == null) {
                    response.sendRedirect("userManagement.jsp?error=user_not_found");
                    return;
                }

                u.setFullName(request.getParameter("fullName"));
                u.setMatricNo(request.getParameter("matricNo"));
                u.setEmail(request.getParameter("email"));
                u.setRole(request.getParameter("role"));
                u.setStatus(request.getParameter("status"));

                dao.updateUser(u);
                response.sendRedirect("userManagement.jsp?success=updated");
            }
            else {
                response.sendRedirect("userManagement.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userManagement.jsp?error=1");
        }
    }
}