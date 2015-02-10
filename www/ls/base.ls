container = d3.select ig.containers.base
  ..append \div .attr \id \chart


mesice = <[Leden Únor Březen Duben Květen Červen Červenec Srpen Září Říjen Listopad Prosinec]>
paliva = {
  cng: ["CNG"]
  lpg: ["LPG"]
  e85: ["E85"]
  elektro: ["Elektromobily"]
  hybrid: ["Hybridní pohon"]
}
months = []
for {palivo, datum, prodano} in d3.csv.parse ig.data.paliva
  count = (parseInt prodano, 10) || 0
  paliva[palivo].push count
  if palivo is \cng
    months.push datum
hide = if window.location.hash
  toShow = that.slice 1 .split ','
  toHide = for palivo, [id] of paliva
    if palivo not in toShow
      id
    else
      null
  toHide.filter -> it isnt null

else
  void

console.log hide

c3.generate do
  bindto: \#chart
  data:
    columns: paliva['lpg','cng','e85','elektro','hybrid']
    type: \bar
    groups: [["CNG", "LPG", "E85", "Elektromobily", "Hybridní pohon"]]
    hide: hide
  axis:
    x:
      tick:
        values: [0 12 24 36 48 60 72 84 96 108]
        format: -> months[it].split "-" .0
  tooltip:
    format:
      title: ->
        date = months[it]
        date
        [year, month] = date.split "-"
        mesic = parseInt month, 10
        --mesic
        "#{mesice[mesic]} #year"
