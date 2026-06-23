package controller;

import dao.ParcelDAO;
import model.Parcel;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.InputStream;

@WebServlet("/ParcelServlet")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,      // 5MB
    maxRequestSize = 1024 * 1024 * 10,  // 10MB
    fileSizeThreshold = 1024 * 1024     // 1MB
)
public class ParcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ParcelDAO dao;

    public void init() {
        dao = new ParcelDAO();
    }

    // =========================
    // DO GET
    // =========================
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");

        try {
            if ("delete".equals(action) && id != null) {
                dao.deleteParcel(id);
                response.sendRedirect("parcelManagement.jsp?success=deleted");
            }
            else if ("collect".equals(action) && id != null) {
                // Redirect to collect form with image upload
                response.sendRedirect("collectParcel.jsp?parcel_id=" + id);
            }
            else if ("updateStatus".equals(action) && id != null) {
                String status = request.getParameter("status");
                if (status != null) {
                    dao.updateParcelStatus(id, status);
                    response.sendRedirect("parcelManagement.jsp?success=updated");
                } else {
                    response.sendRedirect("parcelManagement.jsp?error=missing_status");
                }
            }
            else {
                response.sendRedirect("parcelManagement.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("parcelManagement.jsp?error=1");
        }
    }

    // =========================
    // DO POST
    // =========================
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // Add Parcel (Admin)
                String parcelId = request.getParameter("parcel_id");
                String matricNo = request.getParameter("matric_no");
                String studentName = request.getParameter("student_name");
                String status = request.getParameter("status");

                if (parcelId == null || parcelId.trim().isEmpty() ||
                    matricNo == null || matricNo.trim().isEmpty()) {
                    response.sendRedirect("parcelManagement.jsp?error=missing_fields");
                    return;
                }

                Parcel p = new Parcel();
                p.setParcelId(parcelId.trim());
                p.setMatricNo(matricNo.trim());
                p.setStudentName(studentName != null ? studentName.trim() : "");
                p.setStatus(status != null ? status : "received");

                dao.addParcel(p);
                response.sendRedirect("parcelManagement.jsp?success=added");
            }
            else if ("collect".equals(action)) {
                // Collect Parcel with Image Proof (Student)
                String parcelId = request.getParameter("parcel_id");
                Part filePart = request.getPart("proof_image");
                
                if (parcelId == null || parcelId.trim().isEmpty()) {
                    response.sendRedirect("studentDashboard.jsp?error=missing_parcel");
                    return;
                }

                byte[] imageData = null;
                String imageName = null;
                String imageType = null;
                
                if (filePart != null && filePart.getSize() > 0) {
                    InputStream inputStream = filePart.getInputStream();
                    imageData = inputStream.readAllBytes();
                    imageName = filePart.getSubmittedFileName();
                    imageType = filePart.getContentType();
                }

                dao.collectParcelWithProof(parcelId.trim(), imageData, imageName, imageType);
                response.sendRedirect("studentDashboard.jsp?success=collected");
            }
            else {
                response.sendRedirect("studentDashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentDashboard.jsp?error=1");
        }
    }
}