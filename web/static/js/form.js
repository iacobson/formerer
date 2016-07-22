import submissions_template from "./templates/submissions"

let Form = {
  init(socket){

    for (var clip of $('[data-behaviour="clipboard-copy"]')){
      let clipboard = new Clipboard(clip)
      clipboard.on('success', this.clipboard_success)
    }

    $(document).on('click', '[data-behaviour="toggle-submission-details"]', this.toggle_submission_details)

    // pass this object (Form) to the edit_name
    $('[data-behaviour="edit-form-name"]').on('click', () => this.edit_name())

    $('[data-behaviour="dialog"]').on('click', this.show_dialog)

    $(document).on('click', '[data-behaviour="submit-form"]', this.submit_form)

    this.handle_channels(socket)
  },

  handle_channels(socket){
    let form_submissions = document.getElementById("form-submissions")
    if (form_submissions) {
      $("#submissions-present").hide()
      $("#no-submissions-present").hide()

      let form_id = form_submissions.getAttribute("data-form-id")
      socket.connect()
      let channel = socket.channel("forms:" + form_id)
      let channel_params = channel.params

      channel.on("new_submission", (resp) => {
        this.parse_submissions(resp, channel_params)
      })

      channel.join()
      .receive("ok", resp => {
        this.parse_submissions(resp, channel_params)
      })
      .receive("error", resp => { console.log("nooooooooooo", resp) })
    }
  },

  parse_submissions(resp, channel_params){
    if(resp.submissions.length > 0) {
      this.store_last_submission(resp.submissions, channel_params)
      $("#submissions-present").show()} else{
      $("#no-submissions-present").show()
    }
    let system_columns_keys = Object.keys(resp.system_columns)

    let submissions_data = {
      "submissions": resp.submissions,
      "selected_columns": resp.selected_columns,
      "system_columns": resp.system_columns,
      "system_columns_keys": system_columns_keys,
      "column_count": resp.column_count
    }
    this.render_submission(submissions_data)
  },

  store_last_submission(submissions, channel_params){
    let ids = submissions.map(sub => sub.id)
    channel_params.last_seen_id = Math.max(...ids)
  },

  render_submission(submissions_data){
    let container = $("#submissions-container")
    Handlebars.registerHelper("formatColumnName", (column) => {
      return column.replace(/-|_/g, " ").toLowerCase().split(' ').map((a) => a.charAt(0).toUpperCase() + a.substr(1)).join(' ')
    })
    let html = submissions_template(submissions_data)
    container.prepend(html)
  },

  clipboard_success(){
    $('.copied-notice').show()
    $('.copied-notice').fadeOut(1000)
    $('[data-behaviour="clipboard-copy"]').blur()
  },

  toggle_submission_details(){
    let submission_id = $(this).parents('tr').data('id')
    $('[data-details-for="' + submission_id + '"]').toggle()
    return false;
  },

  edit_name(){
    $('[data-behaviour="edit-form-name"]').hide()
    let name_element = $('[data-behaviour="form-name"]')

    let value = name_element.text()
    name_element.data('old_value', value)

    name_element.prop('contenteditable', true)
    name_element.focus()

    this.select_contents(name_element[0])

    name_element.off('blur keyup')
    name_element.on('blur', this.update_name)
    name_element.on('keyup', (e) => {
      if (e.which === 13) {
        name_element.off('blur')
        this.update_name.call(name_element[0])
      }
    })
  },

  update_name(){
    var name_element = $(this)
    var value = name_element.text().replace(/\s+$/g, '')

    name_element.prop('contenteditable', false)
    $('[data-behaviour="edit-form-name"]').show()

    if (value.length !== 0) {
      name_element.text(value)
      var url = name_element.data('url')
      var token = name_element.data('token')

      $.ajax({
        url: url,
        type: 'POST',
        beforeSend: function(xhr) {
          xhr.setRequestHeader('x-csrf-token', token)
        },
        data: {
          _method: "patch",
          name: value
        },
        success: function(response) {
        }
      })

    } else {
      name_element.text(name_element.data('old_value'))
    }
  },

  select_contents(element){
    var range = document.createRange()
    range.selectNodeContents(element)
    var selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange(range)
  },

  show_dialog(){
    $.fancybox.open({
      type: 'ajax',
      padding: 0,
      href: $(this).attr('href'),
      beforeShow: function() {
        componentHandler.upgradeDom()
      }
    })
    return false
  },

  submit_form(){
    var form = $(this).parents('form')
    var url = form.attr('action')

    $.post(url, form.serialize(), function() {
      window.location.reload()
    })
    return false
  }
}

export default Form
