$(document).ready(function () {
  $('.select-business').change(function () {
    $('#filter-for-chart').submit()
  })

  if (typeof gon == 'undefined') {
    return
  }

  if (gon.datasets) {
    drawChart(gon.datasets.session, gon.labels, 'sessionChart', 'line')
    drawChart(gon.datasets.user, gon.labels, 'userChart', 'bar')
  }

  if (gon.goal_conversion && gon.goal_conversion.datasets) {
    drawChartWithPercen(gon.goal_conversion.datasets, gon.goal_conversion.labels, 'goalConversion', 'line')
  }

  $('#analytic-profile').modal({ backdrop: 'static' })

  $('#segments, #segments_channel, #segments_goal_conversion').select2({
    maximumSelectionLength: 3
  })

  $('#goal_submit').click(function () {
    const date_range = $('.date-range').val().replace(/\s/g, '').split('-')
    if (moment(date_range[0]).isBefore()) {
      getGoalCompletionData()
    }
  })

  $('#conversion_submit').click(function () {
    const date_range = $('#date_range_conversion').val().replace(/\s/g, '').split('-')
    if (moment(date_range[0]).isBefore()) {
      getGoalConversionData()
    }
  })

  $('#channel_submit').click(function () {
    const date_range = $('#date_range_channel').val().replace(/\s/g, '').split('-')
    if (moment(date_range[0]).isBefore()) {
      getChannelData()
    }
  })

  function getGoalCompletionData() {
    const urlParams = new URLSearchParams(window.location.search)
    const business_id = urlParams.get('business_id')
    const date_range_goal_path = $('#date_range_goal_path').val()
    const goal_option_goal_path = $('#goal_option_goal_path').val()
    const segments_goal_path = $('#segments_goal_path').val()

    $.ajax({
      type: 'GET',
      url: '/google_analytics?business_id=' + business_id,
      dataType: 'script',
      contentType: 'text/javascript',
      data: {
        date_range_goal_path: date_range_goal_path,
        goal_option_goal_path: goal_option_goal_path,
        segments_goal_path: segments_goal_path,
        get_goal_completion: true
      }
    })
  }

  function getGoalConversionData() {
    const urlParams = new URLSearchParams(window.location.search)
    const business_id = urlParams.get('business_id')
    const date_range_conversion = $('#date_range_conversion').val()
    const segments_goal_conversion = $('#segments_goal_conversion').val()

    $.ajax({
      type: 'GET',
      url: '/google_analytics?business_id=' + business_id,
      dataType: 'script',
      contentType: 'text/javascript',
      data: {
        date_range_conversion: date_range_conversion,
        segments_goal_conversion: segments_goal_conversion,
        get_goal_conversion: true
      }
    })
  }

  function getChannelData() {
    const urlParams = new URLSearchParams(window.location.search)
    const business_id = urlParams.get('business_id')
    const date_range_channel = $('#date_range_channel').val()
    const segments_channel = $('#segments_channel').val()

    $.ajax({
      type: 'GET',
      url: '/google_analytics?business_id=' + business_id,
      dataType: 'script',
      contentType: 'text/javascript',
      data: {
        date_range_channel: date_range_channel,
        segments_channel: segments_channel,
        get_channel_data: true
      }
    })
  }

  function drawChart(datasets, labels, element, type) {
    var ctx = document.getElementById(element)

    ctx.height = 100;

    new Chart(ctx, {
      type: type,
      data: {
        labels: labels,
        datasets: datasets
      },
      options: {
        scales: {
          xAxes: [{
            gridLines: {
              drawBorder: false,
              display: false,
            },
          }],
          yAxes: [{
            ticks: {
              beginAtZero: true,
              precision: 0
            }
          }]
        },
        elements: {
          line: {
            tension: 0,
            fill: false
          }
        }
      },
    })
  }

  function drawChartWithPercen(datasets, labels, element, type) {
    var ctx = document.getElementById(element)

    ctx.height = 100;

    new Chart(ctx, {
      type: type,
      data: {
        labels: labels,
        datasets: datasets
      },
      options: {
        scales: {
          xAxes: [{
            gridLines: {
              drawBorder: false,
              display: false,
            },
          }],
          yAxes: [{
            ticks: {
              beginAtZero: true,
              precision: 0,
              callback: function (value) { return value + "%" }
            }
          }]
        },
        elements: {
          line: {
            tension: 0,
            fill: false
          }
        },
        tooltips: {
          callbacks: {
            label: function (tooltipItem, data) {
              return data['labels'][tooltipItem['index']] + ': ' + data['datasets'][0]['data'][tooltipItem['index']] + '%';
            }
          }
        }
      },
    })
  }

  function changeProperty(selected_account) {
    $('.select2-property').empty().select2({
      data: gon.property_options[selected_account]
    })
  }

  function changeView(selected_property) {
    $('.select2-view').empty().select2({
      data: gon.view_options[selected_property]
    })
  }
})
