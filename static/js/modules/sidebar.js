import { setLocalStorage } from "./utils.js"

// ShowSidebar
const setSidebar = () => {
  document.querySelector('.sidebar').classList.toggle('hidden')
  document.querySelector('.header_menu').classList.toggle('hidden')
  document.querySelector('.page_main').classList.toggle('push')
}

export const showSidebarEvent = () => {
  setSidebar()
  setLocalStorage('sidebar', true)
}

export const sidebarLoad = () => {
  const sidebar = localStorage.getItem('sidebar')

  if (sidebar) {
    setSidebar()
  }
}


// EditName
const setEditName = () => {
  const nameInput = document.querySelector('.sidebar_name')

  nameInput.disabled = !nameInput.disabled

  document.querySelector('.sidebar_name_edit').classList.toggle('hidden')
  document.querySelector('.sidebar_name_confirm').classList.toggle('hidden')
}

export const editNameEvent = () => {
  setEditName()
}

export const saveNameEvent = async () => {
  const name = document.querySelector('.sidebar_name').value

  console.log(name);

  await fetch('/update-name', {
    method: 'PUT',
    headers: {
      'Content-type': 'application/json'
    },
    body: JSON.stringify({
      name: name
    })
  })

  setEditName()
}

