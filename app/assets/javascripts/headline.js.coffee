# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# $('.nv-y.nv-axis g  g  g text').attr('style', 'opacity: 0')
# $('.nv-y.nv-axis .nv-axisMaxMin text').attr('style', 'opacity: 0')

class ChartGrapher

  constructor: (@chart_id) ->
    @data = []
    @chart = null

  update: (query, results) ->
    @data.push({
      key: query
      values: results
    })
    this.graph()
    #only need to do this once
    if (@data.length >= 1)
      this.showAxes()

  showAxes: () ->
    d3.select('.nv-y.nv-axis').selectAll('.axis-hide').classed('axis-hide', false)

  graph: () ->
    self = this

    if (!@chart)
      nv.addGraph(() ->
        self.chart = nv.models.lineChart()
          .x((d) -> return d[0] )
          .y((d) -> return d[1] )
          .color(d3.scale.category10().range())

        self.chart.xAxis
          .axisLabel('Year')
          .tickFormat((d) -> return d3.time.format('%Y')(new Date('' + d, '0', '1')))

        self.chart.yAxis
          .axisLabel('Number of Headlines')
          .tickFormat(d3.format(',.0f'))

        self.chart.forceY([0])
        self.chart.interactiveLayer.tooltip.gravity('s').distance(10)
        self.chart.tooltipContent((key, x, y) ->
          '<h3>' + key + '</h3>' + '<p>' +  y + ' in ' + x + '</p>'
        )

        d3.select('#' + self.chart_id).datum(self.data).transition().duration(500).call(self.chart)

        nv.utils.windowResize(self.chart.update)

        return self.chart
      )
    else
      d3.select('#' + self.chart_id).datum(self.data).transition().duration(500).call(self.chart)

      nv.utils.windowResize(self.chart.update)

class QuerySearch

  constructor: (@url, @query_key, input_id, button_id, chart_id, spinner_id, search_container_id) ->
    self = this
    @button = $('#' + button_id)[0]
    error_text = 'Not found'
    $(@button).click(
      (e) ->
        e.preventDefault()
        if (e.target.value == error_text || $(e.target).prop('disabled'))
          return
        if (self.input.value.length > 0)
          self.search(self.input.value)
        else
          self.show_error(error_text)
    )

    spinner_opts =
      lines: 9, # The number of lines to draw
      length: 9, # The length of each line
      width: 6, # The line thickness
      radius: 0, # The radius of the inner circle
      corners: 1, # Corner roundness (0..1)
      rotate: 0, # The rotation offset
      direction: 1, # 1: clockwise, -1: counterclockwise
      color: '#000', # #rgb or #rrggbb or array of colors
      speed: 0.9, # Rounds per second
      trail: 60, # Afterglow percentage
      shadow: true, # Whether to render a shadow
      hwaccel: true, # Whether to use hardware acceleration
      className: 'spinner', # The CSS class to assign to the spinner
      zIndex: 2e9, # The z-index (defaults to 2000000000)
      top: 'auto', # Top position relative to parent in px
      left: 0 # Left position relative to parent in px

    @target = $('#' + spinner_id)[0]
    @spinner = new Spinner(spinner_opts)

    @search_container = $('#' + search_container_id)[0]
    @input = $('#' + input_id)[0]
    @chartGrapher = new ChartGrapher chart_id
    @chartGrapher.graph()

  show_error: (error_text) ->
    $(@search_container).addClass('error')
    @button._value = @button.value.slice(0)
    @button.value = error_text

    button = @button
    search_container = @search_container
    setTimeout(() ->
      $(search_container).removeClass('error')
      button.value = button._value
    , 750)

  enable_search: () ->
    @spinner.stop()
    $(@button).prop('disabled', false)
    $(@input).prop('disabled', false)
    @input.value = ''

  disable_search: () ->
    @spinner.spin(@target)
    $(@button).prop('disabled', true)
    $(@input).prop('disabled', true)

  search: (query) ->
    self = this
    grapher = @chartGrapher
    self.disable_search()
    $.get('' + @url + '?' + @query_key + '=' + encodeURIComponent(query), (results) ->
      self.enable_search()
      results = JSON.parse(results)
      if (results.length == 0)
        self.show_error('Not found')
      else
        grapher.update(query, results)
    )

class ChartToPng

  constructor: (button_id, canvas_id, chart_container_id) ->
    $('#' + button_id).click(() ->
      canvg(canvas_id, $('#' + chart_container_id).html())
      canvas = $('#' + canvas_id)[0]
      img = canvas.toDataURL('image/png')
      canvas.getContext('2d').clearRect(0, 0, canvas.width, canvas.height)
      window.open(img)
    )
  
window.querySearch = new QuerySearch('/headlines', 'query', 'query', 'search', 'chart', 'spinner', 'search-input-container')
window.chartToPng = new ChartToPng('save-as-png', 'canvas', 'chart-container')
