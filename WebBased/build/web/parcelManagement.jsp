<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Parcel, dao.ParcelDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    ParcelDAO parcelDao = new ParcelDAO();
    List<Parcel> parcelList = parcelDao.getAllParcels();
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Parcel Management | SiswaPost</title>
    <link rel="stylesheet" href="style.css">  <!-- ✅ FIXED: tukar ke css/style.css -->
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-brand-title">SiswaPost</div>
            <div class="sidebar-brand-sub">Smart Parcel System</div>
        </div>
        <ul class="sidebar-menu">
            <li class="sidebar-item"><a href="adminDashboard.jsp">Dashboard</a></li>
            <li class="sidebar-item active"><a href="parcelManagement.jsp">Parcel Management</a></li>
            <li class="sidebar-item"><a href="userManagement.jsp">User Management</a></li>
            <li class="sidebar-item"><a href="notifications.jsp">Notifikasi</a></li>
        </ul>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <div class="main-container">
        <div class="top-navbar">
            <span>Selamat Datang, <strong><%= userName != null ? userName : "Admin" %></strong></span>
        </div>
        <div class="main-content">
            <h2 class="page-title-heading">📦 Parcel Management</h2>
            <p class="page-subtitle-text">Uruskan semua parcel pelajar di sini.</p>

            <%-- Show messages --%>
            <%
                if (error != null) {
                    if (error.equals("1")) {
            %>
                        <div class="error-msg">❌ Ralat sistem. Sila cuba lagi.</div>
            <%
                    } else if (error.equals("missing_fields")) {
            %>
                        <div class="error-msg">❌ Sila lengkapkan semua ruangan.</div>
            <%
                    } else if (error.equals("missing_status")) {
            %>
                        <div class="error-msg">❌ Status tidak sah.</div>
            <%
                    } else {
            %>
                        <div class="error-msg">❌ Ralat: <%= error %></div>
            <%
                    }
                }
                
                if (success != null) {
                    if (success.equals("added")) {
            %>
                        <div class="success-msg">✅ Parcel berjaya ditambah!</div>
            <%
                    } else if (success.equals("deleted")) {
            %>
                        <div class="success-msg">✅ Parcel berjaya dipadam!</div>
            <%
                    } else if (success.equals("updated")) {
            %>
                        <div class="success-msg">✅ Status parcel berjaya dikemaskini!</div>
            <%
                    } else if (success.equals("collected")) {
            %>
                        <div class="success-msg">✅ Parcel berjaya diambil!</div>
            <%
                    } else {
            %>
                        <div class="success-msg">✅ <%= success %></div>
            <%
                    }
                }
            %>

            <div class="data-section">
                <div class="section-header-panel">
                    <div class="stats-counter-badge-row">
                        <strong>Jumlah Parcel: <%= parcelList.size() %></strong>
                    </div>
                    <button class="primary-btn" onclick="openAddParcelModal()">+ Tambah Parcel</button>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID Parcel</th>
                            <th>No. Matrik</th>
                            <th>Nama Pelajar</th>
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
                                <td colspan="8" style="text-align:center; padding:40px; color:#94a3b8;">
                                    🚫 Tiada parcel untuk dipaparkan.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (Parcel p : parcelList) {
                        %>
                        <tr>
                            <td><strong><%= p.getParcelId() %></strong></td>
                            <td><%= p.getMatricNo() %></td>
                            <td><%= p.getStudentName() != null ? p.getStudentName() : "-" %></td>
                            <td>
                                <span class="badge <%= "collected".equals(p.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                    <%= p.getStatus() != null ? p.getStatus().toUpperCase() : "RECEIVED" %>
                                </span>
                            </td>
                            <td><%= p.getFormattedReceivedAt() %></td>
                            <td><%= p.getFormattedCollectedAt() %></td>
                            <td>
                                <% if (p.hasProofImage()) { %>
                                    <a href="viewImage.jsp?parcel_id=<%= p.getParcelId() %>" target="_blank" style="color:#1e3a61; font-weight:500;">📷 Lihat</a>
                                <% } else { %>
                                    <span style="color:#94a3b8;">-</span>
                                <% } %>
                            </td>
                            <td class="actions-cell">
                                <a href="ParcelServlet?action=delete&id=<%= p.getParcelId() %>" 
                                   title="Padam" 
                                   onclick="return confirm('Padam parcel ini?')">🗑️</a>
                                <% if (!"collected".equals(p.getStatus())) { %>
                                    <a href="ParcelServlet?action=updateStatus&id=<%= p.getParcelId() %>&status=ready" 
                                       title="Mark Ready">📦</a>
                                    <a href="ParcelServlet?action=updateStatus&id=<%= p.getParcelId() %>&status=collected" 
                                       title="Mark Collected">✅</a>
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

    <!-- Add Parcel Modal -->
    <div id="addParcelModal" class="modal-overlay">
        <div class="modal-card">
            <h3>➕ Tambah Parcel Baru</h3>
            <form action="ParcelServlet" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-grid">
                    <div class="modal-input-group full-width">
                        <label>ID Parcel</label>
                        <input type="text" name="parcel_id" placeholder="Contoh: PKG-2026-001" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>No. Matrik Pelajar</label>
                        <input type="text" name="matric_no" placeholder="Masukkan no. matrik" required>
                        <small style="color:#94a3b8;">Pastikan no. matrik wujud dalam sistem</small>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Nama Pelajar</label>
                        <input type="text" name="student_name" placeholder="Masukkan nama pelajar" required>
                    </div>
                    <div class="modal-input-group full-width">
                        <label>Status</label>
                        <select name="status" required>
                            <option value="received">📥 Received</option>
                            <option value="ready">📦 Ready for Pickup</option>
                            <option value="collected">✅ Collected</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer-actions">
                    <button type="button" onclick="closeAddParcelModal()" class="modal-btn" style="background:#e2e8f0; color:#475569;">Batal</button>
                    <button type="submit" class="modal-btn submit-btn-blue">Tambah</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddParcelModal() {
            document.getElementById('addParcelModal').classList.add('active');
        }
        function closeAddParcelModal() {
            document.getElementById('addParcelModal').classList.remove('active');
        }
        window.onclick = function(event) {
            var modal = document.getElementById('addParcelModal');
            if (event.target == modal) {
                modal.classList.remove('active');
            }
        }
    </script>
</body>
</html>