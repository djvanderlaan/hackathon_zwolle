
      function Map(vis) {
        var map = {};
        var nmax   = 9;
        var cscale = colorbrewer.RdYlGn[nmax];
        var variable;

        var data;
        var mp;
        var vmin, vmax;

        function find_data(buurt_code) {
          for (var i = 0; i < data.length; ++i) {
            if (data[i].buurt_code == buurt_code) {
              return data[i];
            }
          }
        }

        function quantize(d, nmax) {
          for (var i = 0; i < data.length; ++i) {
            if (data[i].buurt_code == d.properties.STATCODE) {
              var val = parseFloat(data[i][variable]);
              return Math.floor((val - vmin)*0.99999/(vmax - vmin) * nmax);
            }
          }
        }

        function quantize_color(d) {
          var i = quantize(d, nmax);
          if (i === undefined || isNaN(i)) return "#EEEEEE";
          return cscale[i];
        }
         
        var tip = d3.tip().direction("se").attr('class', 'tip tip-bar').html(function(d) { 
          var data = find_data(d.properties.STATCODE);
          if (!data) return "<b>" + d.properties.BU_NAAM + "</b>";
          var value = data[variable];
          return "<b>" + d.properties.BU_NAAM + "</b><br/>" + Math.round(100*value)/100;
        });
        vis.call(tip);


        map.data = function(d) {
          data = d;
          return this;
        };

        map.vr = function(v) {
          variable = v;
          return this;
        };

        map.mp = function(m) {
          mp = m;
          return this;
        }

        map.height = function(h) {
          height = h;
          return this;
        }

        map.width = function(w) {
          width = w;
          return this;
        }

        map.draw = function() {
          var v = variable;
          vmin = d3.min(data, function(d) { return parseFloat(d[v]);});
          vmax = d3.max(data, function(d) { return parseFloat(d[v]);});
          vmax = Math.max(Math.abs(vmin-1), Math.abs(vmax-1))+1;
          vmin = -vmax+2;

          vis.append("rect").attr("class", "background").attr("width", width)
            .attr("height", height).style({"fill":"#FFFFFF"});

          var projection = d3.geo.transverseMercator()
            .rotate([-5.38720621, -52.15517440]).scale(1).translate([0,0]);
          var path = d3.geo.path().projection(projection);
          // determine scale and translation so that we project the map inside 
          // the window we have
          var bounds = path.bounds(mp);
          var scale  = .95 / Math.max((bounds[1][0] - bounds[0][0]) / width,
              (bounds[1][1] - bounds[0][1]) / height);
          var transl = [(width - scale * (bounds[1][0] + bounds[0][0])) / 2,
              (height - scale * (bounds[1][1] + bounds[0][1])) / 2];
          projection.scale(scale).translate(transl);
          // draw the map
          vis.selectAll("path").data(mp.features).enter().append("path")
            .attr("d", path)
            .attr("fill", quantize_color)
            .on("mouseover", tip.show)
            .on("mouseout", tip.hide);
          return this;
        }; 
        
        return map;
      };

