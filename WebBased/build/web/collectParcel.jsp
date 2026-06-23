<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Parcel, dao.ParcelDAO" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    String parcelId = request.getParameter("parcel_id");
    
    if (role == null || !role.equals("student")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    if (parcelId == null) {
        response.sendRedirect("studentDashboard.jsp");
        return;
    }
    
    ParcelDAO dao = new ParcelDAO();
    Parcel parcel = dao.getParcelById(parcelId);
    
    if (parcel == null) {
        response.sendRedirect("studentDashboard.jsp");
        return;
    }
    
    // Check if already collected
    if ("collected".equals(parcel.getStatus())) {
        response.sendRedirect("studentDashboard.jsp?error=already_collected");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Collect Parcel | SiswaPost</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .preview-container {
            margin-top: 15px;
            display: none;
        }
        .preview-container.show {
            display: block;
        }
        .preview-container img {
            max-width: 200px;
            max-height: 200px;
            border-radius: 8px;
            border: 2px solid #e2e8f0;
            padding: 5px;
        }
        .parcel-details-box {
            margin-bottom: 20px;
            padding: 15px 20px;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 4px solid #1e3a61;
        }
        .parcel-details-box h3 {
            color: #1e3a61;
            margin-bottom: 10px;
        }
        .parcel-details-box p {
            margin: 5px 0;
        }
        .file-input-wrapper {
            position: relative;
        }
        .file-input-wrapper input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 2px dashed #cbd5e1;
            border-radius: 8px;
            cursor: pointer;
            background: #fafafa;
            transition: all 0.3s;
        }
        .file-input-wrapper input[type="file"]:hover {
            border-color: #1e3a61;
            background: #f1f5f9;
        }
        .file-input-wrapper input[type="file"]:focus {
            outline: none;
            border-color: #1e3a61;
        }
        .btn-collect {
            background: #16a34a;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.2s;
        }
        .btn-collect:hover {
            background: #15803d;
            transform: scale(1.02);
        }
        .btn-collect:disabled {
            background: #94a3b8;
            cursor: not-allowed;
            transform: none;
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
            <h2 class="page-title-heading">Collect Parcel</h2>
            <p class="page-subtitle-text">Sila upload gambar sebagai bukti pengambilan parcel.</p>

            <div class="data-section" style="max-width:600px; margin:0 auto;">
                <form action="ParcelServlet" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="collect">
                    <input type="hidden" name="parcel_id" value="<%= parcel.getParcelId() %>">
                    
                    <!-- Parcel Details -->
                    <div class="parcel-details-box">
                        <h3>Maklumat Parcel</h3>
                        <p><strong>ID Parcel:</strong> <span style="color:#1e3a61;"><%= parcel.getParcelId() %></span></p>
                        <p><strong>Nama Pelajar:</strong> <%= parcel.getStudentName() != null ? parcel.getStudentName() : "-" %></p>
                        <p><strong>No. Matrik:</strong> <%= parcel.getMatricNo() %></p>
                        <p><strong>Status:</strong> 
                            <span class="badge badge-inactive"><%= parcel.getStatus() != null ? parcel.getStatus().toUpperCase() : "RECEIVED" %></span>
                        </p>
                        <p><strong>Tarikh Terima:</strong> <%= parcel.getFormattedReceivedAt() %></p>
                    </div>
                    
                    <!-- File Upload -->
                    <div class="modal-input-group" style="margin-bottom:20px;">
                        <label style="font-weight:600; font-size:1rem;">Upload Gambar Bukti</label>
                        <div class="file-input-wrapper">
                            <input type="file" 
                                   name="proof_image" 
                                   accept="image/*" 
                                   required 
                                   onchange="previewImage(event)"
                                   id="proofImage">
                        </div>
                        <small style="color:#64748b; display:block; margin-top:5px;">
                            Format: JPG, PNG, GIF (Max 5MB)
                        </small>
                    </div>

                    <!-- Image Preview -->
                    <div class="preview-container" id="previewContainer">
                        <p style="color:#64748b; font-size:0.9rem;">Preview:</p>
                        <img id="imagePreview" src="#" alt="Preview">
                        <p style="color:#94a3b8; font-size:0.8rem; margin-top:5px;" id="fileName"></p>
                    </div>
                    
                    <!-- Buttons -->
                    <div style="display:flex; gap:10px; margin-top:20px;">
                        <button type="submit" class="btn-collect" id="submitBtn">
                            collect Parcel
                        </button>
                        <a href="studentDashboard.jsp" class="modal-btn" style="background:#e2e8f0; color:#475569; padding:12px 24px; border-radius:8px; text-decoration:none; font-weight:500;">
                            Batal
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function previewImage(event) {
            const container = document.getElementById('previewContainer');
            const preview = document.getElementById('imagePreview');
            const fileName = document.getElementById('fileName');
            const file = event.target.files[0];
            
            if (file) {
                // Check file size (5MB max)
                if (file.size > 5 * 1024 * 1024) {
                    alert('❌ Saiz gambar terlalu besar! Sila pilih gambar bawah 5MB.');
                    event.target.value = '';
                    container.classList.remove('show');
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    fileName.textContent = '📁' + file.name + ' (' + (file.size / 1024).toFixed(1) + ' KB)';
                    container.classList.add('show');
                }
                reader.readAsDataURL(file);
            } else {
                container.classList.remove('show');
            }
        }

        function validateForm() {
            const fileInput = document.getElementById('proofImage');
            const submitBtn = document.getElementById('submitBtn');
            
            if (fileInput.files.length === 0) {
                alert('Sila pilih gambar untuk bukti kolek parcel.');
                return false;
            }
            
            const file = fileInput.files[0];
            const maxSize = 5 * 1024 * 1024; // 5MB
            
            if (file.size > maxSize) {
                alert('Saiz gambar terlalu besar. Sila pilih gambar bawah 5MB.');
                return false;
            }
            
            // Disable button to prevent double submit
            submitBtn.disabled = true;
            submitBtn.textContent = '⏳ Menghantar...';
            return true;
        }
    </script>
</body>
</html>