<%@ page import="java.sql.*, util.DBConnection" %>
<!DOCTYPE html>
<html>
<head><title>Test Database</title></head>
<body>
<h2>Database Connection Test</h2>
<%
    try {
        Connection con = DBConnection.getConnection();
        out.println("<p style='color:green'>? Connection SUCCESS!</p>");
        
        // Test query
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM users");
        
        out.println("<h3>Users in Database:</h3>");
        out.println("<table border='1'><tr><th>ID</th><th>Name</th><th>Matric</th><th>Email</th><th>Role</th></tr>");
        while (rs.next()) {
            out.println("<tr>");
            out.println("<td>" + rs.getInt("userId") + "</td>");
            out.println("<td>" + rs.getString("fullName") + "</td>");
            out.println("<td>" + rs.getString("matricNo") + "</td>");
            out.println("<td>" + rs.getString("email") + "</td>");
            out.println("<td>" + rs.getString("role") + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red'>? Error: " + e.getMessage() + "</p>");
        e.printStackTrace(response.getWriter());
    }
%>
</body>
</html>