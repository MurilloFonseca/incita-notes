import { setLocalStorage } from "./utils.js"

const setDark = () => {
  document.querySelectorAll('*').forEach(el => el.classList.toggle('dark'))
  document.querySelector('.header_darkmode_dark').classList.toggle('hidden')
  document.querySelector('.header_darkmode_light').classList.toggle('hidden')
}

export const changeThemeEvent = () => {
  setDark()
  setLocalStorage('darkmode', true)
}

export const darkmodeLoad = () => {
  const darkmode = localStorage.getItem('darkmode')

  if (darkmode) {
    setDark()
  }
}
