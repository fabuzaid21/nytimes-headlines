(function(){var t,e,n;t=function(){function t(t){this.chart_id=t,this.data=[],this.chart=null}return t.prototype.update=function(t,e){return this.data.push({key:t,values:e}),this.graph(),this.data.length>=1?this.showYAxis():void 0},t.prototype.showYAxis=function(){return d3.select(".nv-y.nv-axis").selectAll(".axis-hide").classed("axis-hide",!1)},t.prototype.graph=function(){var t;return t=this,this.chart?(d3.select("#"+t.chart_id).datum(t.data).transition().duration(500).call(t.chart),nv.utils.windowResize(t.chart.update)):nv.addGraph(function(){return t.chart=nv.models.lineChart().x(function(t){return t[0]}).y(function(t){return t[1]}).color(d3.scale.category10().range()),t.chart.xAxis.axisLabel("Year").tickValues([2001,2002,2003,2004,2005,2006,2007,2008,2009,2010]).tickFormat(function(t){return d3.time.format("%Y")(new Date(""+t,"0","1"))}),t.chart.yAxis.axisLabel("Number of Headlines").tickFormat(d3.format(",.0f")),t.chart.forceY([0]),t.chart.forceX([2001,2010]),t.chart.interactiveLayer.tooltip.gravity("s").distance(10),t.chart.tooltipContent(function(t,e,n){return"<h3>"+t+"</h3>"+"<p>"+n+" in "+e+"</p>"}),d3.select("#"+t.chart_id).datum(t.data).transition().duration(500).call(t.chart),nv.utils.windowResize(t.chart.update),t.chart})},t}(),n=function(){function e(e,n,r,a,o,i,s){var u,l,c;this.url=e,this.query_key=n,l=this,this.button=$("#"+a)[0],u="Not found",$(this.button).click(function(t){return t.preventDefault(),t.target.value===u||$(t.target).prop("disabled")?void 0:l.input.value.length>0?l.search(l.input.value):l.show_error(u)}),c={lines:9,length:9,width:6,radius:0,corners:1,rotate:0,direction:1,color:"#000",speed:.9,trail:60,shadow:!0,hwaccel:!0,className:"spinner",zIndex:2e9,top:"auto",left:0},this.target=$("#"+i)[0],this.spinner=new Spinner(c),this.search_container=$("#"+s)[0],this.input=$("#"+r)[0],this.chartGrapher=new t(o),this.chartGrapher.graph()}return e.prototype.show_error=function(t){var e,n;return $(this.search_container).addClass("error"),this.button._value=this.button.value.slice(0),this.button.value=t,e=this.button,n=this.search_container,setTimeout(function(){return $(n).removeClass("error"),e.value=e._value},750)},e.prototype.enable_search=function(){return this.spinner.stop(),$(this.button).prop("disabled",!1),$(this.input).prop("disabled",!1),this.input.value=""},e.prototype.disable_search=function(){return this.spinner.spin(this.target),$(this.button).prop("disabled",!0),$(this.input).prop("disabled",!0)},e.prototype.search=function(t){var e,n;return n=this,e=this.chartGrapher,n.disable_search(),$.get(""+this.url+"?"+this.query_key+"="+encodeURIComponent(t),function(r){return n.enable_search(),r=JSON.parse(r),0===r.length?n.show_error("Not found"):e.update(t,r)})},e}(),e=function(){function t(t,e,n){$("#"+t).click(function(){var t,r;return canvg(e,$("#"+n).html()),t=$("#"+e)[0],r=t.toDataURL("image/png"),t.getContext("2d").clearRect(0,0,t.width,t.height),window.open(r)})}return t}(),window.querySearch=new n("/headlines","query","query","search","chart","spinner","search-input-container"),window.chartToPng=new e("save-as-png","canvas","chart-container")}).call(this);