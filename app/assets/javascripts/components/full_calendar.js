//= require ../lib/full_calendar/core/main.js
//= require ../lib/full_calendar/daygrid/main.js

document.addEventListener('DOMContentLoaded', function () {
  var calendarEl = document.getElementById('calendar')

  var calendar = new FullCalendar.Calendar(calendarEl, {
    plugins: ['dayGrid'],
    events: gon.events,
    header: {
      left: '',
      center: 'title',
      right: ''
    },
    views: {
      dayGridMonth: {
        titleFormat: { year: 'numeric', month: 'long' }
      }
    },
    locale: 'ja',
    eventOrder: 'id',
    editable: false,
  })

  calendar.render()
  calendar.gotoDate(new Date(gon.selected_month + '/01'))
})

$(document).ready(function () {
  $('.select-business').change(function () {
    $('#filter-for-calendar').submit()
  })

  $('.calendar-filter-select').change(function () {
    $('#filter-for-calendar').submit()
  })

  $('.item-work').on('click', '.btn-show-edit', function () {
    const workId = this.dataset.workId

    $('.section-edit-' + workId).show()
    $('.section-show-' + workId).hide()
    $('.work-history-' + workId).focus()
  })

  $('.item-work').on('click', '.btn-edit', function () {
    const workId = this.dataset.workId
    const provider = this.dataset.provider
    const duration = $('.work-history-' + workId).val()

    $.ajax({
      type: 'POST',
      url: '/calendars/update_duration',
      dataType: 'script',
      data: {
        work_id: workId,
        duration: duration,
        provider: provider
      }
    })

    $('.section-show-' + workId).show()
    $('.section-edit-' + workId).hide()
  })

  $('.item-work').on('click', '.btn-close-edit', function () {
    const workId = this.dataset.workId

    $('.section-show-' + workId).show()
    $('.section-edit-' + workId).hide()
  })

  $('.btn-import').on('click', function () {
    $('.modal-loading').show()
  })
})
