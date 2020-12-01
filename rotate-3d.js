$(function() {

      // Add mouse events for rotation
      $('#chart3D').on('mousedown.hc touchstart.hc', function(eStart) {
   
         var chart = $(this).highcharts(); //Highcharts object

         eStart = chart.pointer.normalize(eStart);

         var posX = eStart.pageX,
         posY = eStart.pageY,
         alpha = chart.options.chart.options3d.alpha,
         beta = chart.options.chart.options3d.beta,
         newAlpha,
         newBeta,
         sensitivity = 5; // lower is more sensitive

         $(document).on({

            'mousemove.hc touchdrag.hc': function(e) {

               // Run beta
               newBeta = beta + (posX - e.pageX) / sensitivity;
               chart.options.chart.options3d.beta = newBeta;

               // Run alpha
               newAlpha = alpha + (e.pageY - posY) / sensitivity;
               chart.options.chart.options3d.alpha = newAlpha;

               chart.redraw(false);
            },

            'mouseup touchend': function() {
               $(document).off('.hc');
            } 
         });
      });
   });
