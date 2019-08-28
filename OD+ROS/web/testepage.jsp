<%-- 
    Document   : govant
    Created on : Aug 9, 2019, 12:25:25 AM
    Author     : matheus-godoi
--%>
<%@page import="models.Usuario"%>

<%
     HttpSession sessao = request.getSession();
        Usuario usuario = new Usuario();
        if(sessao.getAttribute("usuario")==null){
           //request.getRequestDispatcher("index.jsp").forward(request, response);
            System.err.println("DEU PT bem aqui!!!!!");
        }else{
            usuario =  (Usuario) sessao.getAttribute("usuario");
        }
        
        int id_user   =  usuario.getId_user();
%>

<%@page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %> 

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <!--Import Google Icon Font-->
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <!--Import materialize.css-->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
  <link rel="stylesheet" href="css/main.css">
  <script defer src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl"
    crossorigin="anonymous"></script>
  <!--Let browser know website is optimized for mobile-->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

 
   <title>Página Teste</title>

	<!---------- CSS ------------>
	<link rel="stylesheet" type="text/css" href="./css/style.css">

</head>

 <body id="home" class="scrollspy">

    
    <div id="signup-form">
        
        
        <div id="signup-inner">
        
        	<div class="clearfix" id="header">
        	
        		<img id="signup-icon" src="./images/drone.png" alt="" />
        
                <h1>Módulo Teste</h1>

            </div>
              <form id="conecta-vant" action="AjaxRequest" enctype="multipart/form-data" method="post"> 
                <div class="input-field col s12" id="div-upload-porta" style="width: 70px; bgcolor: #440022">
                    <p>
                        <label for="name">Porta:</label>
                        <input id="txt_porta" type="text" name="frm_porta_conexao"  />
                        <button data-form-parent="btn-conectar-drone" id="btn-conect-drone" type="button" class="btn-form-ps submit">Conectar</button>
                    </p>                                        
                </div>
            
                <p>
                    <p>
                        <div class="input-field col s12" id="div-load-mission">
                            <h5 id="h5-load-mission">Caregar missão</h5>
                            <input id="path_missao" type="file">
                            <button data-form-parent="btn-cadastrar-missao" id="btn-start-mission" type="button" class="btn-form-ps submit">Carregar Missao</button>
                        </div>
                        </p>
                    <p>
                        <div class="input-field col s12" id="div-buttons-mission">
                            <button data-form-parent="btn-arm-drone" id="btn-arm-drone" type="button" class="btn-form-ps submit">Arm</button>
                            <button data-form-parent="btn-takeoff-drone" id="btn-takeoff-drone" type="button" class="btn-form-ps submit">Takeoff</button>
                            <button data-form-parent="btn-land-drone" id="btn-land-drone" type="button" class="btn-form-ps submit">Land</button>
                            <p>
                                <button data-form-parent="btn-disc-drone" id="btn-disc-drone" type="button" class="btn-form-ps submit">Desconectar</button>
                            </p>
                        </div>

                    </p>
                </p>
              </form>
        </div>  
    </div>

  <!--JavaScript at end of body for optimized loading-->

  <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/js/materialize.min.js"></script>

  <script>
    // Sidenav
    const sideNav = document.querySelector('.sidenav');
    M.Sidenav.init(sideNav, {});

    // ScrollSpy
    const ss = document.querySelectorAll('.scrollspy');
    M.ScrollSpy.init(ss, {});


    // Material Boxed
    const mb = document.querySelectorAll('.materialboxed');
    M.Materialbox.init(mb, {}); 
  </script>  

  <script src="./js/jquery.form.js"></script> 
  <script src="./js/request_main.js"> </script>  

  <script type="text/javascript">
    $(function(){
      $("#div-upload-porta").show();
      $("#div-load-mission").hide();
      $("#div-buttons-mission").hide();
    });
  </script>
  
  <script>
      $("#btn-disc-drone").click(function(){
        $("#div-upload-porta").show();
        $("#div-load-mission").hide();
        $("#div-buttons-mission").hide();
      });
  
  </script>
  
  <script>
      $("#btn-start-mission").click(function(){
        $("#div-upload-porta").hide();
        $("#div-load-mission").hide();
        $("#div-buttons-mission").show();
      });
  </script>
  
  <script>
      $("#btn-conect-drone").click(function(){
        $("#div-upload-porta").hide();
        $("#div-load-mission").show();   
        $("#div-buttons-mission").hide(); 
      });
  </script>
  
</body>
</html>
