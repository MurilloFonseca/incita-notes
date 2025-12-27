import { setLocalStorage } from "./utils.js"

const setGroup = (id) => {
  document.querySelector(`#${id} .group_body`).classList.toggle('hidden')
  document.querySelector(`#${id} .group_header_chevron_right`).classList.toggle('hidden')
  document.querySelector(`#${id} .group_header_chevron_down`).classList.toggle('hidden')
}

const showGroupEvent = (id) => {
  setGroup(id)
  setLocalStorage(`group:${id}`, true)
}

export const createShowGroupEvents = () => {
  const btns = document.querySelectorAll('.group_header_chevron')
  
  btns.forEach(el => {
    const id = el.closest('.group').id
    el.addEventListener('click', () => showGroupEvent(id))
  })
}

export const groupLoad = () => {
  for (let el in localStorage) {
    const [type, id] = el.split(':')

    if (type === 'group') {
      const value = localStorage.getItem(el)

      if (value) {
        setGroup(id)
      }
    }
  }
}
