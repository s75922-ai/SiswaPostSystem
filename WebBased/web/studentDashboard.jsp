<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Parcel, dao.ParcelDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String matricNo = (String) session.getAttribute("matricNo");
    
    if (role == null || !role.equals("student")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    ParcelDAO parcelDao = new ParcelDAO();
    List<Parcel> parcelList = parcelDao.getParcelsByMatric(matricNo);
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard | SiswaPost</title>
    <link rel="stylesheet" href="style.css">  
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-brand-title">SiswaPost</div>
            <div class="sidebar-brand-sub">Smart Parcel System</div>
        </div>
        <ul class="sidebar-menu">
            <li class="sidebar-item active"><a href="studentDashboard.jsp">My Parcels</a></li>
            <li class="sidebar-item"><a href="notifications.jsp">Notifications</a></li>
        </ul>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <div class="main-container">
        <div class="top-navbar">
            <span>Selamat Datang, <strong><%= userName != null ? userName : "Student" %></strong></span>
        </div>
        <div class="main-content">
            <h2 class="page-title-heading">📦 Parcel Saya</h2>
            <p class="page-subtitle-text">Berikut adalah senarai parcel untuk anda.</p>

            <%-- Show messages --%>
            <%
                if (success != null && success.equals("collected")) {
            %>
                <div class="success-msg">✅ Parcel berjaya dikolek! Bukti telah disimpan.</div>
            <%
                }
                if (error != null) {
                    if (error.equals("already_collected")) {
            %>
                        <div class="error-msg">❌ Parcel ini sudah dikolek.</div>
            <%
                    } else {
            %>
                        <div class="error-msg">❌ Ralat. Sila cuba lagi.</div>
            <%
                    }
                }
            %>

            <div class="data-section">
                <div class="section-header-panel">
                    <div class="stats-counter-badge-row">
                        <strong>Jumlah Parcel: <%= parcelList.size() %></strong>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID Parcel</th>
                            <th>Status</th>
                            <th>Tarikh Terima</th>
                            <th>Tarikh Ambil</th>
                            <th>Bukti</th>
                            <th>Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (parcelList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align:center; padding:40px; color:#94a3b8;">
                                    🚫 Tiada parcel untuk dipaparkan.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (Parcel p : parcelList) {
                        %>
                        <tr>
                            <td><strong><%= p.getParcelId() %></strong></td>
                            <td>
                                <span class="badge <%= "collected".equals(p.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                    <%= p.getStatus() != null ? p.getStatus().toUpperCase() : "RECEIVED" %>
                                </span>
                            </td>
                            <td><%= p.getFormattedReceivedAt() %></td>
                            <td><%= p.getFormattedCollectedAt() %></td>
                            <td>
                                <% if (p.hasProofImage()) { %>
                                    <a href="viewImage.jsp?parcel_id=<%= p.getParcelId() %>" target="_blank" style="color:#1e3a61; font-weight:500;">📷 Lihat Bukti</a>
                                <% } else { %>
                                    <span style="color:#94a3b8;">-</span>
                                <% } %>
                            </td>
                            <td class="actions-cell">
                                <% if (!"collected".equals(p.getStatus())) { %>
                                    <a href="ParcelServlet?action=collect&id=<%= p.getParcelId() %>" 
                                       title="Kolek Parcel" 
                                       style="font-size:1.5rem; text-decoration:none;"
                                       onclick="return confirm('📦 Collect parcel ini? Sila sediakan gambar bukti.')">
                                       📦
                                    </a>
                                <% } else { %>
                                    <span style="color:#16a34a; font-weight:600;">✅ Selesai</span>
                                <% } %>
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
</body>
</html>