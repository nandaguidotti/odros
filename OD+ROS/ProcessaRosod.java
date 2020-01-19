/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import conexao.MysqlDB;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
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

@WebServlet(name = "ProcessaRosod", urlPatterns = {"/ProcessaRosod"})
public class ProcessaRosod extends HttpServlet  {
    
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
    
    
    /*//Checagem se o request contém um arquivo para upload
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if(isMultipart){
        System.out.println("ARQUIVO RECEBIDO");
        String porta = "nullporta";
        String tipoVoo = "nullvoo";
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
                    case "txtPorta":
                        porta = fieldvalue;
                        break;
                    case "tipoRequisicao":
                        tipoRequisicao = fieldvalue;
                        break;
                    case "tipoVoo":
                        tipoVoo = fieldvalue;
                        break;
                    case "caminhoMissao":
                        caminho = fieldvalue;
                        break;
                    default:
                        break;
                }
                
                System.out.println("fname: " + fieldname + " fvalue: " + fieldvalue);
            } else {
                System.out.println("Aquichegoulinha125");

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
                    System.out.println("name: " + fieldname + " content...");
                    File arquivoWP = new File(filePath+fieldname);
                    System.out.println("Filepath: " + filePath + fieldname);
                    caminho = filePath + fieldname;
                    String fileName = fieldname;
                    Rosod conexao = new Rosod(porta);
                    if(tipoVoo.equals("simulado")){
                        uploadMissaoRosod(id_user, caminho, fileName);
                        conexao.carregaMissaoSimulado(caminho);
                    }else if(tipoVoo.equals("real")){
                        uploadMissaoRosod(id_user, caminho, fileName);
                        conexao.carregaMissao(caminho);
                    }
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
                    System.out.println("name: " + fieldname + " content...");
                    File arquivoOBSOBJ = new File(filePath+fieldname);
                    System.out.println("Filepath: " + filePath + fieldname);
                }
            }
            if(iter.hasNext()){
                item = iter.next();
            }else{
                break;
                //return;
            }
        }
        return;
    }//chave final do if(multipart){}... */

