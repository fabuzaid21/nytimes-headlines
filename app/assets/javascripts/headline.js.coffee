# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class ChartGrapher

  constructor: (@chart_id, @legend_id) ->
    self = this
    @palette = new Rickshaw.Color.Palette()
    @graph_config =
      element: $('#' + self.chart_id)[0],
      renderer: 'line',
      width: 600,
      height: 400,
      series: []

  update: (query, results) ->
    self = this
    @graph_config.series.push({
      data: results,
      color: this.palette.color()
      name: query
    })
    this.graph()

  graph: () ->
    if (!@chart)
      @chart = new Rickshaw.Graph @graph_config
      hoverDetail = new Rickshaw.Graph.HoverDetail(
        {
          graph: @chart,
          xFormatter: (x) ->
            new Date(x * 1000).getFullYear()
        }
      )

      new Rickshaw.Graph.Axis.Time({
          graph: this.chart
      })
      new Rickshaw.Graph.Axis.Y({
          graph: this.chart,
          orientation: 'left',
          tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
          element: $('#y_axis')[0]
      })
    $('#' + @legend_id).empty()
    self = this
    legend = new Rickshaw.Graph.Legend({
      graph: @chart,
      element: $('#' + this.legend_id)[0]
    })
    new Rickshaw.Graph.Behavior.Series.Toggle({
      graph: this.chart,
      legend: legend
    })
    new Rickshaw.Graph.Behavior.Series.Highlight({
      graph: this.chart,
      legend: legend
    })
    @chart.render()
    #obj = this

    #nv.addGraph(() ->
    #  chart = nv.models.lineChart()
    #    .x((d) -> return d[0] )
    #    .y((d) -> return d[1] )
    #    .color(d3.scale.category10().range())

    #  chart.xAxis
    #    .axisLabel('Year')
    #    #.tickFormat((d) ->
    #    #  return d3.time.format('%Y')(new Date(d))
    #    #)
    #    .tickFormat((d) -> return d3.time.format('%Y')(new Date('' + d, '0', '1')))

    #  chart.yAxis
    #    .axisLabel('Number of Headlines')
    #    .tickFormat(d3.format(',.0f'))
    #    #.tickFormat((d) -> return d3.format('x')(d))

    #  d3.select('#' + obj.svg_id).datum(obj.data).transition().duration(500).call(chart)

    #  #TODO: Figure out a good way to do this automatically
    #  nv.utils.windowResize(chart.update)

    #  return chart
    #)

class QuerySearch

  constructor: (@url, @query_key, input_id, button_id, chart_id, legend_id) ->
    self = this
    $('#' + button_id).click(
      (e) ->
        e.preventDefault()
        if (self.input.value.length > 0)
          self.search(self.input.value)
          self.input.value = ''
    )
    @input = $('#' + input_id)[0]
    @chartGrapher = new ChartGrapher chart_id, legend_id
    #@chartGrapher.update('', [[]])

  search: (query) ->
    grapher = @chartGrapher
    $.get('' + @url + '?' + @query_key + '=' + encodeURIComponent(query), (results) -> grapher.update(query, JSON.parse(results)))

window.foo = new QuerySearch('/headlines', 'query', 'query', 'search', 'chart', 'legend')
