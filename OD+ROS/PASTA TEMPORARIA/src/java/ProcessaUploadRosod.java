/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import conexao.MysqlDB;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Enumeration;
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
import models.Rota;
import models.Usuario;
import models.Rosod;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.RequestContext;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

/**
 *
 * @author Matheus Vinicius G de Godoi
 */

@WebServlet(name = "ProcessaUploadRosod", urlPatterns = {"/ProcessaUploadRosod"})
public class ProcessaUploadRosod extends HttpServlet  {
    
    /**
     * Processes reques, HttpServletResponse responsets for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private void limpaPastaTemp(File f) {
        if (f.isDirectory()) {
            File[] files = f.listFiles();
            for (int i = 0; i < files.length; ++i) {
                limpaPastaTemp(files[i]);
            }
        }
        f.delete();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
    HttpSession sessao = request.getSession();
    Usuario usuario = new Usuario();
    if (sessao.getAttribute("usuario") == null) {
        //request.getRequestDispatcher("index.jsp").forward(request, response);
        System.err.println("DEU PT bem aqui!!!!!");
    } else {
        usuario = (Usuario) sessao.getAttribute("usuario");
    }   
    
    int id_user = usuario.getId_user();
    System.out.println("Id user: " + id_user);
    
    //Checagem se o request contém um arquivo para upload
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if(isMultipart){
        System.out.println("ARQUIVO RECEBIDO");
        String tipoRequisicao = "nullreq";
        String caminho = "nullcaminho";
        //Manipulação e iteração encima do form data pegando todos os valores e campos.
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(4096);
        factory.setRepository(new File("/tmp"));
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(200000);

        List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));
        Iterator<FileItem> iter = items.iterator();
        FileItem item = iter.next();

        while(true){
            if (item.isFormField()) {
                // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
                String fieldname = item.getFieldName();
                String fieldvalue = item.getString();
                //Recebendo os valores dos campos
                switch (fieldname) {
                    case "tipoRequisicao":
                        tipoRequisicao = fieldvalue;
                        break;
                    default:
                        break;
                }
                
                System.out.println("fname: " + fieldname + " fvalue: " + fieldvalue);
            } else {
                if(tipoRequisicao.equals("upload_missao_rosod")){
                    // Process form file field (input type="file").
                    String fieldname = item.getFieldName();     
                    String userHome = System.getProperty("user.home");
                    String filePath = userHome + "/Missions/" + id_user + "/";    
                    File filePathTemp = new File(filePath);
                    if (!filePathTemp.exists()) {
                        filePathTemp.mkdir();
                    }

                    //String filename = FilenameUtils.getName(item.getName()); //Esse método esta bugado por não ter o FilenameUtils no tomcat mas ter no apache
                    //InputStream filecontent = item.getInputStream(); //Não entendi esse input stream
                    item.write(new File(filePath, fieldname));
                    System.out.println("Filepath: " + filePath + fieldname);
                    caminho = filePath + fieldname;
                    String fileName = fieldname;
                    uploadMissaoRosod(id_user, caminho, fileName);
                }else if(tipoRequisicao.equals("upload_obsobj_rosod")){
                    // Process form file field (input type="file").
                    String fieldname = item.getFieldName();     
                    String userHome = System.getProperty("user.home");
                    String filePath = userHome + "/ObsObj/" + id_user + "/";    
                    File filePathTemp = new File(filePath);
                    if (!filePathTemp.exists()) {
                        filePathTemp.mkdir();
                    }
                    //String filename = FilenameUtils.getName(item.getName()); //Esse método esta bugado por não ter o FilenameUtils no tomcat mas ter no apache
                    //InputStream filecontent = item.getInputStream(); //Não entendi esse input stream
                    item.write(new File(filePath, fieldname));
                    System.out.println("Filepath: " + filePath + fieldname);
                    String fileName = fieldname;
                    uploadObsobjRosod(id_user, caminho, fileName);
                }
            }
            if(iter.hasNext()){
                item = iter.next();
            }else{
                break;
                //return;
            }
        }
    }else{
        System.out.println("NENHUM ARQUIVO RECEBIDO!");
    }//chave final do if(multipart){}... 
}
   
    //=============== Métodos Gerais =====================//
    
    private void uploadMissaoRosod(int id_user,String caminho, String filename) throws SQLException{
        //Limpa pasta temporaria 
        String ABSOLUTE_PATH_MISSAO = System.getProperty("user.home") + "/tempOD/"+id_user+"/";
        File f = new File(ABSOLUTE_PATH_MISSAO);
        if(f.exists()){
            limpaPastaTemp(f);
        }
        boolean statusCadMissao = false;
        MysqlDB banco = new MysqlDB();               
        banco.connect();
        PreparedStatement ps = null;
        String sql = null;
        //System.out.println("Aqui chegou");                 
        try {     
           sql = "INSERT INTO missions(user_id_user, mission_name, mission_folder)" + " VALUES(?,?,?);";   
           // System.out.println("Chegou aqui tbm");
            ps = banco.conn.prepareStatement(sql);
     
            ps.setInt(1, id_user);
            ps.setString(2, filename);
            ps.setString(3, caminho);
           //System.out.println("Instrução Sql: => " + ps.toString());
            
            ps.executeUpdate();
            ps.close();  
          
            statusCadMissao = true;
        }catch(SQLException e){
            System.out.println("Exception is ;"+e);
        }
        
        System.out.println("Cadastrou? " + statusCadMissao);     
    }

    private void uploadObsobjRosod(int id_user,String caminho, String filename) throws SQLException{
        //Limpa pasta temporaria 
        String ABSOLUTE_PATH_MISSAO = System.getProperty("user.home") + "/tempOD/"+id_user+"/";
        File f = new File(ABSOLUTE_PATH_MISSAO);
        if(f.exists()){
            limpaPastaTemp(f);
        }
        boolean statusCadMissao = false;
        MysqlDB banco = new MysqlDB();               
        banco.connect();
        PreparedStatement ps = null;
        String sql = null;
        //System.out.println("Aqui chegou");                 
        /*
        try {     
           sql = "INSERT INTO missions(user_id_user, mission_name, mission_folder)" + " VALUES(?,?,?);";   
           // System.out.println("Chegou aqui tbm");
            ps = banco.conn.prepareStatement(sql);
     
            ps.setInt(1, id_user);
            ps.setString(2, filename);
            ps.setString(3, caminho);
           //System.out.println("Instrução Sql: => " + ps.toString());
            
            ps.executeUpdate();
            ps.close();  
          
            statusCadMissao = true;
        }catch(SQLException e){
            System.out.println("Exception is ;"+e);
        }
        
        System.out.println("Cadastrou? " + statusCadMissao);  
    */
    }
    
     // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ProcessaRosod.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ProcessaRosod.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}