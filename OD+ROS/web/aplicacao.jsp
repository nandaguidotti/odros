<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Usuario"%>
<% 
    HttpSession sessao = request.getSession();
    Usuario usuario = new Usuario();
    if(sessao.getAttribute("usuario")==null){
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }else{
        usuario =  (Usuario) sessao.getAttribute("usuario");
    }

%>

<!DOCTYPE html>
<html>

    <head>
         <script src="script.js"></script>
        <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
  <!--Import Google Icon Font-->
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <!--Import materialize.css-->
  <link type="text/css" rel="stylesheet" href="css/materialize.min.css" media="screen,projection" />
  <link type="text/css" rel="stylesheet" href="css/main.css" />

  <!--Let browser know website is optimized for mobile-->
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script type='text/javascript' src='https://www.gstatic.com/charts/loader.js'></script>
  <title>OracleDrone</title>
  <style>
      
      .hidden {
          display: none
      }
    
    header, main, footer,.content {
      padding-left: 300px;
    }

    @media only screen and (max-width : 992px) {
      header, main, footer,.content {
        padding-left: 0;
      }
    }
  </style>
</head>

<body>
<nav class="teal">
  <div class="nav wrapper">
    <div class="container">
<a href="" class="brand-logo center">OracleDrone</a>
<a href="" class="button-collapse show-on-large" data-activates="sidenav"><i class="material-icons">menu</i></a>
<ul class="right collection hide-on-small-and-down" style="margin:0px;
      border: 0px solid transparent">
        <li class="collection-item avatar" style="background-color: transparent;min-height: 60px;">
          <a href="" class="tooltipped" data-tooltip="Notifications" data-position="top">
            <i class="material-icons circle white teal-text">notifications_active</i></a>
        </li>
        
      </ul>
    </div>
  </div>
</nav>

<ul class="side-nav fixed" id="sidenav">
  <li>
    <div class="user-view">
<div class="background">
  <img src="img/drone9.jpg" alt="" class="responsive-img">
</div>
<a href="">
  <img src="img/person.png" alt="" class="circle">
</a>
<span class="white-text name"><%=usuario.getName_user()%></span>
<span class="white-text email"><%=usuario.getEmail_user()%></span>
    </div>
  </li>
<li>
  <a href="dashboard"><i class="material-icons teal-text">dashboard</i>Dashboard
  </a>
</li>

<li>
    <a  href="cadastro_rota"> <i class="material-icons teal-text">add_location</i>Cadastrar Rota</a>

 
</li>

<li>
    <a href="select_route_plot"><i class="material-icons teal-text">my_location</i>Plotar Rota
</a>
</li>
<!--    
<li>
    <a href="voo_real"><i class="material-icons teal-text">navigation</i>Acompanhar voo
    </a>
</li>
-->

<li>   
    <a href="rosod"><i class="material-icons teal-text">settings_input_antenna</i>Ros
    </a>
</li>

<div class="divider"></div>
<li>
    <a href="sobre"><i class="material-icons teal-text">info</i>Sobre
    </a>
</li>

<li>
    <a href="logout"><i class="material-icons teal-text">exit_to_app</i>Logout
    </a>
</li>
</ul>


<!--SideNav Finished-->

<div id="content" >
    
        
    
     </div>
    

<footer>
<div class="container">
           <div class="row">
                <div class="col s10">
© <script type="text/javascript">document.write(new Date().getFullYear());</script>-OracleDrone, All rights reserved - Hosted by <a href="http://infra.lasdpc.icmc.usp.br/">LaSDPC</a>
              <a class="grey-text text-darken-1 right">Design and Developed by Fernanda Pereira Guidotti</a>
                </div>

                </div>
            </div>
   </footer> 


  <!--Import jQuery before materialize.js-->
  <script type="text/javascript" src="js/jquery.js"></script>
  
  <script type="text/javascript" src="js/materialize.min.js"></script>
  <script>
    $(document).ready(function () {
      // Custom JS & jQuery here
      $('.button-collapse').sideNav();
    });
  </script>
 <script type='text/javascript'>
  google.charts.load('current', {
    'packages': ['geochart'],
    // Note: you will need to get a mapsApiKey for your project.
    // See: https://developers.google.com/chart/interactive/docs/basic_load_libs#load-settings
    'mapsApiKey': 'AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
  });
  google.charts.setOnLoadCallback(drawMarkersMap);

   function drawMarkersMap() {
   var data = google.visualization.arrayToDataTable([
     ['City',   'Population', 'Area'],
     ['Rome',      2761477,    1285.31],
     ['Milan',     1324110,    181.76],
     ['Naples',    959574,     117.27],
     ['Turin',     907563,     130.17],
     ['Palermo',   655875,     158.9],
     ['Genoa',     607906,     243.60],
     ['Bologna',   380181,     140.7],
     ['Florence',  371282,     102.41],
     ['Fiumicino', 67370,      213.44],
     ['Anzio',     52192,      43.43],
     ['Ciampino',  38262,      11]
   ]);

   var options = {
     region: 'IT',
     displayMode: 'markers',
     colorAxis: {colors: ['green', 'teal']}
   };

   var chart = new google.visualization.GeoChart(document.getElementById('chart_div'));
   chart.draw(data, options);
 };
 google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawBasic);

function drawBasic() {

      var data = new google.visualization.DataTable();
      data.addColumn('number', 'X');
      data.addColumn('number', 'Dogs');

      data.addRows([
        [0, 0],   [1, 10],  [2, 23],  [3, 17],  [4, 18],  [5, 9],
        [6, 11],  [7, 27],  [8, 33],  [9, 40],  [10, 32], [11, 35],
        [12, 30], [13, 40], [14, 42], [15, 47], [16, 44], [17, 48],
        [18, 52], [19, 54], [20, 42], [21, 55], [22, 56], [23, 57],
        [24, 60], [25, 50], [26, 52], [27, 51], [28, 49], [29, 53],
        [30, 55], [31, 60], [32, 61], [33, 59], [34, 62], [35, 65],
        [36, 62], [37, 58], [38, 55], [39, 61], [40, 64], [41, 65],
        [42, 63], [43, 66], [44, 67], [45, 69], [46, 69], [47, 70],
        [48, 72], [49, 68], [50, 66], [51, 65], [52, 67], [53, 70],
        [54, 71], [55, 72], [56, 73], [57, 75], [58, 70], [59, 68],
        [60, 64], [61, 60], [62, 65], [63, 67], [64, 68], [65, 69],
        [66, 70], [67, 72], [68, 75], [69, 80]
      ]);

      var options = {
        hAxis: {
          title: 'Time'
        },
        vAxis: {
          title: 'Popularity'
        }
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_div2'));

      chart.draw(data, options);
    }

 google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Year', 'Sales', 'Expenses'],
          ['2013',  1000,      400],
          ['2014',  1170,      460],
          ['2015',  660,       1120],
          ['2016',  1030,      540]
        ]);

        var options = {
          title: 'Company Performance',
          hAxis: {title: 'Year',  titleTextStyle: {color: '#333'}},
          vAxis: {minValue: 0}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div3'));
        chart.draw(data, options);
      }

 </script>
 
 <script>
 $(document).ready(function(){

$('#content').load('dashboard.jsp');

$('a').click(function(e){
  var page = $(this).attr('href');
  
  $('#content').load(page + '.jsp');
  //$('#map').load(page + '.jsp');
  return false; 
    
});


});     
 </script>

 

</body>

</html>