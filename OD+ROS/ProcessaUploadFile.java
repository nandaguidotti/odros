/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;
import models.Rota;
import models.Usuario;
import models.Logidrone;


@WebServlet(name = "ProcessaUploadFile", urlPatterns = {"/ProcessaUploadFile"})
public class ProcessaUploadFile extends HttpServlet {


   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, Exception {

       String tipoRequisicao = "Upload";
           
        switch (tipoRequisicao){
            case "Upload":
                uploadFile(request, response);
                break;
            case "Logout":
               // logout(request,response);
                ;
            default:
                break;
        }
        
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Authentication</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Authentication at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    
    private void uploadFile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, FileUploadException, Exception {

        HttpSession sessao = request.getSession();
        Usuario usuario = new Usuario();
        if(sessao.getAttribute("usuario") == null){
           //request.getRequestDispatcher("index.jsp").forward(request, response);
            System.err.println("DEU PT bem aqui!!!!!");
        }else{
            usuario =  (Usuario) sessao.getAttribute("usuario");
        }
       
        // Aqui faz o cadastro da Rota
        String name_rota  =  request.getParameter("name_user");
        int id_user   =  usuario.getId_user();
        
        //System.out.println("Fernanda vc é muito boa: vc é " + id_user + "0");
                
        Rota rota = new Rota(name_rota, id_user);                        

   /*#### Aqui começa os códigos para upload e processamento do arquivo e inserção dos dados no Banco de Dados ###*/     
   
   response.setContentType("text/html;charset=UTF-8");
                
    Logidrone logidrone = new Logidrone();        
    String filePath  = null;
    //filePath = "C:\\Users\\User\\Documents\\NetBeansProjects\\OD\\web\\upload_logs\\"; 

    filePath = "C:\\Windows\\Temp\\";


    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setSizeThreshold(4096);
    factory.setRepository(new File("C:\\Windows\\Temp\\"));
    ServletFileUpload upload = new ServletFileUpload(factory);        
    upload.setSizeMax(1000000);

    List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));  
        
// Process the uploaded items
	Iterator<FileItem> iter = items.iterator();
	while (iter.hasNext()) {
		FileItem item = iter.next();
		// Process a regular form field
	        if (item.isFormField()) {
                    //String name =  item.getFieldName();
                    String valueNameRota = item.getString();
                   
                    rota.setName_routeidrone(valueNameRota); // Aqui peguei o nome da Rota
                    rota.cadastroRota(id_user); // Insere a Rota
                    //System.out.println("Fernanda: " + valueNameRota);
                    //System.out.println("Fernanda: " + value);
	        }
		// Process a file upload
		if (!item.isFormField()){
                    String fileName = item.getName();						
                    //System.out.println(filePath + fileName);
                    item.write(new File(filePath, fileName));
                    logidrone.gravaCSV(filePath+fileName, id_user);                            
		}
	   }      
        //out.println("<h1>Rota Cadastrada com Sucesso !!</h1>");
//         try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet Authentication</title>");            
//            out.println("</head>");
//            out.println("<body>");
//            //out.println("<h1>Servlet Authentication at " + request.getContextPath() + "</h1>");
//             
//          // out.println("<h1>Rota cadastrada com sucesso!</h1>");
//
//            //request.getRequestDispatcher("cadastro_rota.jsp").forward(request, response);
//            out.println("</body>");
//            out.println("<script>");
//            out.println("alert('Hello World!'); ");
//            out.println("</script>");
//            out.println("</html>");
//            request.getRequestDispatcher("cadastro_rota.jsp").forward(request, response);
//        }

            request.getRequestDispatcher("cadastro_rota.jsp").forward(request, response);
             //request.getRequestDispatcher("").forward(request, response); 
              
    } // Aqui termina o método UploadFile
 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ProcessaUploadFile.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
       try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ProcessaUploadFile.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

   @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
