<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Parcel, dao.ParcelDAO, java.util.Base64" %>
<%
    String role = (String) session.getAttribute("role");
    String parcelId = request.getParameter("parcel_id");
    
    if (role == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    if (parcelId == null) {
        response.sendRedirect("studentDashboard.jsp");
        return;
    }
    
    ParcelDAO dao = new ParcelDAO();
    Parcel parcel = dao.getParcelById(parcelId);
    
    if (parcel == null || !parcel.hasProofImage()) {
        response.sendRedirect("studentDashboard.jsp");
        return;
    }
    
    String imageBase64 = parcel.getProofImageBase64();
    String imageType = parcel.getProofImageType() != null ? parcel.getProofImageType() : "image/jpeg";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Parcel Collect Proof | SiswaPost</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .image-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
            background: #f1f5f9;
        }
        .image-card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            max-width: 800px;
            width: 100%;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .image-card h3 {
            color: #1e3a61;
            margin-bottom: 10px;
        }
        .image-card p {
            color: #64748b;
            margin-bottom: 20px;
        }
        .image-card img {
            max-width: 100%;
            max-height: 70vh;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }
        .back-btn {
            display: inline-block;
            padding: 10px 24px;
            background: #1e3a61;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            margin-top: 15px;
            font-weight: 500;
        }
        .back-btn:hover {
            background: #152944;
        }
        .image-info {
            margin: 15px 0;
            color: #94a3b8;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="image-container">
        <div class="image-card">
            <h3>Collect Proof</h3>
            <p><strong>ID Parcel:</strong> <%= parcel.getParcelId() %></p>
            <p><strong>Name:</strong> <%= parcel.getStudentName() != null ? parcel.getStudentName() : "-" %></p>
            <p><strong>Date Collect:</strong> <%= parcel.getFormattedCollectedAt() %></p>
            <div class="image-info">
                <span><%= parcel.getProofImageName() != null ? parcel.getProofImageName() : "image" %></span>
            </div>
            <img src="data:<%= imageType %>;base64,<%= imageBase64 %>" alt="Collect Parcel Proof">
            <br>
            <a href="studentDashboard.jsp" class="back-btn">← Back to Dashboard</a>
        </div>
    </div>
</body>
</html>