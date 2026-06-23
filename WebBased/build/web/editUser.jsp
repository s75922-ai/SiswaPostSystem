<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("userManagement.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User | SiswaPost</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-brand-title">SiswaPost</div>
            <div class="sidebar-brand-sub">Smart Parcel System</div>
        </div>
        <ul class="sidebar-menu">
            <li class="sidebar-item"><a href="adminDashboard.jsp">Dashboard</a></li>
            <li class="sidebar-item"><a href="parcelManagement.jsp">Parcel Management</a></li>
            <li class="sidebar-item active"><a href="userManagement.jsp">User Management</a></li>
            <li class="sidebar-item"><a href="notifications.jsp">Notifikasi</a></li>
        </ul>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <div class="main-container">
        <div class="top-navbar">
            <span>Selamat Datang, <strong><%= userName != null ? userName : "Admin" %></strong></span>
        </div>
        <div class="main-content">
            <h2 class="page-title-heading">Edit Pengguna</h2>
            <p class="page-subtitle-text">Kemaskini maklumat pengguna.</p>

            <div class="data-section" style="max-width:600px; margin:0 auto;">
                <form action="UserServlet" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                    
                    <div class="modal-input-group" style="margin-bottom:15px;">
                        <label>Nama Penuh</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:6px;">
                    </div>
                    
                    <div class="modal-input-group" style="margin-bottom:15px;">
                        <label>No. Matrik</label>
                        <input type="text" name="matricNo" value="<%= user.getMatricNo() %>" required style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:6px;">
                    </div>
                    
                    <div class="modal-input-group" style="margin-bottom:15px;">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= user.getEmail() %>" required style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:6px;">
                    </div>
                    
                    <div class="modal-input-group" style="margin-bottom:15px;">
                        <label>Role</label>
                        <select name="role" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:6px;">
                            <option value="student" <%= "student".equals(user.getRole()) ? "selected" : "" %>>Student</option>
                            <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>
                    
                    <div class="modal-input-group" style="margin-bottom:15px;">
                        <label>Status</label>
                        <select name="status" style="width:100%; padding:10px; border:1px solid #e2e8f0; border-radius:6px;">
                            <option value="active" <%= "active".equals(user.getStatus()) ? "selected" : "" %>>Active</option>
                            <option value="inactive" <%= "inactive".equals(user.getStatus()) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>
                    
                    <div style="display:flex; gap:10px; margin-top:20px;">
                        <button type="submit" class="primary-btn">Kemaskini</button>
                        <a href="userManagement.jsp" class="modal-btn" style="background:#e2e8f0; color:#475569; padding:10px 20px; border-radius:8px; text-decoration:none;">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>