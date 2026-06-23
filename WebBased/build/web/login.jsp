<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>SiswaPost | Login</title>
    <link rel="stylesheet" href="style.css"> 
    <style>
        /* Additional fix to prevent autofill background */
        input:-webkit-autofill,
        input:-webkit-autofill:hover,
        input:-webkit-autofill:focus,
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px white inset !important;
            box-shadow: 0 0 0 30px white inset !important;
            -webkit-text-fill-color: #1e293b !important;
        }
    </style>
</head>
<body class="login-page">

    <div class="login-card">
        <h2>SiswaPost Login</h2>
        
        <%-- Error Messages --%>
        <% 
            String error = request.getParameter("error");
            if (error != null) {
                if (error.equals("1")) {
        %>
            <div class="error-msg">❌ No. Matrik atau Kata Laluan salah!</div>
        <%
                } else if (error.equals("empty")) {
        %>
            <div class="error-msg">❌ Sila masukkan No. Matrik dan Kata Laluan!</div>
        <%
                }
            }
        %>

        <form action="LoginServlet" method="POST" autocomplete="off">
            <div class="input-group">
                <label for="username">No. Matrik / No. Staff</label>
                <input type="text" 
                       id="username" 
                       name="username" 
                       placeholder="Masukkan ID anda" 
                       required
                       autocomplete="off">
            </div>
            
            <div class="input-group">
                <label for="password">Kata Laluan</label>
                <input type="password" 
                       id="password" 
                       name="password" 
                       placeholder="Masukkan kata laluan" 
                       required
                       autocomplete="new-password">
            </div>
            
            <button type="submit" class="submit-btn">Login</button>
        </form>

        <div class="login-link-container">
            <a href="register.jsp">Belum ada akaun? Daftar di sini</a>
        </div>
    </div>

</body>
</html>