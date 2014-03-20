recalculateCounter = ->
  $('#post-counter').text(140 - $(@).val().length)

$ ->
  $el = $('aside').find('textarea')
  $submit = $('aside').find('input').filter('[type="submit"]')

  $el.on 'input keyup', recalculateCounter
