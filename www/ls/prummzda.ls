mesice = <[leden únor březen duben květen červen červenec srpen září říjen listopad prosinec]>
ig.doPrumMzda = ->
  container = d3.select ig.containers.base
  mzdy = [17067 18112 18203 19963 18270 19300 19305 21269 19687 20740 20721 22641 21632 22246 22181 24309 22108 22796 23091 25418 22738 23504 23600 25591 23372 24116 24107 26211 24131 24627 24439 27055 24013 24917 24778 26591 24817 25498 25219]
  data = d3.csv.parse ig.data.ceny, (row) ->
    row.benzin = parseFloat row.benzin
    row.diesel = parseFloat row.diesel
    [y,m,d] = row.datum.split '-' .map parseInt _, 10
    row.date = new Date!
      ..setTime 0
      ..setFullYear y
      ..setMonth m - 1
      ..setDate d
    yy = (y - 2005) * 4
    mm = Math.floor (m - 1) / 3
    if mm == 3 then mm = 2 # vylouceni extremnich 4. ctvrtleti
    mzda = mzdy[yy+mm] || mzdy[38]
    row.benzin = mzda / row.benzin
    row.diesel = mzda / row.diesel
    row.time = row.date.getTime!
    row

  container = container.append \div
    ..attr \class "ceny prum-mzda"
  width = container.node!.clientWidth - 10
  height = container.node!.clientHeight - 10
  margin = top:20 right:19 bottom:20 left:80

  svg = container.append \svg
    ..attr \class \ceny
    ..attr \width width
    ..attr \height height

  width -= margin.left + margin.right
  height -= margin.top + margin.bottom

  drawing = svg.append \g
    ..attr \transform "translate(#{margin.left},#{margin.top})"

  xScale = d3.time.scale!
    ..domain [data.0.date, data[*-1].date]
    ..range [-1 width]
  yScale = d3.scale.linear!
    ..domain [22 39]
    ..range [height, 0]
  yScale = d3.scale.linear!
    ..domain [1000 530]
    ..range [0, height]

  dieselLine = d3.svg.line!
    ..x -> xScale it.date
    ..y -> yScale it.diesel

  benzinLine = d3.svg.line!
    ..x -> xScale it.date
    ..y -> yScale it.benzin

  dieselPath = drawing.append \path .datum data
    ..attr \class "line diesel"
    ..attr \d dieselLine

  benzinPath = drawing.append \path .datum data
    ..attr \class "line benzin"
    ..attr \d benzinLine

  xAxis = d3.svg.axis!
    ..scale xScale
    ..orient \bottom
    ..tickSize 6, 1
    ..tickValues [2005 to 2015].map ->
      new Date!
        ..setTime 0
        ..setFullYear it
    ..tickFormat -> it.getFullYear!
  svg.append \g
    ..attr \class "axis x"
    ..attr \transform "translate(#{margin.left}, #{margin.top + height})"
    ..call xAxis

  yAxis = d3.svg.axis!
    ..scale yScale
    ..orient \left
    ..tickFormat -> "#{ig.utils.formatNumber it} litrů"
    ..tickSize 6, 1
  svg.append \g
    ..attr \class "axis y"
    ..attr \transform "translate(#{margin.left}, #{margin.top})"
    ..call yAxis
  tipArea = container.append \div
    ..attr \class \tip-area

  svg.on \mousemove ->
    x = d3.event.x - margin.left
    date = xScale.invert x
    time = date.getTime!
    diff = Infinity
    for datum in data
      d = Math.abs datum.time - time
      if diff > d
        diff = d
      else
        break
    {date, diesel, benzin} = datum
    y = date.getFullYear!
    m = date.getMonth!
    yy = (y - 2005) * 4
    mm = Math.floor m / 3
    if mm == 3 then mm = 2 # vylouceni extremnich 4. ctvrtleti
    mzda = mzdy[yy+mm] || mzdy[38]
    date = "#{date.getDate!}. #{mesice[date.getMonth!]} #{date.getFullYear!}"
    tipArea.html "<b>#{date}</b><br>Za průměrnou mzdu <b>#{ig.utils.formatNumber mzda}&nbsp;Kč</b><br>si bylo možné koupit <span class='benzin'>Benzin: <b>#{ig.utils.formatNumber benzin, 2} litrů</b></span><span class='diesel'>Nafta: <b>#{ig.utils.formatNumber diesel, 2} litrů</b></span>"
    moveLine datum

  line = drawing.append \g
    ..attr \transform "translate(-200,0)"
    ..attr \class \highlight-line
    ..append \line
      ..attr \x1 0
      ..attr \y1 0
      ..attr \x2 0
      ..attr \y2 height
  dieselLinePoint = line.append \circle
    ..attr \class \diesel
    ..attr \r 3
  benzinLinePoint = line.append \circle
    ..attr \class \benzin
    ..attr \r 3
  moveLine = (datum) ->
    x = Math.round xScale datum.date
    if x < 0 or x > width
      x = -200
    line.attr \transform "translate(#x,0)"
    dieselLinePoint.attr \cy yScale datum.diesel
    benzinLinePoint.attr \cy yScale datum.benzin