    String type_request;
    System.out.println("Request: " + request.getParameter("tipoRequisicao") + "\nPorta: " + request.getParameter("txtPorta") + "\nVoo: " + request.getParameter("tipoVoo"));
    //System.out.println("File: " + request.getParameter("arquivoMissao"));
    if (request.getParameter("tipoRequisicao") != null) {
        System.out.println("Tipo de requisição recebida com sucesso");
        type_request = request.getParameter("tipoRequisicao");
        
        String tipoVoo = request.getParameter("tipoVoo");
        String porta = request.getParameter("txtPorta");
        Rosod conexaoRosod = new Rosod(porta);

        if (tipoVoo.equals("mapa")){
            switch (type_request){
                case "obstaculos_gerados":
                    escreverMapaObstaculos(id_user, conexaoRosod, request.getParameter("listaPontos"), response);
                    break;
                default:
                    break;
            };
        };

        if(tipoVoo.equals("simulado")){
            switch (type_request) {
                case "conecta_rosod":
                    conectaRosodSimulado(id_user, conexaoRosod, response);
                break;
                case "inicia_missao_rosod":
                    iniciaMissaoRosodSimulado(id_user, conexaoRosod, response);
                break;
                case "arm_rosod":
                    controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "disarm_rosod":
                    //controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "takeoff_rosod":
                    controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "land_rosod":
                    controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "auto_rosod":
                    controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "loiter_rosod":
                    controleRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "nova_rota":
                    String planner = request.getParameter("planner");
                    gerarNovaRotaSimulado(id_user, planner, type_request, conexaoRosod, response);
                break;
                case "carregar_missao":
                    String caminho = request.getParameter("caminho");
                    carregaMissaoSimulado(id_user, caminho, type_request, conexaoRosod, response);
                    break;
                case "upload_agora":
                    missaoAgoraRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "upload_final":
                    missaoFinalRosodSimulado(id_user, type_request, conexaoRosod, response);
                break;
                case "desconecta_rosod":
                    desconectaRosod(id_user, conexaoRosod, response);
                    break;
                default:
                    break;
            }
            if((type_request.toString()).length() < 15){
                System.out.println("Caso: " + (type_request));
            }
        }else if(tipoVoo.equals("real")){
            switch (type_request) {
                case "conecta_rosod":
                    conectaRosod(id_user, porta, conexaoRosod, response);
                    break;
                case "inicia_missao_rosod":
                    iniciaMissaoRosod(id_user, conexaoRosod, response);
                break;
                 case "arm_rosod":
                    controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                 case "disarm_rosod":
                    //controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "takeoff_rosod":
                    controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "land_rosod":
                    controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "auto_rosod":
                    controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "loiter_rosod":
                    controleRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "nova_rota":
                    String planner = request.getParameter("planner");
                    gerarNovaRota(id_user, planner, type_request, conexaoRosod, response);
                break;
                case "carregar_missao":
                    String caminho = request.getParameter("caminho");
                    carregaMissao(id_user, caminho, type_request, conexaoRosod, response);
                break;
                case "upload_agora":
                    missaoAgoraRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "upload_final":
                    missaoFinalRosod(id_user, type_request, conexaoRosod, response);
                break;
                case "desconecta_rosod":
                    desconectaRosod(id_user, conexaoRosod, response);
                    break;
                default:
                    break;
            }
            if((type_request.toString()).length() < 15){
                System.out.println("Caso: " + (type_request));
            }   
        }    
    }else{
            System.out.println("Deu null????");
    }
}
    /*
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
    }*/

    private void escreverMapaObstaculos(int id_user, Rosod conexaoRosod, String listaPontos ,HttpServletResponse response) throws IOException, InterruptedException{
        String[] pontos = listaPontos.split(",");

        int j = 1;
        String str = "[\n{\n\t\"id\": \"xx0\",\n\t\"name\": \"xx0\",\n\t\"geo_home\": [" + pontos[0] + "," + pontos[1] + ", 0],\n";
        str = str.concat("\t\"areas_bonificadoras\":[],\n\t\"areas_penalizadoras\":[],\n\t\"areas_nao_navegaveis\":[\n");       
        str = str.concat("\t\t{\n\t\t\t\"id\": \"id0\",\n\t\t\t\"name\": \"obs0\",\n\t\t\t\"geo_points\":[\n");

        FileWriter fw = new FileWriter("/home/claudio/ObsObj/"+ Integer.toString(id_user) + "/output.json");

        for (int i = 0; i < str.length(); i++) 
            fw.write(str.charAt(i));

        fw.write("\t\t\t\t[");        
        for (int i = 0; i < pontos.length; i++){ 
            if(pontos[i].equals("@@@")){
                fw.write("]");
                if(pontos[i+1].equals("%%%")){
                    i = i+1;
                    j = j+1;
                    fw.write("\n\t\t\t]\n\t\t},");
                    fw.write("\n\t\t{\n\t\t\t\"id\": \"id"+j+"\",\n\t\t\t\"name\": \"obs"+j+"\",\n\t\t\t\"geo_points\":[\n");
                    fw.write("\t\t\t\t[");        
                }else if(pontos[i+1].equals("###")){
                    fw.write("\n\t\t\t]\n\t\t}\n\t]\n}\n]");
                    break;
                }else{
                    fw.write(",\n\t\t\t\t[");
                }
                i = i+1;
            }
            fw.write(pontos[i]);
            fw.write(", ");
            i = i+1;
            fw.write(pontos[i]);
            fw.write(", ");
            i = i+1;
            fw.write(pontos[i]);
        };
        
        //close the file  
        fw.close(); 
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(listaPontos);    
    };

    
    //=============== Métodos para voos simulados ===============//
    private void conectaRosodSimulado(int id_user, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        //Conexao real também
        conexao.conectaDroneSimulado();  
    }
    
    private void iniciaMissaoRosodSimulado(int id_user, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.iniciaMissaoSimulado();
    }   
    
    private void controleRosodSimulado(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.controleDroneSimulado(request);
    }
    
    private void gerarNovaRotaSimulado(int id_user, String planner, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.novaRotaSimulado(planner);
    }
        
    private void carregaMissaoSimulado(int id_user, String caminho, String type_request, Rosod conexao, HttpServletResponse response) throws IOException{
        conexao.carregaMissaoSimulado(caminho);

        response.setContentType("text/html;charset=UTF-8");
        int ch;
        FileReader fr = null;
        try {
            fr = new FileReader(caminho);
        }catch (FileNotFoundException fe){ 
            System.out.println("File not found"); 
            response.getWriter().write("Missao não Encontrada");
        }
        while ((ch=fr.read())!=-1){
            response.getWriter().write((char)ch);        
        }
        // close the file 
        fr.close(); 
        
        
    }

    private void missaoAgoraRosodSimulado(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.missaoAgoraSimulado();
    }    
    
    private void missaoFinalRosodSimulado(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.missaoFinalSimulado();
    }    
            
    private void desconectaRosodSimulado(int id_user, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.desconectaDroneSimulado();
    }
    
    //=============== Métodos para voos reais ===============//
    private void conectaRosod(int id_user,String porta, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        //Conexao real também
        conexao.conectaDrone(porta);  
    }
    
    private void iniciaMissaoRosod(int id_user, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.iniciaMissao();
    }   
    
    private void controleRosod(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.controleDrone(request);
    }   
    
    private void gerarNovaRota(int id_user, String planner, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.novaRotaSimulado(planner);
    }

    private void carregaMissao(int id_user, String caminho, String type_request, Rosod conexao, HttpServletResponse response) throws IOException{
        conexao.carregaMissao(caminho);
    }

    private void missaoAgoraRosod(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.missaoAgora();
    }    
    
    private void missaoFinalRosod(int id_user, String request, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.missaoFinal();
    }    
            
    private void desconectaRosod(int id_user, Rosod conexao, HttpServletResponse response) throws IOException, InterruptedException{
        conexao.desconectaDrone();
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