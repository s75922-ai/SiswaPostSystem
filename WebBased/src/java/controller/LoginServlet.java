package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // DEBUG
        System.out.println("=== LOGIN DEBUG ===");
        System.out.println("Username: " + user);
        System.out.println("Password: " + pass);
        System.out.println("==================");

        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            System.out.println("✅ DB Connected");
            
            // QUERY - Check both matricNo and email
            String sql = "SELECT * FROM users WHERE (matricNo = ? OR email = ?) AND password = ? AND status = 'active'";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user.trim());
            ps.setString(2, user.trim());
            ps.setString(3, pass.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                System.out.println("✅ User found: " + user);
                
                HttpSession session = request.getSession();
                String matricNo = rs.getString("matricNo");
                String role = rs.getString("role");
                String fullName = rs.getString("fullName");

                session.setAttribute("user", matricNo);
                session.setAttribute("role", role);
                session.setAttribute("matricNo", matricNo);
                session.setAttribute("userName", fullName);

                System.out.println("✅ Session created - Role: " + role);
                System.out.println("✅ Redirecting to: " + ("admin".equalsIgnoreCase(role) ? "adminDashboard.jsp" : "studentDashboard.jsp"));

                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("studentDashboard.jsp");
                }
            } else {
                System.out.println("❌ User NOT found for: " + user);
                response.sendRedirect("login.jsp?error=1");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Login Error:");
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=1");
        }
    }
}