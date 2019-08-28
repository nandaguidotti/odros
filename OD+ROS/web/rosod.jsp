<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %> 
<%@page import= "models.Rosod"%>
<%@page import="models.Usuario"%>

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
                <h1>Ros+OD</h1>

            </div>

            <form id="conecta_rosod_form" name="formRosod" action="ProcessaRosod" method="post" enctype="multipart/form-data">
                <input type="hidden" name="tipoRequisicao" id="tipoRequisicao" value="rosod_tipo_requisicao" />   
                
                <p>Por favor selecione a opção desejada.</p>  
                    <p>
                    <label>
                        <input name="group1" id="radiobtnsimulado" value="simulado" type="radio" checked/>
                        <span>Simulado</span>
                    </label>
                </p>

                <p>
                    <label>
                        <input name="group1" id="radiobtnreal" value="real" type="radio"/>
                        <span>Real</span>
                    </label>
                </p>   

                <p>
                    <label id="label_porta" for="name">Porta:</label>
                    <input id="txt_porta" name="frm_name_porta"  />
                    <button data-form-parent="btn-conectar" id="btn-conect-drone" type="submit" class="btn-form-ps submit">Conectar</button>
                </p>

                     
                <p>
                    <label for="name">Carregar a missão:</label>
                    <input type="file" name="frm_up_file" id="frm_up_file">
                    <button data-form-parent="btn-upload-missao" id="btn-upload-missao" type="submit" class="btn-form-ps submit">Upload Missão</button>
                </p>

                <p>
                    <label for="company">Clique no Botão Iniciar para Começar a missão:</label>               
                    <button data-form-parent="btn-cadastrar-rota" id="btn-cadastrar-rota" type="submit" class="btn-form-ps submit">Iniciar</button>
                </p>

                <p>
                    <label for="company">Botões de Controle</label> 
                    <button data-form-parent="btn-arm" id="btn-arm" type="submit" class="btn-form-ps submit">Arm</button>
                    <button data-form-parent="btn-takeoff" id="btn-takeoff" type="submit" class="btn-form-ps submit">TakeOff</button>
                    <button data-form-parent="btn-land" id="btn-land" type="submit" class="btn-form-ps submit">Land</button>
                </p>

                <p>
                    <label for="company">Modos de voo</label>
                    <button data-form-parent="btn-auto" id="btn-auto" type="submit" class="btn-form-ps submit">Auto</button>
                    <button data-form-parent="btn-loiter" id="btn-loiter" type="submit" class="btn-form-ps submit">Loiter</button>
                </p>
    
                <p>
                    <label for="company">Recalcular rota</label>               
                    <button data-form-parent="btn-gnrota" type="submit" class="btn-form-ps submit">Gerar Nova Rota</button>            
                </p>
   
    <script type="text/javascript">
        //Botão de conectar
        $("#btn-conect-drone").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            e.preventDefault();

            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "conecta_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });

        //Botão de upload
        $("#btn-upload-missao").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
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

                fileData.append(fileName, file);
                fileData.append("txtPorta",document.getElementById("txt_porta").value);
                fileData.append("tipoRequisicao", "upload_missao_rosod");
                fileData.append("tipoVoo", radio);                

                $.ajax({
                    type: "POST",
                    url: "http://172.26.220.181:8080/OD/ProcessaRosod",
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

        //Botão iniciar missão
        $("#btn-cadastrar-rota").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "inicia_missao_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Arm
        $("#btn-arm").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "arm_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Takeoff
        $("#btn-takeoff").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "takeoff_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Land
        $("#btn-land").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "land_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Auto
        $("#btn-auto").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "auto_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Loiter
        $("#btn-loiter").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            var data = {
                txtPorta: document.getElementById("txt_porta").value,
                tipoRequisicao: "loiter_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                url: "http://172.26.220.181:8080/OD/ProcessaRosod",
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
      
        //Funções para mostrar/esconder campo de porta
        $(document).ready(function () {
            $("#label_porta").hide();
            $("#txt_porta").hide();
        });

        $("#radiobtnsimulado").click(function(e){
            $("#label_porta").hide();
            $("#txt_porta").hide();
        });
      
        $("#radiobtnreal").click(function(e){
            $("#label_porta").show();
            $("#txt_porta").show();
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
