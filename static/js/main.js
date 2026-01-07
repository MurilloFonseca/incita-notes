import { changeThemeEvent, darkmodeLoad } from './modules/darkmode.js'
import { closePageModal, createShowGroupEvents, createShowPageEvents, groupLoad, openPageModal } from './modules/group.js'
import { editNameEvent, saveNameEvent, showSidebarEvent, sidebarLoad } from './modules/sidebar.js'
import { addEvent } from './modules/utils.js'



window.addEventListener('load', () => {
  darkmodeLoad()
  sidebarLoad()
  groupLoad()

  // createShowGroupEvents()
  createShowPageEvents()

  addEvent('.header_darkmode', 'click', changeThemeEvent)

  // addEvent('.header_menu', 'click', showSidebarEvent)
  // addEvent('.sidebar_close', 'click', showSidebarEvent)
  // addEvent('.sidebar_name_edit', 'click', editNameEvent)
  addEvent('.sidebar_name_confirm', 'click', saveNameEvent)

  addEvent('.group_header_add', 'click', openPageModal)
  addEvent('.group_add-page_cancel', 'click', closePageModal)
})


