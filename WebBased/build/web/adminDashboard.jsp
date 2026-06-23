<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Parcel, model.User, dao.ParcelDAO, dao.UserDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Get data for dashboard
    ParcelDAO parcelDao = new ParcelDAO();
    UserDAO userDao = new UserDAO();
    
    List<Parcel> allParcels = parcelDao.getAllParcels();
    List<User> allUsers = userDao.getAllUsers();
    
    // Count statistics
    int totalParcels = allParcels.size();
    int totalUsers = allUsers.size();
    
    int receivedCount = 0;
    int readyCount = 0;
    int collectedCount = 0;
    
    for (Parcel p : allParcels) {
        String status = p.getStatus();
        if ("received".equals(status)) receivedCount++;
        else if ("ready".equals(status)) readyCount++;
        else if ("collected".equals(status)) collectedCount++;
    }
    
    int studentCount = 0;
    int adminCount = 0;
    for (User u : allUsers) {
        if ("student".equals(u.getRole())) studentCount++;
        else if ("admin".equals(u.getRole())) adminCount++;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | SiswaPost</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 24px 20px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-card .stat-icon {
            font-size: 2rem;
            margin-bottom: 8px;
        }
        .stat-card .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: #1e3a61;
        }
        .stat-card .stat-label {
            color: #64748b;
            font-size: 0.9rem;
            margin-top: 4px;
        }
        .stat-card .stat-sub {
            color: #94a3b8;
            font-size: 0.75rem;
            margin-top: 6px;
        }
        .stat-card.blue { border-top: 4px solid #1e3a61; }
        .stat-card.green { border-top: 4px solid #16a34a; }
        .stat-card.orange { border-top: 4px solid #f59e0b; }
        .stat-card.purple { border-top: 4px solid #7c3aed; }
        .stat-card.red { border-top: 4px solid #dc2626; }
        .stat-card.teal { border-top: 4px solid #14b8a6; }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        .dashboard-card {
            background: white;
            padding: 20px 24px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        .dashboard-card h3 {
            color: #1e3a61;
            font-size: 1rem;
            margin-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 10px;
        }
        .dashboard-card ul {
            list-style: none;
            padding: 0;
        }
        .dashboard-card ul li {
            padding: 8px 0;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
        }
        .dashboard-card ul li:last-child {
            border-bottom: none;
        }
        .dashboard-card ul li .label { color: #64748b; }
        .dashboard-card ul li .value { font-weight: 600; color: #1e293b; }
        .quick-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .quick-action-btn {
            padding: 8px 16px;
            background: #f1f5f9;
            border-radius: 8px;
            text-decoration: none;
            color: #1e3a61;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s;
            border: 1px solid #e2e8f0;
        }
        .quick-action-btn:hover {
            background: #1e3a61;
            color: white;
            border-color: #1e3a61;
        }
        .quick-action-btn.add { background: #dcfce7; border-color: #bbf7d0; }
        .quick-action-btn.add:hover { background: #16a34a; color: white; border-color: #16a34a; }

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            .dashboard-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 480px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand-wrapper">
            <div class="sidebar-brand-title">SiswaPost</div>
            <div class="sidebar-brand-sub">Smart Parcel System</div>
        </div>
        <ul class="sidebar-menu">
            <li class="sidebar-item active"><a href="adminDashboard.jsp">Dashboard</a></li>
            <li class="sidebar-item"><a href="parcelManagement.jsp">Parcel Management</a></li>
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
            
            <!-- Welcome Section -->
            <h1 style="color:#1e3a61; font-size:1.6rem;">Berikut adalah ringkasan sistem SiswaPost.</h1>
            

            <!-- Statistics Cards -->
            <div class="dashboard-stats">
                <div class="stat-card blue">
                    <div class="stat-icon">📦</div>
                    <div class="stat-number"><%= totalParcels %></div>
                    <div class="stat-label">Jumlah Parcel</div>
                    <div class="stat-sub">Keseluruhan parcel dalam sistem</div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon">✅</div>
                    <div class="stat-number"><%= collectedCount %></div>
                    <div class="stat-label">Telah Diambil</div>
                    <div class="stat-sub">Parcel sudah diambil</div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon">📥</div>
                    <div class="stat-number"><%= receivedCount %></div>
                    <div class="stat-label">Belum Diambil</div>
                    <div class="stat-sub"><%= readyCount %> sedia untuk diambil</div>
                </div>
                <div class="stat-card purple">
                    <div class="stat-icon">👤</div>
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="stat-label">Jumlah Pengguna</div>
                    <div class="stat-sub"><%= studentCount %> pelajar, <%= adminCount %> admin</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div style="margin-bottom:20px;">
                <p style="font-weight:600; color:#1e293b; margin-bottom:10px;">⚡ Tindakan Pantas</p>
                <div class="quick-actions">
                    <a href="parcelManagement.jsp" class="quick-action-btn add">➕ Tambah Parcel</a>
                    <a href="userManagement.jsp" class="quick-action-btn">👤 Tambah Pengguna</a>
                    <a href="notifications.jsp" class="quick-action-btn">🔔 Hantar Notifikasi</a>
                    <a href="parcelManagement.jsp" class="quick-action-btn">📦 Urus Parcel</a>
                </div>
            </div>

            <!-- Dashboard Grid -->
            <div class="dashboard-grid">
                <!-- Recent Parcels -->
                <div class="dashboard-card">
                    <h3>📦 Parcel Terkini</h3>
                    <ul>
                        <%
                            int displayCount = Math.min(5, allParcels.size());
                            if (displayCount == 0) {
                        %>
                            <li style="color:#94a3b8; text-align:center; padding:15px;">Tiada parcel</li>
                        <%
                            } else {
                                for (int i = 0; i < displayCount; i++) {
                                    Parcel p = allParcels.get(i);
                        %>
                            <li>
                                <span class="label"><%= p.getParcelId() %></span>
                                <span class="value">
                                    <span class="badge <%= "collected".equals(p.getStatus()) ? "badge-active" : "badge-inactive" %>">
                                        <%= p.getStatus() != null ? p.getStatus().toUpperCase() : "RECEIVED" %>
                                    </span>
                                </span>
                            </li>
                        <%
                                }
                            }
                        %>
                        <%
                            if (allParcels.size() > 5) {
                        %>
                            <li style="color:#94a3b8; font-style:italic; text-align:center;">
                                ... dan <%= allParcels.size() - 5 %> lagi
                            </li>
                        <%
                            }
                        %>
                    </ul>
                </div>

                <!-- Quick Stats -->
                <div class="dashboard-card">
                    <h3>📊 Ringkasan Sistem</h3>
                    <ul>
                        <li>
                            <span class="label">📦 Parcel Diterima</span>
                            <span class="value"><%= receivedCount %></span>
                        </li>
                        <li>
                            <span class="label">📦 Sedia untuk Diambil</span>
                            <span class="value"><%= readyCount %></span>
                        </li>
                        <li>
                            <span class="label">✅ Parcel Diambil</span>
                            <span class="value"><%= collectedCount %></span>
                        </li>
                        <li>
                            <span class="label">👤 Pelajar</span>
                            <span class="value"><%= studentCount %></span>
                        </li>
                        <li>
                            <span class="label">🛡️ Admin</span>
                            <span class="value"><%= adminCount %></span>
                        </li>
                        <li>
                            <span class="label">📅 Tarikh</span>
                            <span class="value"><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></span>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>
</body>
</html>