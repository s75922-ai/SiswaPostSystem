<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Notification, dao.NotificationDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String matricNo = (String) session.getAttribute("matricNo");
    String userName = (String) session.getAttribute("userName");
    
    if (role == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    NotificationDAO dao = new NotificationDAO();
    List<Notification> notifList = "admin".equals(role) ? dao.getAllNotifications() : dao.getNotificationsByMatric(matricNo);
%>
<!DOCTYPE html>
<html>
<head>
    <title>SiswaPost | Notifikasi</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-brand-title">SiswaPost</div>
            <div class="sidebar-brand-sub">Smart Parcel System</div>
        </div>
        <ul class="sidebar-menu">
            <%
                if ("admin".equals(role)) {
            %>
                <li class="sidebar-item"><a href="adminDashboard.jsp">Dashboard</a></li>
                <li class="sidebar-item"><a href="parcelManagement.jsp">Parcel Management</a></li>
                <li class="sidebar-item"><a href="userManagement.jsp">User Management</a></li>
                <li class="sidebar-item active"><a href="notifications.jsp">Notifikasi</a></li>
            <%
                } else {
            %>
                <li class="sidebar-item"><a href="studentDashboard.jsp">My Parcels</a></li>
                <li class="sidebar-item active"><a href="notifications.jsp">Notifications</a></li>
            <%
                }
            %>
        </ul>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <div class="main-container">
        <div class="top-navbar">
            <span>Selamat Datang, <strong><%= userName != null ? userName : "User" %></strong></span>
        </div>
        
        <div class="main-content">
            <h2 class="page-title-heading"><%= "admin".equals(role) ? "Sistem Notifikasi (Admin)" : "Notifikasi Saya" %></h2>
            <p class="page-subtitle-text">Berikut adalah senarai notifikasi terkini anda.</p>

            <%-- Success/Error Messages --%>
            <%
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                if (error != null) {
            %>
                <div class="error-msg">
                    ❌ Terdapat ralat. Sila cuba lagi.
                </div>
            <%
                }
                if (success != null) {
            %>
                <div class="success-msg">
                    ✅ Notifikasi berjaya ditambah.
                </div>
            <%
                }
            %>

            <div class="data-section">
                <div class="section-header-panel">
                    <div class="stats-counter-badge-row">
                        <strong>Jumlah: <%= notifList.size() %></strong>
                    </div>
                    <% if ("admin".equals(role)) { %>
                        <button class="primary-btn" onclick="openAddModal()">+ Tambah Notifikasi</button>
                    <% } %>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Tarikh</th>
                            <% if ("admin".equals(role)) { %><th>No. Matrik</th><% } %>
                            <th>Jenis</th>
                            <th>Mesej</th>
                            <th>Status</th>
                            <th>Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (notifList.isEmpty()) { 
                        %>
                            <tr>
                                <td colspan="<%= "admin".equals(role) ? 6 : 5 %>" style="text-align:center; padding:40px; color:#94a3b8;">
                                    Tiada notifikasi untuk dipaparkan.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (Notification n : notifList) { 
                        %>
                        <tr>
                            <td><%= n.getFormattedCreatedAt() %></td>
                            <% if ("admin".equals(role)) { %><td><%= n.getMatricNo() %></td><% } %>
                            <td><%= n.getNotificationType() != null ? n.getNotificationType() : "-" %></td>
                            <td><%= n.getMessage() %></td>
                            <td>
                                <span class="badge <%= "READ".equals(n.getNotificationStatus()) ? "badge-active" : "badge-inactive" %>">
                                    <%= n.getNotificationStatus() != null ? n.getNotificationStatus().toUpperCase() : "UNREAD" %>
                                </span>
                            </td>
                            <td class="actions-cell">
                                <% if ("student".equals(role) && !"READ".equals(n.getNotificationStatus())) { %>
                                    <a href="NotificationServlet?action=markRead&id=<%= n.getNotificationId() %>" title="Tanda Baca">✅</a>
                                <% } %>
                                <a href="NotificationServlet?action=delete&id=<%= n.getNotificationId() %>" title="Padam" onclick="return confirm('Padam notifikasi ini?')">🗑️</a>
                            </td>
                        </tr>
                        <%      } 
                            } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%-- Add Notification Modal (Admin only) --%>
    <div id="addModal" class="modal-overlay">
        <div class="modal-card">
            <h3>Tambah Notifikasi Baru</h3>
            <form action="NotificationServlet" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-grid">
                    <div class="modal-input-group full-width">
                        <label>No. Matrik</label>
                        <input type="text" name="matric_no" placeholder="Masukkan no. matrik" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>ID Parcel (Optional)</label>
                        <input type="text" name="parcel_id" placeholder="ID Parcel">
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Jenis Notifikasi</label>
                        <select name="notification_type" required>
                            <option value="general">General</option>
                            <option value="parcel_arrived">Parcel Arrived</option>
                            <option value="parcel_ready">Parcel Ready</option>
                            <option value="parcel_collected">Parcel Collected</option>
                            <option value="reminder">Reminder</option>
                        </select>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Mesej</label>
                        <textarea name="message" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer-actions">
                    <button type="button" onclick="closeAddModal()" class="modal-btn" style="background:#e2e8f0; color:#475569;">Batal</button>
                    <button type="submit" class="modal-btn submit-btn-blue">Hantar</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addModal').classList.add('active');
        }
        function closeAddModal() {
            document.getElementById('addModal').classList.remove('active');
        }
        // Close modal on outside click
        window.onclick = function(event) {
            var modal = document.getElementById('addModal');
            if (event.target == modal) {
                modal.classList.remove('active');
            }
        }
    </script>
</body>
</html>