// Available statuses:
// process, connected, disconnected
//
export default (status) => {
  console.debug(`Change online status to ${status}`)
  const e = $('[data-online-status-badge]')
  e.data('status', status)
  e.attr('data-status', status)
  e.attr('title', status)
}
