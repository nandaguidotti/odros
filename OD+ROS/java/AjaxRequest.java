/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import models.Rota;
import models.Logidrone;
import models.Rosod;
import models.Usuario;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.RequestContext;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.apache.tomcat.util.http.fileupload.servlet.ServletRequestContext;

/**
 *
 * @author vinicius
 */
@WebServlet(name = "AjaxRequest", urlPatterns = {"/AjaxRequest"})
//@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 10, maxFileSize = 1024 * 1024 * 30, maxRequestSize = 1024 * 1024 * 50)
public class AjaxRequest extends HttpServlet {

    private void limpaPastaTemp(File f) {
        if (f.isDirectory()) {
            File[] files = f.listFiles();
            for (int i = 0; i < files.length; ++i) {
                limpaPastaTemp(files[i]);
            }
        }
        f.delete();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, Exception {
        HttpSession sessao = request.getSession();
        Usuario usuario = new Usuario();
        if (sessao.getAttribute("usuario") == null) {
            //request.getRequestDispatcher("index.jsp").forward(request, response);
            System.err.println("DEU PT bem aqui!!!!!");
        } else {
            usuario = (Usuario) sessao.getAttribute("usuario");
        }

        int id_user = usuario.getId_user();
        String type_request;
        if (request.getParameter("tipoRequisicao") != null) {
            System.out.println("Tipo de requisição recebida com sucesso");
            type_request = request.getParameter("tipoRequisicao");
            System.out.println(type_request);
            switch (type_request) {
                case "plotar_rota":
                    String route_id = request.getParameter("sltnomepais");
                   // System.out.println("Id da rota>>> " + route_id);
                    plotarRota(route_id, id_user, response);
                    break;
                default:
                    break;
            }
        } else {
            
            //Limpa pasta temporaria 
            String ABSOLUTE_PATH_IMG = System.getProperty("user.home") + "/tempOD/"+id_user+"/";
            File f = new File(ABSOLUTE_PATH_IMG);
            if(f.exists()){
                limpaPastaTemp(f);
            }
            
            String filePath = null;
            //filePath = "C:\\Users\\User\\Documents\\NetBeansProjects\\OD\\web\\upload_logs\\"; 

            //filePath = "C:\\Windows\\Temp\\";
            filePath = "/tmp";

            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(4096);
            factory.setRepository(new File("/tmp"));
            ServletFileUpload upload = new ServletFileUpload(factory);
            //upload.setSizeMax(1000000);
            upload.setSizeMax(20556868);

            List<FileItem> items = upload.parseRequest(new ServletRequestContext(request));
            Iterator<FileItem> iter = items.iterator();
            boolean fora = true;
            do {
                FileItem item = iter.next();
                type_request = item.getString();
                switch (type_request) {
                    case "cadastrar_rota":
                        cadastrarRota(id_user, iter, item, filePath, response);
                        fora = false;
                        break;
                    default:
                        break;
                }
                    if((type_request.toString()).length() < 15){
                        System.out.println("Caso: " + (type_request));
            }
            } while (iter.hasNext() && fora);
        }
        // Retorna resposta para o Ajax caso nao ache funcao para executar requisição
        String json = "{\"status\": \"4044\", \"message\": \"Operacao nao existente ou requisicao invalida para url especificada.\"}";
        PrintWriter out = response.getWriter();
        out.print(json);
        out.close();

    }

    private void cadastrarRota(int id_user, Iterator<FileItem> iter, FileItem item, String filePath, HttpServletResponse response) throws ServletException, IOException, FileUploadException, SQLException, Exception {

        String name_rota = "";
        Rota rota = new Rota(name_rota, id_user);
        Logidrone logidrone = new Logidrone();

        while (iter.hasNext()) {
            item = iter.next();
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
            if (!item.isFormField()) {
                String fileName = item.getName();
                //System.out.println("hereee"+filePath + fileName);
                item.write(new File(filePath, fileName));
                logidrone.gravaCSV(filePath + "/" + fileName, id_user);
            }
        }

        String json = "{\"status\": \"2000\", \"message\": \"Rota Cadastrada.\", \"tipoRequisicao\": \"cadastrar_rota\"}";
        PrintWriter out = response.getWriter();
        out.print(json);
        out.close();

    }

    private void plotarRota(String route_id, int id_user, HttpServletResponse response) throws SQLException, IOException {
        Logidrone logidrone = new Logidrone();
        ArrayList<List<String>> dados = logidrone.getRota(route_id, id_user);

        String json = "{\"pontosLat\": [";

        List<String> lat = dados.get(0);
        int j = 0;
        for (j = 0; j < lat.size() - 1; j++) {
            json += lat.get(j) + ", ";
        }

        json += lat.get(j) + "]";
        json += ",\"pontosLong\": [";

        List<String> longui = dados.get(0);
        for (j = 0; j < longui.size() - 1; j++) {
            json += longui.get(j) + ", ";
        }
        json += longui.get(j) + "]}";

        //System.out.println(json);
       // System.out.println("Fim");

        // response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.close();
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
            Logger.getLogger(AjaxRequest.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(AjaxRequest.class.getName()).log(Level.SEVERE, null, ex);
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
