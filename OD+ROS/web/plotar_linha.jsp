<%-- 
    Document   : plotar_linha
    Created on : 18/12/2018, 16:27:46
    Author     : User
--%>

<%@page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %> 

<%@page import="models.Linhacultivo"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>OD</title>
    </head>
    <body>
        <h1>Linhas Identificadas</h1>
        
        <%
            Linhacultivo linha = new Linhacultivo();
            linha.exec("imagenes/f1.jpg");
        %>  
        
        
    </body>
    
    <div id = 'div_img'></div> 

    
    <input type='button' value="Linhas de Cultivo" onclick = "javascript: imgLetra('a');" > 

            <script  language = 'javascript'> 
        function imgLetra( letra ){ 
        switch( letra ) { 
        case "a": 
        document.getElementById( 'div_img' ).innerHTML = "<img src = 'img/linhacultivo.png' >"; 
        break; 
        } 

        } 

        </script> 
    
</html>
