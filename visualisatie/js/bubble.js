
      function Bubble(vis) {
        var bubble = {};

        var data;
        var variable1, variable2;
        var name1, name2;
        var size, namesize;

        bubble.data = function(d) {
          data = d;
          return this;
        };

        bubble.vr1 = function(v, n) {
          variable1 = v;
          name1 = n;
          return this;
        };

        bubble.vr2 = function(v, n) {
          variable2 = v;
          name2 = n;
          return this;
        }

        bubble.height = function(h) {
          height = h;
          return this;
        }

        bubble.size = function(s, n) {
          size = s;
          namesize = n;
          return this;
        }

        bubble.width = function(w) {
          width = w;
          return this;
        }

        bubble.draw = function() {

          var schema = {
            'fields' : [
              { 'name' : 'buurt', 'title': 'Buurt', 'description': '', 'type': 'string'},
              { 'name' : variable1, 'title' : name1, 'description': '', 'type': 'number'},
              { 'name' : variable2, 'title' : name2, 'description': '', 'type': 'number'},
              { 'name' : size, 'title' : namesize, 'description': '', 'type': 'number'}
            ]
          };

          var g = grph.bubble();
          var mapping = {
            'x' : variable1,
            'y' : variable2,
            'object' : 'buurt'
          };
          if (size) mapping.size = size;

          g.width(width).height(height).schema(schema).assign(mapping)
            .data(data);
          g(vis);

          return this;
        };

        return bubble;
      }
