<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %> 
<%@page import= "models.Rosod"%>
<%@page import= "models.Missions"%>
<%@page import= "models.Usuario"%>
<%@page import= "java.util.List"%>
<%@page import= "java.io.*"%>

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
                    <!--<label id="label_porta" for="name">Porta:</label>
                    <input id="txt_porta" name="frm_name_porta"  />-->
                        <label id="label_porta" for="name">Lista de portas</label>
                        <ul id="ul-seleciona-portas">
                           <li><select class="browser-default" name ="slt-porta" id ="slt-porta" data-user-id="<%=id_user%>">
                                   <option value="noporta" disabled selected>Selecione a Porta</option>
                                   <%
                                        String portaValue = null;
                                        Process p = Runtime.getRuntime().exec("python -m serial.tools.list_ports");

                                        BufferedReader stdInput = new BufferedReader(new 
                                        InputStreamReader(p.getInputStream()));
                                        String nomePorta = null;
                                        String[] temp = new String[3];
                                        // read the output from the command
                                        while ((portaValue = stdInput.readLine()) != null) {
                                           portaValue = portaValue.toString();
                                           temp = portaValue.split("/dev/");
                                           nomePorta = temp[1];
                                   %>                               
                                   <option value=<%=portaValue%>><%=nomePorta%></option>
                                   <% } %>
                               </select></li>
                       </ul>
                    <button data-form-parent="btn-conect-drone" id="btn-conect-drone" type="submit" class="btn-form-ps submit">Conectar</button>
                </p>
                <!--input escondido para armazenar a url-->
                <input id="url" type="hidden" hid name="frm_url"/> 
                <p>
                    <label for="name">Carregar a missão:</label>
                    <ul id="ul-seleciona-missao">
                       <li><select class="browser-default" name ="slt-missao" disabled="disabled" id ="slt-missao" data-user-id="<%=id_user%>">
                               <option value="nomission" disabled selected>Selecione a Missao</option>
                               <%
                                   Missions missoes = new Missions();
                                   List<Missions> listaMissoes = missoes.visualizar(id_user);
                                   for (Missions m : listaMissoes) {
                               %>                               
                               <option value=<%=m.getMissionPath()%>><%=m.getMissionName()%></option>
                               <% } %>
                           </select></li>
                   </ul>
                    <button data-form-parent="btn-carrega-missao" disabled="disabled" id="btn-carrega-missao" type="submit" class="btn-form-ps submit">Carregar Missão</button>
                </p>
                           
                <p>
                    <label for="company">Clique no Botão Iniciar para Começar a missão:</label>               
                    <button data-form-parent="btn-inicia-missao" disabled="disabled" id="btn-inicia-missao" type="submit" class="btn-form-ps submit">Iniciar</button>
                </p>
                <p>
                    <label for="company">Botões de Controle</label> 
                    <!-- <button data-form-parent="btn-arm" disabled="disabled" id="btn-arm" type="submit" class="btn-form-ps submit">Arm</button> -->
                    <div class="switch">
                        <label>
                            Loiter
                            <input type="checkbox" disabled="disabled" id="swt-autoloiter">
                            <span class="lever"></span>
                            Auto
                        </label>
                    </div>
                    <button data-form-parent="btn-takeoff" disabled="disabled" id="btn-takeoff" type="submit" class="btn-form-ps submit">TakeOff</button>
                    <button data-form-parent="btn-land" disabled="disabled" id="btn-land" type="submit" class="btn-form-ps submit">Land</button>
                </p>
                    <button data-form-parent="btn-test" id="btn-teste" type="button" class="btn-form-ps submit">teste</button>
                <p>
                    <label for="company">Modos de voo</label>
                    <!--
                    <button data-form-parent="btn-auto" id="btn-auto" type="submit" class="btn-form-ps submit">Auto</button>
                    <button data-form-parent="btn-loiter" id="btn-loiter" type="submit" class="btn-form-ps submit">Loiter</button>
                    -->
                    <div class="switch">
                        <label>
                            Disarm
                            <input type="checkbox" disabled="disabled" id="swt-armdisarm">
                            <span class="lever"></span>
                            Arm
                        </label>
                    </div>
                </p>
    
                <p>
                    <label for="company">Planejador</label>               
                    <ul id="ul-seleciona-planner">
                        <li><select class="browser-default" disabled="disabled" name ="slt-planner" id ="slt-planner">
                            <option value="noplanner" disabled selected>Selecione o planejador</option>
                            <option value="estat">Estático</option>
                            <option value="genet">Genético</option>
                        </select></li>    
                    </ul>
                </p>
                <p>
                    <label for="company">Recalcular rota</label>
                </p>
                    <button data-form-parent="btn-gnrota" disabled="disabled" id="btn-gnrota" type="submit" class="btn-form-ps submit">Gerar Nova Rota</button>            
                <p>
                    <button data-form-parent="btn-upagora" disabled="disabled" id="btn-upagora" type="submit" class="btn-form-ps submit">Enviar Agora</button>            
                    <button data-form-parent="btn-upfinal" disabled="disabled" id="btn-upfinal" type="submit" class="btn-form-ps submit">Enviar Depois</button>            
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
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "conecta_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });

        //Botão iniciar missão
        $("#btn-inicia-missao").click(function(e){
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            $("#swt-armdisarm").prop("checked", true);
            $("#swt-autoloiter").prop("checked", true);
        
            var data = {
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "inicia_missao_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });

        //Botão Auto loiter
            $("#swt-autoloiter").on('change', function() {
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            var tipoReq = "nullReq";
            if ($(this).is(':checked')) {
                $(this).attr('value', 'true');
                tipoReq = "auto_rosod";
            }else {
                $(this).attr('value', 'false');
                tipoReq = "loiter_rosod";
            };
            var data ={
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: tipoReq,
                tipoVoo: radio
            };
            
            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });

        //Botão arm disarm
            $("#swt-armdisarm").on('change', function() {
            var radio = "simulado";
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            var tipoReq = "nullReq";
            if ($(this).is(':checked')) {
                $(this).attr('value', 'true');
                tipoReq = "arm_rosod";
                //$("#swt-armdisarm").prop("disabled", true);

            }else {
                $(this).attr('value', 'false');
                tipoReq = "disarm_rosod";
            };
            var data ={
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: tipoReq,
                tipoVoo: radio
            };
            
            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
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
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "takeoff_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
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
            
            $("#swt-armdisarm").prop("disabled", false);

            var data = {
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "land_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
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
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "auto_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
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
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "loiter_rosod",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });
        
        //Botão Nova Rota
        $("#btn-gnrota").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };

            e.preventDefault();
            
            if(document.getElementById("slt-planner").value === "noplanner"){
                alert("Por favor escolha um planejador!");
            }else{
                var data = {
                    txtPorta: document.getElementById("slt-porta").value,
                    tipoRequisicao: "nova_rota",
                    tipoVoo: radio,
                    planner: document.getElementById("slt-planner").value
                };
    
                $.ajax({
                    type: "POST",
                    //url: "http://localhost:8080/OD/ProcessaRosod",
                    url: document.getElementById("url").value,
                    data: data,
                    succes: function(response){
                        console.log("ALO3");
                    }
                });
            };
        });
        
        $("#btn-carrega-missao").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            
            if(document.getElementById("slt-missao").value === "nomission"){
                alert("Por favor escolha uma missão!");
            }else{
                var data = {
                    txtPorta: document.getElementById("slt-porta").value,
                    tipoRequisicao: "carregar_missao",
                    caminho: document.getElementById("slt-missao").value,
                    tipoVoo: radio
                };

                $.ajax({
                    type: "POST",
                    //url: "http://localhost:8080/OD/ProcessaRosod",
                    url: document.getElementById("url").value,
                    data: data,
                    succes: function(response){
                        console.log("ALO3");
                    }
                });
            };
        });

        //Botão Upload Missão agora
        $("#btn-upagora").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            
            var data = {
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "upload_agora",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });  
        
        
        //Botão Upload Missão final
        $("#btn-upfinal").click(function(e){
            var radio = "simulado";    
            if(document.getElementById("radiobtnsimulado").checked){
                radio = document.getElementById("radiobtnsimulado").value;
            }else{
                radio = document.getElementById("radiobtnreal").value;
            };
            
            e.preventDefault();
            
            var data = {
                txtPorta: document.getElementById("slt-porta").value,
                tipoRequisicao: "upload_final",
                tipoVoo: radio
            };

            $.ajax({
                type: "POST",
                //url: "http://localhost:8080/OD/ProcessaRosod",
                url: document.getElementById("url").value,
                data: data,
                succes: function(response){
                    console.log("ALO3");
                }
            });
        });  

        
        //Funções para mostrar/esconder campo de porta, além de bloquear os botões
        $(document).ready(function () {
            var url = window.location.href;
            var urlsplit = url.split("/AutenticaLogin");
            var novaurl = urlsplit[0].concat("/ProcessaRosod");
            $("#url").val(novaurl);

            //console.log(novaurl);
            $("#label_porta").hide();
            $("#slt-porta").hide();

            //$("#btn-inicia-missao").css({ "background-color": "#E3D8D8  "});
            $("#btn-inicia-missao").prop("disabled", false);
            //$("#swt-armdisarm").css({ "background-color": "blue"});
            $("#swt-armdisarm").prop("disabled", false);            
            //$("#swt-autoloiter").css({ "background-color": "blue"});
            $("#swt-autoloiter").prop("disabled", false);           
            //$("#btn-takeoff").css({ "background-color": "#E3D8D8"});
            $("#btn-takeoff").prop("disabled", false);
            //$("#btn-land").css({ "background-color": "#E3D8D8"});
            $("#btn-land").prop("disabled", false);
            //$("#btn-gnrota").css({ "background-color": "#E3D8D8"});
            $("#btn-gnrota").prop("disabled", false);
            //$("#slt-planner").css({ "background-color": "#E3D8D8"});
            $("#slt-planner").prop("disabled", false);
            //$("#btn-upagora").css({ "background-color": "#E3D8D8"});
            $("#btn-upagora").prop("disabled", false);
            //$("#btn-upfinal").css({ "background-color": "#E3D8D8"});
            $("#btn-upfinal").prop("disabled", false);
            //$("#btn-carrega-missao").css({ "background-color": "#E3D8D8"});
            $("#btn-carrega-missao").prop("disabled", false);
            //$("#slt-missao").css({ "background-color": "#E3D8D8"});
            $("#slt-missao").prop("disabled", false);
            //$("#slt-porta").css({ "background-color": "#E3D8D8"});
            $("#slt-porta").prop("disabled", false);       
        });

        $("#radiobtnsimulado").click(function(e){
            $("#label_porta").hide();
            $("#slt-porta").hide();
        });
      
        $("#radiobtnreal").click(function(e){
            $("#label_porta").show();
            $("#slt-porta").show();
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
        //$(document).ready(function(){
        //    $('select').formSelect();
        //});
    </script>
  
    <script src="./js/jquery.form.js"> </script> 
    <script src="./js/request_main.js"> </script>
</body>
</html>