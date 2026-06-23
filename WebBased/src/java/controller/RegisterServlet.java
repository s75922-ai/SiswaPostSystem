package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form data
        String fullName = request.getParameter("fullName");
        String matricNo = request.getParameter("matricNo");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "student";

        // DEBUG: Print to server console
        System.out.println("=== REGISTER DEBUG ===");
        System.out.println("fullName: " + fullName);
        System.out.println("matricNo: " + matricNo);
        System.out.println("email: " + email);
        System.out.println("password: " + password);
        System.out.println("======================");

        // Validate input
        if (fullName == null || fullName.trim().isEmpty() ||
            matricNo == null || matricNo.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            System.out.println("❌ Validation failed: Missing fields");
            response.sendRedirect("register.jsp?error=missing");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            System.out.println("✅ Database connected successfully");
            
            // Check if user already exists
            String checkSql = "SELECT * FROM users WHERE matricNo = ? OR email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, matricNo.trim());
            checkPs.setString(2, email.trim());
            java.sql.ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                System.out.println("❌ User already exists: " + matricNo);
                response.sendRedirect("register.jsp?error=exists");
                return;
            }

            // Insert new user
            String sql = "INSERT INTO users (fullName, matricNo, email, password, role, status) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fullName.trim());
            ps.setString(2, matricNo.trim());
            ps.setString(3, email.trim());
            ps.setString(4, password.trim());
            ps.setString(5, role);
            ps.setString(6, "active");

            int result = ps.executeUpdate();
            System.out.println("✅ Insert result: " + result + " row(s) affected");
            
            if (result > 0) {
                response.sendRedirect("index.jsp?success=registered");
            } else {
                System.out.println("❌ Insert failed - 0 rows affected");
                response.sendRedirect("register.jsp?error=failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception in RegisterServlet:");
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=failed");
        }
    }
}