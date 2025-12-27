import { changeThemeEvent, darkmodeLoad } from './modules/darkmode.js'
import { createShowGroupEvents, groupLoad } from './modules/group.js'
import { editNameEvent, saveNameEvent, showSidebarEvent, sidebarLoad } from './modules/sidebar.js'
import { addEvent } from './modules/utils.js'



window.addEventListener('load', () => {
  darkmodeLoad()
  sidebarLoad()
  groupLoad()

  createShowGroupEvents()

  addEvent('.header_darkmode', 'click', changeThemeEvent)

  addEvent('.header_menu', 'click', showSidebarEvent)
  addEvent('.sidebar_close', 'click', showSidebarEvent)
  addEvent('.sidebar_name_edit', 'click', editNameEvent)
  addEvent('.sidebar_name_confirm', 'click', saveNameEvent)
})


