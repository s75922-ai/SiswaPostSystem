<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, dao.UserDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    UserDAO userDao = new UserDAO();
    List<User> userList = userDao.getAllUsers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management | SiswaPost</title>
    <link rel="stylesheet" href="style.css">
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
            <h2 class="page-title-heading">User Management</h2>
            <p class="page-subtitle-text">Uruskan semua pengguna sistem di sini.</p>

            <div class="data-section">
                <div class="section-header-panel">
                    <div class="stats-counter-badge-row">
                        <strong>Jumlah Pengguna: <%= userList.size() %></strong>
                    </div>
                    <button class="primary-btn" onclick="openAddUserModal()">+ Tambah Pengguna</button>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nama Penuh</th>
                            <th>No. Matrik</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (userList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align:center; padding:40px; color:#94a3b8;">
                                    Tiada pengguna untuk dipaparkan.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (User u : userList) {
                        %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getMatricNo() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getRole() %></td>
                            <td>
                                <span class="badge <%= "active".equals(u.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                    <%= u.getStatus() != null ? u.getStatus().toUpperCase() : "INACTIVE" %>
                                </span>
                            </td>
                            <td class="actions-cell">
                                <a href="UserServlet?action=edit&id=<%= u.getUserId() %>" title="Edit">✏️</a>
                                <a href="UserServlet?action=delete&id=<%= u.getUserId() %>" title="Padam" onclick="return confirm('Padam pengguna ini?')">🗑️</a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal-overlay">
        <div class="modal-card">
            <h3>Tambah Pengguna Baru</h3>
            <form action="UserServlet" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-grid">
                    <div class="modal-input-group full-width">
                        <label>Nama Penuh</label>
                        <input type="text" name="fullName" placeholder="Masukkan nama penuh" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>No. Matrik</label>
                        <input type="text" name="matricNo" placeholder="Masukkan no. matrik" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Email</label>
                        <input type="email" name="email" placeholder="Masukkan email" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Password</label>
                        <input type="password" name="password" placeholder="Masukkan password" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Role</label>
                        <select name="role" required>
                            <option value="student">Student</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer-actions">
                    <button type="button" onclick="closeAddUserModal()" class="modal-btn" style="background:#e2e8f0; color:#475569;">Batal</button>
                    <button type="submit" class="modal-btn submit-btn-blue">Tambah</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddUserModal() {
            document.getElementById('addUserModal').classList.add('active');
        }
        function closeAddUserModal() {
            document.getElementById('addUserModal').classList.remove('active');
        }
        window.onclick = function(event) {
            var modal = document.getElementById('addUserModal');
            if (event.target == modal) {
                modal.classList.remove('active');
            }
        }
    </script>
</body>
</html>