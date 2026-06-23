<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to SiswaPost</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero-container { display: flex; align-items: center; justify-content: center; height: 100vh; background-color: #f8fafc; }
        .hero-card { background: white; padding: 50px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); text-align: center; max-width: 500px; border: 1px solid #e2e8f0; }
        .hero-card h1 { color: #1e3a61; margin-bottom: 10px; }
        .hero-card p { color: #64748b; margin-bottom: 30px; }
        .btn-group { display: flex; gap: 15px; justify-content: center; }
        .btn-main { padding: 12px 25px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: 0.3s; }
        .btn-login { background-color: #1e3a61; color: white; }
        .btn-register { background-color: #ffffff; color: #1e3a61; border: 1px solid #1e3a61; }
        .btn-register:hover { background-color: #f1f5f9; }
    </style>
</head>
<body>

<div class="hero-container">
    <div class="hero-card">
        <h1>SiswaPost</h1>
        <p>Student Parcel Management System</p>
        
        <div class="btn-group">
            <a href="login.jsp" class="btn-main btn-login">Login</a>
            <a href="register.jsp" class="btn-main btn-register">Register Account</a>
        </div>
        
        <%-- Check if session is active --%>
        <% if (session.getAttribute("userName") != null) { %>
            <div style="margin-top: 20px;">
                <a href="<%= "ADMIN".equals(session.getAttribute("role")) ? "admin-dashboard.jsp" : "student-dashboard.jsp" %>" 
                   
            </div>
        <% } %>
    </div>
</div>

</body>
</html>