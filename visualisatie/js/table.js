var index, zorg_nodig, zorg_krijg, index_achtergrond, map;
var variable_table = "index_krijg";
var map_grph, bubble;
var bubblevar;

queue()
    .defer(d3.csv,"./data/index_achterground.csv")
    .defer(d3.csv, "./data/regression_results1_krijg.csv")
    .defer(d3.csv, "./data/regression_results1_nodig.csv")
    .defer(d3.json, "./map/bu_2014.json")
    .await(function(error, file1, file2, file3, file4) {
      index = file1;
      zorg_krijg = file2;
      zorg_nodig = file3;
      map = file4;
      fillTable(zorg_krijg, "#p1", 0);
      fillTable(zorg_krijg, "#p2", 50);
      fillTable(zorg_krijg, "#p3", 100);
      fillTable(zorg_krijg, "#p4", 150);

      var height = 600;
      var width = 800;
      variable_table = "index_krijg";

      var vis = d3.select("#map").append("svg")
        .attr("width", width).attr("height", height)
      var vis2 = d3.select("#bubble").append("svg")
        .attr("width", width).attr("height", height)
      map_grph = Map(vis).width(width).height(height).vr(variable_table);
      draw_map(variable_table);
      bubble = Bubble(vis2).width(width).height(height);
      bubblevar = "bsp0_11";
        draw_bubble("index_krijg");
    
     $("#krijgt_zorg").on('change', function () {
        variable_table = "index_krijg";
        fillTable(zorg_krijg, "#p1", 0);
        fillTable(zorg_krijg, "#p2", 50);
        fillTable(zorg_krijg, "#p3", 100);
        fillTable(zorg_krijg, "#p4", 150);
        draw_map("index_krijg");
        draw_bubble("index_krijg");
      }).click();
    $('#zorg_nodig').on('change', function () {
        variable_table = "index_nodig";
        fillTable(zorg_nodig, "#p1", 0);
        fillTable(zorg_nodig, "#p2", 50);
        fillTable(zorg_nodig, "#p3", 100);
        fillTable(zorg_nodig, "#p4", 150);    
        draw_map("index_nodig");
        draw_bubble("index_nodig");
      });

    });

function draw_map(variable) {
$("#map>svg").empty();
          map_grph.vr(variable).data(index);
          map_grph.mp(map);
          map_grph.draw();
}

function draw_bubble(variable) {
$("#bubble>svg").empty();
  bubble.vr2(variable, variable).vr1(bubblevar,bubblevar)
    .size("ondersteuning_nodig", "Ondersteuning nodig")
    //.size(variable, variable)
    .data(index).draw();
}

function signif (s) {
  if ( s < 0.0001) return "***";
  if ( s < 0.01) return "**";
  if ( s < 0.05) return "*";
  if ( s < 0.1) return ".";
  return "";
}

function hooglaag (b) {
  if (b < 0) 
    return '<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span>'
  else
    return '<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span>'
}

function fillTable(data, tab, start) {
    console.log(data);
    $(tab + " .table").empty();
    $(tab + " .table").html('<tr><th>Variable</th><th>R-square</th><th>Sig.</th><th></th></tr>')
    data.slice(start,start+50).forEach(function (row) {
        $(tab + " .table").append(
          "<tr class=\"rrow\" data-variable=\"" + row.variable + "\"><td>" + row.variable_name + "</td><td>" +
          Math.round(row.rsq * 100) / 100 + "</td><td>" + signif(row.p) + "</td><td>"+
          hooglaag(row.b) + "</td></tr>")
      })  
    $("tr.rrow").click(function() {
      bubblevar = $(this).data().variable;
      console.log(variable_table);
      draw_bubble(variable_table);
    });
}
