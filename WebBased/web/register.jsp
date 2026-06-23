<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar Pengguna | SiswaPost</title>
    <link rel="stylesheet" href="style.css">  
    <style>
        .login-link-container { 
            text-align: center; 
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #f1f5f9;
        }
        .login-link-container a { 
            color: #1e3a61; 
            text-decoration: none; 
            font-size: 0.9rem; 
            font-weight: 500; 
        }
        .login-link-container a:hover { 
            text-decoration: underline; 
        }
        
        /* Prevent autofill background */
        input:-webkit-autofill,
        input:-webkit-autofill:hover,
        input:-webkit-autofill:focus,
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px white inset !important;
            box-shadow: 0 0 0 30px white inset !important;
            -webkit-text-fill-color: #1e293b !important;
        }
        
        .error-msg {
            color: #dc2626;
            background: #fee2e2;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 0.9rem;
            border: 1px solid #fecaca;
        }
        
        .success-msg {
            color: #16a34a;
            background: #dcfce7;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 0.9rem;
            border: 1px solid #bbf7d0;
        }
    </style>
</head>
<body class="login-page">

    <div class="login-card">
        <h2>Daftar Akaun Baru</h2>
        
        <%-- Error / Success Messages --%>
        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            
            if (error != null) {
                if (error.equals("missing")) {
        %>
            <div class="error-msg">Sila lengkapkan semua ruangan!</div>
        <%
                } else if (error.equals("exists")) {
        %>
            <div class="error-msg">No. Matrik atau Email sudah wujud!</div>
        <%
                } else if (error.equals("failed")) {
        %>
            <div class="error-msg">Pendaftaran gagal. Sila cuba lagi!</div>
        <%
                } else {
        %>
            <div class="error-msg">Ralat: <%= error %></div>
        <%
                }
            }
            
            if (success != null && success.equals("registered")) {
        %>
            <div class="success-msg">✅ Pendaftaran berjaya! Sila login.</div>
        <%
            }
        %>
        
        <form action="RegisterServlet" method="POST" autocomplete="off">
            <div class="input-group">
                <label for="fullName"> Nama Penuh</label>
                <input type="text" 
                       id="fullName" 
                       name="fullName" 
                       placeholder="Masukkan nama penuh" 
                       required
                       autocomplete="off">
            </div>
            
            <div class="input-group">
                <label for="matricNo">No. Matrik / No. Staff</label>
                <input type="text" 
                       id="matricNo" 
                       name="matricNo" 
                       placeholder="Contoh: 2026123456" 
                       required
                       autocomplete="off">
            </div>
            
            <div class="input-group">
                <label for="email">📧 Email</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       placeholder="contoh@siswa.edu.my" 
                       required
                       autocomplete="off">
            </div>
            
            <div class="input-group">
                <label for="password">Kata Laluan</label>
                <input type="password" 
                       id="password" 
                       name="password" 
                       placeholder="Min. 6 aksara" 
                       required
                       autocomplete="new-password">
            </div>
            
            <input type="hidden" name="role" value="student">
            
            <button type="submit" class="submit-btn">Daftar Sekarang</button>
        </form>

        <div class="login-link-container">
            <a href="login.jsp">Sudah ada akaun? Login di sini</a>
        </div>
    </div>

</body>
</html>