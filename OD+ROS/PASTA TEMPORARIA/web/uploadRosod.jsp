<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %> 
<%@page import= "models.Rosod"%>
<%@page import= "models.Missions"%>
<%@page import= "models.Usuario"%>
<%@page import= "java.util.List"%>

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


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Security-Policy" content="default-src *; style-src 'self' 'unsafe-inline'; script-src: 'self' 'unsafe-inline' 'unsafe-eval'">
    <!--Import Google Icon Font-->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-beta/css/materialize.min.css">
    <link rel="stylesheet" href="css/main.css">
    <script defer src="https://use.fontawesome.com/releases/v5.0.9/js/all.js" integrity="sha384-8iPTk2s/jMVj81dnzb/iFR2sdA7u06vHJyyLlAd4snFpCl/SnyUjRrbdJsw1pGIl"
        crossorigin="anonymous"> </script>
    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Sistema Log UAV - Página de Upload de Logs</title>

    <!---------- CSS ------------>
    <link rel="stylesheet" type="text/css" href="./css/style.css">

</head>
<body id="home" class="scrollspy">     
    <div id="signup-form">
        <div id="signup-inner">
            <div class="clearfix" id="header">

                <img id="signup-icon" src="./images/drone.png" alt="" />
                <h1>Upload de Arquivos</h1>

            </div>

            <form id="upload_rosod_form" name="formUpload" action="ProcessaUploadRosod" method="post" enctype="multipart/form-data">
                <input type="hidden" name="tipoRequisicao" id="tipoRequisicao" value="upload_tipo_requisicao" />   
                
                <!--input escondido para armazenar a url-->
                <input id="url" type="hidden" hid name="frm_url"/> 
                <p>
                    <label for="name">Fazer upload da missão:</label>
                    <input type="file" name="frm_up_file" id="frm_up_file">
                    <button data-form-parent="btn-upload-missao" id="btn-upload-missao" type="submit" class="btn-form-ps submit">Upload Missão</button>
                </p>
                <p>
                    <label for="name">Fazer upload de mapa:</label>
                    <input type="file" name="frm_up_mapa" id="frm_up_mapa">
                    <button data-form-parent="btn-upload-mapa" id="btn-upload-mapa" type="submit" class="btn-form-ps submit">Upload Mapa</button>
                </p>
   
    <script type="text/javascript">
        //Botão de upload de missão
        $("#btn-upload-missao").click(function(e){
            e.preventDefault();
            
            var file = $("#frm_up_file")[0].files[0];
            var filePathValue = document.getElementById("frm_up_file").value;
            var fileType = filePathValue.split(".");
            fileType = fileType[fileType.length-1];
            if(fileType === "wp"){
                var fileData = new FormData();

                var filePathValue = document.getElementById("frm_up_file").value;
                var fileName = filePathValue.split("\\");
                var length = fileName.length;
                fileName = fileName[length-1];

                fileData.append("tipoRequisicao", "upload_missao_rosod");
                fileData.append(fileName, file);
                console.log("alo");
                console.log(document.getElementById("url").value);

                $.ajax({
                    type: "POST",
                    //url: "http://localhost:8080/OD/ProcessaRosod",
                    url: document.getElementById("url").value,
                    crossDomain: true,
                    processData: false,
                    contentType: false,
                    data: fileData,
                    succes: function(response){
                        console.log("ALO3");
                    }
                });
            }else{
                alert("Por favor, envie um arquivo .wp!");
            };
        });

        //Botão de upload de mapa
        $("#btn-upload-mapa").click(function(e){
            e.preventDefault();
            
            var file = $("#frm_up_mapa")[0].files[0];
            var filePathValue = document.getElementById("frm_up_mapa").value;
            var fileType = filePathValue.split(".");
            fileType = fileType[fileType.length-1];
            if(fileType !== ""){
                var fileData = new FormData();

                var filePathValue = document.getElementById("frm_up_mapa").value;
                var fileName = filePathValue.split("\\");
                var length = fileName.length;
                fileName = fileName[length-1];

                fileData.append("tipoRequisicao", "upload_obsobj_rosod");
                fileData.append(fileName, file);

                $.ajax({
                    type: "POST",
                    //url: "http://localhost:8080/OD/ProcessaRosod",
                    url: document.getElementById("url").value,
                    crossDomain: true,
                    processData: false,
                    contentType: false,
                    data: fileData,
                    succes: function(response){
                        console.log("ALO3");
                    }
                });
            }else{
                alert("Por favor, envie um arquivo!");
            };
        });

        //Função para montar a url
        $(document).ready(function () {
            var url = window.location.href;
            var urlsplit = url.split("/AutenticaLogin");
            var novaurl = urlsplit[0].concat("/ProcessaUploadRosod");
            $("#url").val(novaurl);
        });
    </script>
                </form>
                <div class="progress">
                    <div class="determinate progress_bar"></div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="materialize/js/materialize.min.js"></script>
 
    <!--JavaScript at end of body for optimized loading-->
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

        // formselect
        $(document).ready(function(){
            $('select').formSelect();
        });
    </script>
  
    <script src="./js/jquery.form.js"> </script> 
    <script src="./js/request_main.js"> </script>
</body>
</html>