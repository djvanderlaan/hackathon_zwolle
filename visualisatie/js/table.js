var index, zorg_nodig, zorg_krijg;
queue()
    .defer(d3.csv,"./data/index.csv")
    .defer(d3.csv, "./data/regression_results1_krijg.csv")
    .defer(d3.csv, "./data/regression_results1_nodig.csv")
    .await(function(error, file1, file2, file3) {
      index = file1;
      zorg_nodig = file2;
      zorg_krijg = file3;
      fillTable(zorg_nodig, "#p1", 0);
      fillTable(zorg_nodig, "#p2", 50);
      fillTable(zorg_nodig, "#p3", 100);
      fillTable(zorg_nodig, "#p4", 150);
    
     $("#krijgt_zorg").on('change', function () {
        fillTable(zorg_krijg, "#p1", 0);
        fillTable(zorg_krijg, "#p2", 50);
        fillTable(zorg_krijg, "#p3", 100);
        fillTable(zorg_krijg, "#p4", 150);
      });
    $('#zorg_nodig').on('change', function () {
        fillTable(zorg_nodig, "#p1", 0);
        fillTable(zorg_nodig, "#p2", 50);
        fillTable(zorg_nodig, "#p3", 100);
        fillTable(zorg_nodig, "#p4", 150);    
      }).click();

    });

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
    $(tab + " .table").empty();
    $(tab + " .table").html('<thead><tr><th>Variable</th><th>R-square</th><th>Sig.</th><th></th></tr></thead>')
    data.slice(start,start+50).forEach(function (row) {
        $(tab + " .table").append(
          "<tr><td>" + row.variable_name + "</td><td>" +
          Math.round(row.rsq * 100) / 100 + "</td><td>" + signif(row.p) + "</td><td>"+
          hooglaag(row.b) + "</td></tr>")
      })  
}
